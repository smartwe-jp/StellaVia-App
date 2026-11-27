import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_miles_providers.dart';
import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';
import '../support/home_miles_display.dart';
import 'home_miles_card.dart';
import 'home_rank_teaser.dart';

class HomeMilesAccountSection extends ConsumerWidget {
  const HomeMilesAccountSection({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeMilesAccountProvider);
    final tier = ref.watch(myPageTierProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return HomeMilesCard(
      onTap: onTap,
      rank: tier.valueOrNull?.currentTier ?? '—',
      expiring: homeMilesBalance(state.data?.expiringSoonPoints, locale),
      balance: homeMilesBalance(state.data?.availablePoints, locale),
      hasBalance: state.data?.availablePoints != null,
      isLoading:
          state.isLoading ||
          (tier.isLoading &&
              ref.watch(myPageMembershipIdentityProvider) != null),
      hasError: state.hasError || tier.hasError,
      onRetry: () {
        ref.read(homeMilesAccountProvider.notifier).refresh();
        ref.read(myPageTierProvider.notifier).refresh();
      },
    );
  }
}

class HomeMilesRankSection extends ConsumerWidget {
  const HomeMilesRankSection({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeMilesRulesProvider);
    return HomeRankTeaser(
      onTap: onTap,
      names: homeRankNames(state.data),
      isLoading: state.isLoading,
      hasError: state.hasError,
      onRetry: () => ref.read(homeMilesRulesProvider.notifier).refresh(),
    );
  }
}
