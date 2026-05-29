import '../entities/hotel_models.dart';
import '../repositories/hotel_booking_repository.dart';

class QuoteHotelBookingPriceUseCase {
  const QuoteHotelBookingPriceUseCase(this._repository);

  final HotelBookingRepository _repository;

  Future<HotelBookingQuote> call(HotelBookingQuoteRequest request) {
    return _repository.quoteBookingPrice(request);
  }
}
