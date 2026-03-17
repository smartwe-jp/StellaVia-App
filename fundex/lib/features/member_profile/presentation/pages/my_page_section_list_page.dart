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

class MyPageSectionListPage extends ConsumerStatefulWidget {
  const MyPageSectionListPage({super.key, required this.sectionType});

  final MyPageSectionType sectionType;

  @override
  ConsumerState<MyPageSectionListPage> createState() =>
      _MyPageSectionListPageState();
}

class _MyPageSectionListPageState extends ConsumerState<MyPageSectionListPage> {
  static const int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();
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

  @override
  void initState() {
    super.initState();
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
      MyPageSectionType.pendingApplications => selectPendingApplyRecords(
        _applyRecords,
      ).length,
      MyPageSectionType.coolingOff => selectCoolingOffRecords(
        _orderInquiryRecords,
      ).length,
      MyPageSectionType.activeFunds => groupActiveInvestmentRecords(
        _investmentRecords,
      ).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
      appBar: AppBar(
        title: Text(resolveSectionTitle(l10n, widget.sectionType)),
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitial,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: _buildSliverContent(
                context,
                formatter: currencyFormatter,
                localeTag: localeTag,
                fundProjectsById: projectsById,
              ),
            ),
          ],
        ),
      ),
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
    return SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          border: Border.all(color: AppColorTokens.fundexBorder),
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
                style:
                    (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                        .copyWith(color: AppColorTokens.fundexTextSecondary),
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
      footer: canShowApplyCancelAction(record.status)
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
    );
  }

  Widget _buildCoolingOffCard(
    BuildContext context,
    MyPageOrderInquiryRecord record,
    NumberFormat formatter, {
    required String localeTag,
    required Map<String, FundProject> fundProjectsById,
  }) {
    final l10n = context.l10n;
    final projectId = resolveOrderProjectId(record);
    final project = projectId == null ? null : fundProjectsById[projectId];
    final deadline = resolveCoolingOffDeadline(record);

    return FundMyPageProjectCard(
      title: record.projectName,
      accentColor: AppColorTokens.fundexWarning,
      trailing: Text(
        resolveYieldLabel(
          project,
          fallbackRatio: record.investorType?.earningsRadio,
        ),
        style: (Theme.of(context).textTheme.titleMedium ?? const TextStyle())
            .copyWith(
              color: AppColorTokens.fundexDanger,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
      ),
      rows: <FundLabeledValue>[
        FundLabeledValue(
          label: l10n.myPageInvestmentAmountLabel,
          value: formatCurrency(record.price, formatter),
        ),
        FundLabeledValue(
          label: l10n.myPageDocumentDeliveryDateLabel,
          value:
              formatDateOrNull(record.createTime) ??
              l10n.myPageResultAnnouncementTbd,
        ),
        FundLabeledValue(
          label: l10n.myPageCancelDeadlineLabel,
          value: formatCoolingOffDeadlineLabel(
            l10n,
            deadline,
            localeTag: localeTag,
          ),
          valueColor: resolveCoolingOffDeadlineColor(deadline),
        ),
      ],
      footnote: l10n.myPageCoolingOffFootnote,
      footer: OutlinedButton(
        onPressed: () =>
            _showSnackBar(context, message: l10n.myPageCancelRequestComingSoon),
        style: _myPageOutlineButtonStyle(
          borderColor: AppColorTokens.fundexDanger,
          foregroundColor: AppColorTokens.fundexDanger,
        ),
        child: Text(l10n.myPageCancelRequestAction),
      ),
      onTap: _buildProjectTapHandler(context, projectId),
    );
  }

  Widget _buildActiveFundCard(
    BuildContext context,
    MyPageInvestmentGroup group,
    NumberFormat formatter, {
    required Map<String, FundProject> fundProjectsById,
  }) {
    final l10n = context.l10n;
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
            valueColor: AppColorTokens.fundexSuccess,
          ),
        ],
        onTap: _buildActiveFundTapHandler(context, group.projectId),
      ),
    );
  }

  Widget _buildSliverContent(
    BuildContext context, {
    required NumberFormat formatter,
    required String localeTag,
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
        selectPendingApplyRecords(_applyRecords)
            .map((record) => _buildPendingCard(context, record, formatter))
            .toList(growable: false),
      MyPageSectionType.coolingOff =>
        selectCoolingOffRecords(_orderInquiryRecords)
            .map(
              (record) => _buildCoolingOffCard(
                context,
                record,
                formatter,
                localeTag: localeTag,
                fundProjectsById: fundProjectsById,
              ),
            )
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
        message: resolveSectionEmptyState(l10n, widget.sectionType),
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

  VoidCallback? _buildProjectTapHandler(
    BuildContext context,
    String? projectId,
  ) {
    if (projectId == null || projectId.trim().isEmpty) {
      return null;
    }
    return () => context.push('/funds/$projectId');
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
    return () => context.push('/my/active-funds/$projectId', extra: records);
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
            .copyWith(
              color: foregroundColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
