import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import 'home_service_video.dart';

class HomeFeaturesIntro extends StatelessWidget {
  const HomeFeaturesIntro({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.appTextTheme;
    return ColoredBox(
      color: context.appColors.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
        child: Column(
          children: [
            AppBrandHeading(
              eyebrow: l.homeServiceAboutEyebrow,
              title: l.homeServiceAboutTitle,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                l.homeServiceAboutBody,
                textAlign: TextAlign.justify,
                style: t.body.copyWith(fontSize: 14, height: 1.9),
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: const HomeServiceVideo(),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeFeaturesSteps extends StatelessWidget {
  const HomeFeaturesSteps({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [
      ('register', l.homeServiceStep1Title, l.homeServiceStep1Body),
      ('fund', l.homeServiceStep2Title, l.homeServiceStep2Body),
      ('miles', l.homeServiceStep3Title, l.homeServiceStep3Body),
      ('stay', l.homeServiceStep4Title, l.homeServiceStep4Body),
    ];
    final text = context.appTextTheme;
    const ink = AppColorTokens.brandWhite;
    return Container(
      color: AppColorTokens.brandPurple,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        children: [
          AppBrandHeading(
            eyebrow: l.homeServiceStartEyebrow,
            title: l.homeServiceStartTitle,
            inverse: true,
          ),
          for (final (i, step) in steps.indexed)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/feature_${step.$1}.svg',
                          width: 38,
                          height: 38,
                          colorFilter: const ColorFilter.mode(
                            ink,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '0${i + 1}',
                                style: text.caption.copyWith(color: ink),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  step.$2,
                                  style: text.bodyStrong.copyWith(
                                    color: ink,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            step.$3,
                            style: text.caption.copyWith(
                              color: ink.withValues(alpha: .85),
                              height: 1.8,
                            ),
                          ),
                        ],
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
