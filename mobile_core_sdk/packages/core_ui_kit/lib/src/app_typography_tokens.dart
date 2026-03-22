import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

class AppTypographyTokens {
  const AppTypographyTokens._();

  // Product requirement:
  // - Japanese + English: Noto Sans JP
  // - Simplified Chinese: Noto Sans SC
  // - Traditional Chinese: Noto Sans TC
  static const List<String> supportedContentFamilies = <String>[
    'Noto Sans JP',
    'Noto Sans SC',
    'Noto Sans TC',
  ];

  // Platform-specific fallbacks keep glyph coverage stable when the preferred
  // Noto families are unavailable on the device.
  static const List<String> platformSansFallbackFamilies = <String>[
    'Noto Sans CJK JP',
    'Noto Sans CJK SC',
    'Noto Sans CJK TC',
    'PingFang SC',
    'PingFang TC',
    'Hiragino Sans',
    'Hiragino Kaku Gothic ProN',
    'Microsoft YaHei',
    'Microsoft JhengHei',
    '.SF Pro Text',
    '.SF Pro Display',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static const List<String> sansFamilyFallback = <String>[
    ...supportedContentFamilies,
    ...platformSansFallbackFamilies,
  ];

  static const List<String> numericFamilyFallback = <String>[
    'DM Sans',
    '.SF Pro Display',
    '.SF Pro Text',
    'Inter',
    'Roboto',
    ...supportedContentFamilies,
    'Arial',
    'sans-serif',
  ];

  // Preserve the old public name for compatibility with existing imports.
  static const List<String> fallbackFamily = sansFamilyFallback;

  static String primaryContentFamilyForLocale(Locale? locale) {
    if (locale == null) {
      return supportedContentFamilies.first;
    }

    final languageCode = locale.languageCode.toLowerCase();
    final scriptCode = locale.scriptCode?.toLowerCase();
    final countryCode = locale.countryCode?.toUpperCase();

    if (languageCode == 'zh') {
      if (scriptCode == 'hant' ||
          countryCode == 'TW' ||
          countryCode == 'HK' ||
          countryCode == 'MO') {
        return 'Noto Sans TC';
      }
      return 'Noto Sans SC';
    }

    // Product requirement uses Noto Sans JP for both Japanese and English UI.
    return 'Noto Sans JP';
  }

  static TextStyle sansStyle({
    required double size,
    required FontWeight weight,
    required Color color,
    Locale? locale,
    double? height,
    double? letterSpacing,
  }) {
    return _baseStyle(
      size: size,
      weight: weight,
      color: color,
      fontFamily: primaryContentFamilyForLocale(locale),
      height: height,
      letterSpacing: letterSpacing,
      fontFamilyFallback: sansFamilyFallback,
    );
  }

  static TextStyle numericStyle({
    required double size,
    required FontWeight weight,
    required Color color,
    Locale? locale,
    double? height,
    double? letterSpacing,
  }) {
    return _baseStyle(
      size: size,
      weight: weight,
      color: color,
      fontFamily: primaryContentFamilyForLocale(locale),
      height: height,
      letterSpacing: letterSpacing,
      fontFamilyFallback: numericFamilyFallback,
    );
  }

  static TextStyle _baseStyle({
    required double size,
    required FontWeight weight,
    required Color color,
    required String fontFamily,
    required List<String> fontFamilyFallback,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextTheme textTheme(Brightness brightness, {Locale? locale}) {
    final isDark = brightness == Brightness.dark;
    final onSurface = isDark
        ? AppColorTokens.darkOnSurface
        : AppColorTokens.lightOnSurface;
    final muted = isDark ? AppColorTokens.darkMuted : AppColorTokens.lightMuted;

    return TextTheme(
      displayLarge: numericStyle(
        size: 44,
        weight: FontWeight.w900,
        color: onSurface,
        locale: locale,
        height: 1.04,
      ),
      displayMedium: numericStyle(
        size: 32,
        weight: FontWeight.w900,
        color: onSurface,
        locale: locale,
        height: 1.08,
      ),
      displaySmall: sansStyle(
        size: 24,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.16,
      ),
      headlineLarge: sansStyle(
        size: 28,
        weight: FontWeight.w800,
        color: onSurface,
        locale: locale,
        height: 1.14,
      ),
      headlineMedium: sansStyle(
        size: 24,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.2,
      ),
      headlineSmall: sansStyle(
        size: 20,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.24,
      ),
      titleLarge: sansStyle(
        size: 18,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.28,
      ),
      titleMedium: sansStyle(
        size: 16,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.3,
      ),
      titleSmall: sansStyle(
        size: 14,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.32,
      ),
      bodyLarge: sansStyle(
        size: 16,
        weight: FontWeight.w400,
        color: onSurface,
        locale: locale,
        height: 1.5,
      ),
      bodyMedium: sansStyle(
        size: 14,
        weight: FontWeight.w400,
        color: onSurface,
        locale: locale,
        height: 1.5,
      ),
      bodySmall: sansStyle(
        size: 12,
        weight: FontWeight.w400,
        color: muted,
        locale: locale,
        height: 1.5,
      ),
      labelLarge: sansStyle(
        size: 15,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.2,
        letterSpacing: 0.1,
      ),
      labelMedium: sansStyle(
        size: 12,
        weight: FontWeight.w700,
        color: onSurface,
        locale: locale,
        height: 1.2,
        letterSpacing: 0.2,
      ),
      labelSmall: sansStyle(
        size: 10,
        weight: FontWeight.w600,
        color: muted,
        locale: locale,
        height: 1.2,
        letterSpacing: 0.2,
      ),
    );
  }
}
