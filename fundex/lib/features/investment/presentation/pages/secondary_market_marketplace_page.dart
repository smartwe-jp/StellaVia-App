import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';

class SecondaryMarketMarketplacePage extends ConsumerStatefulWidget {
  const SecondaryMarketMarketplacePage({super.key});

  @override
  ConsumerState<SecondaryMarketMarketplacePage> createState() =>
      _SecondaryMarketMarketplacePageState();
}

class _SecondaryMarketMarketplacePageState
    extends ConsumerState<SecondaryMarketMarketplacePage> {
  static const int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();
  final List<MyPageOrderInquiryRecord> _records = <MyPageOrderInquiryRecord>[];

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
      _records.clear();
      _isInitialLoading = true;
      _isLoadingMore = false;
      _hasMore = true;
      _error = null;
      _nextPage = 1;
    });
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _error = null;
    });

    try {
      final records = await ref
          .read(fetchMyPageOrderInquiryListUseCaseProvider)
          .call(startPage: _nextPage, limit: _pageSize, status: 'VALID');
      final existingIds = _records.map((item) => item.id).toSet();
      _records.addAll(
        records.where((item) => !existingIds.contains(item.id)).toList(),
      );
      _nextPage += 1;
      _hasMore = records.length >= _pageSize;
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isLoadingMore = false;
        });
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppNavigationBar(
        title: l10n.homeFreeMarketTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitial,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: _buildContent(context, formatter: formatter),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateCard(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
            if (actionLabel != null && onActionTap != null) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onActionTap, child: Text(actionLabel)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardFooterLoader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: _isLoadingMore
            ? const CircularProgressIndicator.adaptive()
            : const SizedBox.shrink(),
      ),
    );
  }

  SliverList _buildContent(
    BuildContext context, {
    required NumberFormat formatter,
  }) {
    final l10n = context.l10n;

    if (_isInitialLoading && _records.isEmpty) {
      return SliverList.list(
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      );
    }

    if (_error != null && _records.isEmpty) {
      return SliverList.list(
        children: <Widget>[
          _buildStateCard(
            context,
            message: l10n.secondaryMarketListLoadError,
            actionLabel: l10n.fundListRetry,
            onActionTap: _loadInitial,
          ),
        ],
      );
    }

    if (_records.isEmpty) {
      return SliverList.list(
        children: <Widget>[
          _buildStateCard(context, message: l10n.homeFreeMarketEmptyState),
        ],
      );
    }

    return SliverList.list(
      children: <Widget>[
        for (var index = 0; index < _records.length; index++) ...<Widget>[
          FundSecondaryMarketCard(
            width: double.infinity,
            data: _buildSecondaryMarketCardData(
              context,
              _records[index],
              formatter,
            ),
            actionLabel: l10n.secondaryMarketBuyAction,
            yieldLabel: l10n.homeEstimatedYieldLabel,
            soldUnitsTitle: l10n.homeFreeMarketSoldUnitsLabel,
            unitPriceTitle: l10n.homeFreeMarketUnitPriceLabel,
          ),
          if (index < _records.length - 1) const SizedBox(height: 8),
        ],
        _buildCardFooterLoader(context),
      ],
    );
  }
}

FundSecondaryMarketCardData _buildSecondaryMarketCardData(
  BuildContext context,
  MyPageOrderInquiryRecord record,
  NumberFormat formatter,
) {
  final theme = Theme.of(context);
  final colors = theme.appColors;
  final investorCode = record.investorType?.investorCode?.trim();
  final sellNum = record.sellNum ?? 0;
  final soldNum = record.soldNum ?? 0;
  final progress = sellNum <= 0 ? 0.0 : soldNum / sellNum;

  return FundSecondaryMarketCardData(
    title: record.projectName,
    statusLabel: context.l10n.homeFreeMarketStatusListed,
    statusBackgroundColor: colors.warningSubtle,
    statusForegroundColor: colors.warningAction,
    annualYield: _formatYieldPercent(record.investorType?.earningsRadio),
    investorTypeLabel: investorCode != null && investorCode.isNotEmpty
        ? investorCode
        : '--',
    soldUnitsLabel: '${soldNum.toString()} / ${sellNum.toString()}口',
    unitPriceLabel: formatter.format(record.price ?? 0),
    progress: progress.clamp(0, 1),
    onTap: (record.id == null || record.id!.trim().isEmpty)
        ? null
        : () => context.push('/home/free-market/${record.id}', extra: record),
  );
}

String _formatYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}
