import 'package:company_api_runtime/company_api_runtime.dart';
import '../../domain/entities/host_miles_models.dart';

extension HostMilesTierMapping on HostMilesTierDto {
  HostMilesTier toEntity() {
    return HostMilesTier(
      currentTier: currentTier,
      pointRate: pointRate,
      expireMonths: expireMonths,
      leadTimeMonths: leadTimeMonths,
      currentBookingRooms: currentBookingRooms,
      maxRooms: maxRooms,
      currentAum: currentAum,
      nextTier: nextTier,
      nextTierGap: nextTierGap,
    );
  }
}

extension HostMilesAccountMapping on HostMilesAccountDto {
  HostMilesAccount toEntity() {
    return HostMilesAccount(
      availablePoints: availablePoints,
      expiringSoonPoints: expiringSoonPoints,
      frozenPoints: frozenPoints,
      totalEarnedPoints: totalEarnedPoints,
    );
  }
}

extension HostMilesExpiryMapping on HostMilesExpiryDto {
  HostMilesExpiry toEntity() {
    return HostMilesExpiry(amount: amount, expireDate: expireDate);
  }
}

extension HostMilesTierRuleMapping on HostMilesTierRuleDto {
  HostMilesTierRule toEntity() {
    return HostMilesTierRule(
      id: id,
      tierCode: tierCode,
      minAum: minAum,
      maxAum: maxAum,
      pointRate: pointRate,
      expireMonths: expireMonths,
      leadTimeMonths: leadTimeMonths,
      maxRooms: maxRooms,
    );
  }
}

extension HostMilesChartEntryMapping on HostMilesChartEntryDto {
  HostMilesChartEntry toEntity() {
    return HostMilesChartEntry(date: date, points: points);
  }
}

extension HostMilesCumulativeChartMapping on HostMilesCumulativeChartDto {
  HostMilesCumulativeChart toEntity() {
    if (xaxis.length != yaxis.length) {
      throw const FormatException('Chart axes have different lengths.');
    }
    return HostMilesCumulativeChart(
      xaxis: List.unmodifiable(xaxis),
      yaxis: List.unmodifiable(yaxis),
    );
  }
}

extension HostMilesTransactionMapping on HostMilesTransactionDto {
  HostMilesTransaction toEntity() {
    return HostMilesTransaction(
      amount: amount,
      bizType: bizType,
      createTime: createTime,
      expireTime: expireTime,
      outTradeNo: outTradeNo,
    );
  }
}

extension HostMilesTransactionPageMapping on HostMilesTransactionPageDto {
  HostMilesTransactionPage toEntity() {
    return HostMilesTransactionPage(
      total: total,
      limit: limit,
      currentPage: currentPage,
      rows: List.unmodifiable(rows.map((item) => item.toEntity())),
    );
  }
}
