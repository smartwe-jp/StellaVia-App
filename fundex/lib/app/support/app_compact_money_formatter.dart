import 'package:intl/intl.dart';

String formatCompactYenAmount(
  num? amount, {
  required String locale,
  String fallback = '--',
}) {
  if (amount == null) {
    return fallback;
  }

  final value = amount.toDouble();
  final abs = value.abs();
  if (abs >= 1000000) {
    return '¥${_formatCompactNumber(value / 1000000)}M';
  }
  if (abs >= 10000) {
    return '¥${_formatCompactNumber(value / 1000)}K';
  }
  final rounded = value.round();
  return '¥${NumberFormat.decimalPattern(locale).format(rounded)}';
}

String _formatCompactNumber(double value) {
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
