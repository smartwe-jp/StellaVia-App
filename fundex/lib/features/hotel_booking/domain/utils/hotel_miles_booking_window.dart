import 'dart:math' as math;

import '../entities/hotel_models.dart';

/// Lead time covers bookable nights, including the final check-in date.
class HotelMilesBookingWindow {
  factory HotelMilesBookingWindow(DateTime now, int months) {
    final month = now.month + (months < 0 ? 0 : months);
    final lastDay = DateTime(now.year, month + 1, 0).day;
    return HotelMilesBookingWindow._(
      DateTime(now.year, now.month, now.day),
      DateTime(now.year, month, math.min(now.day, lastDay)),
    );
  }

  const HotelMilesBookingWindow._(this.today, this.lastNight);

  final DateTime today;
  final DateTime lastNight;
  DateTime get lastCheckout =>
      DateTime(lastNight.year, lastNight.month, lastNight.day + 1);

  HotelSearchCriteria constrain(HotelSearchCriteria criteria) {
    var start = criteria.checkInDate;
    if (start.isBefore(today) || start.isAfter(lastNight)) start = today;
    var end = criteria.checkOutDate;
    if (start != criteria.checkInDate || !end.isAfter(start)) {
      end = DateTime(start.year, start.month, start.day + 1);
    }
    if (end.isAfter(lastCheckout)) end = lastCheckout;
    return criteria.copyWith(checkInDate: start, checkOutDate: end);
  }
}
