import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_section_support.dart';

class ProfileCenterTabPage extends ConsumerWidget {
  const ProfileCenterTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    final localeTag = locale.toLanguageTag();
    final currencyFormatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '¥',
      decimalDigits: 0,
    );
    final accountStatisticAsync = ref.watch(myPageAccountStatisticProvider);
    final accountStatistic = accountStatisticAsync.asData?.value;
    final loanTypeFunds = accountStatistic?.financialTotal;
    final totalAssetsExcludingLoan = _subtractLoanTypeFunds(
      accountStatistic?.total,
      loanTypeFunds,
    );
    final operatingAssetsExcludingLoan = _subtractLoanTypeFunds(
      accountStatistic?.crowdfundingTotal,
      loanTypeFunds,
    );
    final applyAsync = ref.watch(myPageApplyListProvider);
    final orderInquiryAsync = ref.watch(myPageOrderInquiryListProvider);
    final investmentAsync = ref.watch(myPageInvestmentListProvider);
    final investmentRecords = investmentAsync.asData?.value;
    final fundProjects =
        ref.watch(fundProjectListProvider).asData?.value ??
        const <FundProject>[];
    final fundProjectsById = <String, FundProject>{
      for (final project in fundProjects) project.id: project,
    };

    return ColoredBox(
      color: AppColorTokens.fundexBackground,
      child: RefreshIndicator(
        onRefresh: () => _refreshPage(ref),
        child: ListView(
          key: const Key('profile_tab_content'),
          padding: EdgeInsets.zero,
          children: <Widget>[
            FundMyPageAssetOverview(
              totalAssetsLabel: l10n.myPageTotalAssetsLabel,
              totalAssetsValue: _formatCurrency(
                totalAssetsExcludingLoan,
                currencyFormatter,
              ),
              totalAssetsCaption: l10n.myPageTotalAssetsCaption,
              leading: _HeroHeaderActionButton(
                icon: Icons.notifications_none_rounded,
                showDot: true,
                onTap: () => context.push('/profile/notifications'),
              ),
              trailing: _HeroHeaderActionButton(
                icon: Icons.menu_rounded,
                onTap: () => context.push('/profile/settings'),
              ),
              metrics: <FundMyPageMetricData>[
                FundMyPageMetricData(
                  label: l10n.myPageMetricOperating,
                  value: _formatCompactCurrency(operatingAssetsExcludingLoan),
                  onTap: () => context.push(
                    '/profile/my/section-list?type=${MyPageSectionType.activeFunds.queryValue}',
                  ),
                ),
                FundMyPageMetricData(
                  label: l10n.myPageMetricStandby,
                  value: _formatCompactCurrency(
                    accountStatistic?.firstLevelAccountTotal,
                  ),
                  onTap: () => context.push('/wallet/deposit'),
                ),
                FundMyPageMetricData(
                  label: l10n.myPageMetricAccumulatedDistribution,
                  value: investmentRecords == null
                      ? '--'
                      : _formatCompactCurrency(
                          _sumInvestmentEarnings(investmentRecords),
                        ),
                  valueColor: AppColorTokens.fundexSuccess,
                ),
              ],
              quickActions: <FundMyPageQuickActionData>[
                FundMyPageQuickActionData(
                  icon: const Text('💰', style: TextStyle(fontSize: 16)),
                  label: l10n.myPageDepositAction,
                  backgroundColor: const Color(0xFFE0F2FE),
                  foregroundColor: AppColorTokens.fundexAccent,
                  onTap: () => context.push('/wallet/deposit'),
                ),
                FundMyPageQuickActionData(
                  icon: const Text('💸', style: TextStyle(fontSize: 16)),
                  label: l10n.myPageWithdrawAction,
                  backgroundColor: AppColorTokens.fundexBackground,
                  borderColor: AppColorTokens.fundexBorder,
                  foregroundColor: AppColorTokens.fundexTextSecondary,
                  onTap: () => _handleWithdrawTap(context, ref),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPendingApplicationsSection(
                    context,
                    ref,
                    asyncValue: applyAsync,
                    formatter: currencyFormatter,
                  ),
                  const SizedBox(height: UiTokens.spacing12),
                  _buildCoolingOffSection(
                    context,
                    ref,
                    asyncValue: orderInquiryAsync,
                    formatter: currencyFormatter,
                    fundProjectsById: fundProjectsById,
                    localeTag: localeTag,
                  ),
                  const SizedBox(height: UiTokens.spacing12),
                  _buildActiveFundsSection(
                    context,
                    ref,
                    asyncValue: investmentAsync,
                    formatter: currencyFormatter,
                    fundProjectsById: fundProjectsById,
                  ),
                  const SizedBox(height: UiTokens.spacing32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/profile/wallet/history'),
                      //icon: const Icon(Icons.receipt_long_outlined),
                      label: Text(l10n.myPageTransactionHistoryAction),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: UiTokens.spacing32),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton.icon(
                  //     onPressed: () => _logout(context, ref),
                  //     icon: const Icon(Icons.logout_rounded),
                  //     label: Text(l10n.homeLogout),
                  //     style: OutlinedButton.styleFrom(
                  //       foregroundColor: AppColorTokens.fundexDanger,
                  //       side: const BorderSide(
                  //         color: AppColorTokens.fundexDanger,
                  //       ),
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPendingApplicationsSection(
  BuildContext context,
  WidgetRef ref, {
  required AsyncValue<List<MyPageApplyRecord>> asyncValue,
  required NumberFormat formatter,
}) {
  final l10n = context.l10n;

  return asyncValue.when(
    data: (records) {
      final displayRecords = _selectPendingApplyRecords(records);
      final cards = displayRecords
          .map(
            (record) => FundMyPageProjectCard(
              title: record.projectName,
              accentColor: AppColorTokens.fundexViolet,
              trailing: _PendingStatusBadge(
                label: _resolveApplyStatusLabel(l10n, record),
              ),
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageApplyAmountLabel,
                  value: _formatCurrency(record.applyMoney, formatter),
                ),
                _buildApplySecondaryRow(l10n, record),
              ],
              footer: _canShowApplyCancelAction(record.status)
                  ? OutlinedButton(
                      onPressed: () => _showSnackBar(
                        context,
                        message: l10n.myPageCancelRequestComingSoon,
                      ),
                      style: _myPageOutlineButtonStyle(
                        borderColor: AppColorTokens.fundexDanger,
                        foregroundColor: AppColorTokens.fundexDanger,
                      ),
                      child: Text(l10n.myPageCancelRequestAction),
                    )
                  : null,
              onTap: _buildProjectTapHandler(context, record.projectId),
            ),
          )
          .toList(growable: false);

      return FundSectionList(
        title: l10n.myPagePendingApplicationsTitle,
        initialVisibleCount: cards.isEmpty ? 1 : 3,
        actionLabel: l10n.homeViewAllAction,
        onActionTap: () => context.push(
          '/profile/my/section-list?type=${MyPageSectionType.pendingApplications.queryValue}',
        ),
        children: cards.isEmpty
            ? <Widget>[_SectionStateCard(message: l10n.myPagePendingEmptyState)]
            : cards,
      );
    },
    loading: () => FundSectionList(
      title: l10n.myPagePendingApplicationsTitle,
      initialVisibleCount: 1,
      children: const <Widget>[_SectionLoadingCard()],
    ),
    error: (_, __) => FundSectionList(
      title: l10n.myPagePendingApplicationsTitle,
      initialVisibleCount: 1,
      children: <Widget>[
        _SectionStateCard(
          message: l10n.myPageSectionLoadError,
          actionLabel: l10n.fundListRetry,
          onActionTap: () => ref.invalidate(myPageApplyListProvider),
        ),
      ],
    ),
  );
}

Widget _buildCoolingOffSection(
  BuildContext context,
  WidgetRef ref, {
  required AsyncValue<List<MyPageOrderInquiryRecord>> asyncValue,
  required NumberFormat formatter,
  required Map<String, FundProject> fundProjectsById,
  required String localeTag,
}) {
  final l10n = context.l10n;

  return asyncValue.when(
    data: (records) {
      final displayRecords = _selectCoolingOffRecords(records);
      final cards = displayRecords
          .map((record) {
            final projectId = _resolveOrderProjectId(record);
            final project = projectId == null
                ? null
                : fundProjectsById[projectId];
            final deadline = _resolveCoolingOffDeadline(record);
            final deadlineLabel = _formatCoolingOffDeadlineLabel(
              context,
              deadline,
              localeTag: localeTag,
            );

            return FundMyPageProjectCard(
              title: record.projectName,
              accentColor: AppColorTokens.fundexWarning,
              trailing: Text(
                _resolveYieldLabel(
                  project,
                  fallbackRatio: record.investorType?.earningsRadio,
                ),
                style:
                    (Theme.of(context).textTheme.titleMedium ??
                            const TextStyle())
                        .copyWith(
                          color: AppColorTokens.fundexDanger,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
              ),
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageInvestmentAmountLabel,
                  value: _formatCurrency(record.price, formatter),
                ),
                FundLabeledValue(
                  label: l10n.myPageDocumentDeliveryDateLabel,
                  value:
                      _formatDateOrNull(record.createTime) ??
                      l10n.myPageResultAnnouncementTbd,
                ),
                FundLabeledValue(
                  label: l10n.myPageCancelDeadlineLabel,
                  value: deadlineLabel,
                  valueColor: _resolveCoolingOffDeadlineColor(deadline),
                ),
              ],
              footnote: l10n.myPageCoolingOffFootnote,
              footer: OutlinedButton(
                onPressed: () => _showSnackBar(
                  context,
                  message: l10n.myPageCancelRequestComingSoon,
                ),
                style: _myPageOutlineButtonStyle(
                  borderColor: AppColorTokens.fundexDanger,
                  foregroundColor: AppColorTokens.fundexDanger,
                ),
                child: Text(l10n.myPageCancelRequestAction),
              ),
              onTap: _buildProjectTapHandler(context, projectId),
            );
          })
          .toList(growable: false);

      return FundSectionList(
        title: l10n.myPageCoolingOffTitle,
        initialVisibleCount: cards.isEmpty ? 1 : 3,
        actionLabel: l10n.homeViewAllAction,
        onActionTap: () => context.push(
          '/profile/my/section-list?type=${MyPageSectionType.coolingOff.queryValue}',
        ),
        children: cards.isEmpty
            ? <Widget>[
                _SectionStateCard(message: l10n.myPageCoolingOffEmptyState),
              ]
            : cards,
      );
    },
    loading: () => FundSectionList(
      title: l10n.myPageCoolingOffTitle,
      initialVisibleCount: 1,
      children: const <Widget>[_SectionLoadingCard()],
    ),
    error: (_, __) => FundSectionList(
      title: l10n.myPageCoolingOffTitle,
      initialVisibleCount: 1,
      children: <Widget>[
        _SectionStateCard(
          message: l10n.myPageSectionLoadError,
          actionLabel: l10n.fundListRetry,
          onActionTap: () => ref.invalidate(myPageOrderInquiryListProvider),
        ),
      ],
    ),
  );
}

Widget _buildActiveFundsSection(
  BuildContext context,
  WidgetRef ref, {
  required AsyncValue<List<MyPageInvestmentRecord>> asyncValue,
  required NumberFormat formatter,
  required Map<String, FundProject> fundProjectsById,
}) {
  final l10n = context.l10n;

  return asyncValue.when(
    data: (records) {
      final displayGroups = _groupActiveInvestmentRecords(records);
      final cards = displayGroups
          .map((group) {
            final project = fundProjectsById[group.projectId];
            return FundActiveFundCard(
              data: FundActiveFundCardData(
                title: group.projectName,
                annualYield: _resolveYieldLabel(
                  project,
                  fallbackRatio: group.earningRatio,
                ),
                rows: <FundLabeledValue>[
                  FundLabeledValue(
                    label: l10n.myPageInvestmentAmountLabel,
                    value: _formatCurrency(group.investMoney, formatter),
                  ),
                  FundLabeledValue(
                    label: l10n.myPageAccumulatedDistributionLabel,
                    value: _formatCurrency(group.earnings, formatter),
                    valueColor: AppColorTokens.fundexSuccess,
                  ),
                ],
                onTap: _buildActiveFundDetailTapHandler(
                  context,
                  records: records,
                  projectId: group.projectId,
                ),
              ),
            );
          })
          .toList(growable: false);

      return FundSectionList(
        title: l10n.myPageOperatingFundsTitle,
        initialVisibleCount: cards.isEmpty ? 1 : 3,
        actionLabel: l10n.homeViewAllAction,
        children: cards.isEmpty
            ? <Widget>[
                _SectionStateCard(message: l10n.myPageOperatingFundsEmptyState),
              ]
            : cards,
        onActionTap: () => context.push(
          '/profile/my/section-list?type=${MyPageSectionType.activeFunds.queryValue}',
        ),
      );
    },
    loading: () => FundSectionList(
      title: l10n.myPageOperatingFundsTitle,
      initialVisibleCount: 1,
      children: const <Widget>[_SectionLoadingCard()],
    ),
    error: (_, __) => FundSectionList(
      title: l10n.myPageOperatingFundsTitle,
      initialVisibleCount: 1,
      children: <Widget>[
        _SectionStateCard(
          message: l10n.myPageSectionLoadError,
          actionLabel: l10n.fundListRetry,
          onActionTap: () => ref.invalidate(myPageInvestmentListProvider),
        ),
      ],
    ),
  );
}

Future<void> _refreshPage(WidgetRef ref) async {
  ref.invalidate(fundProjectListProvider);
  await Future.wait<void>(<Future<void>>[
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(myPageAccountStatisticProvider.future).then((_) {}),
    ref.refresh(myPageApplyListProvider.future).then((_) {}),
    ref.refresh(myPageOrderInquiryListProvider.future).then((_) {}),
    ref.refresh(myPageInvestmentListProvider.future).then((_) {}),
  ]);
}

Future<void> _handleWithdrawTap(BuildContext context, WidgetRef ref) async {
  final allowed = await ensureSensitiveActionAuthorized(context, ref);
  if (!context.mounted || !allowed) {
    return;
  }
  context.push('/wallet/withdraw');
}

VoidCallback? _buildProjectTapHandler(BuildContext context, String? projectId) {
  if (projectId == null || projectId.trim().isEmpty) {
    return null;
  }
  return () => context.push('/funds/$projectId');
}

VoidCallback? _buildActiveFundDetailTapHandler(
  BuildContext context, {
  required List<MyPageInvestmentRecord> records,
  required String? projectId,
}) {
  if (projectId == null || projectId.trim().isEmpty) {
    return null;
  }
  final projectRecords = records
      .where((record) => record.projectId == projectId)
      .toList(growable: false);
  return () => context.push(
    '/profile/my/active-funds/$projectId',
    extra: projectRecords,
  );
}

List<MyPageApplyRecord> _selectPendingApplyRecords(
  List<MyPageApplyRecord> records,
) {
  final sorted = [...records]
    ..sort((a, b) => _compareByDateDesc(a.applyTime, b.applyTime));
  final filtered = sorted
      .where((record) {
        return switch (record.status) {
          0 => true,
          _ => false,
        };
      })
      .toList(growable: false);
  return filtered;
}

List<MyPageOrderInquiryRecord> _selectCoolingOffRecords(
  List<MyPageOrderInquiryRecord> records,
) {
  final sorted = [...records]
    ..sort((a, b) => _compareByDateDesc(a.createTime, b.createTime));
  final uniqueByProject = <String, MyPageOrderInquiryRecord>{};
  for (final record in sorted) {
    final key =
        _resolveOrderProjectId(record) ??
        record.id ??
        '${record.projectName}_${record.createTime ?? ''}';
    uniqueByProject.putIfAbsent(key, () => record);
  }
  return uniqueByProject.values.take(3).toList(growable: false);
}

List<_InvestmentGroup> _groupActiveInvestmentRecords(
  List<MyPageInvestmentRecord> records,
) {
  final source = records.where((record) => record.projectStatus == 4).toList();
  final filtered = source.isEmpty ? [...records] : source;
  filtered.sort((a, b) => _compareByDateDesc(a.createTime, b.createTime));

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
    (a, b) => _compareDateTimeDesc(a.latestCreateTime, b.latestCreateTime),
  );
  return values;
}

String _resolveApplyStatusLabel(dynamic l10n, MyPageApplyRecord record) {
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

FundLabeledValue _buildApplySecondaryRow(
  dynamic l10n,
  MyPageApplyRecord record,
) {
  return switch (record.status) {
    0 => FundLabeledValue(
      label: l10n.myPageApplySubmittedAtLabel,
      value:
          _formatDateTimeOrNull(record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    1 => FundLabeledValue(
      label: l10n.myPageApplyReviewedAtLabel,
      value:
          _formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    2 => FundLabeledValue(
      label: l10n.myPageApplyPaymentNoticeLabel,
      value:
          _formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    3 => FundLabeledValue(
      label: l10n.myPageApplyPaidAtLabel,
      value:
          _formatDateTimeOrNull(
            record.actualArrivalTime ?? record.passTime ?? record.applyTime,
          ) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    4 => FundLabeledValue(
      label: l10n.myPageApplyCancellationRequestedAtLabel,
      value:
          _formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    5 => FundLabeledValue(
      label: l10n.myPageApplyCancelledAtLabel,
      value:
          _formatDateTimeOrNull(record.passTime ?? record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
    _ => FundLabeledValue(
      label: l10n.myPageApplySubmittedAtLabel,
      value:
          _formatDateTimeOrNull(record.applyTime) ??
          l10n.myPageResultAnnouncementTbd,
    ),
  };
}

bool _canShowApplyCancelAction(int? status) {
  return switch (status) {
    0 || 1 || 2 => true,
    _ => false,
  };
}

String? _resolveOrderProjectId(MyPageOrderInquiryRecord record) {
  return record.investorType?.projectId ??
      (record.pdfDocuments.isNotEmpty
          ? record.pdfDocuments.first.projectId
          : null);
}

DateTime? _resolveCoolingOffDeadline(MyPageOrderInquiryRecord record) {
  final base = _parseApiDate(record.createTime);
  if (base == null) {
    return null;
  }
  return DateTime(base.year, base.month, base.day).add(const Duration(days: 8));
}

Color _resolveCoolingOffDeadlineColor(DateTime? deadline) {
  if (deadline == null) {
    return AppColorTokens.fundexTextSecondary;
  }
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
  return deadlineDate.isBefore(todayDate)
      ? AppColorTokens.fundexTextSecondary
      : AppColorTokens.fundexDanger;
}

String _formatCoolingOffDeadlineLabel(
  BuildContext context,
  DateTime? deadline, {
  required String localeTag,
}) {
  if (deadline == null) {
    return context.l10n.myPageResultAnnouncementTbd;
  }

  final dateText = DateFormat('M/d', localeTag).format(deadline);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
  final remainingDays = deadlineDate.difference(today).inDays;

  if (remainingDays >= 0) {
    return context.l10n.myPageCoolingOffDeadlineRemaining(
      dateText,
      remainingDays,
    );
  }
  return context.l10n.myPageCoolingOffDeadlineExpired(dateText);
}

String _resolveYieldLabel(FundProject? project, {double? fallbackRatio}) {
  final ratio =
      project?.expectedDistributionRatioMax ??
      project?.expectedDistributionRatioMin ??
      project?.investorTypes.firstOrNull?.earningsRadio ??
      fallbackRatio;
  return _formatYieldPercent(ratio);
}

String _formatYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

num? _subtractLoanTypeFunds(num? baseAmount, num? loanAmount) {
  if (baseAmount == null) {
    return null;
  }
  final adjusted = baseAmount - (loanAmount ?? 0);
  if (adjusted < 0) {
    return 0;
  }
  return adjusted;
}

num _sumInvestmentEarnings(List<MyPageInvestmentRecord> records) {
  num total = 0;
  for (final record in records) {
    total += record.earnings ?? 0;
  }
  return total;
}

String _formatCurrency(num? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return formatter.format(amount);
}

String _formatCompactCurrency(num? amount) {
  if (amount == null) {
    return '--';
  }

  final value = amount.toDouble();
  final abs = value.abs();
  if (abs >= 1000000) {
    return '¥${_formatCompactNumber(value / 1000000)}M';
  }
  if (abs >= 10000) {
    return '¥${_formatCompactNumber(value / 1000)}K';
  }
  return '¥${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(double value) {
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}

String? _formatDateOrNull(String? raw) {
  final date = _parseApiDate(raw);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd').format(date);
}

String? _formatDateTimeOrNull(String? raw) {
  final date = _parseApiDate(raw);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd HH:mm').format(date);
}

DateTime? _parseApiDate(String? raw) {
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

int _compareByDateDesc(String? left, String? right) {
  return _compareDateTimeDesc(_parseApiDate(left), _parseApiDate(right));
}

int _compareDateTimeDesc(DateTime? left, DateTime? right) {
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

void _showSnackBar(BuildContext context, {required String message}) {
  AppNotice.show(context, message: message);
}

ButtonStyle _myPageOutlineButtonStyle({
  required Color borderColor,
  required Color foregroundColor,
}) {
  return OutlinedButton.styleFrom(
    foregroundColor: foregroundColor,
    side: BorderSide(color: borderColor, width: 1.5),
    visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: const Size(0, 0),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
  );
}

class _PendingStatusBadge extends StatelessWidget {
  const _PendingStatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColorTokens.fundexVioletLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
            .copyWith(
              fontSize: 10,
              color: AppColorTokens.fundexViolet,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _HeroHeaderActionButton extends StatelessWidget {
  const _HeroHeaderActionButton({
    required this.icon,
    this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: onTap,
                child: Icon(icon, size: 19, color: Colors.white),
              ),
            ),
          ),
          if (showDot)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColorTokens.fundexDanger,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorTokens.fundexPrimaryDark,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLoadingCard extends StatelessWidget {
  const _SectionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionStateCard(
      indicator: CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}

class _SectionStateCard extends StatelessWidget {
  const _SectionStateCard({
    this.message,
    this.actionLabel,
    this.onActionTap,
    this.indicator,
  });

  final String? message;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? indicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: AppColorTokens.fundexBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: <Widget>[
            if (indicator != null) indicator!,
            if (message != null) ...<Widget>[
              if (indicator != null) const SizedBox(height: UiTokens.spacing8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: (theme.textTheme.bodySmall ?? const TextStyle())
                    .copyWith(color: AppColorTokens.fundexTextSecondary),
              ),
            ],
            if (actionLabel != null && onActionTap != null) ...<Widget>[
              const SizedBox(height: UiTokens.spacing8),
              OutlinedButton(onPressed: onActionTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _InvestmentGroup {
  const _InvestmentGroup({
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
      latestCreateTime = _parseApiDate(seed.createTime),
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
    final candidateDate = _parseApiDate(record.createTime);
    if (_compareDateTimeDesc(latestCreateTime, candidateDate) > 0) {
      latestCreateTime = candidateDate;
    }
  }

  _InvestmentGroup build() {
    return _InvestmentGroup(
      projectId: projectId,
      projectName: projectName,
      investMoney: investMoney,
      earnings: earnings,
      earningRatio: earningRatio,
      latestCreateTime: latestCreateTime,
    );
  }
}
