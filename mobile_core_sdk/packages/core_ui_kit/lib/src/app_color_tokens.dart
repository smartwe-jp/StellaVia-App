import 'package:flutter/material.dart';

class AppColorTokens {
  const AppColorTokens._();

  // FUNDEX core palette (from demo source)
  static const Color fundexPrimaryDark = Color(0xFF0A1628);
  static const Color fundexPrimaryDarkDradient = Color(0xFF1E3A5F);
  static const Color fundexPrimaryDarkAlt = Color(0xFF142240);
  static const Color fundexAccent = Color(0xFF2563EB);
  static const Color fundexAccentLight = Color(0xFFDBEAFE);
  static const Color fundexAccentSuperLight = Color(0xFFEFF6FF);
  static const Color fundexAccentDradient = Color(0xFF60A5FA);
  static const Color fundexAccentAlt = Color(0xFF3B82F6);
  static const Color fundexSuccess = Color(0xFF10B981);
  static const Color fundexSuccessLight = Color(0xFFD1FAE5);
  static const Color fundexDanger = Color(0xFFEF4444);
  static const Color fundexDangerLight = Color(0xFFFEE2E2);
  static const Color fundexWarning = Color(0xFFF59E0B);
  static const Color fundexWarningLight = Color(0xFFFEF3C7);
  static const Color fundexViolet = Color(0xFF8B5CF6);
  static const Color fundexVioletLight = Color(0xFFEDE9FE);
  static const Color fundexPink = Color(0xFFEC4899);
  static const Color fundexPinkLight = Color(0xFFFCE7F3);
  static const Color kizunarkPrimary = Color(0xFF6366F1);
  static const Color kizunarkSecondary = Color(0xFF8B5CF6);
  static const Color kizunarkPrimaryLight = Color(0xFFEDE9FE);
  static const Color fundexBackground = Color(0xFFF8FAFC);
  static const Color fundexSurface = Color(0xFFFFFFFF);
  static const Color fundexBorder = Color(0xFFE2E8F0);
  static const Color fundexText = Color(0xFF0F172A);
  static const Color fundexTextSecondary = Color(0xFF475569);
  static const Color fundexTextTertiary = Color(0xFF94A3B8);

  // Semantic aliases used across the app.
  static const Color accent = fundexAccent;
  static const Color accentSecondary = fundexSuccess;
  static const Color accentTertiary = fundexAccentAlt;

  static const Color lightBackground = fundexBackground;
  static const Color lightSurface = fundexSurface;
  static const Color lightOnSurface = fundexText;
  static const Color lightMuted = fundexTextSecondary;
  static const Color lightBorder = fundexBorder;

  // Dark palette derived from FUNDEX brand tones.
  static const Color darkBackground = fundexPrimaryDark;
  static const Color darkSurface = fundexPrimaryDarkAlt;
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // System UI status bar palette.
  // Keep light/dark entries separated for future adjustments; currently same.
  static const Color statusBarBackgroundLight = fundexPrimaryDark;
  static const Color statusBarBackgroundDark = fundexPrimaryDark;

  static const Color danger = fundexDanger;
  static const Color warning = fundexWarning;

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
