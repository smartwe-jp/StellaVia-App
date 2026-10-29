import '../statistics/statistics_wire_values.dart';

class HostMilesTierDto {
  const HostMilesTierDto({
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
  factory HostMilesTierDto.fromJson(Map<String, dynamic> json) =>
      HostMilesTierDto(
        currentTier: readString(json['currentTier']),
        pointRate: readNumber(json['pointRate']),
        expireMonths: readInteger(json['expireMonths']),
        leadTimeMonths: readInteger(json['leadTimeMonths']),
        currentBookingRooms: readInteger(json['currentBookingRooms']),
        maxRooms: readInteger(json['maxRooms']),
        currentAum: readInteger(json['currentAum']),
        nextTier: readString(json['nextTier']),
        nextTierGap: readInteger(json['nextTierGap']),
      );
}

class HostMilesAccountDto {
  const HostMilesAccountDto({
    this.availablePoints,
    this.expiringSoonPoints,
    this.frozenPoints,
    this.totalEarnedPoints,
  });
  final int? availablePoints;
  final int? expiringSoonPoints;
  final int? frozenPoints;
  final int? totalEarnedPoints;
  factory HostMilesAccountDto.fromJson(Map<String, dynamic> json) =>
      HostMilesAccountDto(
        availablePoints: readInteger(json['availablePoints']),
        expiringSoonPoints: readInteger(json['expiringSoonPoints']),
        frozenPoints: readInteger(json['frozenPoints']),
        totalEarnedPoints: readInteger(json['totalEarnedPoints']),
      );
}

class HostMilesExpiryDto {
  const HostMilesExpiryDto({this.amount, this.expireDate});
  final int? amount;
  final DateTime? expireDate;
  factory HostMilesExpiryDto.fromJson(Map<String, dynamic> json) =>
      HostMilesExpiryDto(
        amount: readInteger(json['amount']),
        expireDate: readTimestamp(json['expireDate']),
      );
}

class HostMilesTierRuleDto {
  const HostMilesTierRuleDto({
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
  factory HostMilesTierRuleDto.fromJson(Map<String, dynamic> json) =>
      HostMilesTierRuleDto(
        id: readInteger(json['id']),
        tierCode: readString(json['tierCode']),
        minAum: readInteger(json['minAum']),
        maxAum: readInteger(json['maxAum']),
        pointRate: readNumber(json['pointRate']),
        expireMonths: readInteger(json['expireMonths']),
        leadTimeMonths: readInteger(json['leadTimeMonths']),
        maxRooms: readInteger(json['maxRooms']),
      );
}

class HostMilesChartEntryDto {
  const HostMilesChartEntryDto({this.date, this.points});
  final String? date;
  final int? points;
  factory HostMilesChartEntryDto.fromJson(Map<String, dynamic> json) =>
      HostMilesChartEntryDto(
        date: readString(json['date']),
        points: readInteger(json['points']),
      );
}

class HostMilesCumulativeChartDto {
  const HostMilesCumulativeChartDto({
    this.xaxis = const [],
    this.yaxis = const [],
  });
  final List<String> xaxis;
  final List<int> yaxis;
  factory HostMilesCumulativeChartDto.fromJson(Map<String, dynamic> json) =>
      HostMilesCumulativeChartDto(
        xaxis: readList(json['xaxis'], readString),
        yaxis: readList(json['yaxis'], readInteger),
      );
}

class HostMilesTransactionDto {
  const HostMilesTransactionDto({
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
  factory HostMilesTransactionDto.fromJson(Map<String, dynamic> json) =>
      HostMilesTransactionDto(
        amount: readInteger(json['amount']),
        bizType: readString(json['bizType']),
        createTime: readTimestamp(json['createTime']),
        expireTime: readTimestamp(json['expireTime']),
        outTradeNo: readString(json['outTradeNo']),
      );
}

class HostMilesTransactionPageDto {
  const HostMilesTransactionPageDto({
    this.total,
    this.limit,
    this.currentPage,
    this.rows = const [],
  });
  final int? total;
  final int? limit;
  final int? currentPage;
  final List<HostMilesTransactionDto> rows;
  factory HostMilesTransactionPageDto.fromJson(Map<String, dynamic> json) =>
      HostMilesTransactionPageDto(
        total: readInteger(json['total']),
        limit: readInteger(json['limit']),
        currentPage: readInteger(json['currentPage']),
        rows: readList(
          json['rows'],
          (value) => readObject(value, HostMilesTransactionDto.fromJson),
        ),
      );
}
