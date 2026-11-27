import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HomeServiceFeaturesCard extends StatelessWidget {
  const HomeServiceFeaturesCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.appColors;
    final text = context.appTextTheme;
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: BoxConstraints(
          minHeight: constraints.maxWidth * 610 / 1074,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          image: const DecorationImage(
            image: AssetImage('assets/images/home_service_chalet.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.homeServiceAboutEyebrow,
                  style: text.pageTitle.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    ExcludeSemantics(
                      child: Text(
                        l.homeGuestBenefitsBody,
                        style: text.body.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..strokeJoin = StrokeJoin.round
                            ..color = AppColorTokens.brandWhite,
                        ),
                      ),
                    ),
                    Text(
                      l.homeGuestBenefitsBody,
                      style: text.body.copyWith(
                        color: AppColorTokens.travelOverlayBlackSoft,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: AppButton(
                  label: l.bannerFeatures,
                  variant: AppButtonVariant.secondary,
                  fullWidth: false,
                  minHeight: UiTokens.controlHeight * 0.7,
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: AppColorTokens.brandWhite,
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
