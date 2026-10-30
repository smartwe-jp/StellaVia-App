import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Feature-only Figma surface and decorative rank colors; not account tiers.
abstract final class HomeDesignTheme {
  static Color background(BuildContext context) => context.appColors.background;
  static const guestGradient = [
    Color(0xFF3B3029),
    Color(0xFF6B5240),
    Color(0xFFB59980),
  ];
  static const rankHeaders = [
    Color(0xFFE6E1D8),
    Color(0xFFAC5728),
    Color(0xFF8D9096),
    Color(0xFF9C6A10),
    Color(0xFF3A0A5C),
  ];
  static const rankSurfaces = [
    Color(0xFFF6F4F0),
    Color(0xFFF4EBE3),
    Color(0xFFEFF0F2),
    Color(0xFFF4EDE1),
    Color(0xFFEFE8F4),
  ];
  // Full information cards use the palette in frames 14 and 15.
  static const detailRankHeaders = [
    Color(0xFF070E2B),
    Color(0xFFA85A2A),
    Color(0xFF687184),
    Color(0xFF91723D),
    Color(0xFF65358B),
  ];
  static const rankInk = Color(0xFF070E2B);
  static const rankOnDark = Color(0xFFFFFFFF);
}
