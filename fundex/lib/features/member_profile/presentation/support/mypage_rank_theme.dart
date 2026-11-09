import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../host_miles/presentation/support/host_miles_rank_theme.dart';

/// Figma membership palette. Colors communicate rank, never derive eligibility.
class MyPageRankTheme {
  static Color inkOn(Color background) {
    final luminance = background.computeLuminance();
    final navyContrast =
        (luminance + .05) / (HostMilesRankTheme.ink.computeLuminance() + .05);
    final whiteContrast = 1.05 / (luminance + .05);
    return navyContrast > whiteContrast
        ? HostMilesRankTheme.ink
        : AppColorTokens.brandWhite;
  }

  static TextStyle gapLabel(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 12);
  static TextStyle gapValue(BuildContext c) => c.appTextTheme.numericBody
      .copyWith(fontSize: 15, fontWeight: FontWeight.w600);
  static TextStyle label(BuildContext c, Color ink) =>
      c.appTextTheme.caption.copyWith(fontSize: 12, color: ink);
  static TextStyle rank(BuildContext c, Color ink) =>
      c.appTextTheme.numericBody.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
        color: ink,
      );
  static TextStyle metric(BuildContext c, Color ink) => c
      .appTextTheme
      .numericBody
      .copyWith(fontSize: 20, fontWeight: FontWeight.w500, color: ink);
  static TextStyle room(BuildContext c) => c.appTextTheme.numericBody.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static TextStyle small(BuildContext c) =>
      c.appTextTheme.meta.copyWith(fontSize: 11);
}
