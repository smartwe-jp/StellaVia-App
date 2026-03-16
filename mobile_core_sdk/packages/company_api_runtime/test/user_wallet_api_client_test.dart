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
  group('UserWalletApiClient', () {
    test('fetchAccountHistory sends GET with accountType query', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserWalletApiPaths.accountHistory));
        expect(
          options.queryParameters,
          equals(<String, dynamic>{'accountType': 1}),
        );
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":[{"amount":"50000","inOut":"收","tradeType":"借入金より振替","businessId":null,"balance":"12000","tradeTime":"2026-03-15","createTime":"2026-03-15 10:00:00","remark":"入金"}]}',
        );
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchAccountHistory(accountType: 1);

      expect(rows, hasLength(1));
      expect(rows.first.amount, equals(50000));
      expect(rows.first.inOut, equals('收'));
      expect(rows.first.tradeType, equals('借入金より振替'));
      expect(rows.first.businessId, isNull);
      expect(rows.first.balance, equals(12000));
      expect(rows.first.remark, equals('入金'));
      expect(rows.first.tradeTime, equals('2026-03-15'));
    });

    test('fetchAccountHistory throws when envelope code failed', () async {
      final dio = _buildDio((_) async {
        return _jsonOk('{"msg":"failed","code":500,"data":null}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      expect(() => api.fetchAccountHistory(), throwsA(isA<StateError>()));
    });
  });
}
