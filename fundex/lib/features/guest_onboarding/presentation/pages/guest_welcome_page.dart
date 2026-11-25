import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/guest_welcome_hero.dart';
import '../widgets/guest_welcome_header.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../widgets/guest_guide_video_background.dart';

class GuestWelcomePage extends StatelessWidget {
  const GuestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.appColors;
    final white = colors.onDark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colors.surface.withValues(alpha: 0),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const GuestGuideVideoBackground(
              posterAsset: 'assets/images/guest_welcome_poster.jpg',
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, .32, .58, 1],
                  colors: [
                    AppColorTokens.brandNavy.withValues(alpha: .08),
                    AppColorTokens.brandNavy.withValues(alpha: .03),
                    AppColorTokens.brandNavy.withValues(alpha: .265),
                    AppColorTokens.brandNavy.withValues(alpha: .425),
                  ],
                ),
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const GuestWelcomeHeader(),
                        const Spacer(flex: 2),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: GuestWelcomeHero(),
                        ),
                        const Spacer(),
                        Text(
                          l.guestGuideTagline,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: white,
                                fontFamily: 'Jost',
                                fontSize: 15,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 1,
                          height: 28,
                          child: ColoredBox(color: white),
                        ),
                      ],
                    ),
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
