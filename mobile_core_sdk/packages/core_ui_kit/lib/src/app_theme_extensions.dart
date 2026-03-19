import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

Color _lerpColor(Color a, Color b, double t) => Color.lerp(a, b, t) ?? b;

List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
  final maxLength = a.length > b.length ? a.length : b.length;
  return List<Color>.generate(maxLength, (int index) {
    final aColor = index < a.length ? a[index] : a.last;
    final bColor = index < b.length ? b[index] : b.last;
    return _lerpColor(aColor, bColor, t);
  });
}

class AppSemanticColorTheme extends ThemeExtension<AppSemanticColorTheme> {
  const AppSemanticColorTheme({
    required this.brandPrimary,
    required this.brandPrimaryDark,
    required this.brandPrimaryBright,
    required this.brandSecondary,
    required this.brandAlert,
    required this.brandNeutral,
    required this.brandWhite,
    required this.primary,
    required this.primaryAlt,
    required this.primarySoft,
    required this.primarySubtle,
    required this.success,
    required this.successSubtle,
    required this.successSoft,
    required this.successBorder,
    required this.successForeground,
    required this.warning,
    required this.warningSubtle,
    required this.warningSoft,
    required this.warningBorder,
    required this.warningForeground,
    required this.warningAction,
    required this.danger,
    required this.dangerSubtle,
    required this.dangerSoft,
    required this.dangerBorder,
    required this.dangerForeground,
    required this.info,
    required this.infoSubtle,
    required this.infoSoft,
    required this.infoBorder,
    required this.infoForeground,
    required this.heroStart,
    required this.heroMiddle,
    required this.heroEnd,
    required this.communityPrimary,
    required this.communitySecondary,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.borderSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.onDark,
    required this.disabled,
    required this.highlightGold,
    required this.scrim,
  });

  final Color brandPrimary;
  final Color brandPrimaryDark;
  final Color brandPrimaryBright;
  final Color brandSecondary;
  final Color brandAlert;
  final Color brandNeutral;
  final Color brandWhite;

  final Color primary;
  final Color primaryAlt;
  final Color primarySoft;
  final Color primarySubtle;

  final Color success;
  final Color successSubtle;
  final Color successSoft;
  final Color successBorder;
  final Color successForeground;

  final Color warning;
  final Color warningSubtle;
  final Color warningSoft;
  final Color warningBorder;
  final Color warningForeground;
  final Color warningAction;

  final Color danger;
  final Color dangerSubtle;
  final Color dangerSoft;
  final Color dangerBorder;
  final Color dangerForeground;

  final Color info;
  final Color infoSubtle;
  final Color infoSoft;
  final Color infoBorder;
  final Color infoForeground;

  final Color heroStart;
  final Color heroMiddle;
  final Color heroEnd;
  final Color communityPrimary;
  final Color communitySecondary;

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color borderSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color onDark;
  final Color disabled;
  final Color highlightGold;
  final Color scrim;

  @override
  AppSemanticColorTheme copyWith({
    Color? brandPrimary,
    Color? brandPrimaryDark,
    Color? brandPrimaryBright,
    Color? brandSecondary,
    Color? brandAlert,
    Color? brandNeutral,
    Color? brandWhite,
    Color? primary,
    Color? primaryAlt,
    Color? primarySoft,
    Color? primarySubtle,
    Color? success,
    Color? successSubtle,
    Color? successSoft,
    Color? successBorder,
    Color? successForeground,
    Color? warning,
    Color? warningSubtle,
    Color? warningSoft,
    Color? warningBorder,
    Color? warningForeground,
    Color? warningAction,
    Color? danger,
    Color? dangerSubtle,
    Color? dangerSoft,
    Color? dangerBorder,
    Color? dangerForeground,
    Color? info,
    Color? infoSubtle,
    Color? infoSoft,
    Color? infoBorder,
    Color? infoForeground,
    Color? heroStart,
    Color? heroMiddle,
    Color? heroEnd,
    Color? communityPrimary,
    Color? communitySecondary,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? borderSoft,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? onDark,
    Color? disabled,
    Color? highlightGold,
    Color? scrim,
  }) {
    return AppSemanticColorTheme(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandPrimaryDark: brandPrimaryDark ?? this.brandPrimaryDark,
      brandPrimaryBright: brandPrimaryBright ?? this.brandPrimaryBright,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandAlert: brandAlert ?? this.brandAlert,
      brandNeutral: brandNeutral ?? this.brandNeutral,
      brandWhite: brandWhite ?? this.brandWhite,
      primary: primary ?? this.primary,
      primaryAlt: primaryAlt ?? this.primaryAlt,
      primarySoft: primarySoft ?? this.primarySoft,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      success: success ?? this.success,
      successSubtle: successSubtle ?? this.successSubtle,
      successSoft: successSoft ?? this.successSoft,
      successBorder: successBorder ?? this.successBorder,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningSubtle: warningSubtle ?? this.warningSubtle,
      warningSoft: warningSoft ?? this.warningSoft,
      warningBorder: warningBorder ?? this.warningBorder,
      warningForeground: warningForeground ?? this.warningForeground,
      warningAction: warningAction ?? this.warningAction,
      danger: danger ?? this.danger,
      dangerSubtle: dangerSubtle ?? this.dangerSubtle,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      dangerBorder: dangerBorder ?? this.dangerBorder,
      dangerForeground: dangerForeground ?? this.dangerForeground,
      info: info ?? this.info,
      infoSubtle: infoSubtle ?? this.infoSubtle,
      infoSoft: infoSoft ?? this.infoSoft,
      infoBorder: infoBorder ?? this.infoBorder,
      infoForeground: infoForeground ?? this.infoForeground,
      heroStart: heroStart ?? this.heroStart,
      heroMiddle: heroMiddle ?? this.heroMiddle,
      heroEnd: heroEnd ?? this.heroEnd,
      communityPrimary: communityPrimary ?? this.communityPrimary,
      communitySecondary: communitySecondary ?? this.communitySecondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      borderSoft: borderSoft ?? this.borderSoft,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      onDark: onDark ?? this.onDark,
      disabled: disabled ?? this.disabled,
      highlightGold: highlightGold ?? this.highlightGold,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppSemanticColorTheme lerp(
    covariant ThemeExtension<AppSemanticColorTheme>? other,
    double t,
  ) {
    if (other is! AppSemanticColorTheme) {
      return this;
    }

    return AppSemanticColorTheme(
      brandPrimary: _lerpColor(brandPrimary, other.brandPrimary, t),
      brandPrimaryDark: _lerpColor(brandPrimaryDark, other.brandPrimaryDark, t),
      brandPrimaryBright: _lerpColor(
        brandPrimaryBright,
        other.brandPrimaryBright,
        t,
      ),
      brandSecondary: _lerpColor(brandSecondary, other.brandSecondary, t),
      brandAlert: _lerpColor(brandAlert, other.brandAlert, t),
      brandNeutral: _lerpColor(brandNeutral, other.brandNeutral, t),
      brandWhite: _lerpColor(brandWhite, other.brandWhite, t),
      primary: _lerpColor(primary, other.primary, t),
      primaryAlt: _lerpColor(primaryAlt, other.primaryAlt, t),
      primarySoft: _lerpColor(primarySoft, other.primarySoft, t),
      primarySubtle: _lerpColor(primarySubtle, other.primarySubtle, t),
      success: _lerpColor(success, other.success, t),
      successSubtle: _lerpColor(successSubtle, other.successSubtle, t),
      successSoft: _lerpColor(successSoft, other.successSoft, t),
      successBorder: _lerpColor(successBorder, other.successBorder, t),
      successForeground: _lerpColor(
        successForeground,
        other.successForeground,
        t,
      ),
      warning: _lerpColor(warning, other.warning, t),
      warningSubtle: _lerpColor(warningSubtle, other.warningSubtle, t),
      warningSoft: _lerpColor(warningSoft, other.warningSoft, t),
      warningBorder: _lerpColor(warningBorder, other.warningBorder, t),
      warningForeground: _lerpColor(
        warningForeground,
        other.warningForeground,
        t,
      ),
      warningAction: _lerpColor(warningAction, other.warningAction, t),
      danger: _lerpColor(danger, other.danger, t),
      dangerSubtle: _lerpColor(dangerSubtle, other.dangerSubtle, t),
      dangerSoft: _lerpColor(dangerSoft, other.dangerSoft, t),
      dangerBorder: _lerpColor(dangerBorder, other.dangerBorder, t),
      dangerForeground: _lerpColor(dangerForeground, other.dangerForeground, t),
      info: _lerpColor(info, other.info, t),
      infoSubtle: _lerpColor(infoSubtle, other.infoSubtle, t),
      infoSoft: _lerpColor(infoSoft, other.infoSoft, t),
      infoBorder: _lerpColor(infoBorder, other.infoBorder, t),
      infoForeground: _lerpColor(infoForeground, other.infoForeground, t),
      heroStart: _lerpColor(heroStart, other.heroStart, t),
      heroMiddle: _lerpColor(heroMiddle, other.heroMiddle, t),
      heroEnd: _lerpColor(heroEnd, other.heroEnd, t),
      communityPrimary: _lerpColor(communityPrimary, other.communityPrimary, t),
      communitySecondary: _lerpColor(
        communitySecondary,
        other.communitySecondary,
        t,
      ),
      background: _lerpColor(background, other.background, t),
      surface: _lerpColor(surface, other.surface, t),
      surfaceAlt: _lerpColor(surfaceAlt, other.surfaceAlt, t),
      border: _lerpColor(border, other.border, t),
      borderSoft: _lerpColor(borderSoft, other.borderSoft, t),
      textPrimary: _lerpColor(textPrimary, other.textPrimary, t),
      textSecondary: _lerpColor(textSecondary, other.textSecondary, t),
      textTertiary: _lerpColor(textTertiary, other.textTertiary, t),
      onDark: _lerpColor(onDark, other.onDark, t),
      disabled: _lerpColor(disabled, other.disabled, t),
      highlightGold: _lerpColor(highlightGold, other.highlightGold, t),
      scrim: _lerpColor(scrim, other.scrim, t),
    );
  }
}

class AppSemanticTextTheme extends ThemeExtension<AppSemanticTextTheme> {
  const AppSemanticTextTheme({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.heroMetricPrimary,
    required this.heroMetricSecondary,
    required this.pageTitle,
    required this.sectionTitle,
    required this.cardTitle,
    required this.body,
    required this.bodyStrong,
    required this.bodyMuted,
    required this.caption,
    required this.meta,
    required this.micro,
    required this.button,
    required this.chip,
    required this.inputLabel,
    required this.inputText,
    required this.helper,
    required this.link,
    required this.numericDisplay,
    required this.numericHeadline,
    required this.numericTitle,
    required this.numericBody,
    required this.numericCaption,
    required this.tableLabel,
    required this.tableValue,
  });

  final TextStyle heroTitle;
  final TextStyle heroSubtitle;
  final TextStyle heroMetricPrimary;
  final TextStyle heroMetricSecondary;
  final TextStyle pageTitle;
  final TextStyle sectionTitle;
  final TextStyle cardTitle;
  final TextStyle body;
  final TextStyle bodyStrong;
  final TextStyle bodyMuted;
  final TextStyle caption;
  final TextStyle meta;
  final TextStyle micro;
  final TextStyle button;
  final TextStyle chip;
  final TextStyle inputLabel;
  final TextStyle inputText;
  final TextStyle helper;
  final TextStyle link;
  final TextStyle numericDisplay;
  final TextStyle numericHeadline;
  final TextStyle numericTitle;
  final TextStyle numericBody;
  final TextStyle numericCaption;
  final TextStyle tableLabel;
  final TextStyle tableValue;

  @override
  AppSemanticTextTheme copyWith({
    TextStyle? heroTitle,
    TextStyle? heroSubtitle,
    TextStyle? heroMetricPrimary,
    TextStyle? heroMetricSecondary,
    TextStyle? pageTitle,
    TextStyle? sectionTitle,
    TextStyle? cardTitle,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? bodyMuted,
    TextStyle? caption,
    TextStyle? meta,
    TextStyle? micro,
    TextStyle? button,
    TextStyle? chip,
    TextStyle? inputLabel,
    TextStyle? inputText,
    TextStyle? helper,
    TextStyle? link,
    TextStyle? numericDisplay,
    TextStyle? numericHeadline,
    TextStyle? numericTitle,
    TextStyle? numericBody,
    TextStyle? numericCaption,
    TextStyle? tableLabel,
    TextStyle? tableValue,
  }) {
    return AppSemanticTextTheme(
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      heroMetricPrimary: heroMetricPrimary ?? this.heroMetricPrimary,
      heroMetricSecondary: heroMetricSecondary ?? this.heroMetricSecondary,
      pageTitle: pageTitle ?? this.pageTitle,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      cardTitle: cardTitle ?? this.cardTitle,
      body: body ?? this.body,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      bodyMuted: bodyMuted ?? this.bodyMuted,
      caption: caption ?? this.caption,
      meta: meta ?? this.meta,
      micro: micro ?? this.micro,
      button: button ?? this.button,
      chip: chip ?? this.chip,
      inputLabel: inputLabel ?? this.inputLabel,
      inputText: inputText ?? this.inputText,
      helper: helper ?? this.helper,
      link: link ?? this.link,
      numericDisplay: numericDisplay ?? this.numericDisplay,
      numericHeadline: numericHeadline ?? this.numericHeadline,
      numericTitle: numericTitle ?? this.numericTitle,
      numericBody: numericBody ?? this.numericBody,
      numericCaption: numericCaption ?? this.numericCaption,
      tableLabel: tableLabel ?? this.tableLabel,
      tableValue: tableValue ?? this.tableValue,
    );
  }

  @override
  AppSemanticTextTheme lerp(
    covariant ThemeExtension<AppSemanticTextTheme>? other,
    double t,
  ) {
    if (other is! AppSemanticTextTheme) {
      return this;
    }

    return AppSemanticTextTheme(
      heroTitle: TextStyle.lerp(heroTitle, other.heroTitle, t)!,
      heroSubtitle: TextStyle.lerp(heroSubtitle, other.heroSubtitle, t)!,
      heroMetricPrimary: TextStyle.lerp(
        heroMetricPrimary,
        other.heroMetricPrimary,
        t,
      )!,
      heroMetricSecondary: TextStyle.lerp(
        heroMetricSecondary,
        other.heroMetricSecondary,
        t,
      )!,
      pageTitle: TextStyle.lerp(pageTitle, other.pageTitle, t)!,
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      cardTitle: TextStyle.lerp(cardTitle, other.cardTitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyStrong: TextStyle.lerp(bodyStrong, other.bodyStrong, t)!,
      bodyMuted: TextStyle.lerp(bodyMuted, other.bodyMuted, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      meta: TextStyle.lerp(meta, other.meta, t)!,
      micro: TextStyle.lerp(micro, other.micro, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      chip: TextStyle.lerp(chip, other.chip, t)!,
      inputLabel: TextStyle.lerp(inputLabel, other.inputLabel, t)!,
      inputText: TextStyle.lerp(inputText, other.inputText, t)!,
      helper: TextStyle.lerp(helper, other.helper, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
      numericDisplay: TextStyle.lerp(numericDisplay, other.numericDisplay, t)!,
      numericHeadline: TextStyle.lerp(
        numericHeadline,
        other.numericHeadline,
        t,
      )!,
      numericTitle: TextStyle.lerp(numericTitle, other.numericTitle, t)!,
      numericBody: TextStyle.lerp(numericBody, other.numericBody, t)!,
      numericCaption: TextStyle.lerp(numericCaption, other.numericCaption, t)!,
      tableLabel: TextStyle.lerp(tableLabel, other.tableLabel, t)!,
      tableValue: TextStyle.lerp(tableValue, other.tableValue, t)!,
    );
  }
}

class AppAuthVisualTheme extends ThemeExtension<AppAuthVisualTheme> {
  const AppAuthVisualTheme({
    required this.backgroundGradientColors,
    required this.loginHeroGradientColors,
    required this.loginHeroLogoGradientColors,
    required this.loginHeroLogoShadowColor,
    required this.loginHeroForegroundColor,
    required this.orbPrimary,
    required this.orbSecondary,
    required this.orbTertiary,
    required this.brandLabelStyle,
    required this.subtitleStyle,
    required this.glassSurfaceColor,
    required this.glassBorderColor,
    required this.inlineErrorTextStyle,
  });

  final List<Color> backgroundGradientColors;
  final List<Color> loginHeroGradientColors;
  final List<Color> loginHeroLogoGradientColors;
  final Color loginHeroLogoShadowColor;
  final Color loginHeroForegroundColor;
  final Color orbPrimary;
  final Color orbSecondary;
  final Color orbTertiary;
  final TextStyle brandLabelStyle;
  final TextStyle subtitleStyle;
  final Color glassSurfaceColor;
  final Color glassBorderColor;
  final TextStyle inlineErrorTextStyle;

  @override
  AppAuthVisualTheme copyWith({
    List<Color>? backgroundGradientColors,
    List<Color>? loginHeroGradientColors,
    List<Color>? loginHeroLogoGradientColors,
    Color? loginHeroLogoShadowColor,
    Color? loginHeroForegroundColor,
    Color? orbPrimary,
    Color? orbSecondary,
    Color? orbTertiary,
    TextStyle? brandLabelStyle,
    TextStyle? subtitleStyle,
    Color? glassSurfaceColor,
    Color? glassBorderColor,
    TextStyle? inlineErrorTextStyle,
  }) {
    return AppAuthVisualTheme(
      backgroundGradientColors:
          backgroundGradientColors ?? this.backgroundGradientColors,
      loginHeroGradientColors:
          loginHeroGradientColors ?? this.loginHeroGradientColors,
      loginHeroLogoGradientColors:
          loginHeroLogoGradientColors ?? this.loginHeroLogoGradientColors,
      loginHeroLogoShadowColor:
          loginHeroLogoShadowColor ?? this.loginHeroLogoShadowColor,
      loginHeroForegroundColor:
          loginHeroForegroundColor ?? this.loginHeroForegroundColor,
      orbPrimary: orbPrimary ?? this.orbPrimary,
      orbSecondary: orbSecondary ?? this.orbSecondary,
      orbTertiary: orbTertiary ?? this.orbTertiary,
      brandLabelStyle: brandLabelStyle ?? this.brandLabelStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      glassSurfaceColor: glassSurfaceColor ?? this.glassSurfaceColor,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
      inlineErrorTextStyle: inlineErrorTextStyle ?? this.inlineErrorTextStyle,
    );
  }

  @override
  AppAuthVisualTheme lerp(
    covariant ThemeExtension<AppAuthVisualTheme>? other,
    double t,
  ) {
    if (other is! AppAuthVisualTheme) {
      return this;
    }

    return AppAuthVisualTheme(
      backgroundGradientColors: _lerpColorList(
        backgroundGradientColors,
        other.backgroundGradientColors,
        t,
      ),
      loginHeroGradientColors: _lerpColorList(
        loginHeroGradientColors,
        other.loginHeroGradientColors,
        t,
      ),
      loginHeroLogoGradientColors: _lerpColorList(
        loginHeroLogoGradientColors,
        other.loginHeroLogoGradientColors,
        t,
      ),
      loginHeroLogoShadowColor: _lerpColor(
        loginHeroLogoShadowColor,
        other.loginHeroLogoShadowColor,
        t,
      ),
      loginHeroForegroundColor: _lerpColor(
        loginHeroForegroundColor,
        other.loginHeroForegroundColor,
        t,
      ),
      orbPrimary: _lerpColor(orbPrimary, other.orbPrimary, t),
      orbSecondary: _lerpColor(orbSecondary, other.orbSecondary, t),
      orbTertiary: _lerpColor(orbTertiary, other.orbTertiary, t),
      brandLabelStyle: TextStyle.lerp(
        brandLabelStyle,
        other.brandLabelStyle,
        t,
      )!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      glassSurfaceColor: _lerpColor(
        glassSurfaceColor,
        other.glassSurfaceColor,
        t,
      ),
      glassBorderColor: _lerpColor(glassBorderColor, other.glassBorderColor, t),
      inlineErrorTextStyle: TextStyle.lerp(
        inlineErrorTextStyle,
        other.inlineErrorTextStyle,
        t,
      )!,
    );
  }
}

class AppFTKTheme extends ThemeExtension<AppFTKTheme> {
  const AppFTKTheme({
    required this.primaryButtonColor,
    required this.primaryButtonShadowColor,
    required this.primaryButtonTextStyle,
    required this.categorySelectedBackgroundColor,
    required this.categorySelectedForegroundColor,
    required this.categorySelectedLabelStyle,
    required this.categoryIdleBackgroundColor,
    required this.categoryIdleBorderColor,
    required this.categoryIdleIconColor,
    required this.categoryIdleLabelStyle,
    required this.categoryShadowColor,
    required this.floatingIconBackgroundColor,
    required this.floatingIconForegroundColor,
    required this.floatingIconShadowColor,
    required this.cardBorderColor,
    required this.cardTileShadowColor,
    required this.amenityHighlightedShadowColor,
    required this.sectionTitleStyle,
    required this.sectionActionColor,
    required this.mediaCardTitleStyle,
    required this.mediaCardSubtitleStyle,
    required this.mediaCardPriceStyle,
    required this.mediaCardRatingStyle,
    required this.mediaCardOverlayGradientColors,
    required this.dealCardOverlayGradientColors,
    required this.discountChipBackgroundColor,
    required this.discountChipTextStyle,
    required this.photoCountChipBackgroundColor,
    required this.photoCountChipTextStyle,
    required this.ratingAccentColor,
    required this.hostActionButtonBackgroundColor,
    required this.hostActionButtonShadowColor,
    required this.iconNavyColor,
    required this.tileCornerRadius,
    required this.cardCornerRadius,
    required this.chipCornerRadius,
  });

  final Color primaryButtonColor;
  final Color primaryButtonShadowColor;
  final TextStyle primaryButtonTextStyle;

  final Color categorySelectedBackgroundColor;
  final Color categorySelectedForegroundColor;
  final TextStyle categorySelectedLabelStyle;
  final Color categoryIdleBackgroundColor;
  final Color categoryIdleBorderColor;
  final Color categoryIdleIconColor;
  final TextStyle categoryIdleLabelStyle;
  final Color categoryShadowColor;

  final Color floatingIconBackgroundColor;
  final Color floatingIconForegroundColor;
  final Color floatingIconShadowColor;

  final Color cardBorderColor;
  final Color cardTileShadowColor;
  final Color amenityHighlightedShadowColor;

  final TextStyle sectionTitleStyle;
  final Color sectionActionColor;

  final TextStyle mediaCardTitleStyle;
  final TextStyle mediaCardSubtitleStyle;
  final TextStyle mediaCardPriceStyle;
  final TextStyle mediaCardRatingStyle;
  final List<Color> mediaCardOverlayGradientColors;
  final List<Color> dealCardOverlayGradientColors;

  final Color discountChipBackgroundColor;
  final TextStyle discountChipTextStyle;
  final Color photoCountChipBackgroundColor;
  final TextStyle photoCountChipTextStyle;
  final Color ratingAccentColor;

  final Color hostActionButtonBackgroundColor;
  final Color hostActionButtonShadowColor;
  final Color iconNavyColor;

  final double tileCornerRadius;
  final double cardCornerRadius;
  final double chipCornerRadius;

  @override
  AppFTKTheme copyWith({
    Color? primaryButtonColor,
    Color? primaryButtonShadowColor,
    TextStyle? primaryButtonTextStyle,
    Color? categorySelectedBackgroundColor,
    Color? categorySelectedForegroundColor,
    TextStyle? categorySelectedLabelStyle,
    Color? categoryIdleBackgroundColor,
    Color? categoryIdleBorderColor,
    Color? categoryIdleIconColor,
    TextStyle? categoryIdleLabelStyle,
    Color? categoryShadowColor,
    Color? floatingIconBackgroundColor,
    Color? floatingIconForegroundColor,
    Color? floatingIconShadowColor,
    Color? cardBorderColor,
    Color? cardTileShadowColor,
    Color? amenityHighlightedShadowColor,
    TextStyle? sectionTitleStyle,
    Color? sectionActionColor,
    TextStyle? mediaCardTitleStyle,
    TextStyle? mediaCardSubtitleStyle,
    TextStyle? mediaCardPriceStyle,
    TextStyle? mediaCardRatingStyle,
    List<Color>? mediaCardOverlayGradientColors,
    List<Color>? dealCardOverlayGradientColors,
    Color? discountChipBackgroundColor,
    TextStyle? discountChipTextStyle,
    Color? photoCountChipBackgroundColor,
    TextStyle? photoCountChipTextStyle,
    Color? ratingAccentColor,
    Color? hostActionButtonBackgroundColor,
    Color? hostActionButtonShadowColor,
    Color? iconNavyColor,
    double? tileCornerRadius,
    double? cardCornerRadius,
    double? chipCornerRadius,
  }) {
    return AppFTKTheme(
      primaryButtonColor: primaryButtonColor ?? this.primaryButtonColor,
      primaryButtonShadowColor:
          primaryButtonShadowColor ?? this.primaryButtonShadowColor,
      primaryButtonTextStyle:
          primaryButtonTextStyle ?? this.primaryButtonTextStyle,
      categorySelectedBackgroundColor:
          categorySelectedBackgroundColor ??
          this.categorySelectedBackgroundColor,
      categorySelectedForegroundColor:
          categorySelectedForegroundColor ??
          this.categorySelectedForegroundColor,
      categorySelectedLabelStyle:
          categorySelectedLabelStyle ?? this.categorySelectedLabelStyle,
      categoryIdleBackgroundColor:
          categoryIdleBackgroundColor ?? this.categoryIdleBackgroundColor,
      categoryIdleBorderColor:
          categoryIdleBorderColor ?? this.categoryIdleBorderColor,
      categoryIdleIconColor:
          categoryIdleIconColor ?? this.categoryIdleIconColor,
      categoryIdleLabelStyle:
          categoryIdleLabelStyle ?? this.categoryIdleLabelStyle,
      categoryShadowColor: categoryShadowColor ?? this.categoryShadowColor,
      floatingIconBackgroundColor:
          floatingIconBackgroundColor ?? this.floatingIconBackgroundColor,
      floatingIconForegroundColor:
          floatingIconForegroundColor ?? this.floatingIconForegroundColor,
      floatingIconShadowColor:
          floatingIconShadowColor ?? this.floatingIconShadowColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      cardTileShadowColor: cardTileShadowColor ?? this.cardTileShadowColor,
      amenityHighlightedShadowColor:
          amenityHighlightedShadowColor ?? this.amenityHighlightedShadowColor,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      sectionActionColor: sectionActionColor ?? this.sectionActionColor,
      mediaCardTitleStyle: mediaCardTitleStyle ?? this.mediaCardTitleStyle,
      mediaCardSubtitleStyle:
          mediaCardSubtitleStyle ?? this.mediaCardSubtitleStyle,
      mediaCardPriceStyle: mediaCardPriceStyle ?? this.mediaCardPriceStyle,
      mediaCardRatingStyle: mediaCardRatingStyle ?? this.mediaCardRatingStyle,
      mediaCardOverlayGradientColors:
          mediaCardOverlayGradientColors ?? this.mediaCardOverlayGradientColors,
      dealCardOverlayGradientColors:
          dealCardOverlayGradientColors ?? this.dealCardOverlayGradientColors,
      discountChipBackgroundColor:
          discountChipBackgroundColor ?? this.discountChipBackgroundColor,
      discountChipTextStyle:
          discountChipTextStyle ?? this.discountChipTextStyle,
      photoCountChipBackgroundColor:
          photoCountChipBackgroundColor ?? this.photoCountChipBackgroundColor,
      photoCountChipTextStyle:
          photoCountChipTextStyle ?? this.photoCountChipTextStyle,
      ratingAccentColor: ratingAccentColor ?? this.ratingAccentColor,
      hostActionButtonBackgroundColor:
          hostActionButtonBackgroundColor ??
          this.hostActionButtonBackgroundColor,
      hostActionButtonShadowColor:
          hostActionButtonShadowColor ?? this.hostActionButtonShadowColor,
      iconNavyColor: iconNavyColor ?? this.iconNavyColor,
      tileCornerRadius: tileCornerRadius ?? this.tileCornerRadius,
      cardCornerRadius: cardCornerRadius ?? this.cardCornerRadius,
      chipCornerRadius: chipCornerRadius ?? this.chipCornerRadius,
    );
  }

  @override
  AppFTKTheme lerp(covariant ThemeExtension<AppFTKTheme>? other, double t) {
    if (other is! AppFTKTheme) {
      return this;
    }

    return AppFTKTheme(
      primaryButtonColor: _lerpColor(
        primaryButtonColor,
        other.primaryButtonColor,
        t,
      ),
      primaryButtonShadowColor: _lerpColor(
        primaryButtonShadowColor,
        other.primaryButtonShadowColor,
        t,
      ),
      primaryButtonTextStyle: TextStyle.lerp(
        primaryButtonTextStyle,
        other.primaryButtonTextStyle,
        t,
      )!,
      categorySelectedBackgroundColor: _lerpColor(
        categorySelectedBackgroundColor,
        other.categorySelectedBackgroundColor,
        t,
      ),
      categorySelectedForegroundColor: _lerpColor(
        categorySelectedForegroundColor,
        other.categorySelectedForegroundColor,
        t,
      ),
      categorySelectedLabelStyle: TextStyle.lerp(
        categorySelectedLabelStyle,
        other.categorySelectedLabelStyle,
        t,
      )!,
      categoryIdleBackgroundColor: _lerpColor(
        categoryIdleBackgroundColor,
        other.categoryIdleBackgroundColor,
        t,
      ),
      categoryIdleBorderColor: _lerpColor(
        categoryIdleBorderColor,
        other.categoryIdleBorderColor,
        t,
      ),
      categoryIdleIconColor: _lerpColor(
        categoryIdleIconColor,
        other.categoryIdleIconColor,
        t,
      ),
      categoryIdleLabelStyle: TextStyle.lerp(
        categoryIdleLabelStyle,
        other.categoryIdleLabelStyle,
        t,
      )!,
      categoryShadowColor: _lerpColor(
        categoryShadowColor,
        other.categoryShadowColor,
        t,
      ),
      floatingIconBackgroundColor: _lerpColor(
        floatingIconBackgroundColor,
        other.floatingIconBackgroundColor,
        t,
      ),
      floatingIconForegroundColor: _lerpColor(
        floatingIconForegroundColor,
        other.floatingIconForegroundColor,
        t,
      ),
      floatingIconShadowColor: _lerpColor(
        floatingIconShadowColor,
        other.floatingIconShadowColor,
        t,
      ),
      cardBorderColor: _lerpColor(cardBorderColor, other.cardBorderColor, t),
      cardTileShadowColor: _lerpColor(
        cardTileShadowColor,
        other.cardTileShadowColor,
        t,
      ),
      amenityHighlightedShadowColor: _lerpColor(
        amenityHighlightedShadowColor,
        other.amenityHighlightedShadowColor,
        t,
      ),
      sectionTitleStyle: TextStyle.lerp(
        sectionTitleStyle,
        other.sectionTitleStyle,
        t,
      )!,
      sectionActionColor: _lerpColor(
        sectionActionColor,
        other.sectionActionColor,
        t,
      ),
      mediaCardTitleStyle: TextStyle.lerp(
        mediaCardTitleStyle,
        other.mediaCardTitleStyle,
        t,
      )!,
      mediaCardSubtitleStyle: TextStyle.lerp(
        mediaCardSubtitleStyle,
        other.mediaCardSubtitleStyle,
        t,
      )!,
      mediaCardPriceStyle: TextStyle.lerp(
        mediaCardPriceStyle,
        other.mediaCardPriceStyle,
        t,
      )!,
      mediaCardRatingStyle: TextStyle.lerp(
        mediaCardRatingStyle,
        other.mediaCardRatingStyle,
        t,
      )!,
      mediaCardOverlayGradientColors: _lerpColorList(
        mediaCardOverlayGradientColors,
        other.mediaCardOverlayGradientColors,
        t,
      ),
      dealCardOverlayGradientColors: _lerpColorList(
        dealCardOverlayGradientColors,
        other.dealCardOverlayGradientColors,
        t,
      ),
      discountChipBackgroundColor: _lerpColor(
        discountChipBackgroundColor,
        other.discountChipBackgroundColor,
        t,
      ),
      discountChipTextStyle: TextStyle.lerp(
        discountChipTextStyle,
        other.discountChipTextStyle,
        t,
      )!,
      photoCountChipBackgroundColor: _lerpColor(
        photoCountChipBackgroundColor,
        other.photoCountChipBackgroundColor,
        t,
      ),
      photoCountChipTextStyle: TextStyle.lerp(
        photoCountChipTextStyle,
        other.photoCountChipTextStyle,
        t,
      )!,
      ratingAccentColor: _lerpColor(
        ratingAccentColor,
        other.ratingAccentColor,
        t,
      ),
      hostActionButtonBackgroundColor: _lerpColor(
        hostActionButtonBackgroundColor,
        other.hostActionButtonBackgroundColor,
        t,
      ),
      hostActionButtonShadowColor: _lerpColor(
        hostActionButtonShadowColor,
        other.hostActionButtonShadowColor,
        t,
      ),
      iconNavyColor: _lerpColor(iconNavyColor, other.iconNavyColor, t),
      tileCornerRadius: lerpDouble(
        tileCornerRadius,
        other.tileCornerRadius,
        t,
      )!,
      cardCornerRadius: lerpDouble(
        cardCornerRadius,
        other.cardCornerRadius,
        t,
      )!,
      chipCornerRadius: lerpDouble(
        chipCornerRadius,
        other.chipCornerRadius,
        t,
      )!,
    );
  }
}

class AppShellNavigationTheme extends ThemeExtension<AppShellNavigationTheme> {
  const AppShellNavigationTheme({required this.bottomTabInactiveColor});

  final Color bottomTabInactiveColor;

  @override
  AppShellNavigationTheme copyWith({Color? bottomTabInactiveColor}) {
    return AppShellNavigationTheme(
      bottomTabInactiveColor:
          bottomTabInactiveColor ?? this.bottomTabInactiveColor,
    );
  }

  @override
  AppShellNavigationTheme lerp(
    covariant ThemeExtension<AppShellNavigationTheme>? other,
    double t,
  ) {
    if (other is! AppShellNavigationTheme) {
      return this;
    }

    return AppShellNavigationTheme(
      bottomTabInactiveColor: _lerpColor(
        bottomTabInactiveColor,
        other.bottomTabInactiveColor,
        t,
      ),
    );
  }
}

extension AppThemeLookup on ThemeData {
  AppSemanticColorTheme get appColors => extension<AppSemanticColorTheme>()!;

  AppSemanticTextTheme get appTextTheme => extension<AppSemanticTextTheme>()!;
}

extension AppBuildContextThemeLookup on BuildContext {
  AppSemanticColorTheme get appColors => Theme.of(this).appColors;

  AppSemanticTextTheme get appTextTheme => Theme.of(this).appTextTheme;
}
