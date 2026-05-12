import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class SearchHotelsUseCase {
  const SearchHotelsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelSearchResult> call({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.searchHotels(
      criteria: criteria,
      languageCode: languageCode,
      page: page,
      limit: limit,
    );
  }
}
