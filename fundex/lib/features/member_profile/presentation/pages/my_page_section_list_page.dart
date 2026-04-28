import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_section_support.dart';
import '../support/mypage_withdraw_action.dart';
import '../widgets/my_page_active_fund_summary_card.dart';

class MyPageSectionListPage extends ConsumerStatefulWidget {
  const MyPageSectionListPage({
    super.key,
    required this.sectionType,
    this.initialApplyFilter = MyPageApplyHistoryFilter.all,
  });

  final MyPageSectionType sectionType;
  final MyPageApplyHistoryFilter initialApplyFilter;

  @override
  ConsumerState<MyPageSectionListPage> createState() =>
      _MyPageSectionListPageState();
}

class _MyPageSectionListPageState extends ConsumerState<MyPageSectionListPage> {
  static const int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();
  final Set<String> _hiddenOrderInquiryIds = <String>{};
  final List<MyPageApplyRecord> _applyRecords = <MyPageApplyRecord>[];
  final List<MyPageOrderInquiryRecord> _orderInquiryRecords =
      <MyPageOrderInquiryRecord>[];
  final List<MyPageInvestmentRecord> _investmentRecords =
      <MyPageInvestmentRecord>[];

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _error;
  int _nextPage = 1;
  int _loadGeneration = 0;
  late MyPageApplyHistoryFilter _applyFilter;
  late MyPageApplyHistoryFilter _loadedApplyFilter;
  MyPageActiveFundFilter _activeFundFilter = MyPageActiveFundFilter.all;

  @override
  void initState() {
    super.initState();
    _applyFilter = widget.initialApplyFilter;
    _loadedApplyFilter = widget.initialApplyFilter;
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients ||
        _isInitialLoading ||
        _isLoadingMore ||
        !_hasMore) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _loadNextPage();
    }
  }

  Future<void> _loadInitial({bool preserveContent = false}) async {
    final requestGeneration = ++_loadGeneration;
    final shouldPreserveContent = preserveContent && _visibleItemCount > 0;
    final targetApplyFilter = _applyFilter;
    setState(() {
      _isInitialLoading = !shouldPreserveContent;
      _isLoadingMore = shouldPreserveContent;
      _hasMore = true;
      _error = null;
      _nextPage = 1;
      if (!shouldPreserveContent) {
        _applyRecords.clear();
        _hiddenOrderInquiryIds.clear();
        _orderInquiryRecords.clear();
        _investmentRecords.clear();
        _loadedApplyFilter = targetApplyFilter;
      }
    });

    try {
      final pageData = await _fetchPageData(1, applyFilter: targetApplyFilter);
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _replaceRecords(pageData);
        _nextPage = 2;
        _hasMore = pageData.fetchedCount >= _pageSize;
        _error = null;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });

      if (_hasMore && _visibleItemCount == 0) {
        await _loadNextPage();
      }
    } catch (error) {
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }
    final requestGeneration = _loadGeneration;

    if (mounted) {
      setState(() {
        _isLoadingMore = true;
        _error = null;
      });
    }

    try {
      final pageData = await _fetchPageData(
        _nextPage,
        applyFilter: _loadedApplyFilter,
      );
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _appendRecords(pageData);
        _nextPage += 1;
        _hasMore = pageData.fetchedCount >= _pageSize;
        _error = null;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });

      if (_hasMore && _visibleItemCount == 0) {
        await _loadNextPage();
      }
    } catch (error) {
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<_MyPageSectionPageData> _fetchPageData(
    int page, {
    required MyPageApplyHistoryFilter applyFilter,
  }) async {
    switch (widget.sectionType) {
      case MyPageSectionType.pendingApplications:
        final records = await ref
            .read(fetchMyPageApplyListUseCaseProvider)
            .call(
              startPage: page,
              limit: _pageSize,
              statuses: applyFilter.statuses,
            );
        return _MyPageSectionPageData(
          applyRecords: records,
          applyFilter: applyFilter,
          fetchedCount: records.length,
        );
      case MyPageSectionType.coolingOff:
        final user = await ref.read(currentAuthUserProvider.future);
        final userId = user?.userId;
        if (userId == null) {
          return const _MyPageSectionPageData(fetchedCount: 0);
        }
        final records = await ref
            .read(fetchMyPageOrderInquiryListUseCaseProvider)
            .call(userId: userId, startPage: page, limit: _pageSize);
        return _MyPageSectionPageData(
          orderInquiryRecords: records,
          fetchedCount: records.length,
        );
      case MyPageSectionType.activeFunds:
        final records = await ref
            .read(fetchMyPageInvestmentListUseCaseProvider)
            .call(startPage: page, limit: _pageSize);
        return _MyPageSectionPageData(
          investmentRecords: records,
          fetchedCount: records.length,
        );
    }
  }

  void _replaceRecords(_MyPageSectionPageData pageData) {
    _applyRecords
      ..clear()
      ..addAll(pageData.applyRecords);
    _hiddenOrderInquiryIds.clear();
    _orderInquiryRecords
      ..clear()
      ..addAll(pageData.orderInquiryRecords);
    _investmentRecords
      ..clear()
      ..addAll(pageData.investmentRecords);
    _loadedApplyFilter = pageData.applyFilter ?? _applyFilter;
  }

  void _appendRecords(_MyPageSectionPageData pageData) {
    _applyRecords.addAll(pageData.applyRecords);
    _orderInquiryRecords.addAll(pageData.orderInquiryRecords);
    _investmentRecords.addAll(pageData.investmentRecords);
    _loadedApplyFilter = pageData.applyFilter ?? _loadedApplyFilter;
  }

  int get _visibleItemCount {
    return switch (widget.sectionType) {
      MyPageSectionType.pendingApplications => _filteredApplyRecords.length,
      MyPageSectionType.coolingOff => selectCoolingOffRecords(
        _visibleOrderInquiryRecords,
      ).length,
      MyPageSectionType.activeFunds => _filteredInvestmentRecords.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final currencyFormatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '¥',
      decimalDigits: 0,
    );
    final projects =
        ref.watch(fundProjectListProvider).asData?.value ??
        const <FundProject>[];
    final projectsById = <String, FundProject>{
      for (final project in projects) project.id: project,
    };

    return Scaffold(
      appBar: AppNavigationBar(
        title: widget.sectionType == MyPageSectionType.pendingApplications
            ? l10n.myPageApplyHistoryListTitle
            : resolveSectionTitle(l10n, widget.sectionType),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: Column(
        children: <Widget>[
          if (widget.sectionType == MyPageSectionType.pendingApplications)
            AppFilterBar<MyPageApplyHistoryFilter>(
              value: _applyFilter,
              onChanged: (MyPageApplyHistoryFilter value) {
                if (_applyFilter == value) {
                  return;
                }
                setState(() {
                  _applyFilter = value;
                });
                _loadInitial(preserveContent: true);
              },
              backgroundColor: colors.surface,
              showBottomDivider: true,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              items: MyPageApplyHistoryFilter.values
                  .map(
                    (filter) => AppFilterBarItem<MyPageApplyHistoryFilter>(
                      value: filter,
                      label: resolveApplyHistoryFilterLabel(l10n, filter),
                    ),
                  )
                  .toList(growable: false),
            ),
          if (widget.sectionType == MyPageSectionType.activeFunds)
            AppFilterBar<MyPageActiveFundFilter>(
              value: _activeFundFilter,
              onChanged: (MyPageActiveFundFilter value) {
                setState(() {
                  _activeFundFilter = value;
                });
                if (_visibleItemCount == 0 && _hasMore) {
                  _loadNextPage();
                }
              },
              backgroundColor: colors.surface,
              showBottomDivider: true,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              items: MyPageActiveFundFilter.values
                  .map(
                    (filter) => AppFilterBarItem<MyPageActiveFundFilter>(
                      value: filter,
                      label: resolveMyPageActiveFundFilterLabel(l10n, filter),
                    ),
                  )
                  .toList(growable: false),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadInitial,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    sliver: _buildSliverContent(
                      context,
                      formatter: currencyFormatter,
                      fundProjectsById: projectsById,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MyPageApplyRecord> get _filteredApplyRecords {
    return filterApplyRecordsByHistoryFilter(_applyRecords, _loadedApplyFilter);
  }

  List<MyPageOrderInquiryRecord> get _visibleOrderInquiryRecords {
    return _orderInquiryRecords
        .where((record) => !_hiddenOrderInquiryIds.contains(record.id))
        .toList(growable: false);
  }

  List<MyPageInvestmentRecord> get _filteredInvestmentRecords {
    return filterInvestmentRecordsByActiveFundFilter(
      _investmentRecords,
      _activeFundFilter,
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return OutlinedButton(
      onPressed: _loadInitial,
      child: Text(context.l10n.fundListRetry),
    );
  }

  SliverList _buildSliverList(List<Widget> children) {
    return SliverList.list(children: children);
  }

  SliverToBoxAdapter _buildSliverState({
    Widget? indicator,
    required String message,
    Widget? action,
  }) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          border: Border.all(color: colors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: <Widget>[
              if (indicator != null) indicator,
              if (indicator != null) const SizedBox(height: UiTokens.spacing8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: appText.bodyMuted.copyWith(color: colors.textSecondary),
              ),
              if (action != null) ...<Widget>[
                const SizedBox(height: UiTokens.spacing8),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingCard(
    BuildContext context,
    MyPageApplyRecord record,
    NumberFormat formatter,
  ) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;
    return FundMyPageProjectCard(
      title: record.projectName,
      accentColor: AppColorTokens.fundexHighlightGold,
      trailing: _StatusBadge(
        label: resolveApplyStatusLabel(l10n, record),
        backgroundColor: AppColorTokens.fundexHighlightGold,
        foregroundColor: AppColorTokens.darkOnSurface,
      ),
      rows: <FundLabeledValue>[
        FundLabeledValue(
          label: l10n.myPageApplyAmountLabel,
          value: formatCurrency(record.applyMoney, formatter),
        ),
        buildApplySecondaryRow(l10n, record),
      ],
      footer: canSubmitApplyWithdraw(record)
          ? OutlinedButton(
              onPressed: () => _handleApplyWithdraw(record),
              style: _myPageOutlineButtonStyle(
                context,
                borderColor: colors.danger,
                foregroundColor: colors.danger,
              ),
              child: Text(l10n.myPageCancelRequestAction),
            )
          : null,
      onTap: () => handlePendingApplyTap(context, record),
    );
  }

  Widget _buildCoolingOffCard(
    BuildContext context,
    MyPageOrderInquiryRecord record,
    NumberFormat formatter,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return FundMyPageProjectCard(
      title: record.projectName,
      accentColor: colors.warning,
      trailing: _StatusBadge(
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
          value: formatCurrency(record.price, formatter),
        ),
      ],
      footer: canSubmitOrderInquiryWithdraw(record)
          ? OutlinedButton(
              onPressed: () => _handleOrderWithdraw(record),
              style: _myPageOutlineButtonStyle(
                context,
                borderColor: colors.danger,
                foregroundColor: colors.danger,
              ),
              child: Text(l10n.myPageCancelOrderAction),
            )
          : null,
      onTap: null,
    );
  }

  Widget _buildActiveFundCard(
    BuildContext context,
    MyPageInvestmentGroup group, {
    required Map<String, FundProject> fundProjectsById,
    MyPageActiveFundDetailSeed? seed,
    MyPageInvestorType? investorType,
  }) {
    final l10n = context.l10n;
    final project = fundProjectsById[group.projectId];
    final status = group.projectStatus ?? project?.projectStatus;
    final investorTypeDisplay = resolveInvestorTypeDisplayText(
      l10n,
      investorType,
      fallbackInvestorCode: seed?.investorCode,
      fallbackEarningType: group.earningType,
      fallbackEarningRatio: group.earningRatio,
    );
    return MyPageActiveFundSummaryCard(
      data: MyPageActiveFundSummaryCardData(
        title: group.projectName,
        periodText: formatMyPageActiveFundPeriod(context, project) != null
            ? '${l10n.fundListPeriodLabel}：${formatMyPageActiveFundPeriod(context, project)!}'
            : l10n.myPageResultAnnouncementTbd,
        investorCode: investorTypeDisplay.investorCode,
        investorType: investorTypeDisplay.investorType,
        returnText: investorTypeDisplay.returnText,
        statusLabel: resolveMyPageActiveFundStatusLabel(l10n, status),
        statusBackgroundColor: resolveMyPageActiveFundStatusBackgroundColor(
          context,
          status,
        ),
        statusForegroundColor: resolveMyPageActiveFundStatusForegroundColor(
          context,
          status,
        ),
        progress: resolveMyPageActiveFundProgress(project),
        imageUrls: project?.photos ?? const <String>[],
        onTap: _buildActiveFundTapHandler(context, group, seed: seed),
      ),
    );
  }

  Widget _buildSliverContent(
    BuildContext context, {
    required NumberFormat formatter,
    required Map<String, FundProject> fundProjectsById,
  }) {
    final l10n = context.l10n;

    if (_isInitialLoading) {
      return _buildSliverState(
        indicator: const CircularProgressIndicator.adaptive(strokeWidth: 2),
        message: l10n.fundListLoadError.replaceFirst(
          l10n.fundListLoadError,
          resolveSectionTitle(l10n, widget.sectionType),
        ),
      );
    }

    if (_error != null && _visibleItemCount == 0) {
      return _buildSliverState(
        message: l10n.myPageSectionLoadError,
        action: _buildRetryButton(context),
      );
    }

    final children = switch (widget.sectionType) {
      MyPageSectionType.pendingApplications =>
        _filteredApplyRecords
            .map((record) => _buildPendingCard(context, record, formatter))
            .toList(growable: false),
      MyPageSectionType.coolingOff =>
        selectCoolingOffRecords(_visibleOrderInquiryRecords)
            .map((record) => _buildCoolingOffCard(context, record, formatter))
            .toList(growable: false),
      MyPageSectionType.activeFunds =>
        _filteredInvestmentRecords
            .map(
              (record) => _buildActiveFundCard(
                context,
                investmentRecordToGroup(record),
                fundProjectsById: fundProjectsById,
                seed: MyPageActiveFundDetailSeed.fromRecord(record),
                investorType: record.investorType,
              ),
            )
            .toList(growable: false),
    };

    if (children.isEmpty) {
      return _buildSliverState(
        message: widget.sectionType == MyPageSectionType.pendingApplications
            ? l10n.myPageApplyHistoryEmptyState
            : widget.sectionType == MyPageSectionType.activeFunds
            ? resolveMyPageActiveFundEmptyState(l10n, _activeFundFilter)
            : resolveSectionEmptyState(l10n, widget.sectionType),
      );
    }

    final listChildren = <Widget>[
      ...children,
      if (_isLoadingMore)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      if (_error != null && !_isLoadingMore)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(child: _buildRetryButton(context)),
        ),
      const SizedBox(height: 16),
    ];
    return _buildSliverList(listChildren);
  }

  VoidCallback? _buildActiveFundTapHandler(
    BuildContext context,
    MyPageInvestmentGroup group, {
    MyPageActiveFundDetailSeed? seed,
  }) {
    final resolvedSeed =
        seed ??
        resolveMyPageActiveFundDetailSeed(
          group.projectId,
          _filteredInvestmentRecords,
        );
    final projectId = resolvedSeed?.projectId ?? group.projectId;
    if (projectId.trim().isEmpty) {
      return null;
    }
    return () => context.push(
      '/profile/my/active-funds/$projectId',
      extra: resolvedSeed,
    );
  }

  Future<void> _refreshAfterWithdraw() async {
    ref.invalidate(myPageApplyListProvider);
    ref.invalidate(myPagePendingApplyListProvider);
    ref.invalidate(myPageOrderInquiryListProvider);
    await _loadInitial();
  }

  Future<void> _hideOrderInquiryRecord(String orderId) async {
    if (!mounted) {
      return;
    }
    setState(() {
      _hiddenOrderInquiryIds.add(orderId);
    });
  }

  Future<void> _handleApplyWithdraw(MyPageApplyRecord record) async {
    final processId = resolveApplyWithdrawProcessId(record);
    if (processId == null) {
      return;
    }
    await confirmAndSubmitMyPageWithdraw(
      context,
      ref,
      processId: processId,
      confirmBody: context.l10n.myPageWithdrawApplyConfirmBody,
      onSuccessRefresh: _refreshAfterWithdraw,
    );
  }

  Future<void> _handleOrderWithdraw(MyPageOrderInquiryRecord record) async {
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
}

class _MyPageSectionPageData {
  const _MyPageSectionPageData({
    this.applyRecords = const <MyPageApplyRecord>[],
    this.applyFilter,
    this.orderInquiryRecords = const <MyPageOrderInquiryRecord>[],
    this.investmentRecords = const <MyPageInvestmentRecord>[],
    required this.fetchedCount,
  });

  final List<MyPageApplyRecord> applyRecords;
  final MyPageApplyHistoryFilter? applyFilter;
  final List<MyPageOrderInquiryRecord> orderInquiryRecords;
  final List<MyPageInvestmentRecord> investmentRecords;
  final int fetchedCount;
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
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
