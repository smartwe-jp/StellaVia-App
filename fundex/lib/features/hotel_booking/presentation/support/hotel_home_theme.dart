import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Figma Bronze summary palette, scoped to the host-miles design preview.
abstract final class HotelHomeTheme {
  static Color bronzeSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? const Color(0xFFF5F2EE)
      : context.appColors.surfaceAlt;
  static Color bronzeInk(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? const Color(0xFFA85A2A)
      : context.appColors.textPrimary;
}
