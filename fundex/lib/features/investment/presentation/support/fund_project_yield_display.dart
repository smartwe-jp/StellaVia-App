import '../../domain/entities/fund_project.dart';

String resolveFundProjectYieldDisplay(FundProject project) {
  final openInvestorRatios = project.investorTypes
      .where((FundProjectInvestorType item) => item.isOpen == true)
      .map((FundProjectInvestorType item) => item.earningsRadio)
      .whereType<double>()
      .where((double value) => value > 0)
      .toList(growable: false);
  if (openInvestorRatios.isNotEmpty) {
    return _formatYieldRange(
      minimum: openInvestorRatios.reduce((double a, double b) => a < b ? a : b),
      maximum: openInvestorRatios.reduce((double a, double b) => a > b ? a : b),
    );
  }

  return _formatYieldRange(
    minimum: project.expectedDistributionRatioMin,
    maximum: project.expectedDistributionRatioMax,
  );
}

String formatFundYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

String _formatYieldRange({
  required double? minimum,
  required double? maximum,
}) {
  final minValue = minimum != null && minimum > 0 ? minimum : null;
  final maxValue = maximum != null && maximum > 0 ? maximum : null;
  if (minValue == null && maxValue == null) {
    return '--';
  }
  if (minValue == null) {
    return formatFundYieldPercent(maxValue);
  }
  if (maxValue == null) {
    return formatFundYieldPercent(minValue);
  }
  if (minValue == maxValue) {
    return formatFundYieldPercent(minValue);
  }
  return '${formatFundYieldPercent(minValue)}～${formatFundYieldPercent(maxValue)}';
}
