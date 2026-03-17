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
  group('PushDeviceRegistrationApiClient', () {
    test(
      'registerDevice posts payload and accepts envelope code 200',
      () async {
        final dio = _buildDio((options) async {
          expect(options.method, equals('POST'));
          expect(
            options.path,
            equals(PushDeviceRegistrationApiPaths.registerDevice),
          );
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.data,
            equals(<String, dynamic>{
              'deviceId': 'fcm-token-value',
              'deviceType': 1,
              'version': '1.2.3',
            }),
          );
          return _jsonOk('{"code":200,"msg":"success","data":{}}');
        });
        final api = PushDeviceRegistrationApiClient(dioForPath: (_) => dio);

        await api.registerDevice(
          deviceId: 'fcm-token-value',
          deviceType: 1,
          version: '1.2.3',
        );
      },
    );

    test('registerDevice accepts envelope code 0', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        return _jsonOk('{"code":0,"msg":"success","data":{}}');
      });
      final api = PushDeviceRegistrationApiClient(dioForPath: (_) => dio);

      await api.registerDevice(
        deviceId: 'another-token',
        deviceType: 0,
        version: '2.0.0',
      );
    });

    test(
      'registerDevice throws when envelope code indicates failure',
      () async {
        final dio = _buildDio((_) async {
          return _jsonOk('{"code":500,"msg":"failed","data":null}');
        });
        final api = PushDeviceRegistrationApiClient(dioForPath: (_) => dio);

        expect(
          () => api.registerDevice(
            deviceId: 'token-x',
            deviceType: 0,
            version: '1.0.0',
          ),
          throwsA(isA<StateError>()),
        );
      },
    );

    test('registerDevice skips request when deviceId is blank', () async {
      var called = false;
      final dio = _buildDio((_) async {
        called = true;
        return _jsonOk('{"code":200,"msg":"success","data":{}}');
      });
      final api = PushDeviceRegistrationApiClient(dioForPath: (_) => dio);

      await api.registerDevice(
        deviceId: '   ',
        deviceType: 0,
        version: '1.0.0',
      );

      expect(called, isFalse);
    });
  });
}
