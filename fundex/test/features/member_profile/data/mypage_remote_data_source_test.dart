import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/datasources/mypage_remote_data_source.dart';

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

class _NoopTokenRefresher implements TokenRefresher {
  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    return null;
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

CoreHttpClient _buildClient(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);

  return CoreHttpClient(
    baseUrl: 'https://api.example.com/api',
    tokenStore: InMemoryTokenStore(),
    tokenRefresher: _NoopTokenRefresher(),
    dio: dio,
  );
}

void main() {
  group('MyPageRemoteDataSourceImpl', () {
    test('fetchAccountStatistic gets envelope and parses data', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'GET');
        expect(options.path, UserInvestmentApiPaths.accountStatistic);
        expect(options.extra['auth_required'], true);

        return _jsonOk(
          '{"msg":"success","code":200,"data":{"userId":125530,"total":"89859954","crowdfundingTotal":"89703200","crowdfundingDistributedBenefit":"572781","firstLevelAccountTotal":"156754","takingAmt":"50000","takingFee":"10000","lockedFee":"2500","lockedList":[{"userId":125530,"lockedAmount":2500,"lockedReason":"新規登録ボーナス ¥2,500","startLockedTime":null,"lockExpireTime":null}]}}',
        );
      });
      final source = MyPageRemoteDataSourceImpl(client);

      final row = await source.fetchAccountStatistic();

      expect(row.userId, 125530);
      expect(row.total, 89859954);
      expect(row.crowdfundingTotal, 89703200);
      expect(row.crowdfundingDistributedBenefit, 572781);
      expect(row.financialTotal, isNull);
      expect(row.firstLevelAccountTotal, 156754);
      expect(row.takingAmt, 50000);
      expect(row.takingFee, 10000);
      expect(row.lockedFee, 2500);
      expect(row.lockedList, hasLength(1));
      expect(row.lockedList.first.lockedAmount, 2500);
      expect(row.lockedList.first.lockedReason, '新規登録ボーナス ¥2,500');
    });

    test('fetchApplyList posts payload and parses rows envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, UserInvestmentApiPaths.applyList);
        expect(options.extra['auth_required'], true);
        expect(options.data, <String, dynamic>{'startPage': 1, 'limit': 20});

        return _jsonOk(
          '{"msg":"success","code":200,"data":{"total":1,"limit":20,"currentPage":1,"rows":[{"projecId":"p-1","projectName":"プレミアムレジデンス赤坂","status":2,"applyMoney":500000,"applyTime":"2025-03-01 10:00:00","passTime":"2025-03-20 00:00:00","investMoney":0,"processId":"proc-1","investorType":{"projectId":"p-1","investorCode":"優先出資者A","earningsRadio":0.062}}]}}',
        );
      });
      final source = MyPageRemoteDataSourceImpl(client);

      final rows = await source.fetchApplyList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, 'p-1');
      expect(rows.first.projectName, 'プレミアムレジデンス赤坂');
      expect(rows.first.status, 2);
      expect(rows.first.applyMoney, 500000);
      expect(rows.first.passTime, '2025-03-20 00:00:00');
      expect(rows.first.investorType?.projectId, 'p-1');
    });

    test('fetchOrderInquiryList posts userId and parses pdf rows', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, UserInvestmentApiPaths.orderInquiryPage);
        expect(options.extra['auth_required'], true);
        expect(options.data, <String, dynamic>{
          'startPage': 1,
          'limit': 20,
          'userId': 58350,
        });

        return _jsonOk(
          '{"msg":"success","code":200,"data":{"total":1,"limit":20,"currentPage":1,"rows":[{"id":"o-1","memberId":58350,"fromProcessId":"proc-1","projectName":"商業ビル心斎橋","price":300000,"status":"VALID","createTime":"2025-03-02 00:00:00","investorType":{"projectId":"p-2","investorCode":"優先出資者A","earningsRadio":0.062},"pdfs":[{"projectId":"p-2","type":3,"desc":"契約成立時書面","urls":[{"name":"doc.pdf","url":"https://cdn.example.com/doc.pdf"}]}]}]}}',
        );
      });
      final source = MyPageRemoteDataSourceImpl(client);

      final rows = await source.fetchOrderInquiryList(userId: 58350);

      expect(rows, hasLength(1));
      expect(rows.first.projectName, '商業ビル心斎橋');
      expect(rows.first.price, 300000);
      expect(rows.first.pdfDocuments, hasLength(1));
      expect(rows.first.pdfDocuments.first.description, '契約成立時書面');
      expect(
        rows.first.pdfDocuments.first.urls.first.url,
        'https://cdn.example.com/doc.pdf',
      );
    });

    test('fetchInvestmentList posts payload and parses rows envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, UserInvestmentApiPaths.myInvestmentList);
        expect(options.extra['auth_required'], true);
        expect(options.data, <String, dynamic>{'startPage': 1, 'limit': 20});

        return _jsonOk(
          '{"msg":"success","code":200,"data":{"total":1,"limit":20,"currentPage":1,"rows":[{"projectId":"p-3","projectName":"渋谷区 オフィスビル #12","investMoney":1000000,"investNum":1,"projectStatus":4,"processId":"proc-3","earningRadio":0.072,"earnings":36000,"investorType":{"projectId":"p-3","investorCode":"優先出資者A","earningsRadio":0.072}}]}}',
        );
      });
      final source = MyPageRemoteDataSourceImpl(client);

      final rows = await source.fetchInvestmentList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, 'p-3');
      expect(rows.first.projectName, '渋谷区 オフィスビル #12');
      expect(rows.first.investMoney, 1000000);
      expect(rows.first.earningRadio, 0.072);
      expect(rows.first.earnings, 36000);
    });
  });
}
