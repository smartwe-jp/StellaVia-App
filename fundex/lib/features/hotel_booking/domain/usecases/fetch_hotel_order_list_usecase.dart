import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelOrderListUseCase {
  const FetchHotelOrderListUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelOrderListResult> call({
    required String languageCode,
    required HotelOrderStatusFilter status,
    int page = 1,
    int limit = 5,
  }) {
    return _repository.fetchOrderList(
      languageCode: languageCode,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
