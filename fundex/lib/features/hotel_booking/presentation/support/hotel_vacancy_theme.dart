import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

abstract final class HotelVacancyTheme {
  static Color textColor(BuildContext context, int count) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.appColors;
    if (count <= 0) return dark ? colors.textTertiary : const Color(0xFF777777);
    if (count <= 3) {
      return dark ? colors.warningForeground : const Color(0xFFB86A1A);
    }
    return dark ? colors.successForeground : const Color(0xFF23825B);
  }
}
