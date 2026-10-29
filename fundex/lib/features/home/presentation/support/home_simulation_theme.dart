import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Scoped Figma frame 8190:2037 tokens. Dark mode uses the existing app surface.
abstract final class HomeSimulationTheme {
  static AppSegmentedControlStyle segments(BuildContext c) =>
      AppSegmentedControlStyle(
        backgroundColor: c.appColors.surfaceAlt,
        selectedBackgroundColor: c.appColors.surface,
        border: const Border.fromBorderSide(BorderSide.none),
        shadows: const [],
        padding: const EdgeInsets.all(3),
        itemPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        radius: 12,
        selectedRadius: 10,
        selectedTextStyle: inputLabel(
          c,
        ).copyWith(fontWeight: FontWeight.w700, color: c.appColors.primary),
        unselectedTextStyle: inputLabel(c).copyWith(
          fontWeight: FontWeight.w700,
          color: c.appColors.textSecondary,
        ),
        captionStyle: bound(c),
      );
  static Color background(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
      ? c.appColors.background
      : const Color(0xFFF5F5F0);
  static const resultSurface = Color(0xFF080D2B);
  static const resultAccent = Color(0xFFD9B8F2);
  static TextStyle inputLabel(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 13);
  static TextStyle inputNumber(BuildContext c) =>
      c.appTextTheme.numericTitle.copyWith(fontSize: 22);
  static TextStyle inputUnit(BuildContext c) =>
      c.appTextTheme.body.copyWith(fontSize: 12);
  static TextStyle bound(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 10);
  static TextStyle resultEyebrow(BuildContext c) =>
      bound(c).copyWith(color: resultAccent, letterSpacing: 2);
  static TextStyle resultSectionTitle(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(color: c.appColors.onDark);
  static TextStyle resultLabel(BuildContext c) => c.appTextTheme.body.copyWith(
    fontSize: 13,
    color: c.appColors.onDark.withValues(alpha: .8),
  );
  static TextStyle resultNumber(
    BuildContext c, {
    bool prominent = false,
    bool miles = false,
  }) => c.appTextTheme.numericTitle.copyWith(
    fontSize: prominent ? 22 : 18,
    color: miles ? resultAccent : c.appColors.onDark,
  );
}
