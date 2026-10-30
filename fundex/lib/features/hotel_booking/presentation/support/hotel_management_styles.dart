import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// 07 宿泊管理 typography and card tones, with existing dark-theme adaptation.
abstract final class HotelManagementStyles {
  static TextStyle title(BuildContext c) => c.appTextTheme.pageTitle.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );
  static TextStyle label(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(fontSize: 14);
  static TextStyle nextTitle(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(fontSize: 15);
  static TextStyle caption(BuildContext c) => c.appTextTheme.caption.copyWith(
    fontSize: 12,
    color: c.appColors.textSecondary,
  );
  static TextStyle count(BuildContext c) => c.appTextTheme.numericBody.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: c.appColors.primary,
  );
  static Color capacityBackground(BuildContext c) =>
      Theme.of(c).brightness == Brightness.light
      ? const Color(0xFFFAF7FF)
      : c.appColors.primarySubtle;
  static Color capacityBorder(BuildContext c) =>
      Theme.of(c).brightness == Brightness.light
      ? const Color(0xFFE8D9F5)
      : c.appColors.border;
}
