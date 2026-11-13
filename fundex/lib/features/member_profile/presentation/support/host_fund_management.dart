import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../asset_statistics/domain/entities/asset_statistics_models.dart';
import '../../domain/entities/mypage_models.dart';

enum HostFundTab {
  applying,
  pending,
  running,
  forecast,
  dividends;

  String label(AppLocalizations l) => switch (this) {
    applying => l.hostManageFundTabApplying,
    pending => l.hostManageFundTabPending,
    running => l.hostManageFundTabRunning,
    forecast => l.hostManageFundTabRedeem,
    dividends => l.hostManageFundTabDividend,
  };
}

String fundMoney(num? value, String locale) =>
    value == null ? '—' : NumberFormat.decimalPattern(locale).format(value);
String fundDate(String? value) {
  if (value == null || value.trim().isEmpty) return '—';
  final match = RegExp(
    r'^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})',
  ).firstMatch(value);
  return match == null
      ? value
      : '${match[1]}/${match[2]!.padLeft(2, '0')}/${match[3]!.padLeft(2, '0')}';
}

String fundPeriod(String? start, String? end) => [start, end]
    .whereType<String>()
    .where((s) => s.trim().isNotEmpty)
    .map(fundDate)
    .join(' ～ ');
String applicationPeriod(MyPageApplyRecord record, AppLocalizations l) {
  final raw = record.period?.trim() ?? '';
  if (raw.isNotEmpty)
    return num.tryParse(raw) == null
        ? raw
        : '$raw ${l.hostManageFundMonthUnit}';
  final range = fundPeriod(record.startDate, record.endDate);
  return range.isEmpty ? '—' : range;
}

String applyYield(MyPageApplyRecord r, AppLocalizations l) {
  final investor = r.investorType;
  final type = investor?.earningsType?.toUpperCase();
  if (type == 'FLOATING') return l.hostManageFundYieldFloating;
  final rate =
      investor?.investorType?.toUpperCase() == 'BORROWING' &&
          type != 'FIXED' &&
          type != 'FIXED_FLOATING'
      ? investor?.interestRadio
      : investor?.earningsRadio ?? r.expectedYield;
  final pct = rate == null || rate == 0
      ? null
      : (rate.abs() > 1 ? rate : rate * 100).toStringAsFixed(2);
  if (type == 'FIXED_FLOATING') {
    return pct == null
        ? l.hostManageFundYieldFloating
        : l.hostManageFundYieldFixedFloating(pct);
  }
  return pct == null ? '—' : '$pct%';
}

class FundForecastMonth {
  const FundForecastMonth(this.month, this.benefit, this.principal);
  final DateTime month;
  final int benefit, principal;
}

List<FundForecastMonth> forecastMonths(
  AssetBenefitForecast source,
  DateTime start,
  int years,
) {
  final benefits = <String, int>{}, principals = <String, int>{};
  for (final entry in source.expectBenefitList) {
    final key = entry.yearMonth;
    if (key == null || key.length < 7) continue;
    final month = key.substring(0, 7);
    benefits.update(
      month,
      (v) => v + (entry.expectBenefit ?? 0),
      ifAbsent: () => entry.expectBenefit ?? 0,
    );
  }
  for (final entry in source.expectPrincipalList) {
    final key = entry.yearMonth;
    if (key == null || key.length < 7) continue;
    principals.update(
      key.substring(0, 7),
      (v) => v + (entry.expectPrincipal ?? 0),
      ifAbsent: () => entry.expectPrincipal ?? 0,
    );
  }
  return List.generate(years * 12, (i) {
    final month = DateTime(start.year, start.month + i);
    final key = DateFormat('yyyy-MM').format(month);
    return FundForecastMonth(month, benefits[key] ?? 0, principals[key] ?? 0);
  });
}
