import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../investment/presentation/support/fund_lottery_apply_step.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_section_support.dart';
import '../support/mypage_withdraw_action.dart';

class ProfileCenterTabPage extends ConsumerStatefulWidget {
  const ProfileCenterTabPage({super.key});

  @override
  ConsumerState<ProfileCenterTabPage> createState() =>
      _ProfileCenterTabPageState();
}

class _ProfileCenterTabPageState extends ConsumerState<ProfileCenterTabPage> {
  final Set<String> _hiddenOrderInquiryIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
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
    final applyAsync = ref.watch(myPagePendingApplyListProvider);
    final orderInquiryAsync = ref.watch(myPageOrderInquiryListProvider);
    final investmentAsync = ref.watch(myPageInvestmentListProvider);
    final investmentRecords = investmentAsync.asData?.value;
    final fundProjects =
        ref.watch(fundProjectListProvider).asData?.value ??
        const <FundProject>[];
    final fundProjectsById = <String, FundProject>{
      for (final project in fundProjects) project.id: project,
    };

    return MainShellTabRefreshScope(
      tabIndex: 3,
      onRefresh: (_) => _refreshPage(),
      child: ColoredBox(
        color: colors.background,
        child: RefreshIndicator(
          onRefresh: _refreshPage,
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
                    value: _formatCompactCurrency(
                      operatingAssetsExcludingLoan ?? 0,
                    ),
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
                    value: _formatCompactCurrency(
                      accountStatistic?.crowdfundingDistributedBenefit ??
                          (investmentRecords == null
                              ? null
                              : _sumInvestmentEarnings(investmentRecords)),
                    ),
                    valueColor: colors.success,
                  ),
                ],
                quickActions: <FundMyPageQuickActionData>[
                  FundMyPageQuickActionData(
                    label: l10n.myPageDepositAction,
                    backgroundColor: colors.infoSubtle,
                    foregroundColor: colors.primary,
                    onTap: () => context.push('/wallet/deposit'),
                  ),
                  FundMyPageQuickActionData(
                    label: l10n.myPageWithdrawAction,
                    backgroundColor: colors.background,
                    borderColor: colors.border,
                    foregroundColor: colors.textSecondary,
                    onTap: () => _handleWithdrawTap(context, ref),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildSectionChildren(
                    context,
                    ref,
                    applyAsync: applyAsync,
                    orderInquiryAsync: orderInquiryAsync,
                    investmentAsync: investmentAsync,
                    currencyFormatter: currencyFormatter,
                    fundProjectsById: fundProjectsById,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      _hiddenOrderInquiryIds.clear();
    });
    await refreshProfileCenterTabPage(ref);
  }

  Future<void> _hideOrderInquiryRecord(String orderId) async {
    if (!mounted) {
      return;
    }
    setState(() {
      _hiddenOrderInquiryIds.add(orderId);
    });
  }

  Future<void> _handleOrderWithdraw(
    BuildContext context,
    WidgetRef ref,
    MyPageOrderInquiryRecord record,
  ) async {
    final processId = resolveOrderInquiryWithdrawProcessId(record);
    final orderId = record.id?.trim();
    final sellNum = record.sellNum;
    final price = record.price?.toInt();
    if (processId == null ||
        orderId == null ||
        sellNum == null ||
        price == null) {
      return;
    }
    await confirmAndSubmitMyPageSecondaryMarketInvalidate(
      context,
      ref,
      id: orderId,
      fromProcessId: processId,
      sellNum: sellNum,
      price: price,
      thisTimeSoldNum: record.soldNum ?? 0,
      confirmBody: context.l10n.myPageWithdrawOrderConfirmBody,
      onSuccessRefresh: () => _hideOrderInquiryRecord(orderId),
    );
  }

  List<Widget> _buildSectionChildren(
    BuildContext context,
    WidgetRef ref, {
    required AsyncValue<List<MyPageApplyRecord>> applyAsync,
    required AsyncValue<List<MyPageOrderInquiryRecord>> orderInquiryAsync,
    required AsyncValue<List<MyPageInvestmentRecord>> investmentAsync,
    required NumberFormat currencyFormatter,
    required Map<String, FundProject> fundProjectsById,
  }) {
    final children = <Widget>[];

    if (_shouldShowHomePendingSection(applyAsync)) {
      children.add(
        _buildPendingApplicationsSection(
          context,
          ref,
          asyncValue: applyAsync,
          formatter: currencyFormatter,
        ),
      );
    }

    if (_shouldShowHomeOrderInquirySection(
      orderInquiryAsync,
      _hiddenOrderInquiryIds,
    )) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: UiTokens.spacing12));
      }
      children.add(
        _buildCoolingOffSection(
          context,
          ref,
          asyncValue: orderInquiryAsync,
          formatter: currencyFormatter,
          hiddenOrderInquiryIds: _hiddenOrderInquiryIds,
          onWithdrawTap: (record) => _handleOrderWithdraw(context, ref, record),
        ),
      );
    }

    if (children.isNotEmpty) {
      children.add(const SizedBox(height: UiTokens.spacing12));
    }
    children.add(
      _buildActiveFundsSection(
        context,
        ref,
        asyncValue: investmentAsync,
        formatter: currencyFormatter,
        fundProjectsById: fundProjectsById,
      ),
    );
    children.add(const SizedBox(height: UiTokens.spacing32));
    children.add(
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => context.push('/wallet/history'),
          label: Text(context.l10n.myPageTransactionHistoryAction),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
    children.add(const SizedBox(height: UiTokens.spacing32));
    return children;
  }
}

Widget _buildPendingApplicationsSection(
  BuildContext context,
  WidgetRef ref, {
  required AsyncValue<List<MyPageApplyRecord>> asyncValue,
  required NumberFormat formatter,
}) {
  final l10n = context.l10n;
  final colors = Theme.of(context).appColors;

  return asyncValue.when(
    data: (records) {
      final displayRecords = sortApplyRecords(records, maxItems: 3);
      final cards = displayRecords
          .map(
            (record) => FundMyPageProjectCard(
              title: record.projectName,
              accentColor: AppColorTokens.fundexViolet,
              trailing: _PendingStatusBadge(
                label: resolveApplyStatusLabel(l10n, record),
              ),
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageApplyAmountLabel,
                  value: _formatCurrency(record.applyMoney, formatter),
                ),
                buildApplySecondaryRow(l10n, record),
              ],
              footer: canSubmitApplyWithdraw(record)
                  ? OutlinedButton(
                      onPressed: () =>
                          _handleApplyWithdraw(context, ref, record),
                      style: _myPageOutlineButtonStyle(
                        context,
                        borderColor: colors.danger,
                        foregroundColor: colors.danger,
                      ),
                      child: Text(l10n.myPageCancelRequestAction),
                    )
                  : null,
              onTap: _buildPendingApplyTapHandler(context, record.projectId),
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
        children: cards.isEmpty ? const <Widget>[] : cards,
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
          onActionTap: () => ref.invalidate(myPagePendingApplyListProvider),
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
  required Set<String> hiddenOrderInquiryIds,
  required Future<void> Function(MyPageOrderInquiryRecord record) onWithdrawTap,
}) {
  final l10n = context.l10n;
  final theme = Theme.of(context);
  final colors = theme.appColors;

  return asyncValue.when(
    data: (records) {
      final visibleRecords = records
          .where((record) => !hiddenOrderInquiryIds.contains(record.id))
          .toList(growable: false);
      final displayRecords = _selectCoolingOffRecords(visibleRecords);
      final cards = displayRecords
          .map((record) {
            return FundMyPageProjectCard(
              title: record.projectName,
              accentColor: colors.warning,
              trailing: _PendingStatusBadge(
                label: resolveOrderInquiryStatusLabel(l10n, record),
                backgroundColor: resolveOrderInquiryStatusBackgroundColor(
                  context,
                  record,
                ),
                foregroundColor: resolveOrderInquiryStatusForegroundColor(
                  context,
                  record,
                ),
              ),
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageOrderTimeLabel,
                  value:
                      formatDateTimeWithSlashOrNull(record.createTime) ??
                      l10n.myPageResultAnnouncementTbd,
                ),
                FundLabeledValue(
                  label: l10n.myPageOrderInvestorTypeLabel,
                  value: formatOrderInvestorTypeLabel(record),
                ),
                FundLabeledValue(
                  label: l10n.myPageOrderUnitsLabel,
                  value: formatOrderUnitsLabel(record),
                ),
                FundLabeledValue(
                  label: l10n.myPageOrderUnitPriceLabel,
                  value: _formatCurrency(record.price, formatter),
                ),
              ],
              footer: canSubmitOrderInquiryWithdraw(record)
                  ? OutlinedButton(
                      onPressed: () => onWithdrawTap(record),
                      style: _myPageOutlineButtonStyle(
                        context,
                        borderColor: colors.danger,
                        foregroundColor: colors.danger,
                      ),
                      child: Text(l10n.myPageCancelRequestAction),
                    )
                  : null,
              onTap: null,
            );
          })
          .toList(growable: false);

      return FundSectionList(
        title: l10n.myPageOrderInquirySectionTitle,
        //leading: const _OrderInquirySectionLeadingIcon(),
        initialVisibleCount: cards.isEmpty ? 1 : 3,
        actionLabel: l10n.homeViewAllAction,
        onActionTap: () => context.push(
          '/profile/my/section-list?type=${MyPageSectionType.coolingOff.queryValue}',
        ),
        children: cards.isEmpty ? const <Widget>[] : cards,
      );
    },
    loading: () => FundSectionList(
      title: l10n.myPageOrderInquirySectionTitle,
      initialVisibleCount: 1,
      children: const <Widget>[_SectionLoadingCard()],
    ),
    error: (_, __) => FundSectionList(
      title: l10n.myPageOrderInquirySectionTitle,
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
  final colors = Theme.of(context).appColors;

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
                    valueColor: colors.success,
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
                _SectionStateCard(
                  actionLabel: l10n.myPageOperatingFundsEmptyAction,
                  onActionTap: () => context.go('/funds'),
                ),
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

Future<void> refreshProfileCenterTabPage(WidgetRef ref) async {
  ref.invalidate(fundProjectListProvider);
  await Future.wait<void>(<Future<void>>[
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(myPageAccountStatisticProvider.future).then((_) {}),
    ref.refresh(myPagePendingApplyListProvider.future).then((_) {}),
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

Future<void> _handleApplyWithdraw(
  BuildContext context,
  WidgetRef ref,
  MyPageApplyRecord record,
) async {
  final processId = resolveApplyWithdrawProcessId(record);
  if (processId == null) {
    return;
  }
  await confirmAndSubmitMyPageWithdraw(
    context,
    ref,
    processId: processId,
    confirmBody: context.l10n.myPageWithdrawApplyConfirmBody,
    onSuccessRefresh: () => refreshProfileCenterTabPage(ref),
  );
}

VoidCallback? _buildPendingApplyTapHandler(
  BuildContext context,
  String? projectId,
) {
  if (projectId == null || projectId.trim().isEmpty) {
    return null;
  }
  return () => context.push(
    '/funds/$projectId/lottery-apply?step=${FundLotteryApplyStep.submitted.queryValue}&allowSubmittedAdvance=false',
  );
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

String? _resolveOrderProjectId(MyPageOrderInquiryRecord record) {
  return record.investorType?.projectId ??
      (record.pdfDocuments.isNotEmpty
          ? record.pdfDocuments.first.projectId
          : null);
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

ButtonStyle _myPageOutlineButtonStyle(
  BuildContext context, {
  required Color borderColor,
  required Color foregroundColor,
}) {
  final appText = Theme.of(context).appTextTheme;
  return OutlinedButton.styleFrom(
    foregroundColor: foregroundColor,
    side: BorderSide(color: borderColor, width: 1.5),
    visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: const Size(0, 0),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: appText.chip,
  );
}

class _PendingStatusBadge extends StatelessWidget {
  const _PendingStatusBadge({
    required this.label,
    this.backgroundColor = AppColorTokens.fundexVioletLight,
    this.foregroundColor = AppColorTokens.fundexViolet,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: appText.tableLabel.copyWith(color: foregroundColor),
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
    final colors = Theme.of(context).appColors;
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: colors.onDark.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: onTap,
                child: Icon(icon, size: 19, color: colors.onDark),
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
                  color: colors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.heroStart, width: 1.5),
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

bool _shouldShowHomePendingSection(
  AsyncValue<List<MyPageApplyRecord>> asyncValue,
) {
  return asyncValue.when(
    data: (records) => records.isNotEmpty,
    loading: () => true,
    error: (_, __) => true,
  );
}

bool _shouldShowHomeOrderInquirySection(
  AsyncValue<List<MyPageOrderInquiryRecord>> asyncValue,
  Set<String> hiddenOrderInquiryIds,
) {
  return asyncValue.when(
    data: (records) {
      final visibleRecords = records
          .where((record) => !hiddenOrderInquiryIds.contains(record.id))
          .toList(growable: false);
      return _selectCoolingOffRecords(visibleRecords).isNotEmpty;
    },
    loading: () => true,
    error: (_, __) => true,
  );
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
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.border),
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
                style: appText.bodyMuted.copyWith(color: colors.textSecondary),
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
