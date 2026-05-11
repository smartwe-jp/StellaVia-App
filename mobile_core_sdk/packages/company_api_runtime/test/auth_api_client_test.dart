import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }
}

ResponseBody _jsonOk([String body = '{}']) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

Dio _buildDio(Future<ResponseBody> Function(RequestOptions options) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return dio;
}

void main() {
  group('AuthApiClient phone change online', () {
    test('sendOnlinePhoneChangeCode uses POST with query parameters', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(AuthApiPaths.changePhoneOnlineSend));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.queryParameters,
          equals(<String, dynamic>{'bizId': '81', 'mobile': '09085309521'}),
        );
        return _jsonOk('{"code":0,"msg":"success","data":null}');
      });
      final api = AuthApiClient(dioForPath: (_) => dio);

      await api.sendOnlinePhoneChangeCode(mobile: '09085309521', bizId: '81');
    });

    test(
      'verifyOnlinePhoneChangeCode uses POST with query parameters',
      () async {
        final dio = _buildDio((options) async {
          expect(options.method, equals('POST'));
          expect(options.path, equals(AuthApiPaths.changePhoneOnlineCheck));
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.queryParameters,
            equals(<String, dynamic>{
              'bizId': '81',
              'mobile': '09085309521',
              'code': '336044',
            }),
          );
          return _jsonOk('{"code":0,"msg":"success","data":null}');
        });
        final api = AuthApiClient(dioForPath: (_) => dio);

        await api.verifyOnlinePhoneChangeCode(
          mobile: '09085309521',
          bizId: '81',
          code: '336044',
        );
      },
    );

    test(
      'sendOnlinePhoneChangeCode resolves nested msg map on failure',
      () async {
        final dio = _buildDio((_) async {
          return _jsonOk(
            '{"code":500,"msg":{"error":"invalid","error_description":"認証コード送信に失敗しました"}}',
          );
        });
        final api = AuthApiClient(dioForPath: (_) => dio);

        await expectLater(
          () =>
              api.sendOnlinePhoneChangeCode(mobile: '09085309521', bizId: '81'),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              '認証コード送信に失敗しました',
            ),
          ),
        );
      },
    );
  });

  group('AuthApiClient /member/login/index', () {
    test(
      'fetchMemberLoginIndexStatus posts full device payload and parses status',
      () async {
        final dio = _buildDio((options) async {
          expect(options.method, equals('POST'));
          expect(options.path, equals(AuthApiPaths.memberLoginIndex));
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.data,
            equals(<String, dynamic>{
              'app': 'STELLAVIA',
              'deviceId': 'device-abc',
              'deviceType': 1,
              'languageTag': 'zh-Hant',
              'version': '1.2.3',
            }),
          );
          return _jsonOk(
            '{"code":0,"msg":"success","data":{"phone":"08012345678","mobileAuth":0,"verificationStatus":0,"currentDeviceVerificationStatus":1,"ownerName":"张三"}}',
          );
        });
        final api = AuthApiClient(dioForPath: (_) => dio);

        final result = await api.fetchMemberLoginIndexStatus(
          deviceId: 'device-abc',
          deviceType: 1,
          languageTag: 'zh-Hant',
          version: '1.2.3',
        );

        expect(result, isNotNull);
        expect(result!.phone, equals('08012345678'));
        expect(result.isPhoneVerified, isTrue);
        expect(result.isRealPersonVerified, isFalse);
        expect(result.isCurrentDeviceVerified, isTrue);
        expect(result.ownerName, equals('张三'));
      },
    );

    test(
      'fetchMemberLoginIndexStatus ignores mobileAuth for phone status',
      () async {
        final dio = _buildDio((options) async {
          expect(options.method, equals('POST'));
          expect(options.path, equals(AuthApiPaths.memberLoginIndex));
          return _jsonOk(
            '{"code":0,"msg":"success","data":{"mobileAuth":1,"verificationStatus":1}}',
          );
        });
        final api = AuthApiClient(dioForPath: (_) => dio);

        final result = await api.fetchMemberLoginIndexStatus(
          deviceId: 'device-abc',
          deviceType: 1,
          languageTag: 'ja',
          version: '1.2.3',
        );

        expect(result, isNotNull);
        expect(result!.phone, isNull);
        expect(result.isPhoneVerified, isFalse);
      },
    );

    test('updateLoginDevice posts device payload with app', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(AuthApiPaths.memberLoginIndex));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'app': 'STELLAVIA',
            'deviceId': 'fcm-token-value',
            'deviceType': 1,
            'languageTag': 'ja',
            'version': '1.2.3',
          }),
        );
        return _jsonOk('{"code":200,"msg":"success","data":{}}');
      });
      final api = AuthApiClient(dioForPath: (_) => dio);

      await api.updateLoginDevice(
        deviceId: 'fcm-token-value',
        deviceType: 1,
        version: '1.2.3',
      );
    });

    test('updateLoginDevice skips request when deviceId is blank', () async {
      var called = false;
      final dio = _buildDio((_) async {
        called = true;
        return _jsonOk();
      });
      final api = AuthApiClient(dioForPath: (_) => dio);

      await api.updateLoginDevice(
        deviceId: '   ',
        deviceType: 0,
        version: '1.0.0',
      );

      expect(called, isFalse);
    });
  });

  group('AuthApiClient loginWithCode errors', () {
    test('uses oauth error_description from bad response payload', () async {
      final dio = _buildDio((_) async {
        return ResponseBody.fromString(
          '{"error":"invalid_grant","error_description":"アカウントはシステムに存在しません"}',
          400,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>['application/json'],
          },
        );
      });
      final api = AuthApiClient(dioForPath: (_) => dio);

      await expectLater(
        () => api.loginWithCode(account: 'demo@example.com', code: '123456'),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'アカウントはシステムに存在しません',
          ),
        ),
      );
    });

    test('resolves nested map message payload', () {
      const codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );

      expect(
        codec.resolveErrorMessage(<String, dynamic>{
          'msg': <String, dynamic>{
            'error': 'invalid_grant',
            'error_description': 'アカウントはシステムに存在しません',
          },
        }, fallbackMessage: 'Login failed.'),
        'アカウントはシステムに存在しません',
      );
    });
  });
}
