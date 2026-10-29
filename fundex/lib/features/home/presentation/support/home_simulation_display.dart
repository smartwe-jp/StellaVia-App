import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/home_simulation.dart';

/// Locale formatting and payment-timing copy, independent of result layout.
class HomeSimulationDisplay {
  HomeSimulationDisplay(this.result, this.input, this.l, String locale)
    : yen = NumberFormat.currency(
        locale: locale,
        symbol: '¥',
        decimalDigits: 0,
      ),
      number = NumberFormat.decimalPattern(locale),
      percentage = (NumberFormat.decimalPattern(locale)
        ..maximumFractionDigits = 6);
  final HomeSimulationResult result;
  final HomeSimulationInput input;
  final AppLocalizations l;
  final NumberFormat yen, number, percentage;
  bool get income => input.type == SimulationDividendType.income;
  String get dividendLabel => income ? l.simMonthlyDividend : l.simTermDividend;
  String get dividend =>
      yen.format(income ? result.monthlyDividend : result.termDividend);
  String get totalDividend => yen.format(result.termDividend);
  String get totalReceived => yen.format(result.totalReceived);
  String get timing => income
      ? l.simTimingIncome(input.months)
      : l.simTimingCapital(input.months);
  String get rank => result.tierCode?.trim().isNotEmpty == true
      ? result.tierCode!.trim()
      : '—';
  String get rate => result.monthlyPointRate == null
      ? '—'
      : '${percentage.format(result.monthlyPointRate! * 100)}%（${l.simMonthlyRateLabel}）';
  String miles(int? value) =>
      value == null ? '—' : l.simMiles(number.format(value));
}
