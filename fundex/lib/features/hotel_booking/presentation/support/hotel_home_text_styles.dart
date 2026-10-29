import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

abstract final class HotelHomeTextStyles {
  static TextStyle pageTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);
  static TextStyle hotelName(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
  static TextStyle sectionTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold);
  static TextStyle brandWordmark(BuildContext context) =>
      context.appTextTheme.numericTitle.copyWith(fontSize: 18);
  static TextStyle milesValue(BuildContext context) =>
      context.appTextTheme.numericTitle.copyWith(fontSize: 24);
}
