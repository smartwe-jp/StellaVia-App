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
  group('UserInvestmentApiClient', () {
    test('fetchAccountStatistic gets envelope and parses data', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserInvestmentApiPaths.accountStatistic));
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"userId":125530,"total":"89859954","crowdfundingTotal":"89703200","crowdfundingDistributedBenefit":"572781","firstLevelAccountTotal":"156754","takingAmt":"50000","takingFee":"10000","lockedFee":"2500","lockedList":[{"userId":125530,"lockedAmount":2500,"lockedReason":"新規登録ボーナス ¥2,500","startLockedTime":null,"lockExpireTime":null}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final row = await api.fetchAccountStatistic();

      expect(row.userId, equals(125530));
      expect(row.total, equals(89859954));
      expect(row.crowdfundingTotal, equals(89703200));
      expect(row.crowdfundingDistributedBenefit, equals(572781));
      expect(row.financialTotal, isNull);
      expect(row.firstLevelAccountTotal, equals(156754));
      expect(row.takingAmt, equals(50000));
      expect(row.takingFee, equals(10000));
      expect(row.lockedFee, equals(2500));
      expect(row.lockedList, hasLength(1));
      expect(row.lockedList.first.lockedAmount, equals(2500));
      expect(row.lockedList.first.lockedReason, equals('新規登録ボーナス ¥2,500'));
    });

    test('fetchApplyList without params posts no body and parses rows', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.applyList));
        expect(options.extra['auth_required'], isTrue);
        expect(options.data, isNull);
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"projecId":"p-1","projectName":"プレミアムレジデンス赤坂","status":2}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchApplyList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, equals('p-1'));
      expect(rows.first.projectName, equals('プレミアムレジデンス赤坂'));
      expect(rows.first.status, equals(2));
    });

    test('fetchApplyList posts only status filter when provided', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.applyList));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'status': <int>[2],
          }),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"projectId":"p-2","projectName":"大阪レジデンス","status":2}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchApplyList(statuses: const <int>[2]);

      expect(rows, hasLength(1));
      expect(rows.first.projectId, equals('p-2'));
      expect(rows.first.status, equals(2));
    });

    test('fetchOrderInquiryList posts userId and parses rows envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.orderInquiryPage));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'startPage': 1,
            'limit': 20,
            'userId': 58350,
          }),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"id":"o-1","projectName":"商業ビル心斎橋","price":300000}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchOrderInquiryList(userId: 58350);

      expect(rows, hasLength(1));
      expect(rows.first.id, equals('o-1'));
      expect(rows.first.projectName, equals('商業ビル心斎橋'));
      expect(rows.first.price, equals(300000));
    });

    test('fetchInvestmentList posts payload and parses rows envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.myInvestmentList));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{'startPage': 1, 'limit': 20}),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"projectId":"p-3","projectName":"渋谷区 オフィスビル #12","investMoney":1000000}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchInvestmentList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, equals('p-3'));
      expect(rows.first.projectName, equals('渋谷区 オフィスビル #12'));
      expect(rows.first.investMoney, equals(1000000));
    });
  });
}
