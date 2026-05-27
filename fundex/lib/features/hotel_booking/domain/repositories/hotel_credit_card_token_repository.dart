import '../entities/hotel_models.dart';

abstract class HotelCreditCardTokenRepository {
  Future<HotelCreditCardToken> createToken(HotelCreditCardTokenDraft draft);
}
