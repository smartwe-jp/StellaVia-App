// Shared wire-value conversion for the new read-only statistics clients.
String? readString(Object? value) => value == null ? null : value.toString();
num? readNumber(Object? value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
int? readInteger(Object? value) {
  final number = readNumber(value);
  return number != null &&
          number.isFinite &&
          number == number.truncateToDouble()
      ? number.toInt()
      : null;
}

bool? readBoolean(Object? value) => switch (value) {
  true || 1 || 'true' || '1' => true,
  false || 0 || 'false' || '0' => false,
  _ => null,
};
DateTime? readTimestamp(Object? value) {
  if (value == null) return null;
  final milliseconds = readInteger(value);
  if (milliseconds != null) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }
  return DateTime.tryParse(value.toString());
}

String? readYearMonth(Object? value) {
  if (value is Map) {
    final year = readInteger(value['year']);
    final month = readInteger(value['monthValue']);
    if (year == null || month == null || month < 1 || month > 12) return null;
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
  }
  return readString(value);
}

List<T> readList<T>(Object? value, T? Function(Object?) parse) {
  if (value == null) return List<T>.unmodifiable(<T>[]);
  if (value is! List) throw const FormatException('Expected an array.');
  return List<T>.unmodifiable(
    value.map((item) {
      final parsed = parse(item);
      // Do not silently drop chart entries and shift date/value alignment.
      if (parsed == null) throw const FormatException('Invalid array entry.');
      return parsed;
    }),
  );
}

T readObject<T>(Object? value, T Function(Map<String, dynamic>) parse) {
  if (value is! Map) throw const FormatException('Expected an object.');
  return parse(Map<String, dynamic>.from(value));
}

String apiMonth(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';
String apiDate(DateTime value) =>
    '${apiMonth(value)}-${value.day.toString().padLeft(2, '0')}';
Map<String, dynamic> apiDateRange(DateTime start, DateTime end) {
  final startText = apiDate(start);
  final endText = apiDate(end);
  if (startText.compareTo(endText) > 0) {
    throw ArgumentError('startDate must not follow endDate.');
  }
  return {'startDate': startText, 'endDate': endText};
}
