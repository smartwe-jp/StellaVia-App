import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Typography for the mobile reservation confirmation flow.
abstract final class HotelBookingTextStyles {
  static TextStyle heading(BuildContext context) => context
      .appTextTheme
      .bodyStrong
      .copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static TextStyle label(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle value(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 13, fontWeight: FontWeight.w400);
  static TextStyle count(BuildContext context) => context
      .appTextTheme
      .numericBody
      .copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle total(BuildContext context) => context
      .appTextTheme
      .numericTitle
      .copyWith(fontSize: 18, fontWeight: FontWeight.w600);
}
