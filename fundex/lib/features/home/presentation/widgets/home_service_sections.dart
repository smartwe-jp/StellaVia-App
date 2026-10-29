import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_text_styles.dart';

class HomeServiceAboutSection extends StatelessWidget {
  const HomeServiceAboutSection({super.key});
  @override
  Widget build(BuildContext context) => _Section(
    children: [
      AppBrandHeading(
        eyebrow: context.l10n.homeServiceAboutEyebrow,
        title: context.l10n.homeServiceAboutTitle,
      ),
      Text(
        context.l10n.homeServiceAboutBody,
        style: HomeTextStyles.readingBody(context),
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/home_service_about.png',
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

class HomeServiceReturnsSection extends StatelessWidget {
  const HomeServiceReturnsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _Section(
      children: [
        AppBrandHeading(
          eyebrow: l.homeServiceReturnsEyebrow,
          title: l.homeServiceReturnsTitle,
        ),
        _ReturnCard(
          eyebrow: l.homeServiceFutureEyebrow,
          englishTitle: l.homeServiceFinancialEyebrow,
          title: l.homeServiceFinancialTitle,
          body: l.homeServiceFinancialBody,
          inverse: true,
        ),
        _ReturnCard(
          eyebrow: l.homeServiceNowEyebrow,
          englishTitle: l.homeServiceExperienceEyebrow,
          title: l.homeServiceExperienceTitle,
          body: l.homeServiceExperienceBody,
        ),
      ],
    );
  }
}

class _ReturnCard extends StatelessWidget {
  const _ReturnCard({
    required this.eyebrow,
    required this.englishTitle,
    required this.title,
    required this.body,
    this.inverse = false,
  });
  final String eyebrow, englishTitle, title, body;
  final bool inverse;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextTheme;
    final foreground = inverse ? colors.onDark : colors.textPrimary;
    return SizedBox(
      width: double.infinity,
      child: AppCard(
        variant: AppCardVariant.filled,
        backgroundColor: inverse ? colors.brandPrimaryDark : colors.surfaceAlt,
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              eyebrow,
              style: HomeTextStyles.returnEyebrow(context).copyWith(
                color: inverse ? colors.brandPrimaryBright : text.link.color,
              ),
            ),
            Text(
              englishTitle,
              style: HomeTextStyles.rankName(
                context,
              ).copyWith(color: inverse ? foreground : text.link.color),
            ),
            Text(
              title,
              style: HomeTextStyles.returnTitle(
                context,
              ).copyWith(color: foreground),
            ),
            Text(
              body,
              style: HomeTextStyles.readingBody(
                context,
              ).copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeServiceStartSection extends StatelessWidget {
  const HomeServiceStartSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [
      (l.homeRegisterFree, l.homeServiceStep1Body),
      (l.homeServiceStep2Title, l.homeServiceStep2Body),
      (l.homeServiceStep3Title, l.homeServiceStep3Body),
      (l.homeServiceStep4Title, l.homeServiceStep4Body),
    ];
    return _Section(
      inverse: true,
      children: [
        AppBrandHeading(
          eyebrow: l.homeServiceStartEyebrow,
          title: l.homeServiceStartTitle,
          inverse: true,
        ),
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '0${i + 1}',
                style: HomeTextStyles.stepNumber(context).copyWith(
                  color: context.appColors.onDark.withValues(alpha: .8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[i].$1,
                      style: HomeTextStyles.stepTitle(
                        context,
                      ).copyWith(color: context.appColors.onDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[i].$2,
                      style: HomeTextStyles.stepDescription(
                        context,
                      ).copyWith(color: context.appColors.onDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Text(
          l.homeServiceMemberNote,
          style: HomeTextStyles.stepDescription(
            context,
          ).copyWith(color: context.appColors.onDark),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.children, this.inverse = false});
  final List<Widget> children;
  final bool inverse;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: inverse ? context.appColors.brandPrimary : context.appColors.surface,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: children,
      ),
    ),
  );
}
