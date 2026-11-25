import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import 'guest_guide_video_background.dart';

class GuestServiceVideoCard extends StatelessWidget {
  const GuestServiceVideoCard({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l = context.l10n;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 172),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Positioned.fill(
              child: GuestGuideVideoBackground(
                posterAsset: 'assets/images/home_service_about.png',
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.scrim.withValues(alpha: .13),
                      colors.scrim.withValues(alpha: .85),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.guestGuideMechanism,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.onDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.guestGuideSummary,
                    style: TextStyle(color: colors.onDark),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colors.onDark,
                      foregroundColor: AppColorTokens.brandPurple,
                      side: const BorderSide(color: AppColorTokens.brandPurple),
                      shape: const StadiumBorder(),
                      minimumSize: const Size.fromHeight(36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                    ),
                    onPressed: () => context.push('/home/service'),
                    child: Text(l.homeLearnService),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
