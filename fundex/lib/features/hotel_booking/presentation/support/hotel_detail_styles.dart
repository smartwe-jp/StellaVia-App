import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Typography for 04 ホテル詳細, derived from the app's locale-aware fonts.
abstract final class HotelDetailStyles {
  static TextStyle title(BuildContext c) =>
      c.appTextTheme.pageTitle.copyWith(fontSize: 26, height: 1.4);
  static TextStyle heading(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(fontSize: 17);
  static TextStyle body(BuildContext c) => c.appTextTheme.body.copyWith(
    fontSize: 16,
    height: 1.75,
    color: c.appColors.textSecondary,
  );
  static TextStyle label(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(fontSize: 16);
  static TextStyle caption(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 12);
  static TextStyle spec(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 11);
  static TextStyle amount(BuildContext c) => c.appTextTheme.numericBody
      .copyWith(fontSize: 18, color: c.appColors.primary);
  static TextStyle rooms(BuildContext c) => c.appTextTheme.numericBody.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.68,
    color: c.appColors.primary,
  );
  static Color summary(BuildContext c) =>
      Theme.of(c).brightness == Brightness.light
      ? const Color(0xFFFAF7FF)
      : c.appColors.primarySubtle;
  static Color chipBorder(BuildContext c) =>
      Theme.of(c).brightness == Brightness.light
      ? const Color(0xFFE8D9F5)
      : c.appColors.border;
}
