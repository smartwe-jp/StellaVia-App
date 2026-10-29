import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/mypage_membership_providers.dart';
import 'my_page_membership_card.dart';
import 'my_page_membership_rooms.dart';
import 'my_page_miles_expiry_sheet.dart';

class MyPageMembershipSection extends ConsumerWidget {
  const MyPageMembershipSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(myPageTierProvider);
    final account = ref.watch(myPageMilesAccountProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          MyPageMembershipCard(
            tier: tier.valueOrNull,
            account: account.valueOrNull,
            onRankTap: () => context.push('/home/ranks'),
          ),
          const SizedBox(height: 12),
          MyPageMembershipRooms(
            tier: tier.valueOrNull,
            account: account.valueOrNull,
            onExpiryTap: () => AppBottomSheet.showAdaptive(
              context: context,
              useRootNavigator: true,
              builder: (_) => const MyPageMilesExpirySheet(),
            ),
          ),
          if (tier.isLoading || account.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (tier.hasError || account.hasError)
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.myPageChartLoadFailed,
                    style: context.appTextTheme.caption,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (tier.hasError) {
                      ref.read(myPageTierProvider.notifier).refresh();
                    }
                    if (account.hasError) {
                      ref.read(myPageMilesAccountProvider.notifier).refresh();
                    }
                  },
                  child: Text(context.l10n.commonRetry),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
