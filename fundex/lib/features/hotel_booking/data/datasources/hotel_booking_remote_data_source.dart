import 'package:company_api_runtime/company_api_runtime.dart';

abstract class HotelBookingRemoteDataSource {
  Future<HotelSearchResultDto> searchHotels(HotelSearchRequestDto request);

  Future<List<HotelBuildingCodeDto>> fetchBuildingCodes({
    required String languageCode,
  });
}

class HotelBookingRemoteDataSourceImpl implements HotelBookingRemoteDataSource {
  const HotelBookingRemoteDataSourceImpl(this._client);

  final HotelApiClient _client;

  @override
  Future<HotelSearchResultDto> searchHotels(HotelSearchRequestDto request) {
    return _client.searchHotels(request);
  }

  @override
  Future<List<HotelBuildingCodeDto>> fetchBuildingCodes({
    required String languageCode,
  }) {
    return _client.fetchBuildingCodes(lang: languageCode);
  }
}
