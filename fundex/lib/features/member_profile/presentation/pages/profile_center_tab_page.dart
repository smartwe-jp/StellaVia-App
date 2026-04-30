import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../../../app/support/app_compact_money_formatter.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
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
import '../support/mypage_withdraw_action.dart';
import '../widgets/my_page_apply_investor_type_panel.dart';
import '../widgets/my_page_active_fund_summary_card.dart';
import '../widgets/my_page_asset_trend_card.dart';

class ProfileCenterTabPage extends ConsumerStatefulWidget {
  const ProfileCenterTabPage({super.key});

  @override
  ConsumerState<ProfileCenterTabPage> createState() =>
      _ProfileCenterTabPageState();
}

class _ProfileCenterTabPageState extends ConsumerState<ProfileCenterTabPage> {
  final Set<String> _hiddenOrderInquiryIds = <String>{};
  MyPageAssetTrendRange _selectedTrendRange = MyPageAssetTrendRange.threeMonths;

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
    final trendEndDate = _resolveTrendEndDate();
    final trendRange = (
      startDate: _selectedTrendRange.resolveStart(trendEndDate),
      endDate: trendEndDate,
    );
    final currencyFormatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '¥',
      decimalDigits: 0,
    );
    final hasUnreadNotifications = ref.watch(
      notificationsControllerProvider.select((state) => state.unreadCount > 0),
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
    final applyAsync = ref.watch(myPagePendingApplyListProvider);
    //final orderInquiryAsync = ref.watch(myPageOrderInquiryListProvider);
    final investmentAsync = ref.watch(myPageInvestmentListProvider);
    final walletHistoryAsync = ref.watch(walletHistoryProvider);
    final assetTrendAsync = ref.watch(myPageAssetTrendProvider(trendRange));
    final investmentRecords = investmentAsync.valueOrNull;
    final fundProjects =
        ref.watch(fundProjectListProvider).valueOrNull ?? const <FundProject>[];
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
                brandLabel: 'STE//AVIA',
                welcomeLabel: l10n.myPageWelcomeBack,
                displayName: _resolveMyPageDisplayName(
                  locale: locale,
                  profile: basicProfile,
                ),
                verificationBadge: authUserAsync.whenOrNull(
                  data: (user) => _resolveMyPageVerificationBadge(
                    l10n,
                    colors,
                    user?.status,
                  ),
                ),
                totalAssetsLabel: l10n.myPageTotalAssetsLabel,
                totalAssetsValue: _formatCurrency(
                  totalAssetsExcludingLoan,
                  currencyFormatter,
                ),
                totalAssetsCaption: l10n.myPageTotalAssetsCaption,
                headerActions: <Widget>[
                  _HeroHeaderActionButton(
                    icon: Icons.notifications_none_rounded,
                    showDot: hasUnreadNotifications,
                    onTap: () => context.push('/profile/notifications'),
                  ),
                  _HeroHeaderActionButton(
                    icon: Icons.menu_rounded,
                    onTap: () => context.push('/profile/settings'),
                  ),
                ],
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
                    onTap: () => context.push('/wallet/deposit'),
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
                  ),
                ],
                quickActions: <FundMyPageQuickActionData>[
                  FundMyPageQuickActionData(
                    label: l10n.myPageDepositAction,
                    backgroundColor: colors.highlightGold,
                    foregroundColor: colors.onDark,
                    onTap: () => context.push('/wallet/deposit'),
                  ),
                  FundMyPageQuickActionData(
                    label: l10n.myPageWithdrawAction,
                    backgroundColor: colors.heroStart,
                    borderColor: colors.highlightGold,
                    foregroundColor: colors.highlightGold,
                    onTap: () => _handleWithdrawTap(context, ref),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: MyPageAssetTrendCard(
                  title: l10n.myPageAssetTrendTitle,
                  selectedRange: _selectedTrendRange,
                  onRangeChanged: (range) {
                    setState(() {
                      _selectedTrendRange = range;
                    });
                  },
                  records: assetTrendAsync.valueOrNull ?? const [],
                  isLoading: assetTrendAsync.isLoading,
                ),
              ),
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
    );
  }

  Future<void> _refreshPage() async {
    if (shouldSkipAppNetworkRefresh(ref)) {
      return;
    }
    setState(() {
      _hiddenOrderInquiryIds.clear();
    });
    final trendEndDate = _resolveTrendEndDate();
    await Future.wait<void>(<Future<void>>[
      refreshProfileCenterTabPage(ref),
      ref.refresh(walletHistoryProvider.future).then((_) {}),
      ref
          .refresh(
            myPageAssetTrendProvider((
              startDate: _selectedTrendRange.resolveStart(trendEndDate),
              endDate: trendEndDate,
            )).future,
          )
          .then((_) {}),
    ]);
  }

  DateTime _resolveTrendEndDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
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
    required AsyncValue<List<MyPageApplyRecord>> applyAsync,
    // required AsyncValue<List<MyPageOrderInquiryRecord>> orderInquiryAsync,
    required AsyncValue<List<MyPageInvestmentRecord>> investmentAsync,
    required AsyncValue<List<WalletAccountHistory>> walletHistoryAsync,
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

    if (children.isNotEmpty) {
      children.add(const SizedBox(height: UiTokens.spacing12));
    }
    children.add(
      _buildActiveFundsSection(
        context,
        ref,
        asyncValue: investmentAsync,
        fundProjectsById: fundProjectsById,
      ),
    );
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
  required AsyncValue<List<MyPageApplyRecord>> asyncValue,
  required NumberFormat formatter,
}) {
  final l10n = context.l10n;
  final colors = Theme.of(context).appColors;

  return asyncValue.when(
    skipError: true,
    data: (records) {
      final displayRecords = sortApplyRecords(records, maxItems: 3);
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
              detail: MyPageApplyInvestorTypePanel(
                label: l10n.myPageOrderInvestorTypeLabel,
                investorCode: investorTypeDisplay.investorCode,
                returnText: investorTypeDisplay.returnText,
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
            return MyPageActiveFundSummaryCard(
              data: MyPageActiveFundSummaryCardData(
                title: group.projectName,
                periodText:
                    formatMyPageActiveFundPeriod(context, project) != null
                    ? '${l10n.fundListPeriodLabel}：${formatMyPageActiveFundPeriod(context, project)!}'
                    : l10n.myPageResultAnnouncementTbd,
                investorCode: investorTypeDisplay.investorCode,
                investorType: investorTypeDisplay.investorType,
                returnText: investorTypeDisplay.returnText,
                accumulatedEarningsLabel:
                    l10n.myPageAccumulatedDistributionLabel,
                accumulatedEarningsValue: _formatCurrency(
                  group.earnings,
                  currencyFormatter,
                ),
                statusLabel: resolveMyPageActiveFundStatusLabel(l10n, status),
                statusBackgroundColor:
                    resolveMyPageActiveFundStatusBackgroundColor(
                      context,
                      status,
                    ),
                statusForegroundColor:
                    resolveMyPageActiveFundStatusForegroundColor(
                      context,
                      status,
                    ),
                progress: resolveMyPageActiveFundProgress(project),
                imageUrls: project?.photos ?? const <String>[],
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
  ref.invalidate(fundProjectListProvider);
  ref.invalidate(myPageAssetTrendProvider);
  await Future.wait<void>(<Future<void>>[
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(myPageAccountStatisticProvider.future).then((_) {}),
    ref.refresh(myPagePendingApplyListProvider.future).then((_) {}),
    ref.refresh(myPageOrderInquiryListProvider.future).then((_) {}),
    ref.refresh(myPageInvestmentListProvider.future).then((_) {}),
  ]);
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
      profile?.familyNameEn.trim() ?? '',
      profile?.givenNameEn.trim() ?? '',
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
    skipError: true,
    data: (records) => records.isNotEmpty,
    loading: () => true,
    error: (_, __) => true,
  );
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
