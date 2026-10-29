import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_tab_refresh.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../../../app/support/app_compact_money_formatter.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
import '../../../home/presentation/support/home_display_name_resolver.dart';
import '../../../wallet/domain/entities/wallet_account_history.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../../wallet/presentation/support/wallet_history_view_support.dart';
import '../../../wallet/presentation/widgets/wallet_history_list_item.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/member_profile_providers.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_section_support.dart';
import '../support/mypage_share_summary.dart';
import '../support/mypage_withdraw_action.dart';
import '../widgets/my_page_apply_card_detail.dart';
import '../widgets/my_page_active_fund_summary_card.dart';
import '../widgets/my_page_holding_card.dart';
import '../widgets/my_page_asset_summary.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/mypage_chart_providers.dart';
import '../widgets/my_page_summary_section.dart';
import '../providers/mypage_membership_providers.dart';
import '../widgets/mypage_share_sheet.dart';

class ProfileCenterTabPage extends ConsumerStatefulWidget {
  const ProfileCenterTabPage({super.key});

  @override
  ConsumerState<ProfileCenterTabPage> createState() =>
      _ProfileCenterTabPageState();
}

class _ProfileCenterTabPageState extends ConsumerState<ProfileCenterTabPage> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _hiddenOrderInquiryIds = <String>{};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final locale = Localizations.localeOf(context);
    final authUserAsync = ref.watch(currentAuthUserProvider);
    final basicProfile = ref.watch(memberBasicProfileProvider);
    final localeTag = locale.toLanguageTag();
    final currencyFormatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '¥',
      decimalDigits: 0,
    );
    final unreadNotificationCount = ref.watch(
      notificationsControllerProvider.select((state) => state.unreadCount),
    );
    final accountStatisticAsync = ref.watch(myPageAccountStatisticProvider);
    final accountStatistic = accountStatisticAsync.valueOrNull;
    final loanTypeFunds = accountStatistic?.financialTotal;
    final totalAssetsExcludingLoan = _subtractLoanTypeFunds(
      accountStatistic?.total,
      loanTypeFunds,
    );
    final operatingAssetsExcludingLoan = _subtractLoanTypeFunds(
      accountStatistic?.crowdfundingTotal,
      loanTypeFunds,
    );
    final applyAsync = ref.watch(myPageHomeApplySectionProvider);
    //final orderInquiryAsync = ref.watch(myPageOrderInquiryListProvider);
    final investmentAsync = ref.watch(myPageInvestmentListProvider);
    final walletHistoryAsync = ref.watch(walletHistoryProvider);
    final investmentRecords = investmentAsync.valueOrNull;
    final displayName = _resolveMyPageDisplayName(
      locale: locale,
      profile: basicProfile,
    );
    final shareSummary = MyPageShareSummary.fromRecords(
      statistic: accountStatistic,
      records: investmentRecords,
    );
    final fundProjects =
        ref.watch(fundProjectListProvider).valueOrNull ?? const <FundProject>[];
    final fundProjectsById = <String, FundProject>{
      for (final project in fundProjects) project.id: project,
    };

    return MainShellTabRefreshScope(
      tabIndex: MainShellTab.profile.index,
      onRefresh: (_) => _refreshPage(),
      scrollController: _scrollController,
      child: Scaffold(
        appBar: AppNavigationBar(
          title: l10n.mainTabProfile,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          showDivider: false,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyPageHeaderAction(
                icon: Symbols.notifications,
                unreadCount: unreadNotificationCount,
                onTap: () => context.push('/profile/notifications'),
              ),
              const SizedBox(width: 8),
              MyPageHeaderAction(
                icon: Symbols.settings,
                onTap: () => context.push('/profile/settings'),
              ),
            ],
          ),
        ),
        body: ColoredBox(
          color: colors.surface,
          child: RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(
              key: const Key('profile_tab_content'),
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: <Widget>[
                MyPageAssetSummary(
                  displayName: displayName,
                  verificationBadge: authUserAsync.whenOrNull(
                    data: (user) => _resolveMyPageVerificationBadge(
                      l10n,
                      colors,
                      user?.status,
                    ),
                  ),
                  totalAssetsValue: _formatCurrency(
                    totalAssetsExcludingLoan,
                    currencyFormatter,
                  ),
                  onDeposit: () => context.push('/wallet/deposit'),
                  onWithdraw: () => _handleWithdrawTap(context, ref),
                  metrics: <FundMyPageMetricData>[
                    FundMyPageMetricData(
                      label: l10n.myPageMetricOperating,
                      value: formatCompactYenAmount(
                        operatingAssetsExcludingLoan ?? 0,
                        locale: localeTag,
                      ),
                      onTap: () => context.push(
                        '/profile/my/section-list?type=${MyPageSectionType.activeFunds.queryValue}',
                      ),
                    ),
                    FundMyPageMetricData(
                      label: l10n.myPageMetricStandby,
                      value: formatCompactYenAmount(
                        accountStatistic?.firstLevelAccountTotal,
                        locale: localeTag,
                      ),
                      onTap: () => context.push('/wallet/history'),
                    ),
                    FundMyPageMetricData(
                      label: l10n.myPageMetricAccumulatedDistribution,
                      value: formatCompactYenAmount(
                        accountStatistic?.crowdfundingDistributedBenefit ??
                            (investmentRecords == null
                                ? null
                                : _sumInvestmentEarnings(investmentRecords)),
                        locale: localeTag,
                      ),
                      onTap: () => context.push(
                        '/profile/my/section-list?type=${MyPageSectionType.activeFunds.queryValue}',
                      ),
                    ),
                  ],
                ),
                const MyPageSummarySection(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildSectionChildren(
                      context,
                      ref,
                      applyAsync: applyAsync,
                      //orderInquiryAsync: orderInquiryAsync,
                      investmentAsync: investmentAsync,
                      walletHistoryAsync: walletHistoryAsync,
                      currencyFormatter: currencyFormatter,
                      fundProjectsById: fundProjectsById,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    if (shouldSkipAppNetworkRefresh(ref)) {
      return;
    }
    setState(() {
      _hiddenOrderInquiryIds.clear();
    });
    await Future.wait<void>(<Future<void>>[
      refreshProfileCenterTabPage(ref),
      ref.refresh(walletHistoryProvider.future).then((_) {}),
      ref.read(myPageTierProvider.notifier).refresh(),
      ref.read(myPageMilesAccountProvider.notifier).refresh(),
      for (final kind in MyPageChartKind.values)
        ref.read(myPageChartProvider(kind).notifier).refresh(),
    ]);
  }

  Future<void> _showShareSheet({
    required MyPageShareSummary summary,
    required NumberFormat currencyFormatter,
  }) {
    final l10n = context.l10n;
    final profitPrefix = summary.profitAmount > 0 ? '+' : '';
    final ratePrefix = summary.profitRate > 0 ? '+' : '';
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).appColors.surface,
      showDragHandle: false,
      builder: (context) => MyPageShareSheet(
        title: l10n.myPageShareCardTitle,
        subtitle: l10n.myPageShareCardSubtitle,
        investedLabel: l10n.myPageShareInvestedLabel,
        investedValue: currencyFormatter.format(summary.investedAmount),
        profitLabel: l10n.myPageShareProfitLabel,
        profitValue:
            '$profitPrefix${currencyFormatter.format(summary.profitAmount)}',
        profitRateLabel: l10n.myPageShareProfitRateLabel,
        profitRateValue: '$ratePrefix${summary.profitRate.toStringAsFixed(2)}%',
        shareActionLabel: l10n.myPageShareSendToAction,
        shareText: l10n.myPageShareText,
        shareFailedNotice: l10n.myPageShareFailedNotice,
      ),
    );
  }

  // Future<void> _hideOrderInquiryRecord(String orderId) async {
  //   if (!mounted) {
  //     return;
  //   }
  //   setState(() {
  //     _hiddenOrderInquiryIds.add(orderId);
  //   });
  // }

  // Future<void> _handleOrderWithdraw(
  //   BuildContext context,
  //   WidgetRef ref,
  //   MyPageOrderInquiryRecord record,
  // ) async {
  //   final processId = resolveOrderInquiryWithdrawProcessId(record);
  //   final orderId = record.id?.trim();
  //   final sellNum = record.sellNum;
  //   final price = record.price?.toInt();
  //   if (processId == null ||
  //       orderId == null ||
  //       sellNum == null ||
  //       price == null) {
  //     return;
  //   }
  //   await confirmAndSubmitMyPageSecondaryMarketInvalidate(
  //     context,
  //     ref,
  //     id: orderId,
  //     fromProcessId: processId,
  //     sellNum: sellNum,
  //     price: price,
  //     thisTimeSoldNum: record.soldNum ?? 0,
  //     confirmBody: context.l10n.myPageWithdrawOrderConfirmBody,
  //     onSuccessRefresh: () => _hideOrderInquiryRecord(orderId),
  //   );
  // }

  List<Widget> _buildSectionChildren(
    BuildContext context,
    WidgetRef ref, {
    required AsyncValue<MyPageHomeApplySectionData> applyAsync,
    // required AsyncValue<List<MyPageOrderInquiryRecord>> orderInquiryAsync,
    required AsyncValue<List<MyPageInvestmentRecord>> investmentAsync,
    required AsyncValue<List<WalletAccountHistory>> walletHistoryAsync,
    required NumberFormat currencyFormatter,
    required Map<String, FundProject> fundProjectsById,
  }) {
    final children = <Widget>[];
    final applySection = _buildPendingApplicationsSection(
      context,
      ref,
      asyncValue: applyAsync,
      formatter: currencyFormatter,
    );
    final showsApplyHistory = applyAsync.valueOrNull?.showsHistory == true;

    if (!showsApplyHistory) {
      children.add(applySection);
      children.add(const SizedBox(height: UiTokens.spacing12));
    }

    // if (_shouldShowHomeOrderInquirySection(
    //   orderInquiryAsync,
    //   _hiddenOrderInquiryIds,
    // )) {
    //   if (children.isNotEmpty) {
    //     children.add(const SizedBox(height: UiTokens.spacing12));
    //   }
    //   children.add(
    //     _buildCoolingOffSection(
    //       context,
    //       ref,
    //       asyncValue: orderInquiryAsync,
    //       formatter: currencyFormatter,
    //       hiddenOrderInquiryIds: _hiddenOrderInquiryIds,
    //       onWithdrawTap: (record) => _handleOrderWithdraw(context, ref, record),
    //     ),
    //   );
    // }

    children.add(
      _buildActiveFundsSection(
        context,
        ref,
        asyncValue: investmentAsync,
        fundProjectsById: fundProjectsById,
      ),
    );
    if (showsApplyHistory) {
      children.add(const SizedBox(height: UiTokens.spacing12));
      children.add(applySection);
    }
    children.add(const SizedBox(height: UiTokens.spacing32));
    children.add(
      _buildTransactionHistorySection(
        context,
        ref,
        asyncValue: walletHistoryAsync,
        formatter: currencyFormatter,
      ),
    );
    children.add(const SizedBox(height: UiTokens.spacing32));
    return children;
  }
}

Widget _buildTransactionHistorySection(
  BuildContext context,
  WidgetRef ref, {
  required AsyncValue<List<WalletAccountHistory>> asyncValue,
  required NumberFormat formatter,
}) {
  final l10n = context.l10n;

  return asyncValue.when(
    skipError: true,
    data: (items) {
      final displayItems = [...items]..sort(compareWalletHistoryByDateDesc);
      final visibleItems = displayItems.take(3).toList(growable: false);

      return FundSectionList(
        title: l10n.walletTransactionHistoryTitle,
        initialVisibleCount: 3,
        itemSpacing: 12,
        actionLabel: l10n.homeViewAllAction,
        onActionTap: () => context.push('/wallet/history'),
        children: visibleItems.isEmpty
            ? <Widget>[_SectionStateCard(message: l10n.walletHistoryEmpty)]
            : visibleItems
                  .map(
                    (item) => WalletHistoryListItem(
                      title: resolveWalletHistoryDisplayTitle(l10n, item),
                      dateText: formatWalletHistoryDateText(
                        item.tradeTime ?? item.createTime,
                      ),
                      amountText: formatWalletHistoryAmountText(
                        item: item,
                        formatter: formatter,
                      ),
                      balanceText: formatWalletHistoryBalanceText(
                        l10n: l10n,
                        item: item,
                        formatter: formatter,
                      ),
                      amountColor: resolveWalletHistoryAmountColor(
                        context,
                        item,
                      ),
                      indicatorColor: resolveWalletHistoryIndicatorColor(
                        context,
                        item,
                      ),
                    ),
                  )
                  .toList(growable: false),
      );
    },
    loading: () => FundSectionList(
      title: l10n.walletTransactionHistoryTitle,
      initialVisibleCount: 1,
      children: const <Widget>[_SectionLoadingCard()],
    ),
    error: (_, __) => FundSectionList(
      title: l10n.walletTransactionHistoryTitle,
      initialVisibleCount: 1,
      children: <Widget>[
        _SectionStateCard(
          message: l10n.myPageSectionLoadError,
          actionLabel: l10n.fundListRetry,
          onActionTap: () => ref.invalidate(walletHistoryProvider),
        ),
      ],
    ),
  );
}

Widget _buildPendingApplicationsSection(
  BuildContext context,
  WidgetRef ref, {
  required AsyncValue<MyPageHomeApplySectionData> asyncValue,
  required NumberFormat formatter,
}) {
  final l10n = context.l10n;
  final colors = Theme.of(context).appColors;

  return asyncValue.when(
    skipError: true,
    data: (sectionData) {
      final displayRecords = sortApplyRecords(sectionData.records, maxItems: 1);
      final cards = displayRecords
          .map((record) {
            final investorTypeDisplay = resolveInvestorTypeDisplayText(
              l10n,
              record.investorType,
              fallbackInvestorCode: record.investorCode,
            );
            return FundMyPageProjectCard(
              title: record.projectName,
              accentColor: AppColorTokens.fundexHighlightGold,
              trailing: _PendingStatusBadge(
                label: resolveApplyStatusLabel(l10n, record),
                backgroundColor: AppColorTokens.fundexHighlightGold,
                foregroundColor: AppColorTokens.darkOnSurface,
              ),
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageApplyUnitsAmountLabel,
                  value: formatApplyUnitsAmountLabel(record, formatter),
                ),
                buildApplySecondaryRow(l10n, record),
              ],
              detail: MyPageApplyCardDetail(
                investorTypeLabel: l10n.myPageOrderInvestorTypeLabel,
                investorCode: investorTypeDisplay.investorCode,
                returnText: investorTypeDisplay.returnText,
                resultDetails: buildApplyResultDetailsData(
                  l10n,
                  record,
                  formatter,
                ),
              ),
              footer: canSubmitApplyWithdraw(record)
                  ? OutlinedButton(
                      onPressed: () =>
                          _handleApplyWithdraw(context, ref, record),
                      style: _myPageOutlineButtonStyle(
                        context,
                        borderColor: colors.border,
                        foregroundColor: colors.textSecondary,
                      ),
                      child: Text(l10n.myPageCancelRequestAction),
                    )
                  : null,
              onTap: () => handlePendingApplyTap(context, record),
            );
          })
          .toList(growable: false);

      return FundSectionList(
        title: sectionData.showsHistory
            ? l10n.myPageApplyHistoryTitle
            : l10n.myPagePendingApplicationsTitle,
        initialVisibleCount: cards.isEmpty ? 1 : 3,
        actionLabel: l10n.homeViewAllAction,
        onActionTap: () => context.push(
          '/profile/my/section-list?type=${MyPageSectionType.pendingApplications.queryValue}',
        ),
        children: cards.isEmpty
            ? <Widget>[
                _SectionStateCard(message: l10n.myPageApplyHistoryEmptyState),
              ]
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
          onActionTap: () => _invalidateHomeApplySection(ref),
        ),
      ],
    ),
  );
}

// ignore: unused_element
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
    skipError: true,
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
  required Map<String, FundProject> fundProjectsById,
}) {
  final l10n = context.l10n;
  final currencyFormatter = NumberFormat.currency(
    locale: Localizations.localeOf(context).toLanguageTag(),
    symbol: '¥',
    decimalDigits: 0,
  );

  return asyncValue.when(
    skipError: true,
    data: (records) {
      final displayRecords = records.take(3).toList(growable: false);
      final cards = displayRecords
          .map((record) {
            final group = investmentRecordToGroup(record);
            final project = fundProjectsById[record.projectId];
            final status = project?.projectStatus ?? record.projectStatus;
            final investorTypeDisplay = resolveInvestorTypeDisplayText(
              l10n,
              record.investorType,
              fallbackInvestorCode: record.investorCode,
              fallbackEarningType: group.earningType,
              fallbackEarningRatio: group.earningRatio,
            );
            return MyPageHoldingCard(
              data: MyPageActiveFundSummaryCardData(
                title: group.projectName,
                periodText: formatMyPageActiveFundPeriod(context, project),
                investorCode: investorTypeDisplay.investorCode,
                investorType: investorTypeDisplay.investorType,
                returnText: investorTypeDisplay.returnText,
                investmentAmountLabel: l10n.myPageInvestmentAmountLabel,
                investmentAmountValue: _formatCurrency(
                  group.investMoney,
                  currencyFormatter,
                ),
                investmentUnitsLabel: resolveActiveFundInvestmentUnitsLabel(
                  l10n,
                ),
                investmentUnitsValue: formatActiveFundInvestmentUnitsValue(
                  group,
                  l10n,
                ),
                accumulatedEarningsLabel:
                    l10n.myPageAccumulatedDistributionLabel,
                accumulatedEarningsValue: _formatCurrency(
                  group.earnings,
                  currencyFormatter,
                ),
                statusLabel: resolveMyPageActiveFundStatusLabel(
                  l10n,
                  status,
                  investNumValid: group.investNumValid,
                ),
                statusBackgroundColor:
                    resolveMyPageActiveFundStatusBackgroundColor(
                      context,
                      status,
                      investNumValid: group.investNumValid,
                    ),
                statusForegroundColor:
                    resolveMyPageActiveFundStatusForegroundColor(
                      context,
                      status,
                      investNumValid: group.investNumValid,
                    ),
                progress: resolveMyPageActiveFundProgress(project),
                imageUrls: project?.photos ?? const <String>[],
                detailLabel: l10n.homeFeaturedFundViewDetailAction,
                onTap: _buildActiveFundDetailTapHandler(
                  context,
                  seed: MyPageActiveFundDetailSeed.fromRecord(record),
                ),
              ),
            );
          })
          .toList(growable: false);

      return FundSectionList(
        title: l10n.myPageInvestmentStatusTitle,
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
      title: l10n.myPageInvestmentStatusTitle,
      initialVisibleCount: 1,
      children: const <Widget>[_SectionLoadingCard()],
    ),
    error: (_, __) => FundSectionList(
      title: l10n.myPageInvestmentStatusTitle,
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
  if (shouldSkipAppNetworkRefresh(ref)) {
    return;
  }
  await refreshMemberProfileVerificationState(ref);
  ref.invalidate(fundProjectListProvider);
  ref.invalidate(myPageAssetTrendProvider);
  _invalidateHomeApplySection(ref);
  await Future.wait<void>(<Future<void>>[
    refreshRootTabSharedData(ref),
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(myPageAccountStatisticProvider.future).then((_) {}),
    ref.refresh(myPageHomeApplySectionProvider.future).then((_) {}),
    ref.refresh(myPageOrderInquiryListProvider.future).then((_) {}),
    ref.refresh(myPageInvestmentListProvider.future).then((_) {}),
  ]);
}

void _invalidateHomeApplySection(WidgetRef ref) {
  ref.invalidate(myPagePendingApplyListProvider);
  ref.invalidate(myPageApplyListProvider);
  ref.invalidate(myPageHomeApplySectionProvider);
}

Future<void> _handleWithdrawTap(BuildContext context, WidgetRef ref) async {
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

VoidCallback? _buildActiveFundDetailTapHandler(
  BuildContext context, {
  required MyPageActiveFundDetailSeed? seed,
}) {
  final projectId = seed?.projectId;
  if (projectId == null) {
    return null;
  }
  if (projectId.trim().isEmpty) {
    return null;
  }
  return () => context.push('/profile/my/active-funds/$projectId', extra: seed);
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

String? _resolveOrderProjectId(MyPageOrderInquiryRecord record) {
  return record.investorType?.projectId ??
      (record.pdfDocuments.isNotEmpty
          ? record.pdfDocuments.first.projectId
          : null);
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

String _resolveMyPageDisplayName({
  required Locale locale,
  required MemberBasicProfile? profile,
}) {
  final languageCode = locale.languageCode.toLowerCase();

  if (languageCode == 'ja') {
    final fullName = <String>[
      profile?.familyName.trim() ?? '',
      profile?.givenName.trim() ?? '',
    ].where((String part) => part.isNotEmpty).join(' ');
    if (fullName.isNotEmpty) {
      return '$fullName さん';
    }
  }

  if (languageCode == 'zh') {
    final fullName = <String>[
      profile?.familyName.trim() ?? '',
      profile?.givenName.trim() ?? '',
    ].where((String part) => part.isNotEmpty).join(' ');
    if (fullName.isNotEmpty) {
      return switch (profile?.sex) {
        0 => '$fullName 女士',
        1 => '$fullName 先生',
        _ => fullName,
      };
    }
  }

  if (languageCode == 'en') {
    final fullName = <String>[
      profile?.givenNameEn.trim() ?? '',
      profile?.familyNameEn.trim() ?? '',
    ].where((String part) => part.isNotEmpty).join(' ');
    if (fullName.isNotEmpty) {
      return switch (profile?.sex) {
        0 => 'Ms. $fullName',
        1 => 'Mr. $fullName',
        _ => fullName,
      };
    }
  }

  return resolveHomeDisplayName(locale: locale, profile: profile);
}

FundMyPageVerificationBadgeData _resolveMyPageVerificationBadge(
  AppLocalizations l10n,
  AppSemanticColorTheme colors,
  int? status,
) {
  return switch (status) {
    4 => FundMyPageVerificationBadgeData(
      label: l10n.memberProfileOverviewStatusVerified,
      backgroundColor: colors.successSoft,
      foregroundColor: colors.successForeground,
      borderColor: colors.successBorder,
      icon: Icons.verified_rounded,
    ),
    2 || 5 => FundMyPageVerificationBadgeData(
      label: l10n.memberProfileOverviewStatusPending,
      backgroundColor: colors.warningSoft,
      foregroundColor: colors.warningForeground,
      borderColor: colors.warningBorder,
      icon: Icons.schedule_rounded,
    ),
    _ => FundMyPageVerificationBadgeData(
      label: l10n.memberProfileOverviewStatusUnverified,
      backgroundColor: colors.dangerSoft,
      foregroundColor: colors.dangerForeground,
      borderColor: colors.dangerBorder,
      icon: Icons.shield_outlined,
    ),
  };
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

class _SectionLoadingCard extends StatelessWidget {
  const _SectionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionStateCard(
      indicator: CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}

// ignore: unused_element
bool _shouldShowHomeOrderInquirySection(
  AsyncValue<List<MyPageOrderInquiryRecord>> asyncValue,
  Set<String> hiddenOrderInquiryIds,
) {
  return asyncValue.when(
    skipError: true,
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
        //border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
