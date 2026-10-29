class HostMilesTier {
  const HostMilesTier({
    this.currentTier,
    this.pointRate,
    this.expireMonths,
    this.leadTimeMonths,
    this.currentBookingRooms,
    this.maxRooms,
    this.currentAum,
    this.nextTier,
    this.nextTierGap,
  });
  final String? currentTier;
  final num? pointRate;
  final int? expireMonths;
  final int? leadTimeMonths;
  final int? currentBookingRooms;
  final int? maxRooms;
  final int? currentAum;
  final String? nextTier;
  final int? nextTierGap;

  /// Missing room counts are unknown, never zero availability usage.
  int? get remainingBookingRooms {
    final maximum = maxRooms;
    final booked = currentBookingRooms;
    if (maximum == null || booked == null || maximum < 0 || booked < 0) {
      return null;
    }
    return (maximum - booked).clamp(0, maximum);
  }
}

class HostMilesAccount {
  const HostMilesAccount({
    this.availablePoints,
    this.expiringSoonPoints,
    this.frozenPoints,
    this.totalEarnedPoints,
  });
  final int? availablePoints;
  final int? expiringSoonPoints;
  final int? frozenPoints;
  final int? totalEarnedPoints;
}

class HostMilesExpiry {
  const HostMilesExpiry({this.amount, this.expireDate});
  final int? amount;
  final DateTime? expireDate;
}

class HostMilesTierRule {
  const HostMilesTierRule({
    this.id,
    this.tierCode,
    this.minAum,
    this.maxAum,
    this.pointRate,
    this.expireMonths,
    this.leadTimeMonths,
    this.maxRooms,
  });
  final int? id;
  final String? tierCode;
  final int? minAum;
  final int? maxAum;
  final num? pointRate;
  final int? expireMonths;
  final int? leadTimeMonths;
  final int? maxRooms;
}

class HostMilesChartEntry {
  const HostMilesChartEntry({this.date, this.points});
  final String? date;
  final int? points;
}

class HostMilesCumulativeChart {
  const HostMilesCumulativeChart({
    this.xaxis = const [],
    this.yaxis = const [],
  });
  final List<String> xaxis;
  final List<int> yaxis;

  /// Historical earned miles, not spendable balance. Empty charts have no total.
  int? get cumulativeEarnedPoints => yaxis.isEmpty ? null : yaxis.last;
}

class HostMilesTransaction {
  const HostMilesTransaction({
    this.amount,
    this.bizType,
    this.createTime,
    this.expireTime,
    this.outTradeNo,
  });
  final int? amount;
  final String? bizType;
  final DateTime? createTime;
  final DateTime? expireTime;
  final String? outTradeNo;
}

class HostMilesTransactionPage {
  const HostMilesTransactionPage({
    this.total,
    this.limit,
    this.currentPage,
    this.rows = const [],
  });
  final int? total;
  final int? limit;
  final int? currentPage;
  final List<HostMilesTransaction> rows;
}
