import '../repositories/hotel_booking_repository.dart';

class UnregisterHotelCreditCardUseCase {
  const UnregisterHotelCreditCardUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call(String cardId) {
    return _repository.unregisterCreditCard(cardId);
  }
}
