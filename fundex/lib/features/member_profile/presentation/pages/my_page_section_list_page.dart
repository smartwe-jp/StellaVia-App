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
  late MyPageApplyHistoryFilter _applyFilter;

  @override
  void initState() {
    super.initState();
    _applyFilter = widget.initialApplyFilter;
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

  Future<void> _loadInitial() async {
    setState(() {
      _isInitialLoading = true;
      _isLoadingMore = false;
      _hasMore = true;
      _error = null;
      _nextPage = 1;
      _applyRecords.clear();
      _hiddenOrderInquiryIds.clear();
      _orderInquiryRecords.clear();
      _investmentRecords.clear();
    });
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingMore = true;
        _error = null;
      });
    }

    try {
      final fetchedCount = await _fetchPage(_nextPage);
      _nextPage += 1;
      _hasMore = fetchedCount >= _pageSize;
      _error = null;

      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isLoadingMore = false;
        });
      }

      if (_hasMore && _visibleItemCount == 0) {
        await _loadNextPage();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<int> _fetchPage(int page) async {
    switch (widget.sectionType) {
      case MyPageSectionType.pendingApplications:
        final records = await ref
            .read(fetchMyPageApplyListUseCaseProvider)
            .call(startPage: page, limit: _pageSize);
        _applyRecords.addAll(records);
        return records.length;
      case MyPageSectionType.coolingOff:
        final user = await ref.read(currentAuthUserProvider.future);
        final userId = user?.userId;
        if (userId == null) {
          return 0;
        }
        final records = await ref
            .read(fetchMyPageOrderInquiryListUseCaseProvider)
            .call(userId: userId, startPage: page, limit: _pageSize);
        _orderInquiryRecords.addAll(records);
        return records.length;
      case MyPageSectionType.activeFunds:
        final records = await ref
            .read(fetchMyPageInvestmentListUseCaseProvider)
            .call(startPage: page, limit: _pageSize);
        _investmentRecords.addAll(records);
        return records.length;
    }
  }

  int get _visibleItemCount {
    return switch (widget.sectionType) {
      MyPageSectionType.pendingApplications => _filteredApplyRecords.length,
      MyPageSectionType.coolingOff => selectCoolingOffRecords(
        _visibleOrderInquiryRecords,
      ).length,
      MyPageSectionType.activeFunds => groupActiveInvestmentRecords(
        _investmentRecords,
      ).length,
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
                setState(() {
                  _applyFilter = value;
                });
                if (_visibleItemCount == 0 && _hasMore) {
                  _loadNextPage();
                }
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
    return filterApplyRecordsByHistoryFilter(_applyRecords, _applyFilter);
  }

  List<MyPageOrderInquiryRecord> get _visibleOrderInquiryRecords {
    return _orderInquiryRecords
        .where((record) => !_hiddenOrderInquiryIds.contains(record.id))
        .toList(growable: false);
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
      accentColor: AppColorTokens.fundexViolet,
      trailing: _StatusBadge(
        label: resolveApplyStatusLabel(l10n, record),
        backgroundColor: AppColorTokens.fundexVioletLight,
        foregroundColor: AppColorTokens.fundexViolet,
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
    MyPageInvestmentGroup group,
    NumberFormat formatter, {
    required Map<String, FundProject> fundProjectsById,
  }) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;
    final project = fundProjectsById[group.projectId];
    return FundActiveFundCard(
      data: FundActiveFundCardData(
        title: group.projectName,
        annualYield: resolveYieldLabel(
          project,
          fallbackRatio: group.earningRatio,
        ),
        rows: <FundLabeledValue>[
          FundLabeledValue(
            label: l10n.myPageInvestmentAmountLabel,
            value: formatCurrency(group.investMoney, formatter),
          ),
          FundLabeledValue(
            label: l10n.myPageAccumulatedDistributionLabel,
            value: formatCurrency(group.earnings, formatter),
            valueColor: colors.success,
          ),
        ],
        onTap: _buildActiveFundTapHandler(context, group.projectId),
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
        groupActiveInvestmentRecords(_investmentRecords)
            .map(
              (group) => _buildActiveFundCard(
                context,
                group,
                formatter,
                fundProjectsById: fundProjectsById,
              ),
            )
            .toList(growable: false),
    };

    if (children.isEmpty) {
      return _buildSliverState(
        message: widget.sectionType == MyPageSectionType.pendingApplications
            ? l10n.myPageApplyHistoryEmptyState
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
    String? projectId,
  ) {
    if (projectId == null || projectId.trim().isEmpty) {
      return null;
    }
    final records = _investmentRecords
        .where((record) => record.projectId == projectId)
        .toList(growable: false);
    return () =>
        context.push('/profile/my/active-funds/$projectId', extra: records);
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
