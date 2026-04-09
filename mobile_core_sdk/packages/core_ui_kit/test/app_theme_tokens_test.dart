import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supports the required JP, EN, SC, and TC content fonts', () {
    expect(AppTypographyTokens.supportedContentFamilies, const <String>[
      'Noto Sans JP',
      'Noto Sans SC',
      'Noto Sans TC',
    ]);
    expect(
      AppTypographyTokens.sansFamilyFallback,
      containsAll(<String>['Noto Sans JP', 'Noto Sans SC', 'Noto Sans TC']),
    );
    expect(
      AppTypographyTokens.sansFamilyFallback,
      isNot(contains('Noto Sans S Chinese')),
    );
  });

  test('light theme exposes semantic color and text themes', () {
    final theme = AppThemeFactory.light();
    final semanticColors = theme.extension<AppSemanticColorTheme>();
    final semanticText = theme.extension<AppSemanticTextTheme>();

    expect(semanticColors, isNotNull);
    expect(semanticText, isNotNull);
    expect(semanticColors!.brandPrimary, const Color(0xFF0C1C50));
    expect(semanticColors.primary, AppColorTokens.fundexAccent);
    expect(theme.textTheme.titleSmall, isNotNull);
    expect(theme.textTheme.labelSmall, isNotNull);
    expect(theme.textTheme.displayLarge, isNotNull);
    expect(
      semanticText!.numericHeadline.fontFamilyFallback,
      contains('DM Sans'),
    );
  });

  test('resolves locale-aware primary content families', () {
    expect(
      AppTypographyTokens.primaryContentFamilyForLocale(const Locale('ja')),
      'Noto Sans JP',
    );
    expect(
      AppTypographyTokens.primaryContentFamilyForLocale(const Locale('en')),
      'Noto Sans JP',
    );
    expect(
      AppTypographyTokens.primaryContentFamilyForLocale(const Locale('zh')),
      'Noto Sans SC',
    );
    expect(
      AppTypographyTokens.primaryContentFamilyForLocale(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      ),
      'Noto Sans TC',
    );
  });

  test('theme text styles use locale-specific primary families', () {
    final jaTheme = AppThemeFactory.light(locale: const Locale('ja'));
    final scTheme = AppThemeFactory.light(locale: const Locale('zh'));
    final tcTheme = AppThemeFactory.light(
      locale: const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    );

    expect(jaTheme.textTheme.titleLarge?.fontFamily, 'Noto Sans JP');
    expect(scTheme.textTheme.titleLarge?.fontFamily, 'Noto Sans SC');
    expect(tcTheme.textTheme.titleLarge?.fontFamily, 'Noto Sans TC');
    expect(
      jaTheme.extension<AppSemanticTextTheme>()?.pageTitle.fontFamily,
      'Noto Sans JP',
    );
  });
}
