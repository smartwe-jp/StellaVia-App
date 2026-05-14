import 'package:company_api_runtime/company_api_runtime.dart';

abstract class HotelBookingRemoteDataSource {
  Future<HotelSearchResultDto> searchHotels(HotelSearchRequestDto request);

  Future<HotelDetailDto> fetchHotelDetail(HotelDetailRequestDto request);

  Future<String> fetchRefundStrategyText({
    required String languageCode,
    required String siteCode,
    required String checkIn,
    required String hotelId,
  });

  Future<HotelPriceCalendarDto> fetchPriceByDate({required String hotelInfoId});

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
  Future<HotelDetailDto> fetchHotelDetail(HotelDetailRequestDto request) {
    return _client.fetchHotelDetail(request);
  }

  @override
  Future<String> fetchRefundStrategyText({
    required String languageCode,
    required String siteCode,
    required String checkIn,
    required String hotelId,
  }) {
    return _client.fetchRefundStrategyText(
      lang: languageCode,
      siteCode: siteCode,
      checkIn: checkIn,
      hotelId: hotelId,
    );
  }

  @override
  Future<HotelPriceCalendarDto> fetchPriceByDate({
    required String hotelInfoId,
  }) {
    return _client.fetchPriceByDate(hotelInfoId: hotelInfoId);
  }

  @override
  Future<List<HotelBuildingCodeDto>> fetchBuildingCodes({
    required String languageCode,
  }) {
    return _client.fetchBuildingCodes(lang: languageCode);
  }
}
