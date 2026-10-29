import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/home_simulation.dart';
import '../support/home_simulation_theme.dart';

class HomeSimulationInputs extends StatelessWidget {
  const HomeSimulationInputs({
    super.key,
    required this.input,
    required this.onUnits,
    required this.onRate,
    required this.onMonths,
    required this.onType,
  });
  final HomeSimulationInput input;
  final ValueChanged<double> onUnits, onRate, onMonths;
  final ValueChanged<SimulationDividendType> onType;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final number = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SimulationSlider(
            id: 'amount',
            label: l.simInvestment,
            value: input.units.toDouble(),
            min: 1,
            max: 5000,
            divisions: 4999,
            display: number.format(input.units),
            unit: l.simTenThousandYen,
            minimum: l.simAmountMinimum,
            maximum: l.simAmountMaximum,
            onChanged: onUnits,
          ),
          const SizedBox(height: 16),
          _SimulationSlider(
            id: 'rate',
            label: l.simAnnualRate,
            value: input.annualRateTenths.toDouble(),
            min: 30,
            max: 100,
            divisions: 70,
            display: (input.annualRateTenths / 10).toStringAsFixed(1),
            unit: '%',
            minimum: '3%',
            maximum: '10%',
            onChanged: onRate,
          ),
          const SizedBox(height: 16),
          _SimulationSlider(
            id: 'months',
            label: l.simTerm,
            value: input.months.toDouble(),
            min: 1,
            max: 36,
            divisions: 35,
            display: number.format(input.months),
            unit: l.simMonthsUnit,
            minimum: l.homeRankMonths(1),
            maximum: l.homeRankMonths(36),
            onChanged: onMonths,
          ),
          const SizedBox(height: 16),
          Text(
            l.simDividendType,
            style: HomeSimulationTheme.inputLabel(context),
          ),
          const SizedBox(height: 8),
          AppTwoLineSegmentedControl<SimulationDividendType>(
            style: HomeSimulationTheme.segments(context),
            height: 48,
            value: input.type,
            onChanged: onType,
            first: AppTwoLineSegmentItem(
              value: SimulationDividendType.income,
              label: l.simIncome,
              caption: l.simMonthlyPayment,
              key: const ValueKey('simulation-income'),
            ),
            second: AppTwoLineSegmentItem(
              value: SimulationDividendType.capital,
              label: l.simCapital,
              caption: l.simMaturityPayment,
              key: const ValueKey('simulation-capital'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationSlider extends StatelessWidget {
  const _SimulationSlider({
    required this.id,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.unit,
    required this.minimum,
    required this.maximum,
    required this.onChanged,
  });
  final String id, label, display, unit, minimum, maximum;
  final double value, min, max;
  final int divisions;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(label, style: HomeSimulationTheme.inputLabel(context)),
          ),
          const SizedBox(width: 8),
          Text(display, style: HomeSimulationTheme.inputNumber(context)),
          Text(unit, style: HomeSimulationTheme.inputUnit(context)),
        ],
      ),
      AppSlider(
        sliderKey: ValueKey('simulation-$id'),
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
        semanticFormatterCallback: (_) => '$label $display $unit',
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(minimum, style: HomeSimulationTheme.bound(context)),
          Text(maximum, style: HomeSimulationTheme.bound(context)),
        ],
      ),
    ],
  );
}
