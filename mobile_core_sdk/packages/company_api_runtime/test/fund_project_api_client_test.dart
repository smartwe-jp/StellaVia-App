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
  group('FundProjectApiClient', () {
    test('fetchFundProjectList uses list endpoint and parses envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(FundProjectApiPaths.projectList));
        expect(options.extra['auth_required'], isTrue);

        return _jsonOk(
          '{"msg":"success","code":200,"data":[{"id":"453461223669231137","projectName":"繁星優選Fund商品20241123","expectedDistributionRatioMax":0.02,"expectedDistributionRatioMin":0.01,"investmentPeriod":"１４ヶ月","offeringMethod":"LOTTERY","gainType":"CAPITAL_GAIN","investmentUnit":100000,"maximumInvestmentPerPerson":100,"achievementRate":1.01,"amountApplication":10000000,"currentlySubscribed":10100000,"daysRemaining":0,"projectStatus":4,"operatingCompany":"運営会社","periodType":"SEASON","times":10,"photos":[{"url":"https://cdn.example.com/p1.png"}],"investorTypeList":[{"id":"i1","projectId":"453461223669231137","investorType":"INVESTMENT","investorCode":"優先出資者A","earningsType":"FLOATING","earningsRadio":0.0,"interestRadio":0.0,"isOpen":false,"isOpenType":2,"currentAmountApplication":5000000}],"pdfs":[{"projectId":"453461223669231137","type":1,"desc":"契約成立前書面","urls":[{"name":"契約成立前書面.pdf","url":"https://cdn.example.com/a.pdf","createTime":"2026-03-17T04:43:45.454Z"}]}]}]}',
        );
      });
      final api = FundProjectApiClient(client);

      final list = await api.fetchFundProjectList();

      expect(list, hasLength(1));
      final item = list.first;
      expect(item.id, equals('453461223669231137'));
      expect(item.projectName, equals('繁星優選Fund商品20241123'));
      expect(item.gainType, equals('CAPITAL_GAIN'));
      expect(item.pdfDocuments.first.urls, hasLength(1));
      expect(item.pdfDocuments.first.urls.first.name, equals('契約成立前書面.pdf'));
      expect(
        item.pdfDocuments.first.urls.first.url,
        equals('https://cdn.example.com/a.pdf'),
      );
    });

    test(
      'fetchFundProjectDetail uses detail endpoint and parses envelope',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, equals('GET'));
          expect(options.path, equals(FundProjectApiPaths.projectDetail));
          expect(options.queryParameters['id'], equals('453461223669231137'));
          expect(options.extra['auth_required'], isTrue);

          return _jsonOk(
            '{"msg":"success","code":200,"data":{"id":"453461223669231137","projectName":"繁星優選Fund商品20241123","description":"ホテル特化型ファンドです。","features":"駅近・高稼働エリア","videoLink":"https://cdn.example.com/project.mp4","subordinatedRatio":"30%","detail":"{\\"permitNumber\\":\\"東京都知事 第001号\\"}","liveJapanBank":{"id":"448371408253091840","bankName":"みずほ銀行","branchBankName":"船場支店","bankNumber":"普通3081072","bankAccountOwnerName":"株式会社繁星優選 大阪2号"}}}',
          );
        });
        final api = FundProjectApiClient(client);

        final item = await api.fetchFundProjectDetail(id: '453461223669231137');

        expect(item.id, equals('453461223669231137'));
        expect(item.description, equals('ホテル特化型ファンドです。'));
        expect(item.features, equals('駅近・高稼働エリア'));
        expect(item.videoLink, equals('https://cdn.example.com/project.mp4'));
        expect(item.subordinatedRatio, equals('30%'));
        expect(item.detailData['permitNumber'], equals('東京都知事 第001号'));
        expect(item.liveJapanBank?.bankName, equals('みずほ銀行'));
        expect(item.liveJapanBank?.branchBankName, equals('船場支店'));
        expect(item.liveJapanBank?.bankNumber, equals('普通3081072'));
      },
    );

    test(
      'fetchProjectApplyDetail uses apply detail endpoint and parses envelope',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, equals('GET'));
          expect(options.path, equals(FundProjectApiPaths.projectApplyDetail));
          expect(
            options.queryParameters['projectId'],
            equals('448236852676001792'),
          );
          expect(options.extra['auth_required'], isTrue);

          return _jsonOk(
            '{"msg":"success","code":200,"data":{"projectId":"448236852676001792","projectName":"测试项目24308-文军","investmentUnit":1000000,"unitTotal":600,"soldedNumTotal":2,"soldedNumMoneyTotal":2000000,"validApplyTotal":2,"validApplyMoneyTotal":2000000,"avaliableApplyTotal":598,"avaliableApplyMoneyTotal":598000000,"investorList":[{"investorCode":"优先投资人","isOpen":true,"unitTotal":235,"soldedNumTotal":0,"soldedNumMoneyTotal":0,"validApplyTotal":0,"validApplyMoneyTotal":0,"avaliableApplyTotal":235,"avaliableApplyMoneyTotal":235000000}]}}',
          );
        });
        final api = FundProjectApiClient(client);

        final item = await api.fetchProjectApplyDetail(
          projectId: '448236852676001792',
        );

        expect(item.projectId, equals('448236852676001792'));
        expect(item.projectName, equals('测试项目24308-文军'));
        expect(item.investmentUnit, equals(1000000));
        expect(item.availableApplyTotal, equals(598));
        expect(item.availableApplyMoneyTotal, equals(598000000));
        expect(item.investorList, hasLength(1));
        expect(item.investorList.first.investorCode, equals('优先投资人'));
        expect(item.investorList.first.isOpen, isTrue);
        expect(item.investorList.first.availableApplyTotal, equals(235));
      },
    );
  });
}
