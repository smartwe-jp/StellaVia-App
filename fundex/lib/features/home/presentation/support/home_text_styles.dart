import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Typography roles for the redesigned home and information sections.
abstract final class HomeTextStyles {
  static TextStyle greeting(BuildContext context) =>
      context.appTextTheme.sectionTitle.copyWith(fontSize: 19);
  static TextStyle caption(BuildContext context) =>
      context.appTextTheme.caption.copyWith(fontSize: 12);
  static TextStyle heroEyebrow(
    BuildContext context, {
    required bool isAuthenticated,
  }) => context.appTextTheme.numericCaption.copyWith(
    fontSize: 10,
    letterSpacing: isAuthenticated ? 0 : 3,
  );
  static TextStyle heroTitle(BuildContext context) =>
      context.appTextTheme.sectionTitle.copyWith(fontSize: 22);
  static TextStyle compactAction(BuildContext context) =>
      context.appTextTheme.micro.copyWith(fontSize: 11);
  static TextStyle brandWordmark(
    BuildContext context, {
    required bool isAuthenticated,
  }) => context.appTextTheme.numericTitle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: isAuthenticated ? 0 : 4.8,
  );
  static TextStyle simulationEyebrow(BuildContext context) => context
      .appTextTheme
      .numericCaption
      .copyWith(fontSize: 10, letterSpacing: 2);
  static TextStyle entryTitle(BuildContext context) =>
      context.appTextTheme.bodyStrong.copyWith(fontSize: 15);
  static TextStyle smallLink(BuildContext context) =>
      context.appTextTheme.link.copyWith(fontSize: 11);
  static TextStyle sectionLink(BuildContext context) =>
      context.appTextTheme.link.copyWith(fontSize: 13);
  static TextStyle rankPreviewEyebrow(BuildContext context) => context
      .appTextTheme
      .numericCaption
      .copyWith(fontSize: 8, letterSpacing: 1.2);
  static TextStyle rankPreviewName(BuildContext context) =>
      context.appTextTheme.numericBody.copyWith(fontSize: 14);
  static TextStyle rankEyebrow(BuildContext context) =>
      context.appTextTheme.caption.copyWith(fontSize: 11, letterSpacing: 1.32);
  static TextStyle rankName(BuildContext context) => context
      .appTextTheme
      .numericTitle
      .copyWith(fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle rankMetricLabel(BuildContext context) =>
      context.appTextTheme.caption.copyWith(fontSize: 12, height: 1.2);
  static TextStyle rankRate(BuildContext context) => context
      .appTextTheme
      .numericTitle
      .copyWith(fontSize: 32, height: 1, fontWeight: FontWeight.w700);
  static TextStyle rankMetricValue(BuildContext context) =>
      context.appTextTheme.bodyStrong.copyWith(fontSize: 14, height: 1.2);
  static TextStyle groupTitle(BuildContext context) =>
      context.appTextTheme.bodyStrong.copyWith(fontSize: 12);
  static TextStyle readingBody(BuildContext context) =>
      context.appTextTheme.body.copyWith(fontSize: 15, height: 2);
  static TextStyle returnEyebrow(BuildContext context) => context
      .appTextTheme
      .numericCaption
      .copyWith(fontSize: 12, letterSpacing: 1.8);
  static TextStyle returnTitle(BuildContext context) =>
      context.appTextTheme.sectionTitle.copyWith(fontSize: 20);
  static TextStyle stepNumber(BuildContext context) =>
      context.appTextTheme.numericTitle.copyWith(fontSize: 26);
  static TextStyle stepTitle(BuildContext context) =>
      context.appTextTheme.bodyStrong.copyWith(fontSize: 16);
  static TextStyle stepDescription(BuildContext context) =>
      context.appTextTheme.caption.copyWith(fontSize: 12, height: 5 / 3);
}
