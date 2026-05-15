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

  Future<HotelAssignOccupancyResultDto> assignOccupancy(
    HotelAssignOccupancyRequestDto request,
  );

  Future<Map<String, String>> fetchPageText({
    required String languageCode,
    required String pageCode,
  });

  Future<Map<String, String>> fetchCountryCodeList({
    required String languageCode,
  });

  Future<HotelRoomExtraPersonResultDto> fetchRoomExtraPerson(
    HotelRoomExtraPersonRequestDto request,
  );

  Future<Map<String, dynamic>> fetchOrderCoupons({
    required String languageCode,
    required String hotelId,
  });

  Future<List<Map<String, dynamic>>> fetchMemberContacts({
    required String languageCode,
  });

  Future<List<Map<String, dynamic>>> fetchRegisteredCards();
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

  @override
  Future<HotelAssignOccupancyResultDto> assignOccupancy(
    HotelAssignOccupancyRequestDto request,
  ) {
    return _client.assignOccupancy(request);
  }

  @override
  Future<Map<String, String>> fetchPageText({
    required String languageCode,
    required String pageCode,
  }) {
    return _client.fetchPageText(lang: languageCode, pageCode: pageCode);
  }

  @override
  Future<Map<String, String>> fetchCountryCodeList({
    required String languageCode,
  }) {
    return _client.fetchCountryCodeList(lang: languageCode);
  }

  @override
  Future<HotelRoomExtraPersonResultDto> fetchRoomExtraPerson(
    HotelRoomExtraPersonRequestDto request,
  ) {
    return _client.fetchRoomExtraPerson(request);
  }

  @override
  Future<Map<String, dynamic>> fetchOrderCoupons({
    required String languageCode,
    required String hotelId,
  }) {
    return _client.fetchOrderCoupons(lang: languageCode, hotelId: hotelId);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMemberContacts({
    required String languageCode,
  }) {
    return _client.fetchMemberContacts(lang: languageCode);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRegisteredCards() {
    return _client.fetchRegisteredCards();
  }
}
