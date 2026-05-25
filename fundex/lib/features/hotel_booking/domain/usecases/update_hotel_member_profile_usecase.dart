import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class UpdateHotelMemberProfileUseCase {
  const UpdateHotelMemberProfileUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<void> call(HotelMemberProfile profile) {
    return _repository.updateMemberProfile(profile);
  }
}
