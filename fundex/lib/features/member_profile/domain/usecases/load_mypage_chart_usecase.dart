import '../../../asset_statistics/domain/repositories/asset_statistics_repository.dart';
import '../../../host_miles/domain/repositories/host_miles_repository.dart';
import '../entities/mypage_chart.dart';
import '../repositories/mypage_repository.dart';

class LoadMyPageChartUseCase {
  const LoadMyPageChartUseCase(this.profile, this.assets, this.miles);
  final MyPageRepository profile;
  final AssetStatisticsRepository assets;
  final HostMilesRepository miles;

  Future<MyPageChartData> call(
    MyPageChartKind kind,
    int years,
    DateTime now,
  ) async {
    final end = DateTime(now.year, now.month, now.day);
    final start = DateTime(now.year - years + 1);
    final points = <MyPageChartPoint>[];
    num? total;
    void add(String? raw, num? value) {
      if (raw == null || value == null || !value.isFinite) return;
      final date = DateTime.tryParse(raw.length == 7 ? '$raw-01' : raw);
      if (date != null && !date.isBefore(start) && !date.isAfter(end)) {
        points.add(MyPageChartPoint(date, value));
      }
    }

    switch (kind) {
      case MyPageChartKind.operating:
        final rows = await profile.fetchAssetTrend(
          startDate: start,
          endDate: end,
        );
        for (final row in rows) {
          add(row.recordDate, row.totalFundAccount);
        }
        points.sort((a, b) => a.date.compareTo(b.date));
        total = points.isEmpty ? null : points.last.value;
      case MyPageChartKind.dividends:
        final data = await assets.fetchCumulativeBenefit(
          startDate: start,
          endDate: end,
        );
        if (data.dates.length != data.values.length) {
          throw const FormatException('Chart axes mismatch');
        }
        for (var i = 0; i < data.dates.length; i++) {
          add(data.dates[i], data.values[i]);
        }
        total = data.total;
      case MyPageChartKind.miles:
        final data = await miles.fetchCumulativeChart(startMonth: start);
        if (data.xaxis.length != data.yaxis.length) {
          throw const FormatException('Chart axes mismatch');
        }
        for (var i = 0; i < data.xaxis.length; i++) {
          add(data.xaxis[i], data.yaxis[i]);
        }
        total = data.cumulativeEarnedPoints;
    }
    points.sort((a, b) => a.date.compareTo(b.date));
    return MyPageChartData(
      start: start,
      end: end,
      points: List.unmodifiable(points),
      total: total,
    );
  }
}
