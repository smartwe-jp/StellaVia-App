import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelCouponsUseCase {
  const FetchHotelCouponsUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelCouponListResult> call({required String languageCode}) {
    return _repository.fetchCoupons(languageCode: languageCode);
  }
}
