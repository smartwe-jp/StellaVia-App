/// Removes empty entries from a legacy serialized list of hotel names.
String hotelCouponHotelNames(String value) {
  final text = value.trim();
  if (text.toLowerCase() == 'null') return '';
  if (!text.startsWith('[') || !text.endsWith(']')) return text;
  return text
      .substring(1, text.length - 1)
      .split(',')
      .map((entry) {
        final name = entry.trim();
        if (name.length >= 2 &&
            ((name.startsWith('"') && name.endsWith('"')) ||
                (name.startsWith("'") && name.endsWith("'")))) {
          return name.substring(1, name.length - 1).trim();
        }
        return name;
      })
      .where((name) => name.isNotEmpty && name.toLowerCase() != 'null')
      .join('・');
}
