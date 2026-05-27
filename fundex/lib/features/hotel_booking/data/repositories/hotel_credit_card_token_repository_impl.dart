import '../../domain/entities/hotel_models.dart';
import '../../domain/repositories/hotel_credit_card_token_repository.dart';
import '../datasources/hotel_credit_card_token_remote_data_source.dart';

class HotelCreditCardTokenRepositoryImpl
    implements HotelCreditCardTokenRepository {
  const HotelCreditCardTokenRepositoryImpl({required this.remote});

  final HotelCreditCardTokenRemoteDataSource remote;

  @override
  Future<HotelCreditCardToken> createToken(
    HotelCreditCardTokenDraft draft,
  ) async {
    final dto = await remote.createToken(
      HotelCreditCardTokenRequest(
        cardNumber: draft.cardNumber,
        cardExpire: draft.cardExpire,
        securityCode: draft.securityCode,
        cardholderName: draft.cardholderName,
        tokenApiKey: draft.tokenApiKey,
        lang: draft.lang,
      ),
    );
    return HotelCreditCardToken(
      token: dto.token,
      tokenExpireDate: dto.tokenExpireDate,
      reqCardNumber: dto.reqCardNumber,
      status: dto.status,
      code: dto.code,
      message: dto.message,
    );
  }
}
