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
