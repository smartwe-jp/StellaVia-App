import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../controllers/secondary_market_controller.dart';
import '../widgets/secondary_market_refresh_scope.dart';

class SecondaryMarketMarketplacePage extends ConsumerWidget {
  const SecondaryMarketMarketplacePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(
      secondaryMarketControllerProvider(SecondaryMarketListKind.market),
    );
    final controller = ref.read(
      secondaryMarketControllerProvider(
        SecondaryMarketListKind.market,
      ).notifier,
    );
    final formatter = NumberFormat.currency(symbol: '¥', decimalDigits: 0);
    return SecondaryMarketRefreshScope(
      onRefresh: controller.refresh,
      child: Scaffold(
        appBar: AppNavigationBar(
          title: l.homeFreeMarketTitle,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.canPop() ? context.pop() : context.go('/home'),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              TextButton(
                onPressed: () async {
                  await context.push('/profile/my/secondary-market');
                  if (context.mounted) await controller.refresh();
                },
                child: Text(l.secondaryMarketManage),
              ),
              if (state.loading) const LinearProgressIndicator(),
              if (state.error != null)
                ListTile(
                  title: Text(l.secondaryMarketListLoadError),
                  trailing: TextButton(
                    onPressed: controller.refresh,
                    child: Text(l.fundListRetry),
                  ),
                ),
              if (!state.loading && state.error == null && state.orders.isEmpty)
                Text(l.homeFreeMarketEmptyState),
              for (final record in state.orders)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FundSecondaryMarketCard(
                    width: double.infinity,
                    data: _buildSecondaryMarketCardData(
                      context,
                      record,
                      formatter,
                      () async {
                        await context.push(
                          '/home/free-market/${record.id}',
                          extra: record,
                        );
                        if (context.mounted) await controller.refresh();
                      },
                    ),
                    actionLabel: l.secondaryMarketBuyAction,
                    yieldLabel: l.homeEstimatedYieldLabel,
                    soldUnitsTitle: l.homeFreeMarketSoldUnitsLabel,
                    unitPriceTitle: l.homeFreeMarketUnitPriceLabel,
                  ),
                ),
              if (state.hasMore && !state.loading)
                TextButton(
                  onPressed: controller.loadMore,
                  child: Text(l.secondaryMarketLoadMore),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

FundSecondaryMarketCardData _buildSecondaryMarketCardData(
  BuildContext context,
  MyPageOrderInquiryRecord record,
  NumberFormat formatter,
  VoidCallback onTap,
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
    statusBackgroundColor: colors.primary,
    statusForegroundColor: colors.onDark,
    annualYield: _formatYieldPercent(record.investorType?.earningsRadio),
    investorTypeLabel: investorCode != null && investorCode.isNotEmpty
        ? investorCode
        : '--',
    soldUnitsLabel:
        '${soldNum.toString()} / ${sellNum.toString()}${context.l10n.myPageResaleUnitsSuffix}',
    unitPriceLabel: formatter.format(record.price ?? 0),
    progress: progress.clamp(0, 1),
    onTap: (record.id == null || record.id!.trim().isEmpty) ? null : onTap,
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
