import 'dart:convert';
import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

Dio fixtureDio(
  Object? data, {
  int code = 200,
  void Function(RequestOptions)? inspect,
}) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        inspect?.call(options);
        handler.resolve(
          Response(
            requestOptions: options,
            data: jsonDecode(
              jsonEncode({'code': code, 'msg': 'fixture', 'data': data}),
            ),
          ),
        );
      },
    ),
  );
  return dio;
}

void main() {
  test('fetchInvestments request contract and response', () async {
    final dio = fixtureDio(
      {
        'investTotal': '90203200',
        'investList': [
          {
            'projectId': '453461223651215337',
            'projectStatus': 4,
            'investNumValid': 1,
            'investMoneyValid': 102000,
            'beginDate': '2024-05-01',
          },
        ],
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/user/invest/chart');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {});
      },
    );
    final api = AssetStatisticsApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/user/invest/chart');
        return dio;
      },
    );
    final value = await api.fetchInvestments();
    expect(value.investTotal, 90203200);
    expect(value.investList.single.projectId, '453461223651215337');
    expect(value.investList.single.projectStatus, 4);
  });
  test('fetchInvestments rejects backend failure', () async {
    final api = AssetStatisticsApiClient(
      dioForPath: (_) => fixtureDio({
        'investTotal': '90203200',
        'investList': [
          {
            'projectId': '453461223651215337',
            'projectStatus': 4,
            'investNumValid': 1,
            'investMoneyValid': 102000,
            'beginDate': '2024-05-01',
          },
        ],
      }, code: 500),
    );
    await expectLater(api.fetchInvestments(), throwsStateError);
  });
  test('fetchCumulativeBenefit request contract and response', () async {
    final dio = fixtureDio(
      {
        'total': 583630,
        'dates': ['2024-08-24', '2026-05-22'],
        'values': [18333, 583630],
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/benefit/chart/cumulative');
        expect(options.method, 'POST');
        expect(options.extra['auth_required'], true);
        expect(options.data, {
          'startDate': '2020-09-01',
          'endDate': '2029-09-01',
        });
      },
    );
    final api = AssetStatisticsApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/benefit/chart/cumulative');
        return dio;
      },
    );
    final value = await api.fetchCumulativeBenefit(
      startDate: DateTime(2020, 9, 1),
      endDate: DateTime(2029, 9, 1),
    );
    expect(value.total, 583630);
    expect(value.values, [18333, 583630]);
  });
  test('fetchCumulativeBenefit rejects backend failure', () async {
    final api = AssetStatisticsApiClient(
      dioForPath: (_) => fixtureDio({
        'total': 583630,
        'dates': ['2024-08-24', '2026-05-22'],
        'values': [18333, 583630],
      }, code: 500),
    );
    await expectLater(
      api.fetchCumulativeBenefit(
        startDate: DateTime(2020, 9, 1),
        endDate: DateTime(2029, 9, 1),
      ),
      throwsStateError,
    );
  });
  test('fetchForecast request contract and response', () async {
    final dio = fixtureDio(
      {
        'expectBenefitList': [
          {
            'yearMonth': '2027-01',
            'expectBenefit': 284821,
            'floatBenefit': true,
          },
        ],
        'expectPrincipalList': [
          {
            'yearMonth': {'year': 2027, 'monthValue': 8},
            'expectPrincipal': 500000,
          },
        ],
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/benefit/expect');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {'endYearMonth': '2029-01'});
      },
    );
    final api = AssetStatisticsApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/benefit/expect');
        return dio;
      },
    );
    final value = await api.fetchForecast(endYearMonth: DateTime(2029, 1, 5));
    expect(value.expectBenefitList.single.floatBenefit, true);
    expect(value.expectBenefitList.single.yearMonth, '2027-01');
    expect(value.expectPrincipalList.single.yearMonth, '2027-08');
    expect(value.expectPrincipalList.single.expectPrincipal, 500000);
  });
  test('fetchForecast rejects backend failure', () async {
    final api = AssetStatisticsApiClient(
      dioForPath: (_) => fixtureDio({
        'expectBenefitList': [
          {
            'yearMonth': '2027-01',
            'expectBenefit': 284821,
            'floatBenefit': true,
          },
        ],
        'expectPrincipalList': [
          {
            'yearMonth': {'year': 2027, 'monthValue': 8},
            'expectPrincipal': 500000,
          },
        ],
      }, code: 500),
    );
    await expectLater(
      api.fetchForecast(endYearMonth: DateTime(2029, 1, 5)),
      throwsStateError,
    );
  });
  test('fetchYearlyBenefits request contract and response', () async {
    final dio = fixtureDio(
      [
        {
          'year': 2024,
          'totalBenefit': 572781,
          'totalTax': 116945,
          'actualBenefit': 455836,
        },
      ],
      inspect: (options) {
        expect(options.path, '/crowdfunding/benefit/year-statistic');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {'startYear': 2021});
      },
    );
    final api = AssetStatisticsApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/benefit/year-statistic');
        return dio;
      },
    );
    final value = await api.fetchYearlyBenefits(startYear: 2021);
    expect(value.single.totalTax, 116945);
    expect(value.single.actualBenefit, 455836);
  });
  test('fetchYearlyBenefits rejects backend failure', () async {
    final api = AssetStatisticsApiClient(
      dioForPath: (_) => fixtureDio([
        {
          'year': 2024,
          'totalBenefit': 572781,
          'totalTax': 116945,
          'actualBenefit': 455836,
        },
      ], code: 500),
    );
    await expectLater(
      api.fetchYearlyBenefits(startYear: 2021),
      throwsStateError,
    );
  });
}
