import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../controllers/trade_management_provider.dart';
import '../widgets/secondary_market_refresh_scope.dart';
import '../widgets/trade_management_list.dart';

enum _Section { sell, buy, history }

class SecondaryMarketActivityPage extends ConsumerWidget {
  const SecondaryMarketActivityPage({
    super.key,
    this.initialPurchases = false,
    this.initialSalesHistory = false,
  });
  final bool initialPurchases, initialSalesHistory;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppNavigationBar(
      title: context.l10n.secondaryMarketManage,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        onTap: () => context.canPop() ? context.pop() : context.go('/profile'),
      ),
    ),
    body: SafeArea(
      top: false,
      child: _Sections(
        key: ValueKey((
          ref.watch(myPageMembershipIdentityProvider),
          initialPurchases,
          initialSalesHistory,
        )),
        history: initialPurchases || initialSalesHistory,
        purchases: initialPurchases,
      ),
    ),
  );
}

class _Sections extends ConsumerStatefulWidget {
  const _Sections({super.key, required this.history, required this.purchases});
  final bool history, purchases;
  @override
  ConsumerState<_Sections> createState() => _SectionsState();
}

class _SectionsState extends ConsumerState<_Sections> {
  late _Section section = widget.history ? _Section.history : _Section.sell;
  late TradeList history = widget.purchases
      ? TradeList.purchaseHistory
      : TradeList.salesHistory;
  int page = 1;
  TradeList get list => switch (section) {
    _Section.sell => TradeList.sell,
    _Section.buy => TradeList.buy,
    _Section.history => history,
  };
  Future<void> refresh() async {
    final provider = tradePageProvider((list: list, page: page));
    if (list == TradeList.sell) ref.invalidate(secondaryMarketHoldingsProvider);
    await ref
        .refresh(provider.future)
        .then<void>((_) {}, onError: (Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(tradePageProvider((list: list, page: page)));
    return SecondaryMarketRefreshScope(
      onRefresh: refresh,
      child: Column(
        children: [
          AppFilterBar<_Section>(
            value: section,
            height: 54,
            backgroundColor: context.appColors.surface,
            items: [
              AppFilterBarItem(value: _Section.sell, label: l.tradeTabSell),
              AppFilterBarItem(value: _Section.buy, label: l.tradeTabBuy),
              AppFilterBarItem(
                value: _Section.history,
                label: l.tradeTabHistory,
              ),
            ],
            onChanged: (s) => setState(() {
              section = s;
              page = 1;
            }),
          ),
          if (section == _Section.history)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: AppDualSegmentedControl<TradeList>(
                height: 34,
                radius: 12,
                style: AppSegmentedControlStyle(
                  shadows: const [],
                  itemPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  selectedBackgroundColor: context.appColors.surface,
                ),
                value: history,
                first: AppDualSegmentItem(
                  value: TradeList.salesHistory,
                  label: l.tradeSubSell,
                ),
                second: AppDualSegmentItem(
                  value: TradeList.purchaseHistory,
                  label: l.tradeSubBuy,
                ),
                onChanged: (value) => setState(() {
                  history = value;
                  page = 1;
                }),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                key: ValueKey((list, page)),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (state.isLoading) const LinearProgressIndicator(),
                  if (state.hasError)
                    ListTile(
                      title: Text(l.fundListLoadError),
                      trailing: TextButton(
                        onPressed: refresh,
                        child: Text(l.commonRetry),
                      ),
                    ),
                  if (state.valueOrNull case final data?)
                    TradeManagementList(
                      data: data,
                      list: list,
                      page: page,
                      onPage: (value) => setState(() => page = value),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
