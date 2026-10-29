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
    final contentMuted = isDark
        ? AppColorTokens.darkMuted
        : AppColorTokens.lightMuted;
    final darkInteractivePrimary = AppColorTokens.brandPrimaryBright;
    final darkInteractivePrimaryAlt = AppColorTokens.brandViolet;
    final linkColor = isDark
        ? AppColorTokens.brandLilac
        : AppColorTokens.brandPurple;
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
      primary: isDark ? darkInteractivePrimary : AppColorTokens.fundexAccent,
      primaryAlt: isDark
          ? darkInteractivePrimaryAlt
          : AppColorTokens.fundexAccentAlt,
      primarySoft: isDark
          ? overlay(darkInteractivePrimary, AppColorTokens.darkSurfaceAlt, 0.32)
          : AppColorTokens.fundexAccentLight,
      primarySubtle: isDark
          ? overlay(darkInteractivePrimary, AppColorTokens.darkSurface, 0.22)
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
      info: isDark ? darkInteractivePrimary : AppColorTokens.info,
      infoSubtle: isDark
          ? overlay(darkInteractivePrimary, AppColorTokens.darkSurface, 0.2)
          : AppColorTokens.infoLight,
      infoSoft: isDark
          ? overlay(darkInteractivePrimary, AppColorTokens.darkSurfaceAlt, 0.3)
          : AppColorTokens.infoSoft,
      infoBorder: isDark
          ? darkInteractivePrimary.withValues(alpha: 0.64)
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
          ? AppColorTokens.darkMuted
          : AppColorTokens.fundexTextSecondary,
      onDark: AppColorTokens.brandWhite,
      disabled: AppColorTokens.fundexDisabled,
      highlightGold: AppColorTokens.fundexHighlightGold,
      scrim: Colors.black.withValues(alpha: isDark ? 0.56 : 0.36),
    );
    final semanticTextTheme = AppSemanticTextTheme(
      heroTitle: sans(
        size: 24,
        weight: FontWeight.w700,
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
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.1,
      ),
      heroMetricSecondary: numeric(
        size: 16,
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.2,
      ),
      pageTitle: sans(
        size: 18,
        weight: FontWeight.w700,
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
        size: 14,
        weight: FontWeight.w400,
        color: semanticColors.textPrimary,
        height: 1.54,
      ),
      bodySemi: sans(
        size: 14,
        weight: FontWeight.w500,
        color: semanticColors.textPrimary,
        height: 1.5,
      ),
      bodyStrong: sans(
        size: 14,
        weight: FontWeight.w700,
        color: semanticColors.textPrimary,
        height: 1.46,
      ),
      bodyMuted: sans(
        size: 14,
        weight: FontWeight.w400,
        color: semanticColors.textSecondary,
        height: 1.54,
      ),
      caption: sans(
        size: 14,
        weight: FontWeight.w400,
        color: semanticColors.textSecondary,
        height: 1.5,
      ),
      meta: sans(
        size: 12,
        weight: FontWeight.w500,
        color: semanticColors.textTertiary,
        height: 1.2,
        letterSpacing: 0.1,
      ),
      micro: sans(
        size: 12,
        weight: FontWeight.w700,
        color: semanticColors.textTertiary,
        height: 1.22,
        letterSpacing: 0.1,
      ),
      button: sans(
        size: 15,
        weight: FontWeight.w500,
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
        size: 14,
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
        color: linkColor,
        height: 1.3,
      ),
      numericDisplay: numeric(
        size: 44,
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.04,
      ),
      numericHeadline: numeric(
        size: 32,
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.08,
      ),
      numericTitle: numeric(
        size: 20,
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.1,
      ),
      numericBody: numeric(
        size: 14,
        weight: FontWeight.w600,
        color: semanticColors.textPrimary,
        height: 1.2,
      ),
      numericCaption: numeric(
        size: 10,
        weight: FontWeight.w600,
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
        size: 14,
        weight: FontWeight.w700,
        color: semanticColors.textTertiary,
        height: 1.35,
      ),
    );

    final authVisualTheme = AppAuthVisualTheme(
      backgroundGradientColors: <Color>[background, background],
      loginHeroGradientColors: const <Color>[
        AppColorTokens.brandNavy,
        AppColorTokens.brandNavy,
      ],
      loginHeroLogoGradientColors: const <Color>[
        AppColorTokens.brandPurple,
        AppColorTokens.brandPurple,
      ],
      loginHeroLogoShadowColor: AppColorTokens.fundexAccent.withValues(
        alpha: isDark ? 0.52 : 0.42,
      ),
      loginHeroForegroundColor: Colors.white,
      orbPrimary: Colors.transparent,
      orbSecondary: Colors.transparent,
      orbTertiary: Colors.transparent,
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
      primaryButtonColor: isDark
          ? semanticColors.primary
          : AppColorTokens.travelPrimaryTeal,
      primaryButtonShadowColor:
          (isDark ? semanticColors.primary : AppColorTokens.travelPrimaryTeal)
              .withValues(alpha: isDark ? 0.28 : 0.15),
      primaryButtonTextStyle: (textTheme.titleMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            height: 22 / 16,
          ),
      categorySelectedBackgroundColor: isDark
          ? semanticColors.primary
          : AppColorTokens.brandPurple,
      categorySelectedForegroundColor: Colors.white,
      categorySelectedLabelStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16.5 / 12,
          ),
      categoryIdleBackgroundColor: isDark ? surface : Colors.white,
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
      categoryShadowColor: AppColorTokens.brandNavy.withValues(
        alpha: isDark ? 0.18 : 0.08,
      ),
      floatingIconBackgroundColor: isDark ? surface : Colors.white,
      floatingIconForegroundColor: isDark
          ? AppColorTokens.darkOnSurface
          : AppColorTokens.travelIconNavy,
      floatingIconShadowColor: Colors.black.withValues(
        alpha: isDark ? 0.24 : 0.10,
      ),
      cardBorderColor: isDark
          ? AppColorTokens.darkBorderSoft
          : AppColorTokens.lightBorderSoft,
      cardTileShadowColor: Colors.black.withValues(alpha: isDark ? 0.22 : 0.10),
      amenityHighlightedShadowColor: Colors.black.withValues(
        alpha: isDark ? 0.26 : 0.10,
      ),
      sectionTitleStyle: (textTheme.headlineSmall ?? const TextStyle())
          .copyWith(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            height: 22 / 23,
            color: onSurface,
          ),
      sectionActionColor: linkColor,
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
      discountChipBackgroundColor: semanticColors.primary,
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
      hostActionButtonBackgroundColor: semanticColors.primary,
      hostActionButtonShadowColor: AppColorTokens.brandPurple.withValues(
        alpha: isDark ? 0.28 : 0.15,
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
          : const Color(0xFF999CAB),
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
      tertiary: semanticColors.primaryAlt,
      onTertiary: Colors.white,
      primaryContainer: semanticColors.primarySoft,
      onPrimaryContainer: isDark
          ? AppColorTokens.brandLilac
          : AppColorTokens.brandPurple,
      secondaryContainer: semanticColors.primarySubtle,
      onSecondaryContainer: isDark
          ? AppColorTokens.brandLilac
          : AppColorTokens.brandPurple,
      surfaceContainerLowest: background,
      surfaceContainerLow: surface,
      surfaceContainer: surface,
      surfaceContainerHigh: semanticColors.surfaceAlt,
      surfaceContainerHighest: semanticColors.surfaceAlt,
      onSurfaceVariant: semanticColors.textSecondary,
      outline: outline,
      outlineVariant: semanticColors.borderSoft,
      inverseSurface: isDark
          ? AppColorTokens.lightSurface
          : AppColorTokens.brandNavy,
      onInverseSurface: isDark
          ? AppColorTokens.brandNavy
          : AppColorTokens.brandWhite,
      inversePrimary: isDark
          ? AppColorTokens.brandPurple
          : AppColorTokens.brandLilac,
      surfaceTint: Colors.transparent,
    );
    final inputFillColor = isDark ? surface.withValues(alpha: 0.72) : surface;
    final inputOutlineColor = outline;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiTokens.radius8),
      borderSide: BorderSide(color: inputOutlineColor),
    );
    final statusBarOverlayStyle = statusBarOverlayStyleFor(brightness);

    return ThemeData(
      primaryColorDark: AppColorTokens.fundexPrimaryDark,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      fontFamily: AppTypographyTokens.primaryContentFamilyForLocale(locale),
      fontFamilyFallback: AppTypographyTokens.sansFamilyFallback,
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
        constraints: const BoxConstraints(minHeight: UiTokens.inputHeight),
        fillColor: inputFillColor,
        prefixIconColor: semanticColors.textSecondary,
        suffixIconColor: semanticColors.textSecondary,
        hintStyle: semanticTextTheme.helper.copyWith(
          color: semanticColors.textTertiary,
        ),
        labelStyle: semanticTextTheme.inputLabel,
        floatingLabelStyle: semanticTextTheme.inputLabel.copyWith(
          color: linkColor,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: semanticColors.borderSoft),
        ),
        errorStyle: semanticTextTheme.helper.copyWith(
          color: semanticColors.dangerForeground,
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: semanticColors.primaryAlt, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: semanticColors.dangerForeground,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: semanticColors.dangerForeground,
            width: 1.5,
          ),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: semanticColors.primary,
          foregroundColor: semanticColors.onDark,
          minimumSize: const Size(0, UiTokens.controlHeight),
          shape: const StadiumBorder(),
          textStyle: semanticTextTheme.button,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, UiTokens.controlHeight),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.circle),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(
            semanticTextTheme.button,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(surface),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) =>
                states.contains(WidgetState.disabled) ? null : linkColor,
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, UiTokens.controlHeight),
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? semanticColors.borderSoft
                  : linkColor,
            ),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.circle),
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
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) =>
                states.contains(WidgetState.disabled) ? null : linkColor,
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.circle),
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
        primaryColor: linkColor,
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
