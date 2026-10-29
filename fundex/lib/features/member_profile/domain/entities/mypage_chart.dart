enum MyPageChartKind { operating, dividends, miles }

class MyPageChartPoint {
  const MyPageChartPoint(this.date, this.value);
  final DateTime date;
  final num value;
}

class MyPageChartData {
  const MyPageChartData({
    required this.start,
    required this.end,
    required this.points,
    this.total,
  });
  final DateTime start;
  final DateTime end;
  final List<MyPageChartPoint> points;
  final num? total;
}
