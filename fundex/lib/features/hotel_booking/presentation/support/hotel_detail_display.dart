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
  for (final bed in room.beds)
    (
      'single-bed',
      bed.quantity == null
          ? bed.name
          : c.l10n.hotelDetailBedSummary(bed.name, bed.quantity!, bed.width),
    ),
];
