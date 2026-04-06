import 'dart:async';

import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_push_runtime.dart';
import 'app_push_settings.dart';

class AliyunPushRuntime implements AppPushRuntime {
  AliyunPushRuntime({
    required AliyunPushCredentials credentials,
    AliyunPushFlutter? push,
    String androidChannelId = 'gutingjunpush',
    String androidChannelName = 'FUNDEX Push',
    String androidChannelDescription = 'FUNDEX notification channel',
  }) : _credentials = credentials,
       _push = push ?? AliyunPushFlutter(),
       _androidChannelId = androidChannelId,
       _androidChannelName = androidChannelName,
       _androidChannelDescription = androidChannelDescription;

  static const String _successCode = '10000';

  final AliyunPushCredentials _credentials;
  final AliyunPushFlutter _push;
  final String _androidChannelId;
  final String _androidChannelName;
  final String _androidChannelDescription;

  bool _initialized = false;
  String? _latestDeviceId;
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();
  final StreamController<AppPushNotificationEvent> _notificationController =
      StreamController<AppPushNotificationEvent>.broadcast();

  @override
  String get providerName => 'aliyun';

  @override
  String? get latestToken => _latestDeviceId;

  @override
  Stream<String> get tokenStream => _tokenController.stream;

  @override
  Stream<AppPushNotificationEvent> get notificationEvents =>
      _notificationController.stream;

  @override
  Future<void> initialize({required AppLogger logger}) async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    if (kIsWeb) {
      logger.warning('Aliyun push runtime is disabled on web platform.');
      return;
    }

    final appKey = _credentials.currentPlatformAppKey?.trim() ?? '';
    final appSecret = _credentials.currentPlatformAppSecret?.trim() ?? '';
    if (appKey.isEmpty || appSecret.isEmpty) {
      logger.warning(
        'Aliyun push credentials are missing for current platform; skip initialization.',
        context: <String, Object?>{'platform': defaultTargetPlatform.name},
      );
      return;
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _ensureAndroidNotificationPermission(logger: logger);
        await _setupAndroidChannel(logger: logger);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _setupIosForegroundBehavior(logger: logger);
      }

      final result = await _push.initPush(appKey: appKey, appSecret: appSecret);
      final code = '${result['code'] ?? ''}'.trim();
      if (!_isSuccess(code)) {
        logger.error(
          'Aliyun push initialization failed.',
          context: <String, Object?>{
            'code': code,
            'errorMsg': '${result['errorMsg'] ?? ''}',
          },
        );
        return;
      }

      logger.info(
        'Aliyun push initialized.',
        context: <String, Object?>{
          'platform': defaultTargetPlatform.name,
          'code': code,
        },
      );

      await _resolveDeviceId(logger: logger);
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _logAndroidNotificationState(logger: logger);
      }
      _setupReceivers(logger: logger);
    } catch (error, stackTrace) {
      logger.error(
        'Aliyun push initialize failed unexpectedly.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _ensureAndroidNotificationPermission({
    required AppLogger logger,
  }) async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      logger.info('Android notification permission already granted.');
      return;
    }

    final result = await Permission.notification.request();
    logger.info(
      'Android notification permission request finished.',
      context: <String, Object?>{'status': result.name},
    );
    if (!result.isGranted) {
      logger.warning(
        'Android notification permission is not granted; system notification UI may be blocked.',
        context: <String, Object?>{'status': result.name},
      );
    }
  }

  Future<void> _setupAndroidChannel({required AppLogger logger}) async {
    final result = await _push.createAndroidChannel(
      _androidChannelId,
      _androidChannelName,
      4,
      _androidChannelDescription,
      showBadge: true,
      vibration: true,
    );
    final code = '${result['code'] ?? ''}'.trim();
    if (_isSuccess(code)) {
      logger.info(
        'Aliyun Android push channel created.',
        context: <String, Object?>{'channelId': _androidChannelId},
      );
      return;
    }
    logger.warning(
      'Aliyun Android push channel setup failed.',
      context: <String, Object?>{
        'channelId': _androidChannelId,
        'code': code,
        'errorMsg': '${result['errorMsg'] ?? ''}',
      },
    );
  }

  Future<void> _setupIosForegroundBehavior({required AppLogger logger}) async {
    await _push.showIOSNoticeWhenForeground(true);
    final channelOpened = await _push.isIOSChannelOpened();
    logger.info(
      'Aliyun iOS notification channel state.',
      context: <String, Object?>{'opened': channelOpened},
    );
  }

  Future<void> _resolveDeviceId({required AppLogger logger}) async {
    final deviceId = (await _push.getDeviceId()).trim();
    if (deviceId.isEmpty) {
      logger.warning('Aliyun push deviceId is empty after initialization.');
      return;
    }
    _latestDeviceId = deviceId;
    _tokenController.add(deviceId);
    logger.info(
      'Aliyun push deviceId resolved.',
      context: <String, Object?>{'deviceId': deviceId},
    );
  }

  Future<void> _logAndroidNotificationState({required AppLogger logger}) async {
    final notificationsEnabled = await _push.isAndroidNotificationEnabled(
      id: _androidChannelId,
    );
    final pushChannelStatus = await _push.checkAndroidPushChannelStatus();
    logger.info(
      'Aliyun Android notification state.',
      context: <String, Object?>{
        'channelId': _androidChannelId,
        'notificationsEnabled': notificationsEnabled,
        'pushChannelCode': '${pushChannelStatus['code'] ?? ''}',
        'pushChannelStatus': '${pushChannelStatus['status'] ?? ''}',
        'pushChannelErrorMsg': '${pushChannelStatus['errorMsg'] ?? ''}',
      },
    );
  }

  void _setupReceivers({required AppLogger logger}) {
    _push.addMessageReceiver(
      onNotificationOpened: (Map<dynamic, dynamic> message) async {
        _emitNotificationEvent(kind: 'opened', message: message);
        logger.info(
          'Aliyun notification opened.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
      onNotification: (Map<dynamic, dynamic> message) async {
        _emitNotificationEvent(kind: 'notification', message: message);
        logger.info(
          'Aliyun notification received.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
      onAndroidNotificationReceivedInApp:
          (Map<dynamic, dynamic> message) async {
            _emitNotificationEvent(kind: 'inAppNotification', message: message);
            logger.info(
              'Aliyun in-app notification received.',
              context: <String, Object?>{'message': message.toString()},
            );
            return null;
          },
      onMessage: (Map<dynamic, dynamic> message) async {
        _emitNotificationEvent(kind: 'message', message: message);
        logger.info(
          'Aliyun data message received.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
      onNotificationRemoved: (Map<dynamic, dynamic> message) async {
        logger.info(
          'Aliyun notification removed.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
    );
  }

  bool _isSuccess(String code) {
    return code == _successCode || code == '0';
  }

  void _emitNotificationEvent({
    required String kind,
    required Map<dynamic, dynamic> message,
  }) {
    _notificationController.add(
      AppPushNotificationEvent(kind: kind, payload: _normalizeMap(message)),
    );
  }

  Map<String, Object?> _normalizeMap(Map<dynamic, dynamic> source) {
    final normalized = <String, Object?>{};
    source.forEach((dynamic key, dynamic value) {
      normalized['$key'] = _normalizeValue(value);
    });
    return normalized;
  }

  Object? _normalizeValue(Object? value) {
    if (value is Map<dynamic, dynamic>) {
      return _normalizeMap(value);
    }
    if (value is Iterable) {
      return value.map(_normalizeValue).toList(growable: false);
    }
    return value;
  }
}
