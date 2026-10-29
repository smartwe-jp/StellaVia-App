import 'package:flutter/material.dart';
import 'app_theme_extensions.dart';

/// Shared typography for captioned selection controls.
abstract final class AppControlStyles {
  static TextStyle segmentLabel(
    BuildContext context, {
    required bool selected,
  }) => context.appTextTheme.caption.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: selected
        ? context.appColors.primary
        : context.appColors.textSecondary,
  );
  static TextStyle segmentCaption(BuildContext context) =>
      context.appTextTheme.caption.copyWith(fontSize: 10);
}
