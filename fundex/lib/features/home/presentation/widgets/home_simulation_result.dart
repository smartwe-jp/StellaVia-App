import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/home_simulation.dart';
import '../support/home_simulation_theme.dart';
import '../support/home_simulation_display.dart';

class HomeSimulationResultCard extends StatelessWidget {
  const HomeSimulationResultCard({
    super.key,
    required this.result,
    required this.input,
  });
  final HomeSimulationResult result;
  final HomeSimulationInput input;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final display = HomeSimulationDisplay(
      result,
      input,
      l,
      Localizations.localeOf(context).toLanguageTag(),
    );
    return AppCard(
      variant: AppCardVariant.filled,
      backgroundColor: HomeSimulationTheme.resultSurface,
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ResultHeading(
            eyebrow: l.simFinancialEyebrow,
            title: l.simFinancialTitle,
          ),
          const SizedBox(height: 12),
          _ResultRow(label: display.dividendLabel, value: display.dividend),
          const SizedBox(height: 6),
          _ResultRow(label: l.simTotalDividend, value: display.totalDividend),
          const SizedBox(height: 6),
          _ResultRow(
            label: l.simTotalReceived,
            value: display.totalReceived,
            prominent: true,
          ),
          const SizedBox(height: 12),
          Text(l.simTiming, style: HomeSimulationTheme.resultLabel(context)),
          const SizedBox(height: 4),
          Text(display.timing, style: HomeSimulationTheme.resultLabel(context)),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: context.appColors.onDark.withValues(alpha: .15),
          ),
          const SizedBox(height: 16),
          _ResultHeading(
            eyebrow: l.simExperienceEyebrow,
            title: l.simExperienceTitle,
          ),
          const SizedBox(height: 12),
          _ResultRow(label: l.simRank, value: display.rank, accent: true),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              display.rate,
              style: HomeSimulationTheme.resultLabel(context),
            ),
          ),
          const SizedBox(height: 8),
          _ResultRow(
            label: l.simMonthlyMiles,
            value: display.miles(result.monthlyMiles),
            accent: true,
          ),
          const SizedBox(height: 6),
          _ResultRow(
            label: l.simEarnedMiles,
            value: display.miles(result.miles),
            accent: true,
          ),
        ],
      ),
    );
  }
}

class _ResultHeading extends StatelessWidget {
  const _ResultHeading({required this.eyebrow, required this.title});
  final String eyebrow, title;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(eyebrow, style: HomeSimulationTheme.resultEyebrow(context)),
      const SizedBox(height: 4),
      Text(title, style: HomeSimulationTheme.resultSectionTitle(context)),
    ],
  );
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.prominent = false,
    this.accent = false,
  });
  final String label, value;
  final bool prominent, accent;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(label, style: HomeSimulationTheme.resultLabel(context)),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: HomeSimulationTheme.resultNumber(
            context,
            prominent: prominent,
            miles: accent,
          ),
        ),
      ),
    ],
  );
}
