import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class PayHotelOrderWithRegisteredCardUseCase {
  const PayHotelOrderWithRegisteredCardUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelCreditCardPaymentResult> call({
    required String cardId,
    required String orderId,
  }) {
    return _repository.payWithRegisteredCreditCard(
      cardId: cardId,
      orderId: orderId,
    );
  }
}
