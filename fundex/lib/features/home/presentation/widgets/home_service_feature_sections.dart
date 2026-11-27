import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';

import 'home_returns_comparison.dart';

class HomeServiceFeatureSections extends StatelessWidget {
  const HomeServiceFeatureSections({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        const HomeReturnsComparison(),
        _FeatureGroup(
          eyebrow: l.homeServiceFutureEyebrow,
          title: l.homeServiceFinancialTitle,
          dark: true,
          kicker: l.featuresInvestmentKicker,
          items: [
            ('building', l.featuresFuture1Title, l.featuresFuture1Body),
            ('sprout', l.featuresFuture2Title, l.featuresFuture2Body),
            ('swap', l.featuresFuture3Title, l.featuresFuture3Body),
          ],
          note: l.featuresFutureNote,
        ),
        _FeatureGroup(
          eyebrow: l.homeServiceNowEyebrow,
          title: l.homeServiceExperienceTitle,
          kicker: l.featuresStayKicker,
          items: [
            ('coins', l.featuresNow1Title, l.featuresNow1Body),
            ('plane', l.featuresNow2Title, l.featuresNow2Body),
            ('bed', l.featuresNow3Title, l.featuresNow3Body),
          ],
          note: l.featuresNowNote,
        ),
      ],
    );
  }
}

class _FeatureGroup extends StatelessWidget {
  const _FeatureGroup({
    required this.eyebrow,
    required this.title,
    required this.items,
    required this.note,
    required this.kicker,
    this.dark = false,
  });
  final bool dark;
  final String eyebrow, title, note, kicker;
  final List<(String, String, String)> items;

  @override
  Widget build(BuildContext context) {
    final text = context.appTextTheme;
    final ink = dark ? AppColorTokens.brandWhite : AppColorTokens.brandNavy;
    final accent = dark
        ? AppColorTokens.brandLilac
        : AppColorTokens.brandViolet;
    return Container(
      width: double.infinity,
      color: dark ? AppColorTokens.brandNavy : AppColorTokens.brandBaseCream,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 64),
      child: Column(
        children: [
          AppBrandHeading(eyebrow: eyebrow, title: title, inverse: dark),
          const SizedBox(height: 12),
          Text(
            kicker,
            textAlign: TextAlign.center,
            style: AppTypographyTokens.numericStyle(
              size: 18,
              weight: FontWeight.w500,
              color: accent,
              letterSpacing: 2,
            ),
          ),
          for (final (index, item) in items.indexed) ...[
            const SizedBox(height: 40),
            SvgPicture.asset(
              'assets/images/feature_${item.$1}.svg',
              width: 36,
              height: 36,
              colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
            ),
            const SizedBox(height: 16),
            Text(
              '0${index + 1}',
              style: AppTypographyTokens.numericStyle(
                size: 18,
                weight: FontWeight.w500,
                color: accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.$2,
              textAlign: TextAlign.center,
              style: text.sectionTitle.copyWith(
                color: ink,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                item.$3,
                textAlign: TextAlign.center,
                style: text.body.copyWith(
                  color: ink.withValues(alpha: .88),
                  fontSize: 13,
                  height: 2,
                ),
              ),
            ),
          ],
          const SizedBox(height: 48),
          Text(
            note,
            style: text.caption.copyWith(
              color: ink.withValues(alpha: .72),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
