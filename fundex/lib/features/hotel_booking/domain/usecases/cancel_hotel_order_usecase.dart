import '../repositories/hotel_booking_repository.dart';

class CancelHotelOrderUseCase {
  const CancelHotelOrderUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call({required String languageCode, required String orderId}) {
    return _repository.cancelOrder(
      languageCode: languageCode,
      orderId: orderId,
    );
  }
}
