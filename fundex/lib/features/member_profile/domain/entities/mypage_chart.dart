import '../../../asset_statistics/domain/entities/asset_statistics_models.dart';

enum MyPageChartKind { miles, operating, dividends, available }

class MyPageChartPoint {
  const MyPageChartPoint(this.date, this.value, {String? label})
    : _label = label;
  final String? _label;
  String get label => _label ?? date.toIso8601String().substring(0, 10);
  final DateTime date;
  final num value;
}

class MyPageChartData {
  const MyPageChartData({
    required this.start,
    required this.end,
    this.points = const [],
    this.total,
    this.holdings = const [],
  });
  final DateTime start, end;
  final List<MyPageChartPoint> points;
  final num? total;
  final List<AssetInvestment> holdings;

  static DateTime rangeStart(DateTime end, int years) =>
      DateTime(end.year - years, end.month, end.day);

  MyPageChartData historyWindow(int years, DateTime now) {
    final end = DateTime(now.year, now.month, now.day);
    final start = rangeStart(end, years);
    final until = DateTime(end.year, end.month, end.day + 1);
    return MyPageChartData(
      start: start,
      end: end,
      points: points
          .where((p) => !p.date.isBefore(start) && p.date.isBefore(until))
          .toList(growable: false),
    );
  }
}
