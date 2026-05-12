import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelBuildingFiltersUseCase {
  const FetchHotelBuildingFiltersUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelBuildingFilter>> call({required String languageCode}) {
    return _repository.fetchBuildingFilters(languageCode: languageCode);
  }
}
