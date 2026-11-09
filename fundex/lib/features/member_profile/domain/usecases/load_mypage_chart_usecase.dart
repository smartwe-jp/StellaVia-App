import '../../../asset_statistics/domain/repositories/asset_statistics_repository.dart';
import '../../../host_miles/domain/repositories/host_miles_repository.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../entities/mypage_chart.dart';

class LoadMyPageChartUseCase {
  const LoadMyPageChartUseCase(this.wallet, this.assets, this.miles);
  final WalletRepository wallet;
  final AssetStatisticsRepository assets;
  final HostMilesRepository miles;

  Future<MyPageChartData> call(
    MyPageChartKind kind,
    int years,
    DateTime now,
  ) async {
    final end = DateTime(now.year, now.month, now.day);
    final start = MyPageChartData.rangeStart(end, years);
    final points = <MyPageChartPoint>[];
    void add(String? raw, num? value) {
      final date = _date(raw);
      if (date != null) {
        points.add(
          MyPageChartPoint(
            date,
            value?.isFinite == true ? value! : 0,
            label: kind == MyPageChartKind.available ? null : raw,
          ),
        );
      }
    }

    switch (kind) {
      case MyPageChartKind.operating:
        final chart = await assets.fetchInvestments();
        return MyPageChartData(
          start: start,
          end: end,
          total: chart.investTotal,
          holdings: chart.investList,
        );
      case MyPageChartKind.dividends:
        final chart = await assets.fetchCumulativeBenefit(
          startDate: start,
          endDate: end,
        );
        for (var i = 0; i < chart.dates.length; i++) {
          add(chart.dates[i], i < chart.values.length ? chart.values[i] : 0);
        }
        return MyPageChartData(
          start: start,
          end: end,
          total: chart.total,
          points: points,
        );
      case MyPageChartKind.miles:
        final rows = await miles.fetchChart(startDate: start, endDate: end);
        for (final row in rows) {
          add(row.date, row.points);
        }
        return MyPageChartData(
          start: start,
          end: end,
          points: points,
          total: points.lastOrNull?.value ?? 0,
        );
      case MyPageChartKind.available:
        final rows = await wallet.fetchAccountHistory(accountType: null);
        for (final row in rows) {
          if (row.balance?.isFinite != true) continue;
          add(
            row.tradeTime?.isNotEmpty == true ? row.tradeTime : row.createTime,
            row.balance,
          );
        }
        points.sort((a, b) => a.date.compareTo(b.date));
        // Keep the unfiltered account history for local range changes.
        return MyPageChartData(start: start, end: end, points: points);
    }
  }

  DateTime? _date(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final numeric = int.tryParse(raw);
    if (numeric != null && (raw.length == 10 || raw.length == 13)) {
      return DateTime.fromMillisecondsSinceEpoch(
        raw.length == 10 ? numeric * 1000 : numeric,
      );
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed.toLocal();
    final normalized = raw.replaceAll('.', '-').replaceAll('/', '-');
    return DateTime.tryParse(
      normalized.length == 7 ? '$normalized-01' : normalized,
    )?.toLocal();
  }
}
