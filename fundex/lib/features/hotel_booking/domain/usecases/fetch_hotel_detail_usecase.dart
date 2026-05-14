import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelDetailUseCase {
  const FetchHotelDetailUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelDetail> call({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required String languageCode,
  }) {
    return _repository.fetchHotelDetail(
      hotelId: hotelId,
      criteria: criteria,
      languageCode: languageCode,
    );
  }
}
