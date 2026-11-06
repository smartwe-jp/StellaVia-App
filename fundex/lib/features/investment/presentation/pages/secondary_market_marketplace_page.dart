import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/secondary_market_controller.dart';
import '../widgets/secondary_market_refresh_scope.dart';
import '../widgets/secondary_market_marketplace_card.dart';

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
                  child: SecondaryMarketMarketplaceCard(
                    record: record,
                    onTap: () async {
                      await context.push(
                        '/home/free-market/${record.id}',
                        extra: record,
                      );
                      if (context.mounted) await controller.refresh();
                    },
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
