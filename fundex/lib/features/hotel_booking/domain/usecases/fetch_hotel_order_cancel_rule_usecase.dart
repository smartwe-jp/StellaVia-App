import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelOrderCancelRuleUseCase {
  const FetchHotelOrderCancelRuleUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelOrderCancelRule> call({
    required String languageCode,
    required String orderId,
  }) {
    return _repository.fetchCancelOrderRule(
      languageCode: languageCode,
      orderId: orderId,
    );
  }
}
