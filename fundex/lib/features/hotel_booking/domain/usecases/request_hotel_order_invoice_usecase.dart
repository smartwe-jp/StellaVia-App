import '../repositories/hotel_booking_repository.dart';

class RequestHotelOrderInvoiceUseCase {
  const RequestHotelOrderInvoiceUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call({
    required String orderId,
    required String receiptTitle,
    required String email,
  }) {
    return _repository.requestOrderInvoice(
      orderId: orderId,
      receiptTitle: receiptTitle,
      email: email,
    );
  }
}
