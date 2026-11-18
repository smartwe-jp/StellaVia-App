import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Shared type hierarchy for reservations and check-in.
abstract final class HotelOrderTextStyles {
  static TextStyle pageTitle(BuildContext context) => context
      .appTextTheme
      .sectionTitle
      .copyWith(fontSize: 17, fontWeight: FontWeight.w700);
  static TextStyle hotelName(BuildContext context) => context
      .appTextTheme
      .bodyStrong
      .copyWith(fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle heading(BuildContext context) => context
      .appTextTheme
      .bodyStrong
      .copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static TextStyle label(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle value(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 13, fontWeight: FontWeight.w400);
  static TextStyle amount(BuildContext context) => context
      .appTextTheme
      .numericTitle
      .copyWith(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle action(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 14, fontWeight: FontWeight.w500);
}
