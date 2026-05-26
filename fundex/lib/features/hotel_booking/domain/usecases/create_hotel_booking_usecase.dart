import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class CreateHotelBookingUseCase {
  const CreateHotelBookingUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<String> call(HotelBookingCreateDraft draft) {
    return _repository.createBooking(draft);
  }
}
