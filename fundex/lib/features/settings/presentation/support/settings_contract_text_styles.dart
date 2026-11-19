import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Compact document typography; retains the app's locale-aware font families.
abstract final class SettingsContractTextStyles {
  static TextStyle description(BuildContext context) =>
      Theme.of(context).appTextTheme.body.copyWith(fontSize: 13);

  static TextStyle projectTitle(BuildContext context) =>
      Theme.of(context).appTextTheme.pageTitle.copyWith(fontSize: 16);

  static TextStyle sectionTitle(BuildContext context) =>
      Theme.of(context).appTextTheme.sectionTitle.copyWith(fontSize: 14);

  static TextStyle fileTitle(BuildContext context) =>
      Theme.of(context).appTextTheme.bodySemi.copyWith(fontSize: 13);
}
