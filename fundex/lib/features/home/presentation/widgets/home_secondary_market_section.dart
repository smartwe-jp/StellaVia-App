import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../investment/presentation/controllers/secondary_market_controller.dart';
import '../../../investment/presentation/widgets/secondary_market_marketplace_card.dart';

class HomeSecondaryMarketSection extends ConsumerWidget {
  const HomeSecondaryMarketSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final provider = secondaryMarketControllerProvider(
      SecondaryMarketListKind.market,
    );
    final state = ref.watch(provider);
    Future<void> open(String path, {Object? extra}) async {
      await context.push(path, extra: extra);
      if (context.mounted) await ref.read(provider.notifier).refresh();
    }

    final rows = state.orders.take(4).toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rows.isNotEmpty)
          FundFeaturedFundCarousel(
            title: l.homeFreeMarketTitle,
            actionLabel: l.homeViewAllAction,
            onActionTap: () => open('/home/free-market'),
            children: [
              for (final row in rows)
                SecondaryMarketMarketplaceCard(
                  record: row,
                  width: 320,
                  onTap: () => open('/home/free-market/${row.id}', extra: row),
                ),
            ],
          )
        else ...[
          FundSectionHeader(
            title: l.homeFreeMarketTitle,
            actionLabel: l.homeViewAllAction,
            onActionTap: () => open('/home/free-market'),
          ),
          if (!state.loading && state.error == null)
            Text(l.homeFreeMarketEmptyState),
        ],
        if (state.loading) const LinearProgressIndicator(),
        if (state.error != null)
          ListTile(
            title: Text(l.secondaryMarketListLoadError),
            trailing: TextButton(
              onPressed: ref.read(provider.notifier).refresh,
              child: Text(l.fundListRetry),
            ),
          ),
      ],
    );
  }
}
