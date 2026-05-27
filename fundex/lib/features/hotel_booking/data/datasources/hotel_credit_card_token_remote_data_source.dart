import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:dio/dio.dart';

class HotelCreditCardTokenRequest {
  const HotelCreditCardTokenRequest({
    required this.cardNumber,
    required this.cardExpire,
    required this.securityCode,
    required this.cardholderName,
    required this.tokenApiKey,
    this.lang = 'en',
  });

  final String cardNumber;
  final String cardExpire;
  final String securityCode;
  final String cardholderName;
  final String tokenApiKey;
  final String lang;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'card_number': cardNumber,
      'card_expire': cardExpire,
      'security_code': securityCode,
      'cardholder_name': cardholderName,
      'token_api_key': tokenApiKey,
      'lang': lang,
    };
  }
}

abstract class HotelCreditCardTokenRemoteDataSource {
  Future<HotelCreditCardTokenDto> createToken(
    HotelCreditCardTokenRequest request,
  );
}

class HotelCreditCardTokenRemoteDataSourceImpl
    implements HotelCreditCardTokenRemoteDataSource {
  const HotelCreditCardTokenRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<HotelCreditCardTokenDto> createToken(
    HotelCreditCardTokenRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/4gtoken',
      data: request.toJson(),
      options: Options(
        contentType: Headers.jsonContentType,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    final data = response.data ?? const <String, dynamic>{};
    final token = HotelCreditCardTokenDto.fromJson(data);
    if (token.status.toLowerCase() == 'success' &&
        token.code.toLowerCase() == 'success' &&
        token.token.trim().isNotEmpty) {
      return token;
    }
    throw HotelCreditCardTokenException(token.message);
  }
}

class HotelCreditCardTokenException implements Exception {
  const HotelCreditCardTokenException(this.message);

  final String message;

  @override
  String toString() => message;
}
