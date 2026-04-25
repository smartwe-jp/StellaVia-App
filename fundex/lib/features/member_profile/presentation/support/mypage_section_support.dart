import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/support/fund_lottery_apply_step.dart';
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

enum MyPageApplyHistoryFilter {
  all,
  applying,
  pendingConfirmation,
  completed,
  invalid,
}

enum MyPageActiveFundFilter { operating, ended }

extension MyPageApplyHistoryFilterX on MyPageApplyHistoryFilter {
  String get queryValue {
    return switch (this) {
      MyPageApplyHistoryFilter.all => 'all',
      MyPageApplyHistoryFilter.applying => 'applying',
      MyPageApplyHistoryFilter.pendingConfirmation => 'pending',
      MyPageApplyHistoryFilter.completed => 'completed',
      MyPageApplyHistoryFilter.invalid => 'invalid',
    };
  }

  List<int>? get statuses {
    return switch (this) {
      MyPageApplyHistoryFilter.all => null,
      MyPageApplyHistoryFilter.applying => const <int>[0],
      MyPageApplyHistoryFilter.pendingConfirmation => const <int>[2],
      MyPageApplyHistoryFilter.completed => const <int>[3],
      MyPageApplyHistoryFilter.invalid => const <int>[1, 4, 5],
    };
  }

  static MyPageApplyHistoryFilter? fromQueryValue(String? value) {
    for (final filter in MyPageApplyHistoryFilter.values) {
      if (filter.queryValue == value) {
        return filter;
      }
    }
    return null;
  }
}

extension MyPageActiveFundFilterX on MyPageActiveFundFilter {
  List<int> get statuses {
    return switch (this) {
      MyPageActiveFundFilter.operating => const <int>[4],
      MyPageActiveFundFilter.ended => const <int>[5],
    };
  }
}

List<MyPageApplyRecord> sortApplyRecords(
  List<MyPageApplyRecord> records, {
  int? maxItems,
}) {
  final sorted = [...records]
    ..sort((a, b) => compareByDateDesc(a.applyTime, b.applyTime));
  if (maxItems == null) {
    return sorted;
  }
  return sorted.take(maxItems).toList(growable: false);
}

List<MyPageApplyRecord> filterApplyRecordsByHistoryFilter(
  List<MyPageApplyRecord> records,
  MyPageApplyHistoryFilter filter,
) {
  final statuses = filter.statuses;
  if (statuses == null) {
    return sortApplyRecords(records);
  }
  return sortApplyRecords(
    records.where((record) => statuses.contains(record.status)).toList(),
  );
}

String resolveApplyHistoryFilterLabel(
  AppLocalizations l10n,
  MyPageApplyHistoryFilter filter,
) {
  return switch (filter) {
    MyPageApplyHistoryFilter.all => l10n.myPageApplyFilterAll,
    MyPageApplyHistoryFilter.applying => l10n.myPageApplyFilterApplying,
    MyPageApplyHistoryFilter.pendingConfirmation =>
      l10n.myPageApplyFilterPendingConfirmation,
    MyPageApplyHistoryFilter.completed => l10n.myPageApplyFilterCompleted,
    MyPageApplyHistoryFilter.invalid => l10n.myPageApplyFilterInvalid,
  };
}

String resolveMyPageActiveFundFilterLabel(
  AppLocalizations l10n,
  MyPageActiveFundFilter filter,
) {
  return switch (filter) {
    MyPageActiveFundFilter.operating => l10n.fundListStatusOperating,
    MyPageActiveFundFilter.ended => l10n.fundListStatusOperatingEnded,
  };
}

String resolveMyPageActiveFundEmptyState(
  AppLocalizations l10n,
  MyPageActiveFundFilter filter,
) {
  return switch (filter) {
    MyPageActiveFundFilter.operating => l10n.myPageOperatingFundsEmptyState,
    MyPageActiveFundFilter.ended => l10n.myPageOperatingEndedFundsEmptyState,
  };
}

List<MyPageInvestmentRecord> filterInvestmentRecordsByActiveFundFilter(
  List<MyPageInvestmentRecord> records,
  MyPageActiveFundFilter filter,
) {
  final statuses = filter.statuses;
  return records
      .where((record) => statuses.contains(record.projectStatus))
      .toList(growable: false);
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
  final source = records
      .where((record) => record.projectStatus == 4 || record.projectStatus == 5)
      .toList();
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
    MyPageSectionType.pendingApplications => l10n.myPageApplyHistoryListTitle,
    MyPageSectionType.coolingOff => l10n.myPageOrderInquiryListTitle,
    MyPageSectionType.activeFunds => l10n.myPageOperatingFundsTitle,
  };
}

String resolveSectionEmptyState(AppLocalizations l10n, MyPageSectionType type) {
  return switch (type) {
    MyPageSectionType.pendingApplications => l10n.myPagePendingEmptyState,
    MyPageSectionType.coolingOff => l10n.myPageOrderInquiryEmptyState,
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

String resolveMyPageActiveFundStatusLabel(
  AppLocalizations l10n,
  int? projectStatus,
) {
  return switch (projectStatus) {
    4 => l10n.fundListStatusOperating,
    5 => l10n.fundListStatusOperatingEnded,
    _ => resolveProjectStatusLabel(l10n, projectStatus),
  };
}

Color resolveMyPageActiveFundStatusBackgroundColor(
  BuildContext context,
  int? projectStatus,
) {
  final colors = Theme.of(context).appColors;
  return switch (projectStatus) {
    4 => Color.lerp(colors.surface, colors.successSubtle, 0.5)!,
    5 => colors.brandPrimary.withValues(alpha: 0.12),
    _ => colors.surfaceAlt,
  };
}

Color resolveMyPageActiveFundStatusForegroundColor(
  BuildContext context,
  int? projectStatus,
) {
  final colors = Theme.of(context).appColors;
  return switch (projectStatus) {
    4 => colors.successForeground,
    5 => colors.textSecondary,
    _ => colors.textSecondary,
  };
}

double? resolveMyPageActiveFundProgress(FundProject? project) {
  final startDate = _parseProjectDate(project?.scheduledStartDate);
  final endDate = _parseProjectDate(project?.scheduledEndDate);
  if (startDate == null || endDate == null || !endDate.isAfter(startDate)) {
    return null;
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (today.isBefore(startDate)) {
    return 0;
  }
  if (today.isAfter(endDate) || today.isAtSameMomentAs(endDate)) {
    return 1;
  }

  final totalDays = endDate.difference(startDate).inMilliseconds;
  if (totalDays <= 0) {
    return null;
  }
  final elapsedDays = today.difference(startDate).inMilliseconds;
  return (elapsedDays / totalDays).clamp(0.0, 1.0);
}

String? formatMyPageActiveFundPeriod(
  BuildContext context,
  FundProject? project,
) {
  final startDate = _parseProjectDate(project?.scheduledStartDate);
  final endDate = _parseProjectDate(project?.scheduledEndDate);
  if (startDate == null || endDate == null) {
    return null;
  }

  final locale = Localizations.localeOf(context);
  return '${_formatProjectDateForLocale(startDate, locale)}～${_formatProjectDateForLocale(endDate, locale)}';
}

String resolveApplyStatusLabel(
  AppLocalizations l10n,
  MyPageApplyRecord record,
) {
  return switch (record.status) {
    0 => l10n.myPageApplyStatusApplying,
    2 => l10n.myPageApplyStatusPendingConfirmation,
    3 => l10n.myPageApplyStatusCompleted,
    1 || 4 || 5 => l10n.myPageApplyStatusInvalid,
    _ => l10n.myPageApplyStatusApplying,
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
    2 => FundLabeledValue(
      label: l10n.myPageApplyConfirmationPendingAtLabel,
      value:
          formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    3 => FundLabeledValue(
      label: l10n.myPageApplyCompletedAtLabel,
      value:
          formatDateTimeOrNull(
            record.actualArrivalTime ?? record.passTime ?? record.applyTime,
          ) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    1 || 4 || 5 => FundLabeledValue(
      label: l10n.myPageApplyInvalidAtLabel,
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
    0 || 2 => true,
    _ => false,
  };
}

void handlePendingApplyTap(BuildContext context, MyPageApplyRecord record) {
  final projectId = record.projectId?.trim();
  if (projectId == null || projectId.isEmpty) {
    return;
  }

  switch (record.status) {
    case 0:
    case 2:
      context.push(
        '/funds/$projectId/lottery-apply?step=${FundLotteryApplyStep.submitted.queryValue}&allowSubmittedAdvance=false',
      );
      return;
    case 3:
      context.push(
        '/funds/$projectId/lottery-apply?step=${FundLotteryApplyStep.selected.queryValue}',
      );
      return;
    case 1:
    case 4:
    case 5:
      AppNotice.show(
        context,
        message: AppLocalizations.of(context).myPageApplyInvalidToast,
      );
      return;
    default:
      context.push(
        '/funds/$projectId/lottery-apply?step=${FundLotteryApplyStep.submitted.queryValue}&allowSubmittedAdvance=false',
      );
      return;
  }
}

String? resolveApplyWithdrawProcessId(MyPageApplyRecord record) {
  final processId = record.processId?.trim();
  if (processId != null && processId.isNotEmpty) {
    return processId;
  }
  final fallback = record.fromProcessId?.trim();
  if (fallback == null || fallback.isEmpty) {
    return null;
  }
  return fallback;
}

bool canSubmitApplyWithdraw(MyPageApplyRecord record) {
  return canShowApplyCancelAction(record.status) &&
      resolveApplyWithdrawProcessId(record) != null;
}

String? resolveOrderInquiryWithdrawProcessId(MyPageOrderInquiryRecord record) {
  final raw = record.fromProcessId?.trim();
  if (raw == null || raw.isEmpty) {
    return null;
  }
  return raw;
}

bool canSubmitOrderInquiryWithdraw(MyPageOrderInquiryRecord record) {
  final orderId = record.id?.trim();
  return resolveOrderInquiryWithdrawProcessId(record) != null &&
      orderId != null &&
      orderId.isNotEmpty;
}

String? resolveOrderProjectId(MyPageOrderInquiryRecord record) {
  return record.projectId ??
      record.investorType?.projectId ??
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

String resolveOrderInquiryStatusLabel(
  AppLocalizations l10n,
  MyPageOrderInquiryRecord record,
) {
  return (record.status?.trim().toUpperCase() == 'VALID')
      ? l10n.myPageOrderInquiryStatusExecuting
      : l10n.myPageOrderInquiryStatusPending;
}

Color resolveOrderInquiryStatusForegroundColor(
  BuildContext context,
  MyPageOrderInquiryRecord record,
) {
  final colors = Theme.of(context).appColors;
  return (record.status?.trim().toUpperCase() == 'VALID')
      ? colors.warningAction
      : colors.textSecondary;
}

Color resolveOrderInquiryStatusBackgroundColor(
  BuildContext context,
  MyPageOrderInquiryRecord record,
) {
  final colors = Theme.of(context).appColors;
  return (record.status?.trim().toUpperCase() == 'VALID')
      ? colors.warningSubtle
      : colors.surfaceAlt;
}

String formatOrderInvestorTypeLabel(MyPageOrderInquiryRecord record) {
  final investorCode = record.investorType?.investorCode?.trim();
  final ratio = record.investorType?.earningsRadio;
  final ratioLabel = formatYieldPercent(ratio);
  if (investorCode != null && investorCode.isNotEmpty) {
    return ratio != null ? '$investorCode  $ratioLabel' : investorCode;
  }
  return ratioLabel;
}

String formatOrderUnitsLabel(MyPageOrderInquiryRecord record) {
  final sellNum = record.sellNum?.toString() ?? '--';
  final soldNum = record.soldNum?.toString() ?? '--';
  return '$sellNum / $soldNum口';
}

String formatYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

DateTime? _parseProjectDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  return DateTime.tryParse(raw.trim().replaceAll(' ', 'T'));
}

String _formatProjectDateForLocale(DateTime value, Locale locale) {
  if (locale.languageCode == 'ja') {
    return DateFormat('yyyy/M/d', 'ja').format(value);
  }
  if (locale.languageCode == 'zh') {
    return DateFormat('yyyy/M/d', locale.toLanguageTag()).format(value);
  }
  return DateFormat.yMd(locale.toLanguageTag()).format(value);
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

String? formatDateTimeWithSlashOrNull(String? raw) {
  final date = parseApiDate(raw);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd HH:mm').format(date);
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
    required this.projectStatus,
  });

  final String projectId;
  final String projectName;
  final num investMoney;
  final num earnings;
  final double? earningRatio;
  final DateTime? latestCreateTime;
  final int? projectStatus;
}

class _InvestmentGroupAccumulator {
  _InvestmentGroupAccumulator(MyPageInvestmentRecord seed)
    : projectId = seed.projectId,
      projectName = seed.projectName,
      investMoney = seed.investMoney ?? 0,
      earnings = seed.earnings ?? 0,
      latestCreateTime = parseApiDate(seed.createTime),
      earningRatio = seed.earningRadio ?? seed.investorType?.earningsRadio,
      projectStatus = seed.projectStatus;

  final String projectId;
  final String projectName;
  num investMoney;
  num earnings;
  double? earningRatio;
  DateTime? latestCreateTime;
  int? projectStatus;

  void add(MyPageInvestmentRecord record) {
    investMoney += record.investMoney ?? 0;
    earnings += record.earnings ?? 0;
    earningRatio ??= record.earningRadio ?? record.investorType?.earningsRadio;
    projectStatus ??= record.projectStatus;
    final candidateDate = parseApiDate(record.createTime);
    if (compareDateTimeDesc(latestCreateTime, candidateDate) > 0) {
      latestCreateTime = candidateDate;
      projectStatus = record.projectStatus ?? projectStatus;
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
      projectStatus: projectStatus,
    );
  }
}
