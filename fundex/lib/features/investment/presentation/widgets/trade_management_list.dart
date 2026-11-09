import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/support/mypage_secondary_market_models.dart';
import '../controllers/trade_management_provider.dart';
import 'secondary_market_activity_cards.dart';
import 'secondary_market_marketplace_card.dart';

class TradeManagementList extends StatelessWidget {
  const TradeManagementList({
    super.key,
    required this.data,
    required this.list,
    required this.page,
    required this.onPage,
  });
  final TradePageData data;
  final TradeList list;
  final int page;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.empty)
          AppCard(
            child: Text(switch (list) {
              TradeList.sell => l.tradeEmptySell,
              TradeList.buy => l.tradeEmptyBuy,
              TradeList.salesHistory => l.tradeEmptyHistorySell,
              TradeList.purchaseHistory => l.tradeEmptyHistoryBuy,
            }),
          ),
        for (final h in data.holdings) _SellableHoldingCard(holding: h),
        for (final order in data.orders)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: list == TradeList.buy
                ? SecondaryMarketMarketplaceCard(
                    record: order,
                    onTap: () => context.push(
                      '/home/free-market/${Uri.encodeComponent(order.id!)}',
                      extra: order,
                    ),
                  )
                : SecondaryMarketListingCard(
                    record: order,
                    onTap: order.id == null
                        ? null
                        : () => context.push(
                            '/profile/my/secondary-market/sales/${Uri.encodeComponent(order.id!)}',
                          ),
                  ),
          ),
        for (final record in data.applications)
          SecondaryMarketApplicationCard(
            record: record,
            onTap: record.processId == null
                ? null
                : () => context.push(
                    '/profile/my/secondary-market/purchases/${Uri.encodeComponent(record.processId!)}',
                  ),
          ),
        if (page > 1 || data.pages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: page == 1 ? null : () => onPage(page - 1),
                child: Text(l.myPageMilesHistoryPrev),
              ),
              Text('$page / ${data.pages < page ? page : data.pages}'),
              TextButton(
                onPressed: page >= data.pages ? null : () => onPage(page + 1),
                child: Text(l.commonNext),
              ),
            ],
          ),
      ],
    );
  }
}

class _SellableHoldingCard extends StatelessWidget {
  const _SellableHoldingCard({required this.holding});
  final SecondaryMarketHolding holding;
  @override
  Widget build(BuildContext context) {
    final h = holding, l = context.l10n;
    final price = h.investmentUnit;
    final amount = h.investedAmount;
    return FundMyPageProjectCard(
      title: h.projectName,
      accentColor: context.appColors.primaryAlt,
      rows: [
        if (h.investorCode?.isNotEmpty == true)
          FundLabeledValue(
            label: l.myPageResaleInvestorTypeLabel,
            value: h.investorCode!,
          ),
        if (h.earningRadio != null)
          FundLabeledValue(
            label: l.homeEstimatedYieldLabel,
            value:
                NumberFormat.decimalPercentPattern(
                  locale: Localizations.localeOf(context).toLanguageTag(),
                  decimalDigits: 2,
                ).format(
                  h.earningRadio!.abs() > 1
                      ? h.earningRadio! / 100
                      : h.earningRadio,
                ),
          ),
        FundLabeledValue(
          label: l.tradeInvestAmount,
          value: amount == null
              ? '—'
              : NumberFormat.currency(
                  locale: Localizations.localeOf(context).toLanguageTag(),
                  symbol: '¥',
                  decimalDigits: 0,
                ).format(amount),
        ),
        FundLabeledValue(
          label: l.myPageResaleAvailableUnitsLabel,
          value: '${h.availableNum} ${l.myPageResaleUnitsSuffix}',
        ),
      ],
      footer: AppButton(
        label: l.tradeSellApply,
        onPressed: h.processId.isEmpty || h.projectId.isEmpty
            ? null
            : () => context.push(
                '/my/secondary-market/sell',
                extra: MyPageSecondaryMarketSellSeed(
                  projectId: h.projectId,
                  projectName: h.projectName,
                  fromProcessId: h.processId,
                  availableUnits: h.availableNum,
                  initialUnitPrice: price,
                  investorCode: h.investorCode,
                  earningRatio: h.earningRadio,
                ),
              ),
      ),
    );
  }
}
