import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

abstract final class HotelRoomDetailTextStyles {
  static TextStyle title(BuildContext context) => context
      .appTextTheme
      .bodyStrong
      .copyWith(fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle heading(BuildContext context) => context
      .appTextTheme
      .bodyStrong
      .copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static TextStyle fact(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 13, fontWeight: FontWeight.w400);
  static TextStyle facility(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle body(BuildContext context) => context.appTextTheme.body
      .copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.6);
}
