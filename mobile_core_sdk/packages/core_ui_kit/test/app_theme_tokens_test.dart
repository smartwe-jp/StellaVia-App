import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supports the required JP, EN, SC, and TC content fonts', () {
    expect(
      AppTypographyTokens.supportedContentFamilies,
      const <String>['Noto Sans JP', 'Noto Sans SC', 'Noto Sans TC'],
    );
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
    expect(semanticColors!.brandPrimary, const Color(0xFF066FC9));
    expect(semanticColors.primary, AppColorTokens.fundexAccent);
    expect(theme.textTheme.titleSmall, isNotNull);
    expect(theme.textTheme.labelSmall, isNotNull);
    expect(theme.textTheme.displayLarge, isNotNull);
    expect(
        semanticText!.numericHeadline.fontFamilyFallback, contains('DM Sans'));
  });
}
