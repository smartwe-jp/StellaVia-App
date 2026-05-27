import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelCreditCardsUseCase {
  const FetchHotelCreditCardsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<List<HotelCreditCard>> call() {
    return _repository.fetchRegisteredCreditCards();
  }
}
