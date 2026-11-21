import 'package:company_api_runtime/company_api_runtime.dart';

abstract class HotelBookingRemoteDataSource {
  Future<List<PointsHotelDto>> searchHotelsByPoints(int points);

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

  Future<List<HotelStayBenefitPeriodDto>> fetchStayBenefitPeriods();

  Future<List<HotelStayBenefitPeriodDto>> fetchStayBenefitPeriodsForHotel({
    required String hotelId,
  });

  Future<Map<String, dynamic>> fetchPriceDiscount({
    required String startDate,
    required String endDate,
    required String languageCode,
    required String hotelId,
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

  Future<HotelRoomExtraPersonResultDto> fetchExtraPerson({
    required String hotelId,
    required String checkIn,
    required String checkOut,
    required String languageCode,
    required List<Map<String, Object?>> orderRoomTypeData,
    required int customerCount,
    required List<Object?> couponsCounts,
  });

  Future<Map<String, dynamic>> fetchOrderCoupons({
    required String languageCode,
    required String hotelId,
  });

  Future<List<HotelCouponDto>> fetchCoupons({required String languageCode});

  Future<List<HotelFundBenefitTicketDto>> fetchFundBenefitTickets();

  Future<List<Map<String, dynamic>>> fetchMemberContacts({
    required String languageCode,
  });

  Future<void> saveOrUpdateMemberContact(
    HotelMemberContactSaveRequestDto request,
  );

  Future<void> deleteMemberContact({required String id});

  Future<List<HotelCreditCardDto>> fetchRegisteredCards();

  Future<HotelMemberPayInfoDto> fetchMemberPayInfo();

  Future<String> registerCreditCard(HotelCreditCardRegisterRequestDto request);

  Future<String> unregisterCreditCard({required String cardId});

  Future<HotelCreditCardPaymentResultDto> payWithCreditCardToken(
    HotelCreditCardRegisterRequestDto request, {
    required bool saveCard,
  });

  Future<HotelCreditCardPaymentResultDto> payWithRegisteredCard(
    HotelRegisteredCardPaymentRequestDto request,
  );

  Future<HotelPaymentResultDto> payForOrder(Pay4OrderRequestDto request);

  Future<AliPayResponseAppDto> createAliAppPayment(AliAppPayRequestDto request);

  Future<String> syncOptimismPayment(OptimismPaymentRequestDto request);

  Future<String> createBooking(
    HotelBookingCreateRequestDto request, {
    bool hostMiles = false,
  });

  Future<HotelOrderListDto> fetchOrderList({
    required String languageCode,
    required int page,
    required int limit,
    required Object? status,
  });

  Future<List<HotelOrderDto>> fetchTodayCheckIns({
    required String languageCode,
  });

  Future<HotelOrderDto> fetchOrderDetail({
    required String languageCode,
    required String orderId,
  });

  Future<String> requestOrderInvoice({
    required String orderId,
    required String receiptTitle,
    required String email,
  });

  Future<void> setUserLanguage({required String languageCode});

  Future<HotelOrderCancelRuleResultDto> fetchCancelOrderRule({
    required String languageCode,
    required String orderId,
  });

  Future<String> cancelOrder({
    required String languageCode,
    required String orderId,
  });

  Future<String> checkInOrderCustomer({
    required String orderId,
    required int checkedIn,
    String? roomId,
  });

  Future<HotelMemberInfoDto> fetchMemberInfo();

  Future<void> updateMemberInfo(HotelMemberInfoUpdateRequestDto request);
}

class HotelBookingRemoteDataSourceImpl implements HotelBookingRemoteDataSource {
  const HotelBookingRemoteDataSourceImpl(this._client);

  final HotelApiClient _client;

  @override
  Future<List<PointsHotelDto>> searchHotelsByPoints(int points) =>
      _client.searchHotelsByPoints(points);

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
  Future<List<HotelStayBenefitPeriodDto>> fetchStayBenefitPeriods() {
    return _client.fetchStayBenefitPeriods();
  }

  @override
  Future<List<HotelStayBenefitPeriodDto>> fetchStayBenefitPeriodsForHotel({
    required String hotelId,
  }) {
    return _client.fetchStayBenefitPeriodsForHotel(hotelId: hotelId);
  }

  @override
  Future<Map<String, dynamic>> fetchPriceDiscount({
    required String startDate,
    required String endDate,
    required String languageCode,
    required String hotelId,
  }) {
    return _client.fetchPriceDiscount(
      startDate: startDate,
      endDate: endDate,
      lang: languageCode,
      hotelId: hotelId,
    );
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
  Future<HotelRoomExtraPersonResultDto> fetchExtraPerson({
    required String hotelId,
    required String checkIn,
    required String checkOut,
    required String languageCode,
    required List<Map<String, Object?>> orderRoomTypeData,
    required int customerCount,
    required List<Object?> couponsCounts,
  }) {
    return _client.fetchExtraPerson(
      hotelId: hotelId,
      checkIn: checkIn,
      checkOut: checkOut,
      lang: languageCode,
      orderRoomTypeData: orderRoomTypeData,
      customerCount: customerCount,
      couponsCounts: couponsCounts,
    );
  }

  @override
  Future<Map<String, dynamic>> fetchOrderCoupons({
    required String languageCode,
    required String hotelId,
  }) {
    return _client.fetchOrderCoupons(lang: languageCode, hotelId: hotelId);
  }

  @override
  Future<List<HotelCouponDto>> fetchCoupons({required String languageCode}) {
    return _client.fetchCustomerCoupons(lang: languageCode);
  }

  @override
  Future<List<HotelFundBenefitTicketDto>> fetchFundBenefitTickets() {
    return _client.fetchFundBenefitTickets();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMemberContacts({
    required String languageCode,
  }) {
    return _client.fetchMemberContacts(lang: languageCode);
  }

  @override
  Future<void> saveOrUpdateMemberContact(
    HotelMemberContactSaveRequestDto request,
  ) {
    return _client.saveOrUpdateMemberContact(request);
  }

  @override
  Future<void> deleteMemberContact({required String id}) {
    return _client.deleteMemberContact(id: id);
  }

  @override
  Future<List<HotelCreditCardDto>> fetchRegisteredCards() {
    return _client.fetchRegisteredCards();
  }

  @override
  Future<HotelMemberPayInfoDto> fetchMemberPayInfo() {
    return _client.fetchMemberPayInfo();
  }

  @override
  Future<String> registerCreditCard(HotelCreditCardRegisterRequestDto request) {
    return _client.registerCreditCard(request);
  }

  @override
  Future<String> unregisterCreditCard({required String cardId}) {
    return _client.unregisterCreditCard(cardId: cardId);
  }

  @override
  Future<HotelCreditCardPaymentResultDto> payWithCreditCardToken(
    HotelCreditCardRegisterRequestDto request, {
    required bool saveCard,
  }) {
    return _client.payWithCreditCardToken(request, saveCard: saveCard);
  }

  @override
  Future<HotelCreditCardPaymentResultDto> payWithRegisteredCard(
    HotelRegisteredCardPaymentRequestDto request,
  ) {
    return _client.payWithRegisteredCard(request);
  }

  @override
  Future<HotelPaymentResultDto> payForOrder(Pay4OrderRequestDto request) {
    return _client.payForOrder(request);
  }

  @override
  Future<AliPayResponseAppDto> createAliAppPayment(
    AliAppPayRequestDto request,
  ) {
    return _client.createAliAppPayment(request);
  }

  @override
  Future<String> syncOptimismPayment(OptimismPaymentRequestDto request) {
    return _client.syncOptimismPayment(request);
  }

  @override
  Future<String> createBooking(
    HotelBookingCreateRequestDto request, {
    bool hostMiles = false,
  }) {
    return _client.createBooking(request, hostMiles: hostMiles);
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
  Future<List<HotelOrderDto>> fetchTodayCheckIns({
    required String languageCode,
  }) {
    return _client.fetchTodayCheckIns(lang: languageCode);
  }

  @override
  Future<HotelOrderDto> fetchOrderDetail({
    required String languageCode,
    required String orderId,
  }) {
    return _client.fetchOrderDetail(lang: languageCode, orderId: orderId);
  }

  @override
  Future<String> requestOrderInvoice({
    required String orderId,
    required String receiptTitle,
    required String email,
  }) {
    return _client.requestOrderInvoice(
      bookingOrderId: orderId,
      receiptTitle: receiptTitle,
      email: email,
    );
  }

  @override
  Future<void> setUserLanguage({required String languageCode}) {
    return _client.setUserLanguage(lang: languageCode);
  }

  @override
  Future<HotelOrderCancelRuleResultDto> fetchCancelOrderRule({
    required String languageCode,
    required String orderId,
  }) {
    return _client.fetchCancelOrderRule(
      lang: languageCode,
      bookingOrderId: orderId,
    );
  }

  @override
  Future<String> cancelOrder({
    required String languageCode,
    required String orderId,
  }) {
    return _client.cancelOrder(lang: languageCode, bookingOrderId: orderId);
  }

  @override
  Future<String> checkInOrderCustomer({
    required String orderId,
    required int checkedIn,
    String? roomId,
  }) {
    return _client.checkInOrderCustomer(
      bookingOrderId: orderId,
      checkedIn: checkedIn,
      roomId: roomId?.trim().isEmpty == true ? null : roomId?.trim(),
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
