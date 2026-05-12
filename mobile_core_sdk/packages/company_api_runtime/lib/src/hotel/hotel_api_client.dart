import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'hotel_dtos.dart';

class HotelApiPaths {
  const HotelApiPaths._();

  static const String hotelSearch = '/hotel/hotelSearch';
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
    this.buildingCodePath = HotelApiPaths.buildingCode,
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
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String hotelSearchPath;
  final String buildingCodePath;
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
    String? status,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      orderListPath,
      data: <String, dynamic>{
        'lang': lang,
        'startPage': startPage,
        'limit': limit,
        if (status != null && status.isNotEmpty) 'status': status,
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

  Future<String> fetchCancelOrderRule({
    required String bookingOrderId,
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cancelOrderRulePath,
      data: <String, dynamic>{'bookingOrderId': bookingOrderId, 'lang': lang},
      options: authRequired(true),
    );

    return _envelopeCodec.extractDataString(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load hotel cancel rule.',
    );
  }

  Future<void> cancelOrder({
    required String bookingOrderId,
    required String lang,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      cancelOrderPath,
      data: <String, dynamic>{'bookingOrderId': bookingOrderId, 'lang': lang},
      options: authRequired(true),
    );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to cancel hotel order.',
      requireTruthyData: true,
    );
  }

  Future<HotelPaymentResultDto> payForOrder({
    required String bookingOrderId,
    required String paymentCode,
    required Object totalAmount,
    required String lang,
    String? token,
    bool? isCheck,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      payForOrderPath,
      data: <String, dynamic>{
        'bookingOrderID': bookingOrderId,
        'paymentCode': paymentCode,
        'totalAmount': totalAmount,
        'lang': lang,
        if (token != null && token.isNotEmpty) 'token': token,
        if (isCheck != null) 'isCheck': isCheck,
      },
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to pay hotel order.',
    );
    return HotelPaymentResultDto.fromJson(data);
  }
}
