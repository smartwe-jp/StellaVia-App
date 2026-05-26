import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelOrderDetailUseCase {
  const FetchHotelOrderDetailUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelOrderDetail> call({
    required String languageCode,
    required String orderId,
  }) {
    return _repository.fetchOrderDetail(
      languageCode: languageCode,
      orderId: orderId,
    );
  }
}
