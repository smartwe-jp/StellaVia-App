import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'hotel_dtos.dart';

class HotelApiPaths {
  const HotelApiPaths._();

  static const String hotelSearch = '/hotel/hotelSearch';
  static const String bookingOrder = '/booking/order';
  static const String bookingOrderSendPaymentLink =
      '/booking/order/sendPaymentLink';
  static const String buildingCode = '/hotel/buildingCode';
  static const String page = '/pms/page';
  static const String refundStrategyText = '/pms/refundStrategyText';
  static const String roomFacility = '/pms/esLoadRoomFacility';
  static const String hotelDetail = '/pms/hotelinfobyidapp';
  static const String bookingOrderSaveV2 = '/pms/bookingorder/save/v2';
  static const String repeatBookings = '/pms/repeatBookings';
  static const String pmsSite = '/pms/site';
  static const String paymentType = '/pms/paymenttype';
  static const String payForOrder = '/pms/pay4order';
  static const String orderList = '/pms/order/list';
  static const String orderDetail = '/pms/order/detail';
  static const String permitMemberPay = '/pms/book/permitMemberPay';
  static const String cancelOrderRule = '/pms/book/cancelOrderRule';
  static const String cancelOrder = '/pms/book/cancelOrder/v2';
  static const String priceByDate = '/pms/priceByDate';
  static const String assignOccupancy = '/pms/assign/occupancy';
  static const String countryCodeList = '/pms/countryCodeList';
  static const String roomExtraPerson = '/pms/order/room/extraPerson';
  static const String couponsOrderCustList = '/pms/coupons/order/custListV2';
  static const String memberInfo = '/pms/member/info';
  static const String memberInfoUpdate = '/pms/member/custSetInfo';
  static const String memberContactsList = '/pms/member/memberContactsList';
  static const String memberContactsUpdate =
      '/pms/member/memberContactsSaveOrUpdate';
  static const String memberContactsDelete = '/pms/member/memberContactsDelete';
  static const String memberContactsDefault =
      '/pms/member/contactsDefaultOption';
  static const String cardPayAuth = '/creditCard/payAndAuth';
  static const String cardPayJoin = '/creditCard/member/payAndJoin';
  static const String cardRegisterList = '/creditCard/register/list';
  static const String cardPayById = '/creditCard/member/cardIdPay';
  static const String cardUnregisterById = '/creditCard/unregister';
  static const String cardRegister = '/creditCard/register';
}

class HotelApiClient {
  HotelApiClient(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
    this.hotelSearchPath = HotelApiPaths.hotelSearch,
    this.bookingOrderPath = HotelApiPaths.bookingOrder,
    this.bookingOrderSendPaymentLinkPath =
        HotelApiPaths.bookingOrderSendPaymentLink,
    this.buildingCodePath = HotelApiPaths.buildingCode,
    this.pagePath = HotelApiPaths.page,
    this.refundStrategyTextPath = HotelApiPaths.refundStrategyText,
    this.roomFacilityPath = HotelApiPaths.roomFacility,
    this.hotelDetailPath = HotelApiPaths.hotelDetail,
    this.bookingOrderSaveV2Path = HotelApiPaths.bookingOrderSaveV2,
    this.payForOrderPath = HotelApiPaths.payForOrder,
    this.orderListPath = HotelApiPaths.orderList,
    this.orderDetailPath = HotelApiPaths.orderDetail,
    this.permitMemberPayPath = HotelApiPaths.permitMemberPay,
    this.cancelOrderRulePath = HotelApiPaths.cancelOrderRule,
    this.cancelOrderPath = HotelApiPaths.cancelOrder,
    this.priceByDatePath = HotelApiPaths.priceByDate,
    this.assignOccupancyPath = HotelApiPaths.assignOccupancy,
    this.countryCodeListPath = HotelApiPaths.countryCodeList,
    this.roomExtraPersonPath = HotelApiPaths.roomExtraPerson,
    this.couponsOrderCustListPath = HotelApiPaths.couponsOrderCustList,
    this.memberInfoPath = HotelApiPaths.memberInfo,
    this.memberInfoUpdatePath = HotelApiPaths.memberInfoUpdate,
    this.memberContactsListPath = HotelApiPaths.memberContactsList,
    this.cardPayAuthPath = HotelApiPaths.cardPayAuth,
    this.cardPayJoinPath = HotelApiPaths.cardPayJoin,
    this.cardRegisterListPath = HotelApiPaths.cardRegisterList,
    this.cardPayByIdPath = HotelApiPaths.cardPayById,
    this.cardRegisterPath = HotelApiPaths.cardRegister,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String hotelSearchPath;
  final String bookingOrderPath;
  final String bookingOrderSendPaymentLinkPath;
  final String buildingCodePath;
  final String pagePath;
  final String refundStrategyTextPath;
  final String roomFacilityPath;
  final String hotelDetailPath;
  final String bookingOrderSaveV2Path;
  final String payForOrderPath;
  final String orderListPath;
  final String orderDetailPath;
  final String permitMemberPayPath;
  final String cancelOrderRulePath;
  final String cancelOrderPath;
  final String priceByDatePath;
  final String assignOccupancyPath;
  final String countryCodeListPath;
  final String roomExtraPersonPath;
  final String couponsOrderCustListPath;
  final String memberInfoPath;
  final String memberInfoUpdatePath;
  final String memberContactsListPath;
  final String cardPayAuthPath;
  final String cardPayJoinPath;
  final String cardRegisterListPath;
  final String cardPayByIdPath;
  final String cardRegisterPath;

  Future<HotelSearchResultDto> searchHotels(
    HotelSearchRequestDto request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      hotelSearchPath,
      data: request.toJson(),
      options: authRequired(false),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel list.',
    );
    return HotelSearchResultDto.fromJson(data);
  }

  Future<int> createAirhostBooking(
    AirhostBookingOrderRequestDto request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      bookingOrderPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataString(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to create Airhost booking.',
    );
    return int.parse(data);
  }

  Future<String> sendAirhostPaymentLink(
    OrderSendPaymentLinkRequestDto request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      bookingOrderSendPaymentLinkPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    return _envelopeCodec.extractDataString(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to send Airhost payment link.',
    );
  }

  Future<List<HotelBuildingCodeDto>> fetchBuildingCodes({
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      buildingCodePath,
      data: <String, dynamic>{'lang': lang},
      options: authRequired(false),
    );

    final rows = _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel building codes.',
    );
    return rows.map(HotelBuildingCodeDto.fromJson).toList(growable: false);
  }

  Future<List<HotelFacilityFilterDto>> fetchRoomFacilities({
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      roomFacilityPath,
      data: <String, dynamic>{'lang': lang},
      options: authRequired(false),
    );

    final rows = _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel room facilities.',
    );
    return rows.map(HotelFacilityFilterDto.fromJson).toList(growable: false);
  }

  Future<Map<String, String>> fetchPageText({
    required String lang,
    required String pageCode,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      pagePath,
      data: <String, dynamic>{'lang': lang, 'pageCode': pageCode},
      options: authRequired(false),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel page text.',
    );
    final rows = data['pageTemplateDetailDTO'];
    if (rows is! List) {
      return const <String, String>{};
    }
    return Map<String, String>.fromEntries(
      rows
          .map((row) {
            final rowMap = _envelopeCodec.toJsonMap(row);
            final entity = _envelopeCodec.toJsonMap(
              rowMap['pageTemplateDetailEntity'],
            );
            final key = '${entity['resCatalog'] ?? ''}${entity['resID'] ?? ''}';
            final value = entity['showName']?.toString().trim() ?? '';
            return MapEntry(key, value);
          })
          .where((entry) => entry.key.isNotEmpty && entry.value.isNotEmpty),
    );
  }

  Future<HotelAssignOccupancyResultDto> assignOccupancy(
    HotelAssignOccupancyRequestDto request, {
    bool authRequiredForRequest = false,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      assignOccupancyPath,
      data: request.toJson(),
      options: authRequired(authRequiredForRequest),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to assign hotel occupancy.',
    );
    return HotelAssignOccupancyResultDto.fromJson(data);
  }

  Future<Map<String, String>> fetchCountryCodeList({
    required String lang,
    bool authRequiredForRequest = false,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      countryCodeListPath,
      data: <String, dynamic>{'lang': lang},
      options: authRequired(authRequiredForRequest),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel country codes.',
    );
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<HotelRoomExtraPersonResultDto> fetchRoomExtraPerson(
    HotelRoomExtraPersonRequestDto request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      roomExtraPersonPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel room extra person quote.',
    );
    return HotelRoomExtraPersonResultDto.fromJson(data);
  }

  Future<Map<String, dynamic>> fetchOrderCoupons({
    required String lang,
    required String hotelId,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      couponsOrderCustListPath,
      data: <String, dynamic>{'lang': lang, 'hotelId': hotelId},
      options: authRequired(true),
    );

    return _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel coupons.',
    );
  }

  Future<HotelMemberInfoDto> fetchMemberInfo() async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      memberInfoPath,
      data: <String, dynamic>{},
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel member info.',
    );
    return HotelMemberInfoDto.fromJson(data);
  }

  Future<void> updateMemberInfo(HotelMemberInfoUpdateRequestDto request) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      memberInfoUpdatePath,
      data: request.toJson(),
      options: authRequired(true),
    );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to update hotel member info.',
      requireTruthyData: true,
    );
  }

  Future<List<Map<String, dynamic>>> fetchMemberContacts({
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      memberContactsListPath,
      data: <String, dynamic>{'lang': lang},
      options: authRequired(true),
    );

    return _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel member contacts.',
    );
  }

  Future<List<HotelCreditCardDto>> fetchRegisteredCards() async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cardRegisterListPath,
      data: <String, dynamic>{},
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load registered credit cards.',
    );
    return rows.map(HotelCreditCardDto.fromJson).toList(growable: false);
  }

  Future<String> registerCreditCard(
    HotelCreditCardRegisterRequestDto request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cardRegisterPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    return _envelopeCodec.extractDataString(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to register credit card.',
    );
  }

  Future<HotelCreditCardPaymentResultDto> payWithCreditCardToken(
    HotelCreditCardRegisterRequestDto request, {
    required bool saveCard,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      saveCard ? cardPayJoinPath : cardPayAuthPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to pay hotel order by credit card.',
    );
    return HotelCreditCardPaymentResultDto.fromJson(data);
  }

  Future<String> fetchRefundStrategyText({
    required String lang,
    required String siteCode,
    required String checkIn,
    required String hotelId,
    bool authRequiredForRequest = false,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      refundStrategyTextPath,
      data: <String, dynamic>{
        'lang': lang,
        'siteCode': siteCode,
        'checkIn': checkIn,
        'hotelId': hotelId,
      },
      options: authRequired(authRequiredForRequest),
    );

    return _envelopeCodec.extractDataString(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel refund policy.',
    );
  }

  Future<HotelDetailDto> fetchHotelDetail(
    HotelDetailRequestDto request, {
    bool authRequiredForRequest = false,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      hotelDetailPath,
      data: request.toJson(),
      options: authRequired(authRequiredForRequest),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel detail.',
    );
    if (data.isEmpty) {
      throw StateError('Failed to load hotel detail.');
    }
    return HotelDetailDto.fromJson(data);
  }

  Future<HotelPriceCalendarDto> fetchPriceByDate({
    required String hotelInfoId,
    bool authRequiredForRequest = false,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      priceByDatePath,
      data: <String, dynamic>{'hotelInfoID': hotelInfoId},
      options: authRequired(authRequiredForRequest),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel price calendar.',
    );
    return HotelPriceCalendarDto(pricesByDate: data);
  }

  Future<String> createBooking(HotelBookingCreateRequestDto request) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      bookingOrderSaveV2Path,
      data: request.toJson(),
      options: authRequired(true),
    );

    return _envelopeCodec.extractDataString(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to create hotel booking.',
    );
  }

  Future<HotelOrderListDto> fetchOrderList({
    required String lang,
    int startPage = 1,
    int limit = 20,
    Object? status,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      orderListPath,
      data: <String, dynamic>{
        'lang': lang,
        'startPage': startPage,
        'limit': limit,
        'status': status,
      },
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel orders.',
    );
    return HotelOrderListDto.fromJson(data);
  }

  Future<HotelOrderDto> fetchOrderDetail({
    required String orderId,
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      orderDetailPath,
      data: <String, dynamic>{'orderId': orderId, 'lang': lang},
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel order detail.',
    );
    if (data.isEmpty) {
      throw StateError('Failed to load hotel order detail.');
    }
    return HotelOrderDto.fromJson(data);
  }

  Future<HotelMemberPayInfoDto> fetchMemberPayInfo() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      permitMemberPayPath,
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel member pay info.',
    );
    return HotelMemberPayInfoDto.fromJson(data);
  }

  Future<HotelOrderCancelRuleResultDto> fetchCancelOrderRule({
    required String bookingOrderId,
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cancelOrderRulePath,
      data: <String, dynamic>{'bookingOrderId': bookingOrderId, 'lang': lang},
      options: authRequired(true),
    );

    final payload = _envelopeCodec.toJsonMap(response.data);
    final canCancel = _envelopeCodec.isSuccessEnvelope(
      payload,
      requireTruthyData: true,
    );
    final message = canCancel
        ? _envelopeCodec.extractDataString(
            payload,
            fallbackMessage: 'Failed to load hotel cancel rule.',
          )
        : _envelopeCodec.resolveErrorMessage(
            payload,
            fallbackMessage: 'Failed to load hotel cancel rule.',
          );
    return HotelOrderCancelRuleResultDto(
      canCancel: canCancel,
      message: message,
    );
  }

  Future<String> cancelOrder({
    required String bookingOrderId,
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cancelOrderPath,
      data: <String, dynamic>{'bookingOrderId': bookingOrderId, 'lang': lang},
      options: authRequired(true),
    );

    final payload = _envelopeCodec.toJsonMap(response.data);
    if (_envelopeCodec.isSuccessEnvelope(payload)) {
      return _envelopeCodec.resolveErrorMessage(
        payload,
        fallbackMessage: 'success',
      );
    }
    return _envelopeCodec.resolveErrorMessage(
      payload,
      fallbackMessage: 'Failed to cancel hotel order.',
    );
  }

  Future<HotelPaymentResultDto> payForOrder(Pay4OrderRequestDto request) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      payForOrderPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to pay hotel order.',
    );
    return HotelPaymentResultDto.fromJson(data);
  }

  Future<HotelCreditCardPaymentResultDto> payWithRegisteredCard(
    HotelRegisteredCardPaymentRequestDto request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cardPayByIdPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to pay hotel order by credit card.',
    );
    return HotelCreditCardPaymentResultDto.fromJson(data);
  }
}
