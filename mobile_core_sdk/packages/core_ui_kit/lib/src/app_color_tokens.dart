import 'package:flutter/material.dart';

class AppColorTokens {
  const AppColorTokens._();

  // StellaVia Figma guideline (2026-10-16). Brand colors are invariant;
  // use AppSemanticColorTheme for brightness-aware UI colors.
  static const Color brandNavy = Color(0xFF070E2B);
  static const Color brandPurple = Color(0xFF4C0679);
  static const Color brandViolet = Color(0xFF9652C2);
  static const Color brandLilac = Color(0xFFC8ABE2);
  static const Color brandPrimary = brandPurple;
  static const Color brandPrimaryDark = brandNavy;
  static const Color brandPrimaryBright = brandViolet;
  static const Color brandBaseCream = Color(0xFFEEE9E1);
  static const Color brandBaseCreamLight = Color(0xFFF6F4F0);
  static const Color brandBaseCreamLighter = Color(0xFFFAF9F7);
  static const Color brandSecondaryTeal = brandViolet;
  static const Color brandAlert = Color(0xFFF9675F);
  static const Color brandNeutral = Color(0xFFE7E7E7);
  static const Color brandWhite = Color(0xFFFFFFFF);

  // Legacy FUNDEX aliases remapped to the current corporate palette.
  // Keep these names for compatibility so the app can switch brand colors
  // from a single file instead of touching component code.
  static const Color fundexPrimaryDark = brandPrimaryDark;
  static const Color fundexPrimaryDarkDradient = brandNavy;
  static const Color fundexPrimaryDarkAlt = brandNavy;
  static const Color fundexAccent = brandPrimary;
  static const Color fundexAccentLight = Color(0xFFEFE8F4);
  static const Color fundexAccentSuperLight = Color(0xFFF8F4FB);
  static const Color fundexAccentDradient = brandPrimaryBright;
  static const Color fundexAccentAlt = brandPrimaryBright;
  static const Color fundexSuccess = Color(0xFF10B981);
  static const Color fundexSuccessLight = Color(0xFFD1FAE5);
  static const Color fundexDanger = brandAlert;
  static const Color fundexDangerLight = Color(0xFFFFECEB);
  static const Color fundexWarning = Color(0xFFF59E0B);
  static const Color fundexWarningLight = Color(0xFFFEF3C7);
  static const Color fundexViolet = brandViolet;
  static const Color fundexVioletLight = Color(0xFFEDE9FE);
  static const Color fundexPink = Color(0xFFEC4899);
  static const Color fundexPinkLight = Color(0xFFFCE7F3);
  static const Color kizunarkPrimary = brandPrimary;
  static const Color kizunarkSecondary = brandPrimaryBright;
  static const Color kizunarkPrimaryLight = fundexAccentSuperLight;
  // White pages/cards with cream reserved for alternate surfaces.
  static const Color fundexBackground = brandWhite;
  static const Color fundexSurface = brandWhite;
  static const Color fundexSurfaceAlt = brandBaseCream;
  static const Color fundexBorder = Color(0x24070E2B);
  static const Color fundexBorderSoft = Color(0x1A070E2B);
  static const Color fundexText = brandNavy;
  static const Color fundexTextSecondary = Color(0xFF5C6070);
  static const Color fundexTextTertiary = Color(0xFF6B6F80);
  static const Color fundexDisabled = Color(0xFFCBD5E1);
  static const Color fundexHighlightGold = Color(0xFF9C6A10);
  static const Color fundexBaseCream = brandBaseCream;
  static const Color fundexSurfaceInverse = Color(0xFF1E293B);
  static const Color fundexSurfaceInverseAlt = Color(0xFF334155);

  // Semantic aliases used across the app.
  static const Color accent = fundexAccent;
  static const Color accentSecondary = fundexSuccess;
  static const Color accentTertiary = fundexAccentAlt;

  static const Color lightBackground = fundexBackground;
  static const Color lightSurface = fundexSurface;
  static const Color lightOnSurface = fundexText;
  static const Color lightMuted = fundexTextSecondary;
  static const Color lightBorder = fundexBorder;
  static const Color lightSurfaceAlt = fundexSurfaceAlt;
  static const Color lightBorderSoft = fundexBorderSoft;

  // App adaptation: the Figma guideline currently specifies light mode only.
  // Layer navy surfaces and reserve lilac for readable links on dark surfaces.
  static const Color darkBackground = Color(0xFF070E2B);
  static const Color darkSurface = Color(0xFF10162E);
  static const Color darkSurfaceAlt = Color(0xFF1B2038);
  static const Color darkOnSurface = Color(0xFFF6F4F8);
  static const Color darkMuted = Color(0xFFB9B6C8);
  static const Color darkBorder = Color(0xFF45465A);
  static const Color darkBorderSoft = Color(0xFF33364C);

  // System UI status bar palette.
  // Default pages use a light status bar; immersive pages own their overlay.
  static const Color statusBarBackgroundLight = brandWhite;
  static const Color statusBarBackgroundDark = darkBackground;

  static const Color danger = fundexDanger;
  static const Color warning = fundexWarning;
  static const Color info = fundexAccent;
  static const Color infoLight = fundexAccentLight;
  static const Color infoSoft = fundexAccentSuperLight;
  static const Color infoBorder = Color(0xFFC8ABE2);
  static const Color infoStrong = Color(0xFF4C0679);
  static const Color infoText = Color(0xFF4C0679);
  static const Color successSoft = Color(0xFFF0FDF4);
  static const Color successBorder = Color(0xFFA7F3D0);
  static const Color successStrong = Color(0xFF047857);
  static const Color warningSoft = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFCD34D);
  static const Color warningStrong = Color(0xFF92400E);
  static const Color warningText = Color(0xFFA16207);
  static const Color warningAction = Color(0xFFD97706);
  static const Color dangerSoft = Color(0xFFFFF1F2);
  static const Color dangerSoftAlt = Color(0xFFFEF2F2);
  static const Color dangerBorder = Color(0xFFFCA5A5);
  static const Color dangerStrong = Color(0xFFDC2626);
  static const Color dangerText = Color(0xFF991B1B);

  // Funding semantic aliases.
  static const Color fundingPrimary = fundexAccent;
  static const Color fundingPrimaryAlt = fundexAccentAlt;

  // Figma inspiration palette (Hotel Management UI - Community)
  // Extracted from the referenced design nodes to build reusable travel widgets.
  static const Color travelPrimaryBlue = Color(0xFF1AA7FF);
  static const Color travelPrimaryBlueAlt = Color(0xFF18A8FE);
  static const Color travelRatingOrange = Color(0xFFFE8814);
  static const Color travelFabOrange = Color(0xFFFF930C);
  static const Color travelDiscountCoral = Color(0xFFFF7D56);
  static const Color travelLinkGold = Color(0xFFD99221);
  static const Color travelTextStrong = Color(0xFF1B1A1A);
  static const Color travelIconNavy = Color(0xFF1C274C);
  static const Color travelTextMuted = Color(0xFF75747A);
  static const Color travelTextSubtle = Color(0xFF9A999E);
  static const Color travelBodyMuted = Color(0xFF8C8B8B);
  static const Color travelBorderSoft = Color(0xFFF4F4F4);
  static const Color travelDividerSoft = Color(0xFFECEBEB);
  static const Color travelShadowBlue = Color(0xFFB6D3FF);
  static const Color travelShadowOrange = Color(0xFFFFC588);
  static const Color travelOverlayWarm = Color(0xFFA7643E);
  static const Color travelOverlayCharcoal = Color(0xFF232321);
  static const Color travelOverlayCool = Color(0xFF333941);
  static const Color travelOverlayBlackSoft = Color(0xFF1D1D1C);

  // Kept for compatibility with existing auth/hotel widgets.
  static const Color travelPrimaryTeal = fundingPrimary;
}
