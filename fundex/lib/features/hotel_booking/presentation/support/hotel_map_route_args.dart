import '../../domain/entities/hotel_models.dart';

class HotelMapRouteArgs {
  const HotelMapRouteArgs({
    required this.criteria,
    this.selectedHotel,
    this.selectedHotelId,
    this.latitude,
    this.longitude,
  });

  factory HotelMapRouteArgs.fromHotel({
    required HotelSearchCriteria criteria,
    required HotelSummary hotel,
  }) {
    return HotelMapRouteArgs(
      criteria: criteria,
      selectedHotel: hotel,
      selectedHotelId: hotel.id,
      latitude: hotel.latitude,
      longitude: hotel.longitude,
    );
  }

  final HotelSearchCriteria criteria;
  final HotelSummary? selectedHotel;
  final String? selectedHotelId;
  final double? latitude;
  final double? longitude;

  bool get hasValidTarget {
    final latitude = this.latitude;
    final longitude = this.longitude;
    if (latitude == null || longitude == null) {
      return false;
    }
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }
}
