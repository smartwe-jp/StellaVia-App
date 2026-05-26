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

  Future<String> createBooking(HotelBookingCreateRequestDto request);

  Future<HotelOrderListDto> fetchOrderList({
    required String languageCode,
    required int page,
    required int limit,
    required Object? status,
  });

  Future<HotelMemberInfoDto> fetchMemberInfo();

  Future<void> updateMemberInfo(HotelMemberInfoUpdateRequestDto request);
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

  @override
  Future<String> createBooking(HotelBookingCreateRequestDto request) {
    return _client.createBooking(request);
  }

  @override
  Future<HotelOrderListDto> fetchOrderList({
    required String languageCode,
    required int page,
    required int limit,
    required Object? status,
  }) {
    return _client.fetchOrderList(
      lang: languageCode,
      startPage: page,
      limit: limit,
      status: status,
    );
  }

  @override
  Future<HotelMemberInfoDto> fetchMemberInfo() {
    return _client.fetchMemberInfo();
  }

  @override
  Future<void> updateMemberInfo(HotelMemberInfoUpdateRequestDto request) {
    return _client.updateMemberInfo(request);
  }
}
