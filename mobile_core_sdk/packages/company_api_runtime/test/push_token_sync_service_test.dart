import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

class _FakePushDeviceRegistrationApiClient
    extends PushDeviceRegistrationApiClient {
  _FakePushDeviceRegistrationApiClient({required this.onRegister})
    : super(dioForPath: (_) => Dio());

  final Future<void> Function({
    required String deviceId,
    required int deviceType,
    required String version,
  })
  onRegister;

  @override
  Future<void> registerDevice({
    required String deviceId,
    required int deviceType,
    required String version,
  }) {
    return onRegister(
      deviceId: deviceId,
      deviceType: deviceType,
      version: version,
    );
  }
}

class _FakePushLogger extends PushTokenSyncLogger {
  final List<String> infos = <String>[];
  final List<String> warnings = <String>[];
  final List<String> errors = <String>[];

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {
    infos.add('$message|$context');
  }

  @override
  void warning(String message, {Map<String, Object?> context = const {}}) {
    warnings.add('$message|$context');
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    errors.add('$message|$context|$error');
  }
}

void main() {
  group('PushTokenSyncService', () {
    test('syncs pending token after auth becomes true', () async {
      final calls = <Map<String, Object?>>[];
      final logger = _FakePushLogger();
      final service = PushTokenSyncService(
        apiClient: _FakePushDeviceRegistrationApiClient(
          onRegister:
              ({
                required String deviceId,
                required int deviceType,
                required String version,
              }) async {
                calls.add(<String, Object?>{
                  'deviceId': deviceId,
                  'deviceType': deviceType,
                  'version': version,
                });
              },
        ),
        logger: logger,
        appVersionResolver: () async => '1.2.3',
        deviceTypeResolver: () => 1,
        retryDelays: const <Duration>[Duration(milliseconds: 10)],
      );

      service.enqueueToken('token-a');
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(calls, isEmpty);

      service.updateAuthentication(true);
      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(calls, hasLength(1));
      expect(calls.first['deviceId'], equals('token-a'));
      expect(calls.first['deviceType'], equals(1));
      expect(calls.first['version'], equals('1.2.3'));

      service.dispose();
    });

    test('retries when sync fails and succeeds later', () async {
      var attempt = 0;
      final logger = _FakePushLogger();
      final completer = Completer<void>();
      final service = PushTokenSyncService(
        apiClient: _FakePushDeviceRegistrationApiClient(
          onRegister:
              ({
                required String deviceId,
                required int deviceType,
                required String version,
              }) async {
                attempt += 1;
                if (attempt == 1) {
                  throw StateError('temporary failure');
                }
                if (!completer.isCompleted) {
                  completer.complete();
                }
              },
        ),
        logger: logger,
        appVersionResolver: () async => '2.0.0',
        deviceTypeResolver: () => 0,
        retryDelays: const <Duration>[Duration(milliseconds: 20)],
      );

      service.updateAuthentication(true);
      service.enqueueToken('token-b');

      await completer.future.timeout(const Duration(seconds: 2));
      expect(attempt, greaterThanOrEqualTo(2));
      expect(logger.warnings, isNotEmpty);
      expect(logger.errors, isNotEmpty);

      service.dispose();
    });
  });
}
