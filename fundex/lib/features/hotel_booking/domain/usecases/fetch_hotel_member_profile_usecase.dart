import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class FetchHotelMemberProfileUseCase {
  const FetchHotelMemberProfileUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelMemberProfile> call() {
    return _repository.fetchMemberProfile();
  }
}
