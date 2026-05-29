import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class PayHotelOrderWithCreditCardTokenUseCase {
  const PayHotelOrderWithCreditCardTokenUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelCreditCardPaymentResult> call({
    required HotelCreditCardRegistrationDraft draft,
    required bool saveCard,
  }) {
    return _repository.payWithCreditCardToken(draft: draft, saveCard: saveCard);
  }
}
