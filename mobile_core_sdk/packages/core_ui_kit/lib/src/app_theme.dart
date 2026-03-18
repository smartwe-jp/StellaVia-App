import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color_tokens.dart';
import 'app_theme_extensions.dart';
import 'app_typography_tokens.dart';
import 'ui_tokens.dart';

class AppThemeFactory {
  const AppThemeFactory._();

  static ThemeData light() {
    return _build(Brightness.light);
  }

  static ThemeData dark() {
    return _build(Brightness.dark);
  }

  static Color statusBarColorFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppColorTokens.statusBarBackgroundDark
        : AppColorTokens.statusBarBackgroundLight;
  }

  static SystemUiOverlayStyle statusBarOverlayStyleFor(Brightness brightness) {
    final backgroundColor = statusBarColorFor(brightness);
    final backgroundBrightness = ThemeData.estimateBrightnessForColor(
      backgroundColor,
    );
    final foregroundBrightness = backgroundBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarIconBrightness: foregroundBrightness,
      statusBarBrightness: backgroundBrightness,
    );
  }

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background =
        isDark ? AppColorTokens.darkBackground : AppColorTokens.lightBackground;
    final surface =
        isDark ? AppColorTokens.darkSurface : AppColorTokens.lightSurface;
    final onSurface =
        isDark ? AppColorTokens.darkOnSurface : AppColorTokens.lightOnSurface;
    final outline =
        isDark ? AppColorTokens.darkBorder : AppColorTokens.lightBorder;
    final textTheme = AppTypographyTokens.textTheme(brightness);
    final contentMuted = onSurface.withValues(alpha: 0.72);
    final semanticColors = AppSemanticColorTheme(
      brandPrimary: AppColorTokens.brandPrimary,
      brandPrimaryDark: AppColorTokens.brandPrimaryDark,
      brandPrimaryBright: AppColorTokens.brandPrimaryBright,
      brandSecondary: AppColorTokens.brandSecondaryTeal,
      brandAlert: AppColorTokens.brandAlert,
      brandNeutral: AppColorTokens.brandNeutral,
      brandWhite: AppColorTokens.brandWhite,
      primary: AppColorTokens.fundexAccent,
      primaryAlt: AppColorTokens.fundexAccentAlt,
      primarySoft: AppColorTokens.fundexAccentLight,
      primarySubtle: AppColorTokens.fundexAccentSuperLight,
      success: AppColorTokens.fundexSuccess,
      successSubtle: AppColorTokens.fundexSuccessLight,
      successSoft: AppColorTokens.successSoft,
      successBorder: AppColorTokens.successBorder,
      successForeground: AppColorTokens.successStrong,
      warning: AppColorTokens.fundexWarning,
      warningSubtle: AppColorTokens.fundexWarningLight,
      warningSoft: AppColorTokens.warningSoft,
      warningBorder: AppColorTokens.warningBorder,
      warningForeground: AppColorTokens.warningStrong,
      warningAction: AppColorTokens.warningAction,
      danger: AppColorTokens.fundexDanger,
      dangerSubtle: AppColorTokens.fundexDangerLight,
      dangerSoft: AppColorTokens.dangerSoft,
      dangerBorder: AppColorTokens.dangerBorder,
      dangerForeground: AppColorTokens.dangerText,
      info: AppColorTokens.info,
      infoSubtle: AppColorTokens.infoLight,
      infoSoft: AppColorTokens.infoSoft,
      infoBorder: AppColorTokens.infoBorder,
      infoForeground: AppColorTokens.infoText,
      heroStart: AppColorTokens.fundexPrimaryDark,
      heroMiddle: AppColorTokens.fundexPrimaryDarkDradient,
      heroEnd: AppColorTokens.fundexPrimaryDarkAlt,
      communityPrimary: AppColorTokens.kizunarkPrimary,
      communitySecondary: AppColorTokens.kizunarkSecondary,
      background: background,
      surface: surface,
      surfaceAlt: isDark
          ? AppColorTokens.darkSurfaceAlt
          : AppColorTokens.lightSurfaceAlt,
      border: outline,
      borderSoft: isDark
          ? AppColorTokens.darkBorderSoft
          : AppColorTokens.lightBorderSoft,
      textPrimary: onSurface,
      textSecondary: isDark
          ? AppColorTokens.darkMuted
          : AppColorTokens.fundexTextSecondary,
      textTertiary: isDark
          ? AppColorTokens.darkMuted.withValues(alpha: 0.84)
          : AppColorTokens.fundexTextTertiary,
      onDark: AppColorTokens.darkOnSurface,
      disabled: AppColorTokens.fundexDisabled,
      highlightGold: AppColorTokens.fundexHighlightGold,
      scrim: Colors.black.withValues(alpha: isDark ? 0.56 : 0.36),
    );
    final semanticTextTheme = AppSemanticTextTheme(
      heroTitle: AppTypographyTokens.sansStyle(
        size: 24,
        weight: FontWeight.w700,
        color: semanticColors.onDark,
        height: 1.16,
      ),
      heroSubtitle: AppTypographyTokens.sansStyle(
        size: 12,
        weight: FontWeight.w400,
        color: semanticColors.onDark.withValues(alpha: 0.72),
        height: 1.5,
      ),
      pageTitle: (textTheme.headlineSmall ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      sectionTitle: (textTheme.titleLarge ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      cardTitle: (textTheme.titleMedium ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      body: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      bodyStrong: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      bodyMuted: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: semanticColors.textSecondary,
      ),
      caption: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: semanticColors.textSecondary,
      ),
      meta: (textTheme.labelSmall ?? const TextStyle()).copyWith(
        color: semanticColors.textTertiary,
      ),
      micro: AppTypographyTokens.sansStyle(
        size: 9,
        weight: FontWeight.w600,
        color: semanticColors.textTertiary,
        height: 1.22,
        letterSpacing: 0.1,
      ),
      button: (textTheme.labelLarge ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      chip: (textTheme.labelMedium ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      inputLabel: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: semanticColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      inputText: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: semanticColors.textPrimary,
      ),
      helper: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: semanticColors.textSecondary,
      ),
      link: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: semanticColors.primary,
        fontWeight: FontWeight.w700,
      ),
      numericDisplay: AppTypographyTokens.numericStyle(
        size: 44,
        weight: FontWeight.w900,
        color: semanticColors.textPrimary,
        height: 1.04,
      ),
      numericHeadline: AppTypographyTokens.numericStyle(
        size: 32,
        weight: FontWeight.w900,
        color: semanticColors.textPrimary,
        height: 1.08,
      ),
      numericTitle: AppTypographyTokens.numericStyle(
        size: 20,
        weight: FontWeight.w800,
        color: semanticColors.textPrimary,
        height: 1.1,
      ),
      numericBody: AppTypographyTokens.numericStyle(
        size: 14,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.2,
      ),
      numericCaption: AppTypographyTokens.numericStyle(
        size: 10,
        weight: FontWeight.w700,
        color: semanticColors.textSecondary,
        height: 1.2,
      ),
    );

    final authVisualTheme = AppAuthVisualTheme(
      backgroundGradientColors: isDark
          ? const <Color>[
              AppColorTokens.darkBackground,
              Color(0xFF101A2A),
              Color(0xFF15253B),
            ]
          : const <Color>[
              Color(0xFFEAF3FF),
              Color(0xFFF8FBFF),
              Color(0xFFE7FFF8),
            ],
      loginHeroGradientColors: isDark
          ? const <Color>[
              AppColorTokens.darkBackground,
              AppColorTokens.darkSurface,
              AppColorTokens.darkBackground,
            ]
          : const <Color>[
              AppColorTokens.fundexPrimaryDark,
              AppColorTokens.fundexPrimaryDarkDradient,
              AppColorTokens.fundexPrimaryDarkAlt,
            ],
      loginHeroLogoGradientColors: const <Color>[
        AppColorTokens.fundexAccent,
        AppColorTokens.fundexAccentDradient,
      ],
      loginHeroLogoShadowColor: AppColorTokens.fundexAccent.withValues(
        alpha: isDark ? 0.52 : 0.42,
      ),
      loginHeroForegroundColor: Colors.white,
      orbPrimary: AppColorTokens.accent.withValues(alpha: 0.28),
      orbSecondary: AppColorTokens.accentTertiary.withValues(alpha: 0.24),
      orbTertiary: AppColorTokens.accentSecondary.withValues(alpha: 0.22),
      brandLabelStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
        color: contentMuted,
        letterSpacing: 2.4,
        fontWeight: FontWeight.w700,
      ),
      subtitleStyle: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: contentMuted,
      ),
      glassSurfaceColor: surface.withValues(alpha: isDark ? 0.66 : 0.82),
      glassBorderColor: onSurface.withValues(alpha: 0.14),
      inlineErrorTextStyle: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: AppColorTokens.danger,
      ),
    );

    final travelHotelTheme = AppFTKTheme(
      primaryButtonColor: AppColorTokens.travelPrimaryTeal,
      primaryButtonShadowColor: AppColorTokens.travelPrimaryTeal.withValues(
        alpha: isDark ? 0.22 : 0.15,
      ),
      primaryButtonTextStyle:
          (textTheme.titleMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w900,
        height: 22 / 16,
      ),
      categorySelectedBackgroundColor: AppColorTokens.travelPrimaryBlueAlt,
      categorySelectedForegroundColor: Colors.white,
      categorySelectedLabelStyle:
          (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16.5 / 12,
      ),
      categoryIdleBackgroundColor:
          isDark ? const Color(0xFF161E2D) : Colors.white,
      categoryIdleBorderColor: isDark
          ? outline.withValues(alpha: 0.9)
          : AppColorTokens.travelBorderSoft,
      categoryIdleIconColor:
          isDark ? AppColorTokens.darkMuted : AppColorTokens.travelTextMuted,
      categoryIdleLabelStyle:
          (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color:
            isDark ? AppColorTokens.darkMuted : AppColorTokens.travelTextSubtle,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16.5 / 12,
      ),
      categoryShadowColor: AppColorTokens.travelShadowBlue.withValues(
        alpha: isDark ? 0.18 : 0.5,
      ),
      floatingIconBackgroundColor:
          isDark ? const Color(0xFF17202E) : Colors.white,
      floatingIconForegroundColor:
          isDark ? AppColorTokens.darkOnSurface : AppColorTokens.travelIconNavy,
      floatingIconShadowColor: Colors.black.withValues(
        alpha: isDark ? 0.24 : 0.10,
      ),
      cardBorderColor: isDark
          ? outline.withValues(alpha: 0.85)
          : AppColorTokens.travelBorderSoft,
      cardTileShadowColor: Colors.black.withValues(alpha: isDark ? 0.22 : 0.10),
      amenityHighlightedShadowColor: Colors.black.withValues(
        alpha: isDark ? 0.26 : 0.10,
      ),
      sectionTitleStyle:
          (textTheme.headlineSmall ?? const TextStyle()).copyWith(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        height: 22 / 23,
        color: isDark ? AppColorTokens.darkOnSurface : Colors.black,
      ),
      sectionActionColor:
          isDark ? const Color(0xFFF3BA55) : AppColorTokens.travelLinkGold,
      mediaCardTitleStyle:
          (textTheme.titleMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 15.28 / 16,
      ),
      mediaCardSubtitleStyle:
          (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 11.46 / 12,
      ),
      mediaCardPriceStyle: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 11.46 / 12,
      ),
      mediaCardRatingStyle:
          (textTheme.labelMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 9.55 / 10,
      ),
      mediaCardOverlayGradientColors: <Color>[
        Colors.transparent,
        AppColorTokens.travelOverlayCool.withValues(
          alpha: isDark ? 0.82 : 0.62,
        ),
        Colors.black.withValues(alpha: isDark ? 0.98 : 0.94),
      ],
      dealCardOverlayGradientColors: <Color>[
        AppColorTokens.travelOverlayCharcoal.withValues(
          alpha: isDark ? 0.86 : 0.78,
        ),
        AppColorTokens.travelOverlayCool.withValues(
          alpha: isDark ? 0.70 : 0.59,
        ),
        AppColorTokens.travelOverlayBlackSoft.withValues(
          alpha: isDark ? 0.88 : 0.47,
        ),
        Colors.black.withValues(alpha: isDark ? 1 : 0.96),
      ],
      discountChipBackgroundColor: AppColorTokens.travelDiscountCoral,
      discountChipTextStyle:
          (textTheme.labelMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 9.55 / 10,
      ),
      photoCountChipBackgroundColor:
          isDark ? const Color(0x99404A56) : const Color(0x801D1A19),
      photoCountChipTextStyle:
          (textTheme.labelMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 9.55 / 10,
      ),
      ratingAccentColor: AppColorTokens.travelRatingOrange,
      hostActionButtonBackgroundColor: AppColorTokens.travelFabOrange,
      hostActionButtonShadowColor: AppColorTokens.travelShadowOrange.withValues(
        alpha: isDark ? 0.55 : 1,
      ),
      iconNavyColor:
          isDark ? AppColorTokens.darkOnSurface : AppColorTokens.travelIconNavy,
      tileCornerRadius: 19,
      cardCornerRadius: 17,
      chipCornerRadius: 87,
    );

    final shellNavigationTheme = AppShellNavigationTheme(
      bottomTabInactiveColor: isDark
          ? onSurface.withValues(alpha: 0.84)
          : onSurface.withValues(alpha: 0.68),
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: semanticColors.primary,
      onPrimary: Colors.white,
      secondary: semanticColors.primaryAlt,
      onSecondary: Colors.white,
      error: semanticColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      tertiary: semanticColors.success,
      onTertiary: Colors.white,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      borderSide: BorderSide(color: outline),
    );
    final statusBarOverlayStyle = statusBarOverlayStyleFor(brightness);

    return ThemeData(
      primaryColorDark: AppColorTokens.fundexPrimaryDark,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[
        semanticColors,
        semanticTextTheme,
        authVisualTheme,
        travelHotelTheme,
        shellNavigationTheme,
      ],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: onSurface,
        titleTextStyle: semanticTextTheme.pageTitle,
        systemOverlayStyle: statusBarOverlayStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withValues(alpha: isDark ? 0.68 : 0.9),
        hintStyle: semanticTextTheme.helper,
        labelStyle: semanticTextTheme.inputLabel,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColorTokens.accent,
            width: 1.5,
          ),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColorTokens.danger),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiTokens.spacing16,
          vertical: UiTokens.spacing16,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius20),
          side: BorderSide(color: outline.withValues(alpha: 0.6)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius20),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(UiTokens.radius28),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, 52),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
            ),
          ),
          textStyle:
              WidgetStatePropertyAll<TextStyle?>(semanticTextTheme.button),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, 52),
          ),
          side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: outline)),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
            ),
          ),
          textStyle:
              WidgetStatePropertyAll<TextStyle?>(semanticTextTheme.button),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
        ),
        backgroundColor:
            isDark ? const Color(0xFF1B2433) : const Color(0xFF1F2937),
      ),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        brightness: brightness,
        primaryColor: AppColorTokens.accent,
        scaffoldBackgroundColor: background,
        barBackgroundColor: surface.withValues(alpha: 0.8),
        textTheme: CupertinoTextThemeData(
          textStyle: semanticTextTheme.body,
          navTitleTextStyle: semanticTextTheme.sectionTitle,
          navLargeTitleTextStyle: semanticTextTheme.pageTitle,
        ),
      ),
    );
  }
}
