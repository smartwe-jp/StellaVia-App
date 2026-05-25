import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/network/app_client_metadata_interceptor.dart';

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

ResponseBody _ok() {
  return ResponseBody.fromString(
    '{}',
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

void main() {
  group('AppClientMetadataInterceptor', () {
    test('adds hotel client type and app version headers', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://hotel.example.com/api'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        expect(options.headers['x-client-type'], 'Stellavia-App');
        expect(options.headers['app-version'], '1.2.3');
        return _ok();
      });
      dio.interceptors.add(
        AppClientMetadataInterceptor(appVersionResolver: () async => '1.2.3'),
      );

      await dio.post('/pms/order/room/extraPerson');
    });

    test('falls back to 0.0.0 when resolved version is empty', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://hotel.example.com/api'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        expect(options.headers['x-client-type'], 'Stellavia-App');
        expect(options.headers['app-version'], '0.0.0');
        return _ok();
      });
      dio.interceptors.add(
        AppClientMetadataInterceptor(appVersionResolver: () async => ''),
      );

      await dio.get('/hotel/hotelSearch');
    });
  });
}
