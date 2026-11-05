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
    test('secondary market filter and contract fields including nested applications', () async {
      final dio = _buildDio((options) async {
        if (options.path == UserInvestmentApiPaths.applyList) {
          expect(options.data, {'startPage': 2, 'limit': 10, 'status': [0, 2], 'marketType': 2});
          return _jsonOk('{"code":200,"data":{"rows":[{"projectName":"fund","contractId":123,"ecStatus":0,"ecUserTodo":true,"status":2}]}}');
        }
        return _jsonOk('{"code":200,"data":{"rows":[{"id":1,"projectName":"fund","status":"VALID","applyList":[{"processId":"a","contractId":"123","ecStatus":1,"ecUserTodo":false,"status":3},{"processId":"b","ecStatus":null,"ecUserTodo":null,"status":0}]}]}}');
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);
      final purchases = await api.fetchApplyList(marketType: 2, startPage: 2, limit: 10, statuses: [0, 2]);
      expect(purchases.single.contractId, '123');
      expect(purchases.single.ecStatus, 0);
      expect(purchases.single.ecUserTodo, true);
      final orders = await api.fetchOrderInquiryList(userId: 42);
      expect(orders.single.status, 'VALID');
      expect(orders.single.applyList.map((e) => e.status), [3, 0]);
      expect(orders.single.applyList.first.ecUserTodo, false);
      expect(orders.single.applyList.last.contractId, isNull);
    });
    test('available holdings preserve process identity and server availability', () async {
      final dio = _buildDio((options) async {
        expect(options.path, '/crowdfunding/secondary/market/available');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        return _jsonOk('{"code":200,"data":[{"processId":"a","projectId":1,"projectName":"fund","availableNum":2,"investmentUnit":100000},{"processId":"b","projectId":1,"projectName":"fund","availableNum":5}]}');
      });
      final rows = await UserInvestmentApiClient(dioForPath: (_) => dio).fetchSecondaryMarketHoldings();
      expect(rows.map((e) => e.processId), ['a', 'b']);
      expect(rows.map((e) => e.availableNum), [2, 5]);
      expect(rows.first.investmentUnit, 100000);
      expect(rows.last.investmentUnit, isNull);
    });
    test('secondary market writes send existing contract and reject business failure', () async {
      final bodies = <Object?>[];
      final dio = _buildDio((options) async {
        expect(options.extra['auth_required'], true);
        bodies.add(options.data);
        return _jsonOk(options.path == UserInvestmentApiPaths.secondaryMarketPurchase
          ? '{"code":500,"msg":"sold out"}' : '{"code":200,"data":true}');
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);
      await api.submitSecondaryMarketCreate(fromProcessId: 'holding', sellNum: 2, price: 100);
      await api.submitSecondaryMarketModify(id: 'listing', fromProcessId: 'holding', sellNum: 2, price: 100, status: 'INVALID', thisTimeSoldNum: 1);
      await expectLater(api.submitSecondaryMarketPurchase(id: 'listing', buyNum: 1), throwsA(anything));
      expect(bodies, [
        {'fromProcessId':'holding','sellNum':'2','price':100},
        {'id':'listing','fromProcessId':'holding','sellNum':2,'price':100,'status':'INVALID','thisTimeSoldNum':1},
        {'buyNum':'1','id':'listing'},
      ]);
    });
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

    test('fetchAssetTrend gets envelope and parses rows', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserInvestmentApiPaths.assetTrend));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.queryParameters,
          equals(<String, dynamic>{
            'startDate': '2026-01-09',
            'endDate': '2026-05-09',
          }),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":[{"recordDate":"2026-01-09","totalAccount":120000,"totalFirstLevelAccount":20000,"totalFundAccount":100000},{"recordDate":"2026-05-09","totalAccount":150000,"totalFirstLevelAccount":30000,"totalFundAccount":120000}]}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchAssetTrend(
        startDate: DateTime(2026, 1, 9),
        endDate: DateTime(2026, 5, 9),
      );

      expect(rows, hasLength(2));
      expect(rows.first.recordDate, equals('2026-01-09'));
      expect(rows.first.totalAccount, equals(120000));
      expect(rows.first.totalFirstLevelAccount, equals(20000));
      expect(rows.first.totalFundAccount, equals(100000));
      expect(rows.last.recordDate, equals('2026-05-09'));
      expect(rows.last.totalAccount, equals(150000));
    });

    test('fetchApplyList without params posts an empty body and parses rows', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.applyList));
        expect(options.extra['auth_required'], isTrue);
        expect(options.data, equals(<String, dynamic>{}));
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
          '{"msg":"success","code":200,"data":{"rows":[{"projectId":"p-3","projectName":"渋谷区 オフィスビル #12","investMoney":1000000,"hiwariJobs":[{"processId":null,"startDate":"2026-03-10","endDate":"2026-03-31","num":"500"},{"processId":"proc-3","startDate":"2026-04-01","endDate":null,"num":""}]}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchInvestmentList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, equals('p-3'));
      expect(rows.first.projectName, equals('渋谷区 オフィスビル #12'));
      expect(rows.first.investMoney, equals(1000000));
      expect(rows.first.hiwariJobs, hasLength(2));
      expect(rows.first.hiwariJobs.first.processId, isNull);
      expect(rows.first.hiwariJobs.first.startDate, equals('2026-03-10'));
      expect(rows.first.hiwariJobs.first.endDate, equals('2026-03-31'));
      expect(rows.first.hiwariJobs.first.num, equals(500));
      expect(rows.first.hiwariJobs.last.processId, equals('proc-3'));
      expect(rows.first.hiwariJobs.last.num, isNull);
    });
  });
}
