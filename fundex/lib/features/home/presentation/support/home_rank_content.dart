import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';

/// Display mapping only; membership eligibility remains server-owned.
class HomeRankContent {
  const HomeRankContent(
    this.name,
    this.investmentRange,
    this.rate,
    this.validityMonths,
    this.advanceMonths,
    this.rooms,
  );
  final String name, investmentRange, rate;
  final int? validityMonths, advanceMonths, rooms;
}

List<HomeRankContent> homeRankContent(
  AppLocalizations l10n,
  List<HostMilesTierRule> rules,
  String locale,
) {
  final currency = NumberFormat.currency(
    locale: locale,
    symbol: '¥',
    decimalDigits: 0,
  );
  final percentage = NumberFormat.decimalPattern(locale)
    ..maximumFractionDigits = 6;
  final sorted = [...rules]
    ..sort((a, b) {
      if (a.minAum == null) return b.minAum == null ? 0 : 1;
      if (b.minAum == null) return -1;
      return a.minAum!.compareTo(b.minAum!);
    });
  return sorted
      .map((rule) {
        final minimum = rule.minAum;
        final maximum = rule.maxAum;
        final range = minimum == null
            ? '—'
            : maximum == null
            ? l10n.homeRankRangeFrom(currency.format(minimum))
            : l10n.homeRankRangeBetween(
                currency.format(minimum),
                currency.format(maximum),
              );
        return HomeRankContent(
          rule.tierCode?.trim().isNotEmpty == true
              ? rule.tierCode!.trim()
              : '—',
          range,
          rule.pointRate == null
              ? '—'
              : '${percentage.format(rule.pointRate! * 100)}%',
          rule.expireMonths,
          rule.leadTimeMonths,
          rule.maxRooms,
        );
      })
      .toList(growable: false);
}
