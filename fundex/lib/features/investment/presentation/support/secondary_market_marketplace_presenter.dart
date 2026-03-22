import 'package:intl/intl.dart';

import '../../../member_profile/domain/entities/mypage_models.dart';
import 'secondary_market_trade_support.dart';

String formatSecondaryMarketRatio(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

String buildSecondaryMarketInvestorTypeDisplay(
  MyPageOrderInquiryRecord record,
) {
  final code = record.investorType?.investorCode?.trim();
  final ratio = formatSecondaryMarketRatio(record.investorType?.earningsRadio);
  if (code == null || code.isEmpty) {
    return ratio;
  }
  return '$code  $ratio';
}

String? formatSecondaryMarketDateTime(String? raw) {
  final date = _parseDateTime(raw);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd HH:mm').format(date);
}

int countSecondaryMarketApplications(MyPageOrderInquiryRecord record) {
  return record.applyList.length;
}

int countSecondaryMarketDeals(MyPageOrderInquiryRecord record) {
  return record.applyResultList.length;
}

String? resolveLatestSecondaryMarketApplicationTime(
  MyPageOrderInquiryRecord record,
) {
  DateTime? latest;
  for (final item in record.applyList) {
    final candidate = _parseDateTime(item.applyTime);
    if (candidate == null) {
      continue;
    }
    if (latest == null || candidate.isAfter(latest)) {
      latest = candidate;
    }
  }
  return latest == null ? null : DateFormat('yyyy/MM/dd HH:mm').format(latest);
}

String? resolveLatestSecondaryMarketDealTime(MyPageOrderInquiryRecord record) {
  DateTime? latest;
  for (final item in record.applyList) {
    final candidate = _parseDateTime(item.passTime);
    if (candidate == null) {
      continue;
    }
    if (latest == null || candidate.isAfter(latest)) {
      latest = candidate;
    }
  }
  for (final item in record.applyResultList) {
    final candidate = _parseDateTime(item.createTime);
    if (candidate == null) {
      continue;
    }
    if (latest == null || candidate.isAfter(latest)) {
      latest = candidate;
    }
  }
  return latest == null ? null : DateFormat('yyyy/MM/dd HH:mm').format(latest);
}

String formatSecondaryMarketCompletionRate(MyPageOrderInquiryRecord record) {
  final sell = record.sellNum ?? 0;
  if (sell <= 0) {
    return '0%';
  }
  final sold = record.soldNum ?? 0;
  final percentage = (sold / sell) * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

String formatSecondaryMarketRemainingUnits(MyPageOrderInquiryRecord record) {
  return remainingUnitsForSecondaryMarketRecord(record).toString();
}

DateTime? _parseDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  return DateTime.tryParse(raw.trim().replaceAll(' ', 'T'));
}
