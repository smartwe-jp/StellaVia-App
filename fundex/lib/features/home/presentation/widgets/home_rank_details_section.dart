import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_miles_providers.dart';
import 'home_data_status.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_rank_content.dart';
import 'home_rank_detail_card.dart';
import '../support/home_text_styles.dart';

class HomeRankDetailsSection extends ConsumerWidget {
  const HomeRankDetailsSection({super.key, this.onDetails});
  final VoidCallback? onDetails;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(homeRankDetailsRulesProvider);
    final ranks = homeRankContent(
      l,
      state.data ?? const [],
      Localizations.localeOf(context).toLanguageTag(),
    );
    return ColoredBox(
      color: context.appColors.brandPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            AppBrandHeading(
              eyebrow: l.homeRankEyebrow,
              title: l.homeRankDetailTitle,
              inverse: true,
            ),
            Text(
              l.homeRankDetailBody,
              style: HomeTextStyles.readingBody(
                context,
              ).copyWith(color: context.appColors.onDark),
            ),
            if (state.isLoading || state.hasError)
              AppCard(
                child: HomeDataStatus(
                  isLoading: state.isLoading,
                  hasError: state.hasError,
                  onRetry: () =>
                      ref.read(homeRankDetailsRulesProvider.notifier).refresh(),
                ),
              ),
            if (!state.isLoading && !state.hasError && ranks.isEmpty)
              Text(
                l.homeRankRulesEmpty,
                style: context.appTextTheme.body.copyWith(
                  color: context.appColors.onDark,
                ),
              ),
            Column(
              spacing: 20,
              children: [
                for (var i = 0; i < ranks.length; i++)
                  HomeRankDetailCard(
                    key: ValueKey('rank-${ranks[i].name}'),
                    rank: ranks[i],
                    index: i,
                  ),
              ],
            ),
            if (onDetails != null)
              AppButton(
                label: l.homeRankDetails,
                onPressed: onDetails,
                variant: AppButtonVariant.secondary,
                style: OutlinedButton.styleFrom(
                  backgroundColor: context.appColors.surface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
