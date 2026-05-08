import 'dart:async';
import 'dart:math' as math;

abstract class PushTokenSyncLogger {
  const PushTokenSyncLogger();

  void info(String message, {Map<String, Object?> context});
  void warning(String message, {Map<String, Object?> context});
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context,
  });
}

class PushTokenSyncService {
  PushTokenSyncService({
    required Future<void> Function({
      required String deviceId,
      required int deviceType,
      required String languageTag,
      required String version,
    })
    registerDevice,
    required PushTokenSyncLogger logger,
    required Future<String> Function() appVersionResolver,
    required int Function() deviceTypeResolver,
    String Function()? languageTagResolver,
    List<Duration>? retryDelays,
  }) : _registerDevice = registerDevice,
       _logger = logger,
       _appVersionResolver = appVersionResolver,
       _deviceTypeResolver = deviceTypeResolver,
       _languageTagResolver = languageTagResolver ?? (() => 'ja'),
       _retryDelays =
           retryDelays ??
           const <Duration>[
             Duration(seconds: 5),
             Duration(seconds: 15),
             Duration(seconds: 30),
             Duration(minutes: 1),
             Duration(minutes: 2),
             Duration(minutes: 5),
           ];

  final Future<void> Function({
    required String deviceId,
    required int deviceType,
    required String languageTag,
    required String version,
  })
  _registerDevice;
  final PushTokenSyncLogger _logger;
  final Future<String> Function() _appVersionResolver;
  final int Function() _deviceTypeResolver;
  final String Function() _languageTagResolver;
  final List<Duration> _retryDelays;

  String? _pendingToken;
  String? _lastSyncedToken;
  bool _isAuthenticated = false;
  bool _isSyncing = false;
  bool _isDisposed = false;
  int _retryAttempt = 0;
  Timer? _retryTimer;

  void enqueueToken(String token) {
    final normalized = token.trim();
    if (normalized.isEmpty) {
      return;
    }

    _pendingToken = normalized;
    _retryAttempt = 0;
    _retryTimer?.cancel();

    if (!_isAuthenticated) {
      _logger.info(
        'Push token observed before auth; wait for authenticated state.',
        context: <String, Object?>{'token': _maskToken(normalized)},
      );
      return;
    }

    _scheduleSync(const Duration(milliseconds: 50));
  }

  void updateAuthentication(bool authenticated) {
    _isAuthenticated = authenticated;
    if (!_isAuthenticated) {
      _retryTimer?.cancel();
      _lastSyncedToken = null;
      return;
    }

    final pending = _pendingToken;
    if (pending == null || pending.isEmpty || pending == _lastSyncedToken) {
      return;
    }
    _scheduleSync(const Duration(milliseconds: 50));
  }

  void resetSyncState({String reason = 'manual'}) {
    _lastSyncedToken = null;
    final token = _pendingToken;
    if (!_isAuthenticated || token == null || token.isEmpty) {
      return;
    }
    _logger.info(
      'Push token sync state reset; scheduling backend sync.',
      context: <String, Object?>{'reason': reason, 'token': _maskToken(token)},
    );
    _scheduleSync(const Duration(milliseconds: 50));
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _retryTimer?.cancel();
  }

  void _scheduleSync(Duration delay) {
    if (_isDisposed) {
      return;
    }
    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      unawaited(_syncPendingToken());
    });
  }

  Future<void> _syncPendingToken() async {
    if (_isDisposed || _isSyncing || !_isAuthenticated) {
      return;
    }
    final token = _pendingToken;
    if (token == null || token.isEmpty) {
      return;
    }
    if (_lastSyncedToken == token) {
      return;
    }

    _isSyncing = true;
    try {
      final version = await _appVersionResolver();
      await _registerDevice(
        deviceId: token,
        deviceType: _deviceTypeResolver(),
        languageTag: _languageTagResolver(),
        version: version,
      );
      _lastSyncedToken = token;
      _retryAttempt = 0;
      _logger.info(
        'Push token synced to backend.',
        context: <String, Object?>{
          'token': _maskToken(token),
          'version': version,
        },
      );
    } catch (error, stackTrace) {
      _retryAttempt += 1;
      final delay = _nextRetryDelay(_retryAttempt);
      _logger.warning(
        'Push token sync failed; will retry.',
        context: <String, Object?>{
          'token': _maskToken(token),
          'attempt': _retryAttempt,
          'retryInSeconds': delay.inSeconds,
        },
      );
      _logger.error(
        'Push token sync failure detail.',
        error: error,
        stackTrace: stackTrace,
      );
      _scheduleSync(delay);
    } finally {
      _isSyncing = false;
    }
  }

  Duration _nextRetryDelay(int attempt) {
    final index = math.max(0, math.min(attempt - 1, _retryDelays.length - 1));
    return _retryDelays[index];
  }

  String _maskToken(String token) {
    if (token.length <= 10) {
      return token;
    }
    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
  }
}
