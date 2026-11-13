import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_text_styles.dart';
import 'home_rank_progression.dart';

class HomeBrandIntro extends StatelessWidget {
  const HomeBrandIntro({
    super.key,
    required this.onServiceTap,
    required this.ranks,
  });
  final List<String> ranks;
  final VoidCallback onServiceTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.heroStart,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeGuestEyebrow,
                  style: HomeTextStyles.heroEyebrow(
                    context,
                    isAuthenticated: false,
                  ).copyWith(color: colors.onDark),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeGuestBenefitsTitle,
                  style: HomeTextStyles.heroTitle(
                    context,
                  ).copyWith(color: colors.onDark),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeRankTitle,
                  style: HomeTextStyles.caption(
                    context,
                  ).copyWith(color: colors.onDark),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  if (ranks.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: HomeRankProgression(names: ranks),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 8,
                      bottom: 0,
                    ),
                    child: AppButton(
                      label: l10n.homeLearnService,
                      fullWidth: false,
                      minHeight: 34,
                      variant: AppButtonVariant.secondary,
                      onPressed: onServiceTap,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: colors.onDark,
                        foregroundColor: AppColorTokens.brandPurple,
                        side: const BorderSide(
                          color: AppColorTokens.brandPurple,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        textStyle: context.appTextTheme.micro,
                      ),
                    ),
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
