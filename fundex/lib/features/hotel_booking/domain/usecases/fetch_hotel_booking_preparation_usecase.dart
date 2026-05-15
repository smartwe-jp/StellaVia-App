import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelBookingPreparationUseCase {
  const FetchHotelBookingPreparationUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelBookingPreparation> call({
    required HotelBookingConfirmSeed seed,
    required String languageCode,
  }) {
    return _repository.fetchBookingPreparation(
      seed: seed,
      languageCode: languageCode,
    );
  }
}
