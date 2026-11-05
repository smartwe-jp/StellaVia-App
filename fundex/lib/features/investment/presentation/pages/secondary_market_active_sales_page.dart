import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/secondary_market_controller.dart';
import '../widgets/secondary_market_activity_cards.dart';
import '../widgets/secondary_market_refresh_scope.dart';

class SecondaryMarketActiveSalesPage extends ConsumerWidget {
  const SecondaryMarketActiveSalesPage({
    super.key,
    required this.projectId,
    required this.processId,
  });
  final String projectId, processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final provider = secondaryMarketActiveSalesProvider((
      projectId: projectId,
      processId: processId,
    ));
    final state = ref.watch(provider);
    Future<void> refresh() async {
      try {
        ref.invalidate(provider);
        await ref.read(provider.future);
      } catch (_) {
        // The provider exposes the failure while retaining the previous value.
      }
    }

    final rows = state.valueOrNull ?? [];
    return SecondaryMarketRefreshScope(
      onRefresh: refresh,
      child: Scaffold(
        appBar: AppNavigationBar(
          title: l.secondaryMarketActiveSalesTitle,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              if (state.isLoading) const LinearProgressIndicator(),
              if (state.hasError)
                ListTile(
                  title: Text(l.fundListLoadError),
                  trailing: TextButton(
                    onPressed: refresh,
                    child: Text(l.fundListRetry),
                  ),
                ),
              if (!state.isLoading && !state.hasError && rows.isEmpty)
                Text(l.secondaryMarketActiveSalesEmpty),
              for (final row in rows)
                SecondaryMarketListingCard(
                  record: row,
                  onTap: () async {
                    await context.push(
                      '/profile/my/secondary-market/sales/${Uri.encodeComponent(row.id!)}',
                    );
                    if (context.mounted) await refresh();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
