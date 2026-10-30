import '../../domain/entities/hotel_models.dart';

enum HotelBookingMode { regular, hostMiles }

class HotelDetailRouteArgs {
  const HotelDetailRouteArgs({
    required this.criteria,
    required this.buildingCode,
    this.mode = HotelBookingMode.regular,
  });

  final HotelSearchCriteria criteria;
  final String buildingCode;
  final HotelBookingMode mode;
}
