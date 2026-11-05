import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/secondary_market_controller.dart';
import '../widgets/secondary_market_activity_cards.dart';
import '../widgets/secondary_market_refresh_scope.dart';

class SecondaryMarketActivityPage extends ConsumerStatefulWidget {
  const SecondaryMarketActivityPage({super.key, this.initialPurchases = false});
  final bool initialPurchases;
  @override
  ConsumerState<SecondaryMarketActivityPage> createState() =>
      _SecondaryMarketActivityPageState();
}

class _SecondaryMarketActivityPageState
    extends ConsumerState<SecondaryMarketActivityPage> {
  late SecondaryMarketListKind kind = widget.initialPurchases
      ? SecondaryMarketListKind.purchases
      : SecondaryMarketListKind.sales;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(secondaryMarketControllerProvider(kind));
    final controller = ref.read(
      secondaryMarketControllerProvider(kind).notifier,
    );
    return SecondaryMarketRefreshScope(
      onRefresh: () => controller.refresh(),
      child: Scaffold(
        appBar: AppNavigationBar(
          title: l.secondaryMarketManage,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back,
            onTap: () =>
                context.canPop() ? context.pop() : context.go('/profile/my'),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<SecondaryMarketListKind>(
                segments: [
                  ButtonSegment(
                    value: SecondaryMarketListKind.purchases,
                    label: Text(l.secondaryMarketPurchases),
                  ),
                  ButtonSegment(
                    value: SecondaryMarketListKind.sales,
                    label: Text(l.secondaryMarketSales),
                  ),
                ],
                selected: {kind},
                onSelectionChanged: (value) =>
                    setState(() => kind = value.single),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (state.error != null)
                      ListTile(
                        title: Text(l.fundListLoadError),
                        trailing: TextButton(
                          onPressed: controller.refresh,
                          child: Text(l.fundListRetry),
                        ),
                      ),
                    if (state.loading) const LinearProgressIndicator(),
                    if (!state.loading &&
                        state.error == null &&
                        state.orders.isEmpty &&
                        state.applications.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(l.secondaryMarketNoApplications),
                      ),
                    for (final record in state.applications)
                      SecondaryMarketApplicationCard(
                        record: record,
                        onTap: record.processId == null
                            ? null
                            : () async {
                                await context.push(
                                  '/profile/my/secondary-market/purchases/${Uri.encodeComponent(record.processId!)}',
                                );
                                if (mounted) {
                                  ref
                                      .read(
                                        secondaryMarketControllerProvider(
                                          kind,
                                        ).notifier,
                                      )
                                      .refresh();
                                }
                              },
                      ),
                    for (final record in state.orders)
                      SecondaryMarketListingCard(
                        record: record,
                        onTap: record.id == null
                            ? null
                            : () async {
                                await context.push(
                                  '/profile/my/secondary-market/sales/${Uri.encodeComponent(record.id!)}',
                                );
                                if (mounted) {
                                  ref
                                      .read(
                                        secondaryMarketControllerProvider(
                                          kind,
                                        ).notifier,
                                      )
                                      .refresh();
                                }
                              },
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
          ],
        ),
      ),
    );
  }
}
