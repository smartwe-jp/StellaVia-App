import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class AssignHotelOccupancyUseCase {
  const AssignHotelOccupancyUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelAssignOccupancyResult> call({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required List<HotelSelectedRoom> selectedRooms,
    required String languageCode,
  }) {
    return _repository.assignOccupancy(
      hotelId: hotelId,
      criteria: criteria,
      selectedRooms: selectedRooms,
      languageCode: languageCode,
    );
  }
}
