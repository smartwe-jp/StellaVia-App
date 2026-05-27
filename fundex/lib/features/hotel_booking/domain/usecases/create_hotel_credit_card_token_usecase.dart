import '../entities/hotel_models.dart';
import '../repositories/hotel_credit_card_token_repository.dart';

class CreateHotelCreditCardTokenUseCase {
  const CreateHotelCreditCardTokenUseCase(this._repository);

  final HotelCreditCardTokenRepository _repository;

  Future<HotelCreditCardToken> call(HotelCreditCardTokenDraft draft) {
    return _repository.createToken(draft);
  }
}
