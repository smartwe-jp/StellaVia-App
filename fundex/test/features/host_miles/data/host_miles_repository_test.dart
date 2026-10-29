import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/host_miles/data/datasources/host_miles_remote_data_source.dart';
import 'package:fundex/features/host_miles/data/repositories/host_miles_repository_impl.dart';
import 'package:fundex/features/host_miles/data/mappers/host_miles_mapper.dart';
import 'package:fundex/features/asset_statistics/data/mappers/asset_statistics_mapper.dart';

void main() {
  test('tier preserves unknown rooms and caps exceeded quota at zero', () {
    expect(
      const HostMilesTierDto(maxRooms: 6).toEntity().remainingBookingRooms,
      isNull,
    );
    expect(
      const HostMilesTierDto(
        maxRooms: 6,
        currentBookingRooms: 2,
      ).toEntity().remainingBookingRooms,
      4,
    );
    expect(
      const HostMilesTierDto(
        maxRooms: 6,
        currentBookingRooms: 7,
      ).toEntity().remainingBookingRooms,
      0,
    );
    expect(
      const HostMilesTierDto(
        maxRooms: 6,
        currentBookingRooms: -1,
      ).toEntity().remainingBookingRooms,
      isNull,
    );
  });
  test('cumulative total is last value, never sum; empty is unknown', () {
    final chart = const HostMilesCumulativeChartDto(
      xaxis: ['2026-01', '2026-02'],
      yaxis: [10, 15],
    ).toEntity();
    expect(chart.cumulativeEarnedPoints, 15);
    expect(
      const HostMilesCumulativeChartDto().toEntity().cumulativeEarnedPoints,
      isNull,
    );
    expect(() => chart.yaxis.add(20), throwsUnsupportedError);
  });
  test('mismatched axes fail rather than silently pairing wrong values', () {
    expect(
      () => const HostMilesCumulativeChartDto(
        xaxis: ['2026-01'],
        yaxis: [],
      ).toEntity(),
      throwsFormatException,
    );
    expect(
      () => const AssetCumulativeBenefitDto(dates: [], values: [10]).toEntity(),
      throwsFormatException,
    );
  });
  test(
    'repository carries API metadata and signed transaction amounts',
    () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.data, {
              'startPage': 3,
              'limit': 10,
              'bizType': 'EXPIRE',
            });
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'code': 200,
                  'data': {
                    'total': 25,
                    'limit': 10,
                    'currentPage': 3,
                    'rows': [
                      {
                        'bizType': 'EXPIRE',
                        'amount': -12,
                        'createTime': 1790833387000,
                      },
                    ],
                  },
                },
              ),
            );
          },
        ),
      );
      final repository = HostMilesRepositoryImpl(
        HostMilesRemoteDataSource(HostMilesApiClient(dioForPath: (_) => dio)),
      );
      final page = await repository.fetchTransactions(
        bizType: 'EXPIRE',
        startPage: 3,
        limit: 10,
      );
      expect(page.total, 25);
      expect(page.currentPage, 3);
      expect(page.limit, 10);
      expect(page.rows.single.amount, -12);
      expect(
        page.rows.single.createTime!.millisecondsSinceEpoch,
        1790833387000,
      );
    },
  );
  test('forecast preserves independent principal dates and floating flag', () {
    final value = const AssetBenefitForecastDto(
      expectBenefitList: [
        AssetExpectedBenefitDto(
          yearMonth: '2027-01',
          expectBenefit: 284821,
          floatBenefit: true,
        ),
      ],
      expectPrincipalList: [
        AssetExpectedPrincipalDto(
          yearMonth: '2027-08',
          expectPrincipal: 500000,
        ),
      ],
    ).toEntity();
    expect(value.expectBenefitList.single.floatBenefit, true);
    expect(value.expectPrincipalList.single.yearMonth, '2027-08');
    expect(value.expectPrincipalList.single.expectPrincipal, 500000);
  });
}
