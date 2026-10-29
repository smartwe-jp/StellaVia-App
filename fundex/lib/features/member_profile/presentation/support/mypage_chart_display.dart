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
        MyPageChartKind.miles => l.myPageChartMiles,
      };
  static String amount(num? value, String locale) =>
      value == null ? '—' : NumberFormat.decimalPattern(locale).format(value);

  /// Cumulative series: show last observed balance in each year/month, never sum balances.
  static List<MyPageChartPoint> bars(MyPageChartData data, int years) {
    final buckets = <int, MyPageChartPoint>{};
    for (final p in data.points) {
      buckets[years == 1 ? p.date.month : p.date.year] = p;
    }
    return buckets.values.toList();
  }

  static List<String> labels(MyPageChartData data, int years) => years == 1
      ? [
          for (final m in [1, 4, 7, 10, 12]) '$m',
        ]
      : [for (var y = data.start.year; y <= data.end.year; y++) '$y'];
}

/// Figma summary chart typography, based on the shared theme font families.
class MyPageChartStyles {
  static TextStyle title(BuildContext c) =>
      c.appTextTheme.bodyStrong.copyWith(fontSize: 14);
  static TextStyle amount(BuildContext c) => c.appTextTheme.numericBody
      .copyWith(fontSize: 26, fontWeight: FontWeight.w500);
  static TextStyle unit(BuildContext c) =>
      c.appTextTheme.caption.copyWith(fontSize: 13);
  static TextStyle range(BuildContext c) => c.appTextTheme.meta.copyWith(
    fontSize: 11,
    color: c.appColors.textSecondary,
  );
  static TextStyle axis(BuildContext c) => c.appTextTheme.numericCaption
      .copyWith(fontSize: 10, color: c.appColors.textSecondary);
}
