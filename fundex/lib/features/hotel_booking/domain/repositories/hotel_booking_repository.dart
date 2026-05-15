import '../entities/hotel_models.dart';

abstract class HotelBookingRepository {
  Future<HotelSearchResult> searchHotels({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  });

  Future<List<HotelBuildingFilter>> fetchBuildingFilters({
    required String languageCode,
  });

  Future<HotelDetail> fetchHotelDetail({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required String languageCode,
  });

  Future<HotelAssignOccupancyResult> assignOccupancy({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required List<HotelSelectedRoom> selectedRooms,
    required String languageCode,
  });

  Future<HotelBookingPreparation> fetchBookingPreparation({
    required HotelBookingConfirmSeed seed,
    required String languageCode,
  });
}
