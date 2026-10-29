import 'package:intl/intl.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';

class MyPageRankDisplay {
  static String name(HostMilesTier? tier) =>
      tier?.currentTier?.trim().isNotEmpty == true
      ? tier!.currentTier!.trim()
      : '—';
  static String number(num? value, String locale) =>
      value == null ? '—' : NumberFormat.decimalPattern(locale).format(value);
  static String rate(num? value, String locale) {
    if (value == null || !value.isFinite) return '—';
    final format = NumberFormat.decimalPattern(locale)
      ..maximumFractionDigits = 6;
    return format.format(value * 100);
  }

  static bool isMax(HostMilesTier? tier) =>
      tier?.nextTier?.trim().toUpperCase() == 'MAX';

  /// Progress toward the next absolute AUM threshold. Thresholds remain server-owned.
  static double? progress(HostMilesTier? tier) {
    if (isMax(tier)) return 1;
    final current = tier?.currentAum;
    final gap = tier?.nextTierGap;
    if (current == null ||
        gap == null ||
        current < 0 ||
        gap < 0 ||
        current + gap <= 0) {
      return null;
    }
    return (current / (current + gap)).clamp(0, 1);
  }

  static String expiryDate(DateTime? date, String locale) {
    if (date == null) return '—';
    // Backend epochs are UTC; business expiry dates are displayed in Japan time.
    final japan = date.isUtc ? date.add(const Duration(hours: 9)) : date;
    return DateFormat.yMd(locale).format(japan);
  }
}
