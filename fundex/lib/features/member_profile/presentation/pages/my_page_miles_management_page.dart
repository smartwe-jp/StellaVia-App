import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/miles_management_providers.dart';
import '../providers/mypage_chart_providers.dart';
import '../providers/mypage_membership_providers.dart';
import '../widgets/my_page_miles_expiry_sheet.dart';
import '../widgets/my_page_summary_charts.dart';
import '../widgets/my_page_summary_rank_card.dart';
import '../widgets/miles_management_panels.dart';

class MyPageMilesManagementPage extends ConsumerWidget {
  const MyPageMilesManagementPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppNavigationBar(
      title: context.l10n.myPageShortcutMiles,
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.textPrimary,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        foregroundColor: context.appColors.textPrimary,
        backgroundColor: context.appColors.surface,
        onTap: () => context.pop(),
      ),
    ),
    body: _MilesBody(
      key: ValueKey(ref.watch(myPageMembershipIdentityProvider)),
    ),
  );
}

class _MilesBody extends ConsumerStatefulWidget {
  const _MilesBody({super.key});
  @override
  ConsumerState<_MilesBody> createState() => _MilesBodyState();
}

class _MilesBodyState extends ConsumerState<_MilesBody> {
  int years = 1;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now(), month = DateTime(now.year, now.month);
    final tier = ref.watch(myPageTierProvider);
    final expiry = ref.watch(myPageMilesExpiryProvider);
    final daily = ref.watch(myPageChartProvider(MyPageChartKind.miles));
    final provider = cumulativeMilesProvider((month: month, years: years));
    final cumulative = ref.watch(provider);
    final total =
        cumulative.asData?.value.total ??
        tier.asData?.value.cumulativeMiles ??
        tier.asData?.value.pointsBalance ??
        daily.data.valueOrNull?.total;
    final alerts = expiry.asData?.value;
    final expiryTotal =
        alerts == null || alerts.any((row) => row.amount == null)
        ? null
        : alerts.fold<num>(0, (sum, item) => sum + item.amount!);
    return RefreshIndicator(
      onRefresh: () async {
        if (shouldSkipAppNetworkRefresh(ref)) return;

        await Future.wait<void>([
          ref
              .refresh(myPageMilesExpiryProvider.future)
              .then<void>((_) {}, onError: (Object _) {}),
          ref
              .refresh(provider.future)
              .then<void>((_) {}, onError: (Object _) {}),
          for (final offset in [-1, 0, 1])
            ref
                .refresh(
                  monthlyMilesProvider((
                    month: DateTime(month.year, month.month + offset),
                    expected: offset == 1,
                  )).future,
                )
                .then<void>((_) {}, onError: (Object _) {}),
          ref.read(myPageTierProvider.notifier).refresh(),
          ref
              .read(myPageChartProvider(MyPageChartKind.miles).notifier)
              .refresh(),
        ]);
        if (mounted) setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          MyPageSummaryRankCard(
            tier: tier.asData?.value,
            account: null,
            management: true,
            cumulativeMiles: total,
            expiringMiles: expiryTotal,
            onRankTap: () => context.push('/home/ranks'),
            onExpiryTap: () => AppBottomSheet.showAdaptive(
              context: context,
              useRootNavigator: true,
              builder: (_) => const MyPageMilesExpirySheet(),
            ),
          ),
          if (tier.isLoading || expiry.isLoading)
            const LinearProgressIndicator(),
          if (tier.hasError || expiry.hasError)
            TextButton(
              child: Text(context.l10n.commonRetry),
              onPressed: () {
                if (tier.hasError) {
                  ref.read(myPageTierProvider.notifier).refresh();
                }
                if (expiry.hasError) ref.invalidate(myPageMilesExpiryProvider);
              },
            ),
          const SizedBox(height: 12),
          const MyPageSummaryChartCard(kind: MyPageChartKind.miles),
          for (final offset in [-1, 0, 1]) ...[
            const SizedBox(height: 12),
            MonthlyMilesCard(month: month, offset: offset),
          ],
          const SizedBox(height: 12),
          CumulativeMilesCard(
            state: cumulative,
            total: total,
            years: years,
            onYears: (y) => setState(() => years = y),
            onRetry: () => ref.invalidate(provider),
          ),
        ],
      ),
    );
  }
}
