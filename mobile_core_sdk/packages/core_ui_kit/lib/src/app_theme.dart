import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color_tokens.dart';
import 'app_theme_extensions.dart';
import 'app_typography_tokens.dart';
import 'ui_tokens.dart';

class AppThemeFactory {
  const AppThemeFactory._();

  static ThemeData light({Locale? locale}) {
    return _build(Brightness.light, locale: locale);
  }

  static ThemeData dark({Locale? locale}) {
    return _build(Brightness.dark, locale: locale);
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

  static ThemeData _build(Brightness brightness, {Locale? locale}) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? AppColorTokens.darkBackground
        : AppColorTokens.lightBackground;
    final surface = isDark
        ? AppColorTokens.darkSurface
        : AppColorTokens.lightSurface;
    final onSurface = isDark
        ? AppColorTokens.darkOnSurface
        : AppColorTokens.lightOnSurface;
    final outline = isDark
        ? AppColorTokens.darkBorder
        : AppColorTokens.lightBorder;
    Color overlay(Color foreground, Color base, double opacity) =>
        Color.alphaBlend(foreground.withValues(alpha: opacity), base);
    final textTheme = AppTypographyTokens.textTheme(brightness, locale: locale);
    final contentMuted = onSurface.withValues(alpha: 0.72);
    TextStyle sans({
      required double size,
      required FontWeight weight,
      required Color color,
      double? height,
      double? letterSpacing,
    }) => AppTypographyTokens.sansStyle(
      size: size,
      weight: weight,
      color: color,
      locale: locale,
      height: height,
      letterSpacing: letterSpacing,
    );
    TextStyle numeric({
      required double size,
      required FontWeight weight,
      required Color color,
      double? height,
      double? letterSpacing,
    }) => AppTypographyTokens.numericStyle(
      size: size,
      weight: weight,
      color: color,
      locale: locale,
      height: height,
      letterSpacing: letterSpacing,
    );
    final semanticColors = AppSemanticColorTheme(
      brandPrimary: AppColorTokens.brandPrimary,
      brandPrimaryDark: AppColorTokens.brandPrimaryDark,
      brandPrimaryBright: AppColorTokens.brandPrimaryBright,
      brandSecondary: AppColorTokens.brandSecondaryTeal,
      brandAlert: AppColorTokens.brandAlert,
      brandNeutral: AppColorTokens.brandNeutral,
      brandWhite: AppColorTokens.brandWhite,
      primary: isDark
          ? AppColorTokens.brandPrimaryBright
          : AppColorTokens.fundexAccent,
      primaryAlt: isDark
          ? AppColorTokens.brandPrimary
          : AppColorTokens.fundexAccentAlt,
      primarySoft: isDark
          ? overlay(
              AppColorTokens.brandPrimaryBright,
              AppColorTokens.darkSurfaceAlt,
              0.24,
            )
          : AppColorTokens.fundexAccentLight,
      primarySubtle: isDark
          ? overlay(
              AppColorTokens.brandPrimary,
              AppColorTokens.darkSurface,
              0.16,
            )
          : AppColorTokens.fundexAccentSuperLight,
      success: AppColorTokens.fundexSuccess,
      successSubtle: isDark
          ? overlay(
              AppColorTokens.fundexSuccess,
              AppColorTokens.darkSurface,
              0.14,
            )
          : AppColorTokens.fundexSuccessLight,
      successSoft: isDark
          ? overlay(
              AppColorTokens.fundexSuccess,
              AppColorTokens.darkSurfaceAlt,
              0.22,
            )
          : AppColorTokens.successSoft,
      successBorder: isDark
          ? AppColorTokens.fundexSuccess.withValues(alpha: 0.52)
          : AppColorTokens.successBorder,
      successForeground: isDark
          ? AppColorTokens.fundexSuccessLight
          : AppColorTokens.successStrong,
      warning: AppColorTokens.fundexWarning,
      warningSubtle: isDark
          ? overlay(
              AppColorTokens.fundexWarning,
              AppColorTokens.darkSurface,
              0.14,
            )
          : AppColorTokens.fundexWarningLight,
      warningSoft: isDark
          ? overlay(
              AppColorTokens.fundexWarning,
              AppColorTokens.darkSurfaceAlt,
              0.22,
            )
          : AppColorTokens.warningSoft,
      warningBorder: isDark
          ? AppColorTokens.fundexWarning.withValues(alpha: 0.56)
          : AppColorTokens.warningBorder,
      warningForeground: isDark
          ? AppColorTokens.warningBorder
          : AppColorTokens.warningStrong,
      warningAction: AppColorTokens.warningAction,
      danger: AppColorTokens.fundexDanger,
      dangerSubtle: isDark
          ? overlay(
              AppColorTokens.fundexDanger,
              AppColorTokens.darkSurface,
              0.14,
            )
          : AppColorTokens.fundexDangerLight,
      dangerSoft: isDark
          ? overlay(
              AppColorTokens.fundexDanger,
              AppColorTokens.darkSurfaceAlt,
              0.22,
            )
          : AppColorTokens.dangerSoft,
      dangerBorder: isDark
          ? AppColorTokens.fundexDanger.withValues(alpha: 0.56)
          : AppColorTokens.dangerBorder,
      dangerForeground: isDark
          ? AppColorTokens.dangerBorder
          : AppColorTokens.dangerText,
      info: isDark ? AppColorTokens.brandPrimaryBright : AppColorTokens.info,
      infoSubtle: isDark
          ? overlay(
              AppColorTokens.brandPrimaryBright,
              AppColorTokens.darkSurface,
              0.14,
            )
          : AppColorTokens.infoLight,
      infoSoft: isDark
          ? overlay(
              AppColorTokens.brandPrimaryBright,
              AppColorTokens.darkSurfaceAlt,
              0.22,
            )
          : AppColorTokens.infoSoft,
      infoBorder: isDark
          ? AppColorTokens.brandPrimaryBright.withValues(alpha: 0.56)
          : AppColorTokens.infoBorder,
      infoForeground: isDark
          ? AppColorTokens.infoBorder
          : AppColorTokens.infoText,
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
      heroTitle: sans(
        size: 24,
        weight: FontWeight.w800,
        color: semanticColors.onDark,
        height: 1.16,
      ),
      heroSubtitle: sans(
        size: 16,
        weight: FontWeight.w600,
        color: semanticColors.onDark.withValues(alpha: 0.78),
        height: 1.25,
      ),
      heroMetricPrimary: numeric(
        size: 26,
        weight: FontWeight.w800,
        color: semanticColors.textPrimary,
        height: 1.1,
      ),
      heroMetricSecondary: numeric(
        size: 16,
        weight: FontWeight.w800,
        color: semanticColors.textPrimary,
        height: 1.2,
      ),
      pageTitle: sans(
        size: 18,
        weight: FontWeight.w800,
        color: semanticColors.textPrimary,
        height: 1.24,
      ),
      sectionTitle: sans(
        size: 15,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.2,
      ),
      cardTitle: sans(
        size: 14,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.28,
      ),
      body: sans(
        size: 13,
        weight: FontWeight.w400,
        color: semanticColors.textPrimary,
        height: 1.54,
      ),
      bodySemi: sans(
        size: 13,
        weight: FontWeight.w500,
        color: semanticColors.textPrimary,
        height: 1.5,
      ),
      bodyStrong: sans(
        size: 13,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.46,
      ),
      bodyMuted: sans(
        size: 13,
        weight: FontWeight.w400,
        color: semanticColors.textSecondary,
        height: 1.54,
      ),
      caption: sans(
        size: 13,
        weight: FontWeight.w400,
        color: semanticColors.textSecondary,
        height: 1.5,
      ),
      meta: sans(
        size: 11,
        weight: FontWeight.w500,
        color: semanticColors.textTertiary,
        height: 1.2,
        letterSpacing: 0.1,
      ),
      micro: sans(
        size: 11,
        weight: FontWeight.w700,
        color: semanticColors.textTertiary,
        height: 1.22,
        letterSpacing: 0.1,
      ),
      button: sans(
        size: 15,
        weight: FontWeight.w800,
        color: semanticColors.textPrimary,
        height: 1.2,
        letterSpacing: 0.1,
      ),
      chip: sans(
        size: 12,
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.2,
        letterSpacing: 0.1,
      ),
      inputLabel: sans(
        size: 14,
        weight: FontWeight.w600,
        color: semanticColors.textSecondary,
        height: 1.3,
      ),
      inputText: sans(
        size: 15,
        weight: FontWeight.w500,
        color: semanticColors.textPrimary,
        height: 1.42,
      ),
      helper: sans(
        size: 12,
        weight: FontWeight.w400,
        color: semanticColors.textSecondary,
        height: 1.45,
      ),
      link: sans(
        size: 12,
        weight: FontWeight.w700,
        color: semanticColors.primary,
        height: 1.3,
      ),
      numericDisplay: numeric(
        size: 44,
        weight: FontWeight.w900,
        color: semanticColors.textPrimary,
        height: 1.04,
      ),
      numericHeadline: numeric(
        size: 32,
        weight: FontWeight.w900,
        color: semanticColors.textPrimary,
        height: 1.08,
      ),
      numericTitle: numeric(
        size: 20,
        weight: FontWeight.w800,
        color: semanticColors.textPrimary,
        height: 1.1,
      ),
      numericBody: numeric(
        size: 14,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.2,
      ),
      numericCaption: numeric(
        size: 10,
        weight: FontWeight.w700,
        color: semanticColors.textSecondary,
        height: 1.2,
      ),
      tableLabel: sans(
        size: 13,
        weight: FontWeight.w500,
        color: semanticColors.textTertiary,
        height: 1.2,
      ),
      tableValue: sans(
        size: 14,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.35,
      ),
      cellValue: sans(
        size: 16,
        weight: FontWeight.w700,
        color: semanticColors.textTertiary,
        height: 1.35,
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
      primaryButtonTextStyle: (textTheme.titleMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            height: 22 / 16,
          ),
      categorySelectedBackgroundColor: AppColorTokens.travelPrimaryBlueAlt,
      categorySelectedForegroundColor: Colors.white,
      categorySelectedLabelStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16.5 / 12,
          ),
      categoryIdleBackgroundColor: isDark
          ? const Color(0xFF161E2D)
          : Colors.white,
      categoryIdleBorderColor: isDark
          ? outline.withValues(alpha: 0.9)
          : AppColorTokens.travelBorderSoft,
      categoryIdleIconColor: isDark
          ? AppColorTokens.darkMuted
          : AppColorTokens.travelTextMuted,
      categoryIdleLabelStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
            color: isDark
                ? AppColorTokens.darkMuted
                : AppColorTokens.travelTextSubtle,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16.5 / 12,
          ),
      categoryShadowColor: AppColorTokens.travelShadowBlue.withValues(
        alpha: isDark ? 0.18 : 0.5,
      ),
      floatingIconBackgroundColor: isDark
          ? const Color(0xFF17202E)
          : Colors.white,
      floatingIconForegroundColor: isDark
          ? AppColorTokens.darkOnSurface
          : AppColorTokens.travelIconNavy,
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
      sectionTitleStyle: (textTheme.headlineSmall ?? const TextStyle())
          .copyWith(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            height: 22 / 23,
            color: isDark ? AppColorTokens.darkOnSurface : Colors.black,
          ),
      sectionActionColor: isDark
          ? const Color(0xFFF3BA55)
          : AppColorTokens.travelLinkGold,
      mediaCardTitleStyle: (textTheme.titleMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 15.28 / 16,
          ),
      mediaCardSubtitleStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
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
      mediaCardRatingStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(
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
      discountChipTextStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 9.55 / 10,
          ),
      photoCountChipBackgroundColor: isDark
          ? const Color(0x99404A56)
          : const Color(0x801D1A19),
      photoCountChipTextStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(
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
      iconNavyColor: isDark
          ? AppColorTokens.darkOnSurface
          : AppColorTokens.travelIconNavy,
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
      borderRadius: BorderRadius.circular(UiTokens.radius12),
      borderSide: BorderSide(color: outline, width: 1.5),
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
        fillColor: isDark ? surface.withValues(alpha: 0.72) : surface,
        hintStyle: semanticTextTheme.helper.copyWith(
          color: semanticColors.textTertiary,
        ),
        labelStyle: semanticTextTheme.inputLabel,
        floatingLabelStyle: semanticTextTheme.inputLabel.copyWith(
          color: semanticColors.primary,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: semanticColors.primary, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: semanticColors.danger, width: 1.5),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: semanticColors.danger, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiTokens.spacing16,
          vertical: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          side: BorderSide(color: outline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
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
            Size(double.infinity, 54),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius14),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(
            semanticTextTheme.button,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, 54),
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: outline, width: 1.5),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius14),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(
            semanticTextTheme.button,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll<TextStyle?>(
            semanticTextTheme.button,
          ),
          foregroundColor: WidgetStatePropertyAll<Color>(
            semanticColors.primary,
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius14),
            ),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
        ),
        backgroundColor: isDark
            ? AppColorTokens.darkSurfaceAlt
            : AppColorTokens.fundexText,
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
