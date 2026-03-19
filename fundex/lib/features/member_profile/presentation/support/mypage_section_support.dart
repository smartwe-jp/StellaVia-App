import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../domain/entities/mypage_models.dart';

enum MyPageSectionType {
  pendingApplications('pending'),
  coolingOff('cooling-off'),
  activeFunds('active');

  const MyPageSectionType(this.queryValue);

  final String queryValue;

  static MyPageSectionType? fromQueryValue(String? value) {
    for (final type in values) {
      if (type.queryValue == value) {
        return type;
      }
    }
    return null;
  }
}

List<MyPageApplyRecord> selectPendingApplyRecords(
  List<MyPageApplyRecord> records,
) {
  final sorted = [...records]
    ..sort((a, b) => compareByDateDesc(a.applyTime, b.applyTime));
  return sorted.where((record) => record.status == 0).toList(growable: false);
}

List<MyPageOrderInquiryRecord> selectCoolingOffRecords(
  List<MyPageOrderInquiryRecord> records, {
  int? maxItems,
}) {
  final sorted = [...records]
    ..sort((a, b) => compareByDateDesc(a.createTime, b.createTime));
  final uniqueByProject = <String, MyPageOrderInquiryRecord>{};
  for (final record in sorted) {
    final key =
        resolveOrderProjectId(record) ??
        record.id ??
        '${record.projectName}_${record.createTime ?? ''}';
    uniqueByProject.putIfAbsent(key, () => record);
  }
  final values = uniqueByProject.values.toList(growable: false);
  if (maxItems == null) {
    return values;
  }
  return values.take(maxItems).toList(growable: false);
}

List<MyPageInvestmentGroup> groupActiveInvestmentRecords(
  List<MyPageInvestmentRecord> records,
) {
  final source = records.where((record) => record.projectStatus == 4).toList();
  final filtered = source.isEmpty ? [...records] : source;
  filtered.sort((a, b) => compareByDateDesc(a.createTime, b.createTime));

  final groups = <String, _InvestmentGroupAccumulator>{};
  for (final record in filtered) {
    final key = record.projectId;
    groups.putIfAbsent(key, () => _InvestmentGroupAccumulator(record));
    groups[key]!.add(record);
  }

  final values = groups.values
      .map((accumulator) => accumulator.build())
      .toList(growable: false);
  values.sort(
    (a, b) => compareDateTimeDesc(a.latestCreateTime, b.latestCreateTime),
  );
  return values;
}

String resolveSectionTitle(AppLocalizations l10n, MyPageSectionType type) {
  return switch (type) {
    MyPageSectionType.pendingApplications =>
      l10n.myPagePendingApplicationsTitle,
    MyPageSectionType.coolingOff => l10n.myPageCoolingOffTitle,
    MyPageSectionType.activeFunds => l10n.myPageOperatingFundsTitle,
  };
}

String resolveSectionEmptyState(AppLocalizations l10n, MyPageSectionType type) {
  return switch (type) {
    MyPageSectionType.pendingApplications => l10n.myPagePendingEmptyState,
    MyPageSectionType.coolingOff => l10n.myPageCoolingOffEmptyState,
    MyPageSectionType.activeFunds => l10n.myPageOperatingFundsEmptyState,
  };
}

String resolveProjectStatusLabel(AppLocalizations l10n, int? projectStatus) {
  return switch (projectStatus) {
    0 => l10n.fundListStatusUpcoming,
    1 => l10n.fundListStatusOpen,
    2 => l10n.fundListStatusFailed,
    3 => l10n.fundListStatusClosed,
    4 => l10n.fundListStatusOperating,
    5 => l10n.fundListStatusOperatingEnded,
    7 => l10n.fundListStatusCompleted,
    _ => l10n.fundListStatusUnknown,
  };
}

String resolveApplyStatusLabel(
  AppLocalizations l10n,
  MyPageApplyRecord record,
) {
  return switch (record.status) {
    0 => l10n.myPageApplyStatusUnderReview,
    1 => l10n.myPageApplyStatusReviewed,
    2 => l10n.myPageApplyStatusAwaitingPayment,
    3 => l10n.myPageApplyStatusPaid,
    4 => l10n.myPageApplyStatusCancellationReview,
    5 => l10n.myPageApplyStatusCancelled,
    _ => l10n.myPageApplyStatusUnderReview,
  };
}

FundLabeledValue buildApplySecondaryRow(
  AppLocalizations l10n,
  MyPageApplyRecord record,
) {
  return switch (record.status) {
    0 => FundLabeledValue(
      label: l10n.myPageApplySubmittedAtLabel,
      value:
          formatDateTimeOrNull(record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    1 => FundLabeledValue(
      label: l10n.myPageApplyReviewedAtLabel,
      value:
          formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    2 => FundLabeledValue(
      label: l10n.myPageApplyPaymentNoticeLabel,
      value:
          formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    3 => FundLabeledValue(
      label: l10n.myPageApplyPaidAtLabel,
      value:
          formatDateTimeOrNull(
            record.actualArrivalTime ?? record.passTime ?? record.applyTime,
          ) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    4 => FundLabeledValue(
      label: l10n.myPageApplyCancellationRequestedAtLabel,
      value:
          formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    5 => FundLabeledValue(
      label: l10n.myPageApplyCancelledAtLabel,
      value:
          formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    _ => FundLabeledValue(
      label: l10n.myPageApplySubmittedAtLabel,
      value:
          formatDateTimeOrNull(record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
  };
}

bool canShowApplyCancelAction(int? status) {
  return switch (status) {
    0 || 1 || 2 => true,
    _ => false,
  };
}

String? resolveOrderProjectId(MyPageOrderInquiryRecord record) {
  return record.investorType?.projectId ??
      (record.pdfDocuments.isNotEmpty
          ? record.pdfDocuments.first.projectId
          : null);
}

DateTime? resolveCoolingOffDeadline(MyPageOrderInquiryRecord record) {
  final base = parseApiDate(record.createTime);
  if (base == null) {
    return null;
  }
  return DateTime(base.year, base.month, base.day).add(const Duration(days: 8));
}

Color resolveCoolingOffDeadlineColor(BuildContext context, DateTime? deadline) {
  final colors = Theme.of(context).appColors;
  if (deadline == null) {
    return colors.textSecondary;
  }
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
  return deadlineDate.isBefore(todayDate)
      ? colors.textSecondary
      : colors.danger;
}

String formatCoolingOffDeadlineLabel(
  AppLocalizations l10n,
  DateTime? deadline, {
  required String localeTag,
}) {
  if (deadline == null) {
    return l10n.myPageResultAnnouncementTbd;
  }

  final dateText = DateFormat('M/d', localeTag).format(deadline);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
  final remainingDays = deadlineDate.difference(today).inDays;

  if (remainingDays >= 0) {
    return l10n.myPageCoolingOffDeadlineRemaining(dateText, remainingDays);
  }
  return l10n.myPageCoolingOffDeadlineExpired(dateText);
}

String resolveYieldLabel(FundProject? project, {double? fallbackRatio}) {
  final ratio =
      project?.expectedDistributionRatioMax ??
      project?.expectedDistributionRatioMin ??
      project?.investorTypes.firstOrNull?.earningsRadio ??
      fallbackRatio;
  return formatYieldPercent(ratio);
}

String formatYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

String formatCurrency(num? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return formatter.format(amount);
}

String? formatDateOrNull(String? raw) {
  final date = parseApiDate(raw);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd').format(date);
}

String? formatDateTimeOrNull(String? raw) {
  final date = parseApiDate(raw);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd HH:mm').format(date);
}

DateTime? parseApiDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }

  final value = raw.trim();
  for (final pattern in <String>['yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd']) {
    try {
      return DateFormat(pattern).parseStrict(value);
    } catch (_) {
      continue;
    }
  }

  return DateTime.tryParse(value);
}

int compareByDateDesc(String? left, String? right) {
  return compareDateTimeDesc(parseApiDate(left), parseApiDate(right));
}

int compareDateTimeDesc(DateTime? left, DateTime? right) {
  if (left == null && right == null) {
    return 0;
  }
  if (left == null) {
    return 1;
  }
  if (right == null) {
    return -1;
  }
  return right.compareTo(left);
}

class MyPageInvestmentGroup {
  const MyPageInvestmentGroup({
    required this.projectId,
    required this.projectName,
    required this.investMoney,
    required this.earnings,
    required this.earningRatio,
    required this.latestCreateTime,
  });

  final String projectId;
  final String projectName;
  final num investMoney;
  final num earnings;
  final double? earningRatio;
  final DateTime? latestCreateTime;
}

class _InvestmentGroupAccumulator {
  _InvestmentGroupAccumulator(MyPageInvestmentRecord seed)
    : projectId = seed.projectId,
      projectName = seed.projectName,
      investMoney = seed.investMoney ?? 0,
      earnings = seed.earnings ?? 0,
      latestCreateTime = parseApiDate(seed.createTime),
      earningRatio = seed.earningRadio ?? seed.investorType?.earningsRadio;

  final String projectId;
  final String projectName;
  num investMoney;
  num earnings;
  double? earningRatio;
  DateTime? latestCreateTime;

  void add(MyPageInvestmentRecord record) {
    investMoney += record.investMoney ?? 0;
    earnings += record.earnings ?? 0;
    earningRatio ??= record.earningRadio ?? record.investorType?.earningsRadio;
    final candidateDate = parseApiDate(record.createTime);
    if (compareDateTimeDesc(latestCreateTime, candidateDate) > 0) {
      latestCreateTime = candidateDate;
    }
  }

  MyPageInvestmentGroup build() {
    return MyPageInvestmentGroup(
      projectId: projectId,
      projectName: projectName,
      investMoney: investMoney,
      earnings: earnings,
      earningRatio: earningRatio,
      latestCreateTime: latestCreateTime,
    );
  }
}
