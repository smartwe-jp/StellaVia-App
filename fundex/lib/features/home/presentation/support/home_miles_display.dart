import 'package:intl/intl.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';

String homeMilesBalance(int? availablePoints, String locale) =>
    availablePoints == null
    ? '—'
    : NumberFormat.decimalPattern(locale).format(availablePoints);

List<String> homeRankNames(List<HostMilesTierRule>? rules) {
  if (rules == null) return const [];
  final sorted = [...rules]
    ..sort((a, b) => (a.minAum ?? 0).compareTo(b.minAum ?? 0));
  return sorted
      .map((rule) => rule.tierCode?.trim() ?? '')
      .where((name) => name.isNotEmpty)
      .toSet()
      .toList(growable: false);
}
