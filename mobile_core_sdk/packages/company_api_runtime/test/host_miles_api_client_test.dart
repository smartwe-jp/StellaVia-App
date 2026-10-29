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
  test('fetchTier request contract and response', () async {
    final dio = fixtureDio(
      {
        'currentTier': 'MASTER',
        'pointRate': '0.006',
        'currentBookingRooms': null,
        'maxRooms': '6',
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/points/user-tier-info');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {});
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/points/user-tier-info');
        return dio;
      },
    );
    final value = await api.fetchTier();
    expect(value.currentBookingRooms, isNull);
    expect(value.maxRooms, 6);
    expect(value.pointRate, 0.006);
  });
  test('fetchTier rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio({
        'currentTier': 'MASTER',
        'pointRate': '0.006',
        'currentBookingRooms': null,
        'maxRooms': '6',
      }, code: 500),
    );
    await expectLater(api.fetchTier(), throwsStateError);
  });
  test('fetchAccount request contract and response', () async {
    final dio = fixtureDio(
      {
        'availablePoints': 120,
        'frozenPoints': '30',
        'totalEarnedPoints': 900,
        'expiringSoonPoints': 10,
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/points/user-account-summary');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {});
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/points/user-account-summary');
        return dio;
      },
    );
    final value = await api.fetchAccount();
    expect(value.availablePoints, 120);
    expect(value.totalEarnedPoints, 900);
    expect(value.frozenPoints, 30);
  });
  test('fetchAccount rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio({
        'availablePoints': 120,
        'frozenPoints': '30',
        'totalEarnedPoints': 900,
        'expiringSoonPoints': 10,
      }, code: 500),
    );
    await expectLater(api.fetchAccount(), throwsStateError);
  });
  test('fetchExpiryAlerts request contract and response', () async {
    final dio = fixtureDio(
      [
        {'amount': '15', 'expireDate': 1790833387000},
      ],
      inspect: (options) {
        expect(options.path, '/crowdfunding/points/user-expire-alert');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {});
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/points/user-expire-alert');
        return dio;
      },
    );
    final value = await api.fetchExpiryAlerts();
    expect(value.single.amount, 15);
    expect(value.single.expireDate!.millisecondsSinceEpoch, 1790833387000);
  });
  test('fetchExpiryAlerts rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio([
        {'amount': '15', 'expireDate': 1790833387000},
      ], code: 500),
    );
    await expectLater(api.fetchExpiryAlerts(), throwsStateError);
  });
  test('fetchTierRules request contract and response', () async {
    final dio = fixtureDio(
      [
        {
          'tierCode': 'MASTER',
          'minAum': '10000000',
          'maxAum': null,
          'pointRate': 0.006,
        },
      ],
      inspect: (options) {
        expect(options.path, '/crowdfunding/offline/listRules');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], false);
        expect(options.queryParameters, {});
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/offline/listRules');
        return dio;
      },
    );
    final value = await api.fetchTierRules();
    expect(value.single.minAum, 10000000);
    expect(value.single.maxAum, isNull);
  });
  test('fetchTierRules rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio([
        {
          'tierCode': 'MASTER',
          'minAum': '10000000',
          'maxAum': null,
          'pointRate': 0.006,
        },
      ], code: 500),
    );
    await expectLater(api.fetchTierRules(), throwsStateError);
  });
  test('fetchChart request contract and response', () async {
    final dio = fixtureDio(
      [
        {'date': '2026-01-02', 'points': '0'},
      ],
      inspect: (options) {
        expect(options.path, '/crowdfunding/points/chart');
        expect(options.method, 'POST');
        expect(options.extra['auth_required'], true);
        expect(options.data, {
          'startDate': '2026-01-02',
          'endDate': '2026-02-03',
        });
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/points/chart');
        return dio;
      },
    );
    final value = await api.fetchChart(
      startDate: DateTime(2026, 1, 2),
      endDate: DateTime(2026, 2, 3),
    );
    expect(value.single.date, '2026-01-02');
    expect(value.single.points, 0);
  });
  test('fetchChart rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio([
        {'date': '2026-01-02', 'points': '0'},
      ], code: 500),
    );
    await expectLater(
      api.fetchChart(
        startDate: DateTime(2026, 1, 2),
        endDate: DateTime(2026, 2, 3),
      ),
      throwsStateError,
    );
  });
  test('fetchCumulativeChart request contract and response', () async {
    final dio = fixtureDio(
      {
        'xaxis': ['2026-01', '2026-02'],
        'yaxis': [9020314, '9020320'],
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/points/cumulative-chart');
        expect(options.method, 'GET');
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, {'startMonth': '2025-01'});
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/points/cumulative-chart');
        return dio;
      },
    );
    final value = await api.fetchCumulativeChart(
      startMonth: DateTime(2025, 1, 22),
    );
    expect(value.xaxis, ['2026-01', '2026-02']);
    expect(value.yaxis, [9020314, 9020320]);
  });
  test('fetchCumulativeChart rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio({
        'xaxis': ['2026-01', '2026-02'],
        'yaxis': [9020314, '9020320'],
      }, code: 500),
    );
    await expectLater(
      api.fetchCumulativeChart(startMonth: DateTime(2025, 1, 22)),
      throwsStateError,
    );
  });
  test('fetchTransactions request contract and response', () async {
    final dio = fixtureDio(
      {
        'total': '21',
        'currentPage': 2,
        'limit': 10,
        'rows': [
          {
            'amount': -15000,
            'bizType': 'CONSUME',
            'createTime': 1790833387000,
            'expireTime': '2026-11-01T12:00:00Z',
            'outTradeNo': 'pms-1',
          },
        ],
      },
      inspect: (options) {
        expect(options.path, '/crowdfunding/points/user-transactions');
        expect(options.method, 'POST');
        expect(options.extra['auth_required'], true);
        expect(options.data, {'bizType': 'ISSUE', 'startPage': 2, 'limit': 10});
      },
    );
    final api = HostMilesApiClient(
      dioForPath: (path) {
        expect(path, '/crowdfunding/points/user-transactions');
        return dio;
      },
    );
    final value = await api.fetchTransactions(
      bizType: 'ISSUE',
      startPage: 2,
      limit: 10,
    );
    expect(value.total, 21);
    expect(value.currentPage, 2);
    expect(value.limit, 10);
    expect(value.rows.single.amount, -15000);
    expect(value.rows.single.bizType, 'CONSUME');
    expect(value.rows.single.createTime!.millisecondsSinceEpoch, 1790833387000);
    expect(value.rows.single.expireTime, DateTime.utc(2026, 11, 1, 12));
  });
  test('fetchTransactions rejects backend failure', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => fixtureDio({
        'total': '21',
        'currentPage': 2,
        'limit': 10,
        'rows': [
          {
            'amount': -15000,
            'bizType': 'CONSUME',
            'createTime': 1790833387000,
            'expireTime': '2026-11-01T12:00:00Z',
            'outTradeNo': 'pms-1',
          },
        ],
      }, code: 500),
    );
    await expectLater(
      api.fetchTransactions(bizType: 'ISSUE', startPage: 2, limit: 10),
      throwsStateError,
    );
  });

  test('invalid pagination and ranges never issue requests', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) => throw StateError('unexpected request'),
    );
    await expectLater(api.fetchTransactions(startPage: 0), throwsArgumentError);
    await expectLater(
      api.fetchChart(startDate: DateTime(2027), endDate: DateTime(2026)),
      throwsArgumentError,
    );
  });
  test('absent account is not an empty balance', () async {
    final api = HostMilesApiClient(dioForPath: (_) => fixtureDio(null));
    await expectLater(api.fetchAccount(), throwsFormatException);
  });
  test('empty transaction page retains metadata', () async {
    final api = HostMilesApiClient(
      dioForPath: (_) =>
          fixtureDio({'total': 0, 'limit': 20, 'currentPage': 1, 'rows': []}),
    );
    final page = await api.fetchTransactions();
    expect(page.rows, isEmpty);
    expect(page.total, 0);
  });
  test('invalid chart values cannot shift labels', () {
    expect(
      () => HostMilesCumulativeChartDto.fromJson({
        'xaxis': ['a', 'b'],
        'yaxis': [1, null],
      }),
      throwsFormatException,
    );
  });
  test('network errors propagate', () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          ),
        ),
      ),
    );
    await expectLater(
      HostMilesApiClient(dioForPath: (_) => dio).fetchTier(),
      throwsA(isA<DioException>()),
    );
  });
}
