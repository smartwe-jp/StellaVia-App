import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Figma membership palette. Colors communicate rank, never derive eligibility.
class MyPageRankTheme {
  static Color surface(BuildContext context, String rank) =>
      switch (rank.toUpperCase()) {
        'REGULAR' => const Color(0xFF070E2B),
        'BRONZE' => const Color(0xFFA85929),
        'SILVER' => const Color(0xFF687184),
        'GOLD' => const Color(0xFF91723D),
        'MASTER' => const Color(0xFF65358B),
        _ => context.appColors.primary,
      };
  static TextStyle gapLabel(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 12);
  static TextStyle gapValue(BuildContext c) => c.appTextTheme.numericBody
      .copyWith(fontSize: 15, fontWeight: FontWeight.w600);
  static TextStyle label(BuildContext c) => c.appTextTheme.caption.copyWith(
    fontSize: 12,
    color: c.appColors.onDark.withValues(alpha: .85),
  );
  static TextStyle rank(BuildContext c) => c.appTextTheme.numericBody.copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.4,
    color: c.appColors.onDark,
  );
  static TextStyle metric(BuildContext c) =>
      c.appTextTheme.numericBody.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: c.appColors.onDark,
      );
  static TextStyle room(BuildContext c) => c.appTextTheme.numericBody.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static TextStyle small(BuildContext c) =>
      c.appTextTheme.meta.copyWith(fontSize: 11);
}
