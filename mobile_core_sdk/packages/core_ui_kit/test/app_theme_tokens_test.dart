import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supports the required JP, EN, SC, and TC content fonts', () {
    expect(AppTypographyTokens.supportedContentFamilies, const <String>[
      'Zen Kaku Gothic Antique',
      'Jost',
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
    expect(semanticColors!.brandPrimary, const Color(0xFF4C0679));
    expect(semanticColors.primary, AppColorTokens.fundexAccent);
    expect(theme.textTheme.titleSmall, isNotNull);
    expect(theme.textTheme.labelSmall, isNotNull);
    expect(theme.textTheme.displayLarge, isNotNull);
    expect(
      semanticText!.numericHeadline.fontFamilyFallback,
      contains('Zen Kaku Gothic Antique'),
    );
  });

  test('resolves locale-aware primary content families', () {
    expect(
      AppTypographyTokens.primaryContentFamilyForLocale(const Locale('ja')),
      'Zen Kaku Gothic Antique',
    );
    expect(
      AppTypographyTokens.primaryContentFamilyForLocale(const Locale('en')),
      'Jost',
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

    expect(jaTheme.textTheme.titleLarge?.fontFamily, 'Zen Kaku Gothic Antique');
    expect(scTheme.textTheme.titleLarge?.fontFamily, 'Noto Sans SC');
    expect(tcTheme.textTheme.titleLarge?.fontFamily, 'Noto Sans TC');
    expect(
      jaTheme.extension<AppSemanticTextTheme>()?.pageTitle.fontFamily,
      'Zen Kaku Gothic Antique',
    );
  });
  for (final brightness in Brightness.values) {
    test('$brightness keeps body, links, and filled actions readable', () {
      final theme = brightness == Brightness.light
          ? AppThemeFactory.light()
          : AppThemeFactory.dark();
      final colors = theme.extension<AppSemanticColorTheme>()!;
      final text = theme.extension<AppSemanticTextTheme>()!;
      for (final surface in [
        colors.background,
        colors.surface,
        colors.surfaceAlt,
      ]) {
        for (final foreground in [
          colors.textPrimary,
          colors.textSecondary,
          colors.textTertiary,
          text.link.color!,
        ]) {
          expect(_contrast(foreground, surface), greaterThanOrEqualTo(4.5));
        }
      }
      expect(
        _contrast(theme.colorScheme.onPrimary, theme.colorScheme.primary),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(theme.colorScheme.onSecondary, theme.colorScheme.secondary),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(
          theme.colorScheme.onPrimaryContainer,
          theme.colorScheme.primaryContainer,
        ),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(colors.onDark, colors.primary),
        greaterThanOrEqualTo(4.5),
      );
      expect(theme.colorScheme.outline, colors.border);
      expect(theme.colorScheme.surfaceContainerHigh, colors.surfaceAlt);
      expect(theme.cupertinoOverrideTheme?.primaryColor, text.link.color);
    });
  }

  test('numeric styles retain Jost and locale fallback across themes', () {
    for (final locale in [
      const Locale('ja'),
      const Locale('en'),
      const Locale('zh'),
      const Locale('zh', 'TW'),
    ]) {
      for (final theme in [
        AppThemeFactory.light(locale: locale),
        AppThemeFactory.dark(locale: locale),
      ]) {
        final text = theme.extension<AppSemanticTextTheme>()!;
        expect(text.numericHeadline.fontFamily, 'Jost');
        expect(
          text.numericHeadline.fontFamilyFallback,
          contains(AppTypographyTokens.primaryContentFamilyForLocale(locale)),
        );
        expect(text.numericHeadline.fontWeight, FontWeight.w600);
      }
    }
  });

  test('status bar icons follow actual background brightness', () {
    for (final brightness in Brightness.values) {
      final style = AppThemeFactory.statusBarOverlayStyleFor(brightness);
      expect(
        style.statusBarIconBrightness,
        brightness == Brightness.light ? Brightness.dark : Brightness.light,
      );
    }
  });
}

double _contrast(Color foreground, Color background) {
  final fg = Color.alphaBlend(foreground, background).computeLuminance();
  final bg = background.computeLuminance();
  return (fg > bg ? fg + 0.05 : bg + 0.05) / (fg > bg ? bg + 0.05 : fg + 0.05);
}
