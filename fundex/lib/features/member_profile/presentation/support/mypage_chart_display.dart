import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mypage_chart.dart';

class MyPageChartDisplay {
  static String title(AppLocalizations l, MyPageChartKind kind) =>
      switch (kind) {
        MyPageChartKind.operating => l.myPageChartOperating,
        MyPageChartKind.dividends => l.myPageChartDividends,
        MyPageChartKind.miles => l.myPageChartMilesBalance,
        MyPageChartKind.available => l.myPageChartAvailable,
      };
  static String amount(num? value, String locale) =>
      value == null ? '—' : NumberFormat.decimalPattern(locale).format(value);

  static const ringColors = [
    AppColorTokens.brandViolet,
    AppColorTokens.brandPurple,
    AppColorTokens.brandLilac,
    Color(0xFF7B4FA0),
    Color(0xFFA67BC8),
    Color(0xFF5A2A8A),
    Color(0xFFD4BFE8),
  ];

  static String axisValue(double value, MyPageChartKind kind, String locale) {
    if (kind == MyPageChartKind.dividends) {
      final thousands = value / 1000;
      return NumberFormat(
        thousands >= 1 ? '#,##0' : '0.0',
        locale,
      ).format(thousands);
    }
    final magnitude = value.abs();
    final format = NumberFormat('0.#', locale);
    if (magnitude >= 1e8) return '${format.format(value / 1e8)}億';
    if (magnitude >= 1e4) return '${format.format(value / 1e4)}万';
    if (magnitude >= 1e3) return '${format.format(value / 1e3)}k';
    return NumberFormat('0', locale).format(value);
  }
}

/// Figma summary chart typography, based on the shared theme font families.
class MyPageChartStyles {
  static TextStyle title(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(fontSize: 14);
  static TextStyle amount(BuildContext c) => c.appTextTheme.numericBody
      .copyWith(fontSize: 26, fontWeight: FontWeight.w500);
  static TextStyle unit(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 13);
  static TextStyle range(BuildContext c) => c.appTextTheme.caption.copyWith(
    fontSize: 12,
    height: 1,
    fontWeight: FontWeight.w700,
    color: c.appColors.textPrimary,
  );
  static TextStyle axis(BuildContext c) => c.appTextTheme.numericCaption
      .copyWith(fontSize: 10, color: c.appColors.textSecondary);
}
