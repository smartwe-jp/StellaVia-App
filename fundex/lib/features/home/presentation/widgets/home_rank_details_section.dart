import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_rank_content.dart';
import 'home_rank_detail_card.dart';

class HomeRankDetailsSection extends StatelessWidget {
  const HomeRankDetailsSection({super.key, this.onDetails});
  final VoidCallback? onDetails;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ranks = homeRankContent(l);
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
              style: context.appTextTheme.body.copyWith(
                color: context.appColors.onDark,
                fontSize: 15,
                height: 2,
              ),
            ),
            Text(
              l.homeRankDraftNotice,
              style: context.appTextTheme.caption.copyWith(
                color: context.appColors.onDark,
                fontSize: 12,
                height: 5 / 3,
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
