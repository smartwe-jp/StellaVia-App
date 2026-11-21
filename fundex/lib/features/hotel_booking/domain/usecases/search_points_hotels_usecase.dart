import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class SearchPointsHotelsUseCase {
  const SearchPointsHotelsUseCase(this.repository);
  final HotelBookingRepository repository;

  Future<List<PointsHotel>> call(int points) =>
      repository.searchHotelsByPoints(points);
}
