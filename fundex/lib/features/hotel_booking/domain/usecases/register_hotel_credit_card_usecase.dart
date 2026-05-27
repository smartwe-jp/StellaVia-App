import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class RegisterHotelCreditCardUseCase {
  const RegisterHotelCreditCardUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call(HotelCreditCardRegistrationDraft draft) {
    return _repository.registerCreditCard(draft);
  }
}
