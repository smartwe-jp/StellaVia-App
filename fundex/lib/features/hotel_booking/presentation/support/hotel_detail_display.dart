import 'package:flutter/widgets.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

String hotelDetailPlainText(String value) => value
    .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
    .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
    .replaceAll(RegExp(r'<[^>]+>'), '')
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&amp;', '&')
    .trim();

String hotelFeatureTitle(String text) {
  final end = RegExp(r'。|[.](?=\s|$)').firstMatch(text)?.end;
  return end == null ? text : text.substring(0, end);
}

String hotelBedWidthLabel(BuildContext context, String raw) {
  final width = raw
      .trim()
      .replaceFirst(RegExp(r'^(幅|宽|寬|width\s*)', caseSensitive: false), '')
      .replaceFirst(
        RegExp(r'(cm|ｃｍ|㎝|厘米|公分|センチメートル)$', caseSensitive: false),
        '',
      )
      .trim();
  return width.isEmpty ? '' : context.l10n.hotelRoomBedWidth(width);
}

String _detailBedSummary(BuildContext context, HotelRoomBed bed) {
  final width = hotelBedWidthLabel(context, bed.width);
  final quantity = bed.quantity;
  if (quantity != null) {
    return context.l10n.hotelDetailBedSummary(bed.name, quantity, width).trim();
  }
  return width.isEmpty
      ? bed.name
      : context.l10n.hotelRoomBedSummaryWithWidth(bed.name, width);
}

List<(String, String)> hotelDetailRoomFacts(
  BuildContext c,
  HotelRoomPlan room,
) => [
  if (room.occupancy != null)
    ('user', c.l10n.hotelDetailRoomCapacity(room.occupancy!)),
  if (room.bedroomCount != null)
    ('bed', c.l10n.hotelDetailBedrooms(room.bedroomCount!)),
  if (room.bathroomCount != null)
    ('bath', c.l10n.hotelDetailBathrooms(room.bathroomCount!)),
  if (room.roomSize.isNotEmpty)
    ('area', c.l10n.hotelDetailRoomArea(room.roomSize)),
  for (final bed in room.beds) ('single-bed', _detailBedSummary(c, bed)),
];
