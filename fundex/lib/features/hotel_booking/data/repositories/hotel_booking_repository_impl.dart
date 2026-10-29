import 'dart:convert';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/hotel_models.dart';
import '../../domain/repositories/hotel_booking_repository.dart';
import '../datasources/hotel_booking_remote_data_source.dart';

class HotelBookingRepositoryImpl implements HotelBookingRepository {
  HotelBookingRepositoryImpl({required HotelBookingRemoteDataSource remote})
    : _remote = remote;

  final HotelBookingRemoteDataSource _remote;
  final DateFormat _wireDateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _wireDateTimeFormat = DateFormat('yyyy-MM-dd 00:00:00');

  @override
  Future<HotelSearchResult> searchHotels({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  }) async {
    final result = await _remote.searchHotels(
      HotelSearchRequestDto(
        startPage: page,
        limit: limit,
        startDate: _wireDateFormat.format(criteria.checkInDate),
        endDate: _wireDateFormat.format(criteria.checkOutDate),
        keyWord: criteria.keyword.trim().isEmpty
            ? null
            : criteria.keyword.trim(),
        lang: languageCode,
        area: criteria.area.trim(),
        bookingType: criteria.bookingType,
        buildingCode: criteria.buildingCode?.trim() ?? '',
        priceSort: switch (criteria.priceSort) {
          HotelPriceSort.none => null,
          HotelPriceSort.ascending => 'asc',
          HotelPriceSort.descending => 'desc',
        },
        occupancy: criteria.occupancy,
        kids: criteria.kids,
        roomNum: criteria.roomCount,
        stayBenefit: criteria.stayBenefit,
      ),
    );

    return HotelSearchResult(
      hotels: result.hotels.map(_mapHotelSummary).toList(growable: false),
      totalCount: result.count ?? result.hotels.length,
    );
  }

  @override
  Future<List<HotelBuildingFilter>> fetchBuildingFilters({
    required String languageCode,
  }) async {
    final rows = await _remote.fetchBuildingCodes(languageCode: languageCode);
    return rows
        .map(
          (row) => HotelBuildingFilter(
            code: row.buildingCode.trim(),
            name: _formatBuildingName(row, languageCode),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<HotelStayBenefitPeriod>> fetchStayBenefitPeriods() async {
    final rows = await _remote.fetchStayBenefitPeriods();
    return _mapStayBenefitPeriods(rows);
  }

  @override
  Future<List<HotelStayBenefitPeriod>> fetchStayBenefitPeriodsForHotel({
    required String hotelId,
  }) async {
    final rows = await _remote.fetchStayBenefitPeriodsForHotel(
      hotelId: hotelId,
    );
    return _mapStayBenefitPeriods(rows);
  }

  @override
  Future<HotelPriceDiscount> fetchPriceDiscount({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required String languageCode,
  }) async {
    final raw = await _remote.fetchPriceDiscount(
      startDate: _wireDateFormat.format(criteria.checkInDate),
      endDate: _wireDateFormat.format(criteria.checkOutDate),
      languageCode: languageCode,
      hotelId: hotelId,
    );
    return _mapPriceDiscount(raw);
  }

  List<HotelStayBenefitPeriod> _mapStayBenefitPeriods(
    List<HotelStayBenefitPeriodDto> rows,
  ) {
    return rows
        .map(
          (row) => HotelStayBenefitPeriod(
            month: row.month,
            days: List<int>.unmodifiable(row.days),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<HotelDetail> fetchHotelDetail({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required String languageCode,
  }) async {
    final checkIn = _wireDateFormat.format(criteria.checkInDate);
    final checkOut = _wireDateFormat.format(criteria.checkOutDate);
    final detailFuture = _remote.fetchHotelDetail(
      HotelDetailRequestDto(
        id: hotelId,
        lang: languageCode,
        startDate: checkIn,
        endDate: checkOut,
        occupancy: criteria.occupancy,
      ),
    );
    final refundPolicyFuture = _remote
        .fetchRefundStrategyText(
          languageCode: languageCode,
          siteCode: 'gl',
          checkIn: checkIn,
          hotelId: hotelId,
        )
        .catchError((_) => '');
    final priceCalendarFuture = _remote
        .fetchPriceByDate(hotelInfoId: hotelId)
        .catchError((_) => const HotelPriceCalendarDto());

    final detail = await detailFuture;
    final refundPolicyText = await refundPolicyFuture;
    final priceCalendar = await priceCalendarFuture;
    return _mapHotelDetail(
      detail,
      refundPolicyText: refundPolicyText,
      priceCalendarByDate: priceCalendar.pricesByDate,
    );
  }

  @override
  Future<HotelAssignOccupancyResult> assignOccupancy({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required List<HotelSelectedRoom> selectedRooms,
    required String languageCode,
  }) async {
    final result = await _remote.assignOccupancy(
      HotelAssignOccupancyRequestDto(
        lang: languageCode,
        hotelId: hotelId,
        checkIn: _wireDateFormat.format(criteria.checkInDate),
        checkOut: _wireDateFormat.format(criteria.checkOutDate),
        occupancy: criteria.occupancy,
        roomTypeRoomNums: selectedRooms
            .where((selection) => selection.quantity > 0)
            .map(
              (selection) => HotelRoomTypeRoomNumDto(
                roomTypeId: selection.room.id,
                roomNumber: selection.quantity,
              ),
            )
            .toList(growable: false),
      ),
    );
    return _mapAssignOccupancyResult(result);
  }

  @override
  Future<HotelBookingPreparation> fetchBookingPreparation({
    required HotelBookingConfirmSeed seed,
    required String languageCode,
  }) async {
    final checkIn = _wireDateFormat.format(seed.criteria.checkInDate);
    final checkOut = _wireDateFormat.format(seed.criteria.checkOutDate);
    final pageTextFutures = <Future<Map<String, String>>>[
      for (final pageCode in const <String>[
        'APP011',
        'APP003',
        'APP004',
        'APP012',
      ])
        _remote
            .fetchPageText(languageCode: languageCode, pageCode: pageCode)
            .catchError((_) => const <String, String>{}),
    ];
    final countryCodesFuture = _remote
        .fetchCountryCodeList(languageCode: languageCode)
        .catchError((_) => const <String, String>{});
    final quoteFuture = _fetchPreparationQuote(
      seed: seed,
      languageCode: languageCode,
      checkIn: checkIn,
      checkOut: checkOut,
    ).catchError((_) => const HotelRoomExtraPersonResultDto());
    final couponsFuture = _remote
        .fetchOrderCoupons(languageCode: languageCode, hotelId: seed.detail.id)
        .catchError((_) => const <String, dynamic>{});
    final contactsFuture = _remote
        .fetchMemberContacts(languageCode: languageCode)
        .catchError((_) => const <Map<String, dynamic>>[]);
    final cardsFuture = _remote.fetchRegisteredCards().catchError(
      (_) => const <HotelCreditCardDto>[],
    );

    final pageTextMaps = await Future.wait(pageTextFutures);
    final pageTexts = <String, String>{};
    for (final pageText in pageTextMaps) {
      pageTexts.addAll(pageText);
    }
    final countryCodes = await countryCodesFuture;
    final quote = await quoteFuture;
    final coupons = await couponsFuture;
    final contacts = await contactsFuture;
    final cards = await cardsFuture;
    final couponItems = _mapOrderCoupons(coupons);
    final availableCouponCount = couponItems
        .where((coupon) => coupon.canUse ?? true)
        .length;

    return HotelBookingPreparation(
      pointTotal: quote.pointTotal,
      pageTexts: Map<String, String>.unmodifiable(pageTexts),
      countryCodes: _mapCountryCodes(countryCodes),
      coupons: List<HotelCoupon>.unmodifiable(couponItems),
      couponsAvailableCount: availableCouponCount,
      contactsCount: contacts.length,
      registeredCardCount: cards.length,
      quotedPrice: quote.priceElement?.price,
      originalPrice: quote.priceElement?.originalPrice,
      roomPriceElements: _mapRoomPriceElements(
        quote.priceElement?.roomPriceElements ??
            const <HotelRoomPriceElementDto>[],
      ),
    );
  }

  @override
  Future<HotelBookingQuote> quoteBookingPrice(
    HotelBookingQuoteRequest request,
  ) async {
    final couponsCounts = _mapCouponsCounts(request.coupons);
    final quote = request.usesRoomPlanSelection
        ? await _remote.fetchRoomExtraPerson(
            HotelRoomExtraPersonRequestDto(
              hotelId: request.hotelId,
              checkIn: _wireDateTimeFormat.format(request.checkIn),
              checkOut: _wireDateTimeFormat.format(request.checkOut),
              lang: request.languageCode,
              roomTypeCustNums: request.rooms
                  .map(
                    (room) => HotelRoomTypeCustNumRequestDto(
                      roomTypeId: room.roomTypeId,
                      occupancy: room.occupancy.toString(),
                    ),
                  )
                  .toList(growable: false),
              couponsCounts: couponsCounts,
            ),
          )
        : await _remote.fetchExtraPerson(
            hotelId: request.hotelId,
            checkIn: _wireDateFormat.format(request.checkIn),
            checkOut: _wireDateFormat.format(request.checkOut),
            languageCode: request.languageCode,
            orderRoomTypeData: _mapOrderRoomTypeDataForSelections(
              request.selectedRooms,
            ),
            customerCount: request.rooms.fold<int>(
              0,
              (sum, room) => sum + room.occupancy,
            ),
            couponsCounts: couponsCounts,
          );
    return HotelBookingQuote(
      pointTotal: quote.pointTotal,
      quotedPrice: quote.priceElement?.price,
      originalPrice: quote.priceElement?.originalPrice,
      roomPriceElements: _mapRoomPriceElements(
        quote.priceElement?.roomPriceElements ??
            const <HotelRoomPriceElementDto>[],
      ),
    );
  }

  @override
  Future<String> createBooking(HotelBookingCreateDraft draft) {
    return _remote.createBooking(_mapBookingCreateRequest(draft));
  }

  @override
  Future<HotelCouponListResult> fetchCoupons({
    required String languageCode,
  }) async {
    final pageTextFuture = _remote
        .fetchPageText(languageCode: languageCode, pageCode: 'APP011')
        .catchError((_) => const <String, String>{});
    final couponsFuture = _remote.fetchCoupons(languageCode: languageCode);
    final pageTexts = await pageTextFuture;
    final coupons = await couponsFuture;
    return HotelCouponListResult(
      coupons: coupons.map(_mapCoupon).toList(growable: false),
      pageTexts: Map<String, String>.unmodifiable(pageTexts),
    );
  }

  @override
  Future<List<HotelFundBenefitTicket>> fetchFundBenefitTickets() async {
    final rows = await _remote.fetchFundBenefitTickets();
    return rows.map(_mapFundBenefitTicket).toList(growable: false);
  }

  @override
  Future<List<HotelMemberContact>> fetchMemberContacts({
    required String languageCode,
  }) async {
    final rows = await _remote.fetchMemberContacts(languageCode: languageCode);
    return rows.map(_mapMemberContact).toList(growable: false);
  }

  @override
  Future<List<HotelCountryCode>> fetchCountryCodes({
    required String languageCode,
  }) async {
    final rows = await _remote.fetchCountryCodeList(languageCode: languageCode);
    return _mapCountryCodes(rows);
  }

  @override
  Future<void> saveMemberContact(HotelMemberContactDraft draft) {
    return _remote.saveOrUpdateMemberContact(
      HotelMemberContactSaveRequestDto(
        id: draft.id,
        memberId: draft.memberId,
        name: draft.name,
        firstName: draft.firstName.trim(),
        lastName: draft.lastName.trim(),
        email: draft.email.trim(),
        intlCode: _normalizeIntlCode(draft.intlCode),
        mobile: draft.mobile.trim(),
        nationality: draft.nationality.trim(),
        defaultOption: draft.isDefault,
        dr: draft.dr,
        nationalityText: draft.nationalityText,
      ),
    );
  }

  @override
  Future<void> deleteMemberContact({required String id}) {
    return _remote.deleteMemberContact(id: id.trim());
  }

  @override
  Future<HotelOrderListResult> fetchOrderList({
    required String languageCode,
    required HotelOrderStatusFilter status,
    int page = 1,
    int limit = 5,
  }) async {
    final dto = await _remote.fetchOrderList(
      languageCode: languageCode,
      page: page,
      limit: limit,
      status: status.wireStatus,
    );
    final orders = dto.orders.map(_mapOrderSummary).toList(growable: false);
    return HotelOrderListResult(
      orders: orders,
      totalCount: dto.count ?? orders.length,
      page: dto.startPage ?? page,
      limit: dto.limit ?? limit,
    );
  }

  @override
  Future<List<HotelTodayCheckIn>> fetchTodayCheckIns({
    required String languageCode,
  }) async {
    const pageCodes = <String>['APP007', 'APP003', 'APP008'];
    await Future.wait(
      pageCodes.map(
        (pageCode) => _remote
            .fetchPageText(languageCode: languageCode, pageCode: pageCode)
            .catchError((_) => const <String, String>{}),
      ),
    );
    final rows = await _remote.fetchTodayCheckIns(languageCode: languageCode);
    return rows.map(_mapTodayCheckIn).toList(growable: false);
  }

  @override
  Future<HotelOrderDetail> fetchOrderDetail({
    required String languageCode,
    required String orderId,
  }) async {
    const pageCodes = <String>['APP008', 'APP003', 'APP0011'];
    final detailFuture = _remote.fetchOrderDetail(
      languageCode: languageCode,
      orderId: orderId,
    );
    final pageTextFuture = Future.wait(
      pageCodes.map(
        (pageCode) => _remote
            .fetchPageText(languageCode: languageCode, pageCode: pageCode)
            .catchError((_) => const <String, String>{}),
      ),
    );

    final dto = await detailFuture;
    final pageTextMaps = await pageTextFuture;
    final pageTexts = <String, Map<String, String>>{};
    for (var index = 0; index < pageCodes.length; index += 1) {
      pageTexts[pageCodes[index]] = Map<String, String>.unmodifiable(
        pageTextMaps[index],
      );
    }

    return _mapOrderDetail(
      dto,
      pageTexts: Map<String, Map<String, String>>.unmodifiable(pageTexts),
    );
  }

  @override
  Future<String> requestOrderInvoice({
    required String orderId,
    required String receiptTitle,
    required String email,
  }) {
    return _remote.requestOrderInvoice(
      orderId: orderId,
      receiptTitle: receiptTitle,
      email: email,
    );
  }

  @override
  Future<void> setUserLanguage({required String languageCode}) {
    return _remote.setUserLanguage(languageCode: languageCode);
  }

  @override
  Future<HotelOrderCancelRule> fetchCancelOrderRule({
    required String languageCode,
    required String orderId,
  }) async {
    final result = await _remote.fetchCancelOrderRule(
      languageCode: languageCode,
      orderId: orderId,
    );
    return HotelOrderCancelRule(
      canCancel: result.canCancel,
      message: result.message.trim(),
    );
  }

  @override
  Future<String> cancelOrder({
    required String languageCode,
    required String orderId,
  }) {
    return _remote.cancelOrder(languageCode: languageCode, orderId: orderId);
  }

  @override
  Future<String> checkInOrderCustomer({
    required String orderId,
    required int checkedIn,
    String? roomId,
  }) {
    return _remote.checkInOrderCustomer(
      orderId: orderId.trim(),
      checkedIn: checkedIn,
      roomId: roomId,
    );
  }

  @override
  Future<HotelMemberProfile> fetchMemberProfile() async {
    final dto = await _remote.fetchMemberInfo();
    return _mapMemberProfile(dto);
  }

  @override
  Future<void> updateMemberProfile(HotelMemberProfile profile) {
    return _remote.updateMemberInfo(
      HotelMemberInfoUpdateRequestDto(
        id: profile.id,
        memberName: profile.memberName.trim(),
        email: profile.email.trim(),
        phoneCountryCode: profile.phoneCountryCode.trim(),
        phoneNumber: profile.phoneNumber.trim(),
        birthday: profile.birthday.trim(),
        gender: profile.gender,
        sourceUserId: profile.sourceUserId,
      ),
    );
  }

  @override
  Future<List<HotelCreditCard>> fetchRegisteredCreditCards() async {
    final rows = await _remote.fetchRegisteredCards();
    return rows.map(_mapCreditCard).toList(growable: false);
  }

  @override
  Future<HotelMemberPayInfo> fetchMemberPayInfo() async {
    final info = await _remote.fetchMemberPayInfo();
    return HotelMemberPayInfo(balance: info.balance ?? 0);
  }

  @override
  Future<String> registerCreditCard(HotelCreditCardRegistrationDraft draft) {
    return _remote.registerCreditCard(
      HotelCreditCardRegisterRequestDto(
        cardToken: HotelCreditCardTokenDto(
          token: draft.token.token,
          tokenExpireDate: draft.token.tokenExpireDate,
          reqCardNumber: draft.token.reqCardNumber,
          status: draft.token.status,
          code: draft.token.code,
          message: draft.token.message,
        ),
        bookingOrderId: draft.bookingOrderId.trim(),
        defaultFlag: draft.defaultFlag ? 1 : 0,
        cardholderMobilePhoneCountry: draft.mobileCountryCode.trim(),
        cardholderMobilePhoneNumber: draft.mobileNumber.trim(),
        cardholderEmail: draft.email.trim(),
      ),
    );
  }

  @override
  Future<String> unregisterCreditCard(String cardId) {
    return _remote.unregisterCreditCard(cardId: cardId.trim());
  }

  @override
  Future<HotelCreditCardPaymentResult> payWithCreditCardToken({
    required HotelCreditCardRegistrationDraft draft,
    required bool saveCard,
  }) async {
    final result = await _remote.payWithCreditCardToken(
      HotelCreditCardRegisterRequestDto(
        cardToken: HotelCreditCardTokenDto(
          token: draft.token.token,
          tokenExpireDate: draft.token.tokenExpireDate,
          reqCardNumber: draft.token.reqCardNumber,
          status: draft.token.status,
          code: draft.token.code,
          message: draft.token.message,
        ),
        bookingOrderId: draft.bookingOrderId.trim(),
        defaultFlag: draft.defaultFlag ? 1 : 0,
        cardholderMobilePhoneCountry: draft.mobileCountryCode.trim(),
        cardholderMobilePhoneNumber: draft.mobileNumber.trim(),
        cardholderEmail: draft.email.trim(),
      ),
      saveCard: saveCard,
    );
    return HotelCreditCardPaymentResult(
      pay: result.pay ?? false,
      secureUrl: result.url?.trim() ?? '',
    );
  }

  @override
  Future<HotelCreditCardPaymentResult> payWithRegisteredCreditCard({
    required String cardId,
    required String orderId,
  }) async {
    final result = await _remote.payWithRegisteredCard(
      HotelRegisteredCardPaymentRequestDto(
        cardId: cardId.trim(),
        bookingOrderId: orderId.trim(),
      ),
    );
    return HotelCreditCardPaymentResult(
      pay: result.pay ?? false,
      secureUrl: result.url?.trim() ?? '',
    );
  }

  @override
  Future<HotelOrderPaymentResult> payOrder({
    required String orderId,
    required String paymentCode,
    required num totalAmount,
    required String languageCode,
    bool isCheck = false,
  }) async {
    final result = await _remote.payForOrder(
      Pay4OrderRequestDto(
        bookingOrderId: int.parse(orderId.trim()),
        paymentCode: paymentCode.trim(),
        totalAmount: totalAmount,
        lang: _legacyHotelPaymentLang(languageCode),
        isCheck: isCheck,
        system: 'app',
      ),
    );
    return _mapOrderPaymentResult(result);
  }

  @override
  Future<HotelOrderPaymentResult> createAlipayPayment({
    required String orderId,
    required String system,
  }) async {
    final result = await _remote.createAliAppPayment(
      AliAppPayRequestDto(id: int.parse(orderId.trim()), system: system.trim()),
    );
    return HotelOrderPaymentResult(
      pay: false,
      message: '',
      code: null,
      wechat: null,
      alipay: _mapAliPayResponseApp(result),
    );
  }

  @override
  Future<String> syncOptimismPayment({
    required String orderId,
    required bool success,
  }) {
    return _remote.syncOptimismPayment(
      OptimismPaymentRequestDto(
        id: int.parse(orderId.trim()),
        success: success,
      ),
    );
  }

  Future<HotelRoomExtraPersonResultDto> _fetchPreparationQuote({
    required HotelBookingConfirmSeed seed,
    required String languageCode,
    required String checkIn,
    required String checkOut,
  }) {
    if (seed.usesRoomPlanSelection) {
      return _remote.fetchRoomExtraPerson(
        HotelRoomExtraPersonRequestDto(
          hotelId: seed.detail.id,
          checkIn: checkIn,
          checkOut: checkOut,
          lang: languageCode,
          roomTypeCustNums: _roomTypeCustNumsForSeed(seed),
        ),
      );
    }
    return _remote.fetchExtraPerson(
      hotelId: seed.detail.id,
      checkIn: checkIn,
      checkOut: checkOut,
      languageCode: languageCode,
      orderRoomTypeData: _mapOrderRoomTypeDataForSelections(seed.selectedRooms),
      customerCount: seed.criteria.occupancy + seed.criteria.kids,
      couponsCounts: const <Object?>[],
    );
  }

  List<HotelRoomTypeCustNumRequestDto> _roomTypeCustNumsForSeed(
    HotelBookingConfirmSeed seed,
  ) {
    final assignedOccupanciesByRoomId = <String, List<int>>{};
    for (final assignment in seed.roomTypeCustNums) {
      if (assignment.occupancy <= 0) {
        continue;
      }
      assignedOccupanciesByRoomId
          .putIfAbsent(assignment.roomTypeId, () => <int>[])
          .add(assignment.occupancy);
    }
    final rows = <HotelRoomTypeCustNumRequestDto>[];
    for (final selection in seed.selectedRooms) {
      final assignedOccupancies =
          assignedOccupanciesByRoomId[selection.room.id] ?? <int>[];
      for (var index = 0; index < selection.quantity; index += 1) {
        final occupancy = assignedOccupancies.isNotEmpty
            ? assignedOccupancies.removeAt(0)
            : 1;
        rows.add(
          HotelRoomTypeCustNumRequestDto(
            roomTypeId: selection.room.id,
            occupancy: occupancy.clamp(1, 999).toString(),
          ),
        );
      }
    }
    return rows;
  }

  List<Object?> _mapCouponsCounts(List<HotelBookingSelectedCoupon> coupons) {
    return coupons
        .map(
          (coupon) => <String, Object>{
            'couponsId': coupon.couponId,
            'count': coupon.count,
          },
        )
        .toList(growable: false);
  }

  List<Map<String, Object?>> _mapOrderRoomTypeDataForSelections(
    List<HotelSelectedRoom> selectedRooms,
  ) {
    return selectedRooms
        .map(
          (selection) => <String, Object?>{
            'roomTypeID': selection.room.id,
            'roomCount': selection.quantity,
            'roomTypename': selection.room.name,
            'roomPrice': selection.room.price,
            'occupancy':
                selection.room.baseOccupancy ?? selection.room.occupancy,
          },
        )
        .toList(growable: false);
  }

  HotelCreditCard _mapCreditCard(HotelCreditCardDto dto) {
    return HotelCreditCard(
      id: dto.cardId.trim(),
      maskedNumber: dto.cardNumber.trim(),
      expire: dto.cardExpire.trim(),
      holderName: dto.cardholderName.trim(),
      isDefault: dto.defaultCard.trim() == '1',
      brandCode: _firstNotEmpty(<String?>[dto.kindCode, dto.acquireCode3]),
    );
  }

  HotelOrderPaymentResult _mapOrderPaymentResult(HotelPaymentResultDto dto) {
    return HotelOrderPaymentResult(
      pay: dto.pay ?? false,
      message: dto.msg?.trim() ?? '',
      code: dto.code,
      wechat: _mapWechatPayment(dto.wechatPay ?? dto.swaggerWechatPay),
      alipay: _mapAlipayPayment(dto),
    );
  }

  HotelWechatPaymentPayload? _mapWechatPayment(HotelWechatPaymentDto? dto) {
    if (dto == null) {
      return null;
    }
    return HotelWechatPaymentPayload(
      appId: dto.appId?.trim() ?? '',
      partnerId: dto.mchId?.trim() ?? '',
      prepayId: dto.prepayId?.trim() ?? '',
      packageValue: dto.packageValue?.trim() ?? '',
      nonceStr: dto.nonceStr?.trim() ?? '',
      timestamp: _intOrNull(dto.timeStamp),
      paySign: dto.paySign?.trim() ?? '',
      signType: dto.signType?.trim() ?? '',
      mwebUrl: dto.mwebUrl?.trim() ?? '',
    );
  }

  HotelAlipayPaymentPayload? _mapAlipayPayment(HotelPaymentResultDto dto) {
    final orderInfo = _firstNotEmpty(<String?>[
      dto.aliPay?.orderInfo,
      dto.aliPay?.paymentData,
      dto.aliPay?.normalUrl,
      dto.swaggerAliPay?.orderInfo,
      dto.swaggerAliPay?.paymentData,
      dto.swaggerAliPay?.normalUrl,
      dto.aliPayReponseApp?.orderInfo,
      dto.aliPayReponseApp?.paymentData,
      dto.aliPayReponseApp?.payUrl,
      dto.aliPayReponseApp?.normalUrl,
    ]);
    if (orderInfo.isEmpty) {
      return null;
    }
    return HotelAlipayPaymentPayload(orderInfo: orderInfo);
  }

  HotelAlipayPaymentPayload? _mapAliPayResponseApp(AliPayResponseAppDto dto) {
    final orderInfo = _firstNotEmpty(<String?>[
      dto.orderInfo,
      dto.paymentData,
      dto.payUrl,
      dto.normalUrl,
    ]);
    if (orderInfo.isEmpty) {
      return null;
    }
    return HotelAlipayPaymentPayload(orderInfo: orderInfo);
  }

  HotelBookingCreateRequestDto _mapBookingCreateRequest(
    HotelBookingCreateDraft draft,
  ) {
    final seed = draft.seed;
    final totalRoomCount = seed.selectedRooms.fold<int>(
      0,
      (sum, selection) => sum + selection.quantity,
    );
    final totalGuestCount = draft.roomGuests.fold<int>(
      0,
      (sum, guest) => sum + guest.adults + guest.children,
    );
    final orderRooms = <HotelOrderRoomTypeDataDto>[];
    var guestCursor = 0;
    for (final selection in seed.selectedRooms) {
      final room = selection.room;
      final guestsForSelection = <HotelBookingRoomGuestDraft>[];
      for (var index = 0; index < selection.quantity; index += 1) {
        if (guestCursor < draft.roomGuests.length) {
          guestsForSelection.add(draft.roomGuests[guestCursor]);
        } else {
          guestsForSelection.add(
            HotelBookingRoomGuestDraft(
              firstName: draft.booker.firstName,
              lastName: draft.booker.lastName,
              nationality: draft.booker.nationality,
              email: draft.booker.email,
              adults: seed.criteria.occupancy,
              children: seed.criteria.kids,
            ),
          );
        }
        guestCursor += 1;
      }
      final roomTypeId = _intOrNull(room.id);
      final maxAdults =
          room.baseOccupancy ??
          room.occupancy ??
          (guestsForSelection.isEmpty
              ? null
              : guestsForSelection.first.adults) ??
          seed.criteria.occupancy;
      final fallbackRoomPrice = totalRoomCount <= 0
          ? 0
          : draft.totalAmount / totalRoomCount;
      final roomPrice = room.price ?? fallbackRoomPrice;
      final selectionGuestCount = guestsForSelection.fold<int>(
        0,
        (sum, guest) => sum + guest.adults + guest.children,
      );
      final extraGuestCount = guestsForSelection.fold<int>(
        0,
        (sum, guest) =>
            sum +
            ((guest.adults + guest.children) - maxAdults).clamp(0, 999).toInt(),
      );
      orderRooms.add(
        HotelOrderRoomTypeDataDto(
          roomTypeId: room.id,
          roomCount: selection.quantity,
          roomTypename: room.name,
          roomPrice: roomPrice,
          occupancy: maxAdults,
          roomTypeExtraGuestPrices: HotelRoomTypeExtraGuestPriceDto(
            roomTypeId: roomTypeId ?? room.id,
            roomTypeName: room.name,
            roomCount: selection.quantity,
            totalGuestCount: selectionGuestCount,
            extraGuestCount: extraGuestCount,
            extraGuestPrice: 0,
          ),
          roomCusts: guestsForSelection
              .map(
                (guest) => HotelRoomCustomerDto(
                  roomTypeId: roomTypeId,
                  firstName: guest.firstName,
                  lastName: guest.lastName,
                  name: guest.fullName,
                  email: guest.email,
                  count: guest.adults,
                  childCount: guest.children,
                  nationality: guest.nationality,
                  maxcount: maxAdults,
                ),
              )
              .toList(growable: false),
        ),
      );
    }

    return HotelBookingCreateRequestDto(
      fundBenefitTicketNo: draft.fundBenefitTicketNo,
      couponsCounts: draft.selectedCoupons.isEmpty
          ? null
          : draft.selectedCoupons
                .map(
                  (coupon) => <String, dynamic>{
                    'couponsId': coupon.couponId,
                    'count': coupon.count,
                  },
                )
                .toList(growable: false),
      parent: HotelBookingCreateParentDto(
        bookingOrderEntity: HotelBookingOrderEntityDto(
          checkIn: _wireDateTimeFormat.format(seed.criteria.checkInDate),
          checkOut: _wireDateTimeFormat.format(seed.criteria.checkOutDate),
          firstName: draft.booker.firstName,
          lastName: draft.booker.lastName,
          name: draft.booker.fullName,
          nationality: draft.booker.nationality,
          lang: draft.languageCode,
          hotelInfoId: seed.detail.id,
          roomCount: totalRoomCount,
          totalRoomCount: totalRoomCount,
          totalCount: totalGuestCount,
          contactIntlCode: _normalizeIntlCode(draft.booker.intlCode),
          contactMobile: draft.booker.mobile,
          contactEmail: draft.booker.email,
          receiptTitle: draft.receiptTitle,
          comment: draft.comment,
          orderRoomTypeData: orderRooms,
          totalAmount: draft.totalAmount,
        ),
      ),
    );
  }
}

String _legacyHotelPaymentLang(String raw) {
  final normalized = raw.trim().toLowerCase();
  if (normalized.startsWith('ja') || normalized == 'jp') {
    return 'JP';
  }
  if (normalized.startsWith('zh') || normalized == 'cn') {
    return 'CN';
  }
  return 'EN';
}

String _formatBuildingName(HotelBuildingCodeDto dto, String languageCode) {
  final localizedName = dto.localizedNames[languageCode]?.trim();
  if (localizedName != null && localizedName.isNotEmpty) {
    return localizedName;
  }
  final defaultName = dto.buildingName.trim();
  if (defaultName.isNotEmpty) {
    return defaultName;
  }
  return dto.buildingCode.trim();
}

HotelSummary _mapHotelSummary(HotelSummaryDto dto) {
  final price = dto.basePrice2 ?? dto.basePrice ?? dto.price ?? dto.entirePrice;
  final discount = dto.discount2 ?? dto.discount;
  final discountName = dto.discountName2 ?? '';
  return HotelSummary(
    description: dto.detail,
    id: dto.id,
    name: dto.hotelName.trim(),
    address: dto.address?.trim() ?? '',
    area: dto.area?.trim() ?? '',
    imageUrl: dto.image?.trim() ?? '',
    latitude: _doubleOrNull(dto.lat),
    longitude: _doubleOrNull(dto.lng),
    lowestPrice: price,
    beforeDiscountPrice: dto.beforeDiscountPrice ?? dto.basePrice,
    discount: discount,
    discountName: discountName.trim(),
    bookingType: _intOrNull(dto.bookingType),
    buildingCode: dto.buildingCode?.trim() ?? '',
    bookingTypeLabel: _formatBookingType(dto.bookingType),
    buildingType: dto.buildingType?.trim() ?? '',
    isBookable: dto.bookingStatus ?? true,
    remainingRooms: _mapSummaryRemainingRooms(dto),
    stayBenefitParticipate: dto.stayBenefitParticipate,
    tags: dto.tags
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false),
  );
}

HotelPriceDiscount _mapPriceDiscount(Map<String, dynamic> raw) {
  return HotelPriceDiscount(
    discount: _numOrNull(raw['discount']),
    discountName: _stringOrEmpty(raw['discountName']),
    discountAmount: _numOrNull(raw['discountAmount']),
    memberDiscount: _numOrNull(raw['memberDiscount']),
    memberDiscountName: _stringOrEmpty(raw['memberDiscountName']),
    memberDiscountAmount: _numOrNull(raw['memberDiscountAmount']),
    originalAmount: _numOrNull(raw['originalAmount']),
    finalAmount: _numOrNull(raw['finalAmount']),
    totalDiscountAmount: _numOrNull(raw['totalDiscountAmount']),
  );
}

HotelCoupon _mapCoupon(HotelCouponDto dto) {
  return HotelCoupon(
    id: dto.couponsId,
    name: dto.couponsName.trim(),
    number: dto.number,
    detail: dto.detail.trim(),
    type: dto.type,
    discount: dto.discount,
    amount: dto.amount,
    amountEvery: dto.amountEvery.trim(),
    hotelNames: dto.hotelNames.trim(),
    beginDate: dto.beginDate.trim(),
    endDate: dto.endDate.trim(),
    createdTime: dto.createdTime.trim(),
    canUse: dto.use,
  );
}

HotelFundBenefitTicket _mapFundBenefitTicket(HotelFundBenefitTicketDto dto) {
  return HotelFundBenefitTicket(
    id: dto.id,
    ticketNo: dto.ticketNo.trim(),
    benefitAmount: dto.benefitAmount,
    grantMethod: dto.grantMethod,
    ticketStatus: dto.ticketStatus,
    grantTime: dto.grantTime.trim(),
    usedTime: dto.usedTime.trim(),
    bookingOrderId: dto.bookingOrderId,
    createdTime: dto.createdTime.trim(),
    updatedTime: dto.updatedTime.trim(),
  );
}

HotelMemberContact _mapMemberContact(Map<String, dynamic> raw) {
  return HotelMemberContact(
    id: _stringOrEmpty(raw['id']),
    memberId: _intOrNull(raw['memberId']),
    name: _stringOrEmpty(raw['name']),
    firstName: _stringOrEmpty(raw['firstName']),
    lastName: _stringOrEmpty(raw['lastName']),
    email: _stringOrEmpty(raw['email']),
    intlCode: _normalizeIntlCode(_stringOrEmpty(raw['intlCode'])),
    mobile: _stringOrEmpty(raw['mobile']),
    nationality: _stringOrEmpty(raw['nationality']),
    nationalityText: _stringOrEmpty(raw['nationalityText']),
    isDefault: raw['defaultOption'] == true,
    dr: _intOrNull(raw['dr']),
  );
}

List<HotelCoupon> _mapOrderCoupons(Map<String, dynamic> raw) {
  final coupons = <HotelCoupon>[];
  void append(Object? source, {bool? canUse}) {
    if (source is! List) {
      return;
    }
    for (final item in source) {
      if (item is! Map) {
        continue;
      }
      final row = Map<String, dynamic>.from(item);
      if (canUse != null && !row.containsKey('use')) {
        row['use'] = canUse;
      }
      coupons.add(_mapCoupon(HotelCouponDto.fromJson(row)));
    }
  }

  append(raw['availableList'], canUse: true);
  append(raw['unavailableList'], canUse: false);
  append(raw['disableList'], canUse: false);
  append(raw['disabledList'], canUse: false);
  append(raw['unUseList'], canUse: false);
  if (coupons.isEmpty) {
    append(raw['data']);
    append(raw['list']);
  }
  return coupons;
}

int? _mapSummaryRemainingRooms(HotelSummaryDto dto) {
  if (dto.roomCount != null) {
    return dto.roomCount;
  }
  return _parseRemainingRoomsText(dto.remainRoomNum);
}

int? _parseRemainingRoomsText(Object? raw) {
  final text = raw?.toString().trim() ?? '';
  if (text.isEmpty) {
    return null;
  }
  final lower = text.toLowerCase();
  if (text.contains('無') ||
      text.contains('无') ||
      text.contains('なし') ||
      lower.contains('no ')) {
    return 0;
  }
  if (text.contains('以上') || text.contains('+') || lower.contains('more')) {
    return 5;
  }
  final digits = StringBuffer();
  for (final codeUnit in text.codeUnits) {
    if (codeUnit >= 48 && codeUnit <= 57) {
      digits.writeCharCode(codeUnit);
      continue;
    }
    if (digits.isNotEmpty) {
      break;
    }
  }
  return digits.isEmpty ? null : int.tryParse(digits.toString());
}

String _formatBookingType(Object? raw) {
  final value = raw?.toString().trim();
  return switch (value) {
    '0' => 'AirHost',
    '1' => 'PMS',
    '2' => 'Hotel',
    _ => '',
  };
}

HotelDetail _mapHotelDetail(
  HotelDetailDto dto, {
  required String refundPolicyText,
  required Map<String, Object?> priceCalendarByDate,
}) {
  return HotelDetail(
    id: dto.id.trim(),
    name: dto.name.trim(),
    address: dto.address?.trim() ?? '',
    description: dto.description?.trim() ?? '',
    latitude: _doubleOrNull(dto.lat),
    longitude: _doubleOrNull(dto.lng),
    bookingType: dto.bookingType,
    buildingTypeStr: dto.buildingTypeStr?.trim() ?? '',
    isBookable: dto.bookingStatus ?? true,
    entirePrice: dto.entirePrice,
    checkInMessage: dto.checkInMessage?.trim() ?? '',
    checkInTime: dto.checkInTime?.trim() ?? '',
    checkOutTime: dto.checkOutTime?.trim() ?? '',
    detailText: dto.detail?.trim() ?? '',
    surroundingText: dto.surrounding?.trim() ?? '',
    travelText: dto.travel?.trim() ?? '',
    checkInGuide: dto.checkInGuide?.trim() ?? '',
    ruleText: dto.rule?.trim() ?? '',
    refundPolicyText: refundPolicyText.trim(),
    telNo: dto.telNo?.trim() ?? '',
    facilities: _mapFacilities(dto),
    images: dto.pictures.map(_mapDetailImage).toList(growable: false),
    roomPlans: dto.roomTypes.map(_mapRoomPlan).toList(growable: false),
    tags: dto.tags
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false),
    priceCalendarByDate: Map<String, Object?>.unmodifiable(priceCalendarByDate),
  );
}

HotelDetailImage _mapDetailImage(HotelPictureDto dto) {
  return HotelDetailImage(
    url: dto.relativeUrl.trim(),
    description: dto.description?.trim() ?? '',
  );
}

HotelRoomPlan _mapRoomPlan(HotelRoomTypeDto dto) {
  final discount = dto.discount2 ?? dto.discount;
  final discountName = dto.discountName2 ?? '';
  return HotelRoomPlan(
    id: dto.id.trim(),
    name: (dto.showName?.trim().isNotEmpty ?? false)
        ? dto.showName!.trim()
        : dto.name.trim(),
    price: dto.price,
    beforeDiscountPrice: dto.beforeDiscountPrice,
    discount: discount,
    discountName: discountName.trim(),
    occupancy: dto.occupancy,
    adultCapacity: dto.adults,
    childCapacity: dto.kids,
    baseOccupancy: dto.occupantsForBaseRate,
    roomSize: _stringOrEmpty(dto.roomSize),
    bedroomCount: dto.bedRoomCount,
    bathroomCount: dto.bathRoomCount,
    remainingRooms: dto.roomCount,
    minimumStayNights: dto.minStay,
    description: dto.description?.trim() ?? '',
    facilityCategories: _mapRoomFacilityCategories(dto),
    images: dto.pictures.map(_mapDetailImage).toList(growable: false),
    beds: dto.beds.map(_mapRoomBed).toList(growable: false),
  );
}

HotelRoomBed _mapRoomBed(HotelRoomBedDto dto) {
  return HotelRoomBed(
    name: dto.name.trim(),
    quantity: dto.quantity ?? dto.num ?? dto.count,
    width: _stringOrEmpty(dto.width),
  );
}

HotelAssignOccupancyResult _mapAssignOccupancyResult(
  HotelAssignOccupancyResultDto dto,
) {
  return HotelAssignOccupancyResult(
    price: dto.price,
    message: dto.message?.trim() ?? '',
    roomTypeCustNums: dto.roomTypeCustNums
        .map(
          (item) => HotelRoomOccupancyAssignment(
            roomTypeId: _stringOrEmpty(item.roomTypeId),
            occupancy: item.occupancy ?? 0,
          ),
        )
        .where((item) => item.roomTypeId.isNotEmpty)
        .toList(growable: false),
    roomTypeExtraGuestPrices: dto.roomTypeExtraGuestPrices
        .map(
          (item) => HotelRoomTypeExtraGuestPrice(
            roomTypeId: _stringOrEmpty(item.roomTypeId),
            roomTypeName: item.roomTypeName?.trim() ?? '',
            roomCount: item.roomCount ?? 0,
            totalGuestCount: item.totalGuestCount ?? 0,
            extraGuestCount: item.extraGuestCount ?? 0,
            extraGuestPrice: item.extraGuestPrice,
          ),
        )
        .where((item) => item.roomTypeId.isNotEmpty)
        .toList(growable: false),
  );
}

List<HotelBookingRoomPriceElement> _mapRoomPriceElements(
  List<HotelRoomPriceElementDto> rows,
) {
  return rows
      .map(
        (row) => HotelBookingRoomPriceElement(
          roomTypeId: _stringOrEmpty(row.roomTypeId),
          freeUserPrice: row.freeUserPrice ?? 0,
          priceTip: row.priceTip?.trim() ?? '',
        ),
      )
      .toList(growable: false);
}

List<HotelCountryCode> _mapCountryCodes(Map<String, String> rows) {
  final values = rows.entries
      .map((entry) {
        final label = entry.key.trim();
        final code = entry.value.trim();
        return HotelCountryCode(code: code, name: label);
      })
      .where((item) => item.code.isNotEmpty && item.name.isNotEmpty)
      .toList();
  values.sort((a, b) => a.code.compareTo(b.code));
  return values;
}

HotelMemberProfile _mapMemberProfile(HotelMemberInfoDto dto) {
  return HotelMemberProfile(
    id: dto.id,
    memberName: dto.memberName.trim(),
    email: dto.email.trim(),
    phoneCountryCode: dto.phoneCountryCode.trim(),
    phoneNumber: dto.phoneNumber.trim(),
    birthday: dto.birthday.trim(),
    gender: dto.gender,
    joinDate: dto.joinDate.trim(),
    membersLevel: dto.membersLevel.trim(),
    membersLevelCode: dto.membersLevelCode,
    discount: dto.discount,
    expireDate: dto.expireDate.trim(),
    sourceUserId: dto.sourceUserId,
    membersStatus: dto.membersStatus.trim(),
  );
}

HotelOrderSummary _mapOrderSummary(HotelOrderDto dto) {
  final price = _numOrNull(dto.priceElement['price']);
  final originalPrice = _numOrNull(dto.priceElement['originalPrice']);
  return HotelOrderSummary(
    id: (dto.orderId.isNotEmpty ? dto.orderId : dto.id ?? '').trim(),
    hotelName: dto.hotelName?.trim() ?? '',
    buildingName: dto.buildingName?.trim() ?? '',
    hotelImageUrl: _firstNotEmpty(<String?>[
      dto.hotelImage,
      dto.hotelHomeImage,
    ]),
    hotelAddress: _firstNotEmpty(<String?>[dto.hotelAddress, dto.address]),
    checkIn: dto.checkIn?.trim() ?? '',
    checkOut: dto.checkOut?.trim() ?? '',
    bookingOrderTime:
        dto.bookingOrderTime?.trim() ?? dto.createdTime?.trim() ?? '',
    paymentStatus: dto.paymentStatus?.trim() ?? '',
    paymentStatusCode: dto.paymentStatusCode,
    orderStatus: dto.orderStatusStr?.trim().isNotEmpty == true
        ? dto.orderStatusStr!.trim()
        : dto.orderStatus?.trim() ?? _stringOrEmpty(dto.status),
    orderStatusCode: dto.orderStatusCode,
    payCode: dto.payCode?.trim() ?? '',
    totalAmount: dto.totalAmount ?? dto.paidAmount ?? price ?? originalPrice,
    canPay: dto.pay ?? false,
    canRefund: dto.refund ?? false,
  );
}

HotelTodayCheckIn _mapTodayCheckIn(HotelOrderDto dto) {
  final checkedInText = dto.checkedIn?.trim();
  final checkedIn = checkedInText == '1' || checkedInText == 'true';
  return HotelTodayCheckIn(
    id: (dto.orderId.isNotEmpty ? dto.orderId : dto.id ?? '').trim(),
    hotelName: dto.hotelName?.trim() ?? '',
    buildingName: dto.buildingName?.trim() ?? '',
    hotelImageUrl: _firstNotEmpty(<String?>[
      dto.hotelImage,
      dto.hotelHomeImage,
    ]),
    hotelAddress: _firstNotEmpty(<String?>[dto.hotelAddress, dto.address]),
    checkIn: dto.checkIn?.trim() ?? '',
    checkOut: dto.checkOut?.trim() ?? '',
    orderStatus: dto.orderStatusStr?.trim().isNotEmpty == true
        ? dto.orderStatusStr!.trim()
        : dto.orderStatus?.trim() ?? _stringOrEmpty(dto.status),
    orderStatusCode: dto.orderStatusCode,
    paymentStatus: dto.paymentStatus?.trim() ?? '',
    paymentStatusCode: dto.paymentStatusCode,
    totalAmount: dto.totalAmount ?? dto.paidAmount,
    roomNo: dto.roomNo?.trim() ?? '',
    checkedIn: checkedIn,
  );
}

HotelOrderDetail _mapOrderDetail(
  HotelOrderDto dto, {
  required Map<String, Map<String, String>> pageTexts,
}) {
  final rooms = _mapOrderRooms(dto.roomTypeCount);
  return HotelOrderDetail(
    summary: _mapOrderSummary(dto),
    hotelId: dto.hotelId?.trim() ?? '',
    imageUrl: _firstNotEmpty(<String?>[dto.hotelHomeImage, dto.hotelImage]),
    address: _firstNotEmpty(<String?>[dto.address, dto.hotelAddress]),
    latitude: _doubleOrNull(dto.lat),
    longitude: _doubleOrNull(dto.lng),
    orderNo: dto.orderNo?.trim() ?? '',
    serialNo: dto.serialNo?.trim() ?? '',
    createdTime: dto.createdTime?.trim() ?? '',
    guestName: dto.name?.trim() ?? '',
    receiptTitle: dto.receiptTitle?.trim() ?? '',
    contactEmail: dto.contactEmail?.trim() ?? '',
    contactIntlCode: dto.contactIntlCode?.trim() ?? '',
    contactMobile: dto.contactMobile?.trim() ?? '',
    nationalityText: dto.nationalityText?.trim() ?? '',
    checkedInStatus: _intOrNull(dto.checkedIn),
    checkedInText: dto.checkedInText?.trim() ?? '',
    adultCount: dto.adultCount,
    childCount: dto.childCount,
    paidAmount: dto.paidAmount,
    originalAmount: _numOrNull(dto.priceElement['originalPrice']),
    couponDiscountAmount: _numOrNull(dto.priceElement['coupons']),
    fundBenefitTicket: _mapOrderFundBenefitTicket(
      dto.priceElement['fundBenefitTicket'],
    ),
    payName: dto.payName?.trim() ?? '',
    payCode: dto.payCode?.trim() ?? '',
    paymentTime: dto.paymentTime?.trim() ?? '',
    comment: dto.comment?.trim() ?? '',
    checkInGuide: dto.checkInGuide?.trim() ?? '',
    cancelRule: dto.cancelRule?.trim() ?? '',
    gatePassword: _firstNotEmpty(<String?>[
      for (final room in rooms)
        for (final guest in room.guests) guest.password,
    ]),
    rooms: rooms,
    roomId: dto.roomId?.toString() ?? '',
    roomNo: dto.roomNo?.trim() ?? '',
    bookingType: dto.bookingType,
    pageTexts: pageTexts,
  );
}

HotelOrderFundBenefitTicket? _mapOrderFundBenefitTicket(Object? raw) {
  final map = hotelMapFromJson(raw);
  if (map.isEmpty) {
    return null;
  }
  final dto = HotelOrderFundBenefitTicketDto.fromJson(map);
  final hasValue =
      dto.ticketNo.trim().isNotEmpty ||
      dto.benefitAmount != null ||
      dto.deductionAmount != null ||
      dto.beforePrice != null ||
      dto.afterPrice != null;
  if (!hasValue) {
    return null;
  }
  return HotelOrderFundBenefitTicket(
    id: dto.id?.trim() ?? '',
    ticketNo: dto.ticketNo.trim(),
    benefitAmount: dto.benefitAmount,
    deductionAmount: dto.deductionAmount,
    beforePrice: dto.beforePrice,
    afterPrice: dto.afterPrice,
  );
}

List<HotelOrderRoomSummary> _mapOrderRooms(
  List<Map<String, Object?>> rawRooms,
) {
  return rawRooms
      .map((room) {
        final guests = hotelMapListFromJson(
          room['roomIdCustNums'],
        ).map(_mapOrderRoomGuest).toList(growable: false);
        return HotelOrderRoomSummary(
          name: _firstNotEmpty(<String?>[
            _stringOrEmpty(room['showName']),
            _stringOrEmpty(room['name']),
            _stringOrEmpty(room['roomTypeName']),
          ]),
          imageUrl: _firstOrderRoomImage(room),
          roomCount: _intOrNull(room['roomCount']),
          guests: guests,
        );
      })
      .where(
        (room) =>
            room.name.isNotEmpty ||
            room.imageUrl.isNotEmpty ||
            room.guests.isNotEmpty,
      )
      .toList(growable: false);
}

HotelOrderRoomGuest _mapOrderRoomGuest(Map<String, Object?> raw) {
  return HotelOrderRoomGuest(
    roomTypeName: _stringOrEmpty(raw['roomTypeName']),
    roomId: _firstNotEmpty(<String?>[
      _stringOrEmpty(raw['roomId']),
      _stringOrEmpty(raw['roomID']),
      _stringOrEmpty(raw['id']),
    ]),
    roomNo: _stringOrEmpty(raw['roomNo']),
    name: _stringOrEmpty(raw['custName']),
    nationalityText: _stringOrEmpty(raw['nationalityText']),
    guestCount: _intOrNull(raw['custNum']) ?? _intOrNull(raw['count']),
    email: _firstNotEmpty(<String?>[
      _stringOrEmpty(raw['email']),
      _stringOrEmpty(raw['custEmail']),
      _stringOrEmpty(raw['contactEmail']),
    ]),
    checkedInStatus:
        _intOrNull(raw['checkedIn']) ?? _intOrNull(raw['checkedInStatus']),
    checkedInText: _stringOrEmpty(raw['checkedInText']),
    password: _stringOrEmpty(raw['password']),
  );
}

String _firstOrderRoomImage(Map<String, Object?> room) {
  final pictures = hotelMapListFromJson(room['roomPictures']);
  if (pictures.isEmpty) {
    return '';
  }
  return _firstNotEmpty(<String?>[
    _stringOrEmpty(pictures.first['relativeUrl']),
    _stringOrEmpty(pictures.first['thumbnail']),
    _stringOrEmpty(pictures.first['localPath']),
  ]);
}

List<String> _mapFacilities(HotelDetailDto dto) {
  final values = <String>[
    for (final value in dto.propertyFacilities) _stringOrEmpty(value),
    for (final value in dto.propertyFacilityNames.values) _stringOrEmpty(value),
  ];
  return values
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet()
      .toList(growable: false);
}

List<HotelRoomFacilityCategory> _mapRoomFacilityCategories(
  HotelRoomTypeDto dto,
) {
  final typedCategories = dto.roomTypeFacilities
      .map(_mapRoomFacilityCategory)
      .where((category) => category.items.isNotEmpty)
      .toList(growable: false);
  if (typedCategories.isNotEmpty) {
    return typedCategories;
  }

  final legacyItems = _roomFacilityItemsFromRaw(dto.roomFacility);
  if (legacyItems.isEmpty) {
    return const <HotelRoomFacilityCategory>[];
  }
  return <HotelRoomFacilityCategory>[
    HotelRoomFacilityCategory(code: 'all', name: '', items: legacyItems),
  ];
}

HotelRoomFacilityCategory _mapRoomFacilityCategory(Map<String, Object?> raw) {
  return HotelRoomFacilityCategory(
    code: _stringOrEmpty(raw['categoryCode']),
    name: _stringOrEmpty(raw['categoryName']),
    items: _roomFacilityItemsFromRaw(raw['items']),
  );
}

List<String> _roomFacilityItemsFromRaw(Object? raw) {
  if (raw == null) {
    return const <String>[];
  }
  if (raw is List) {
    return raw
        .map(_stringOrEmpty)
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
  if (raw is Map) {
    return _roomFacilityItemsFromRaw(raw['id'] ?? raw['items']);
  }
  if (raw is String) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const <String>[];
    }
    try {
      return _roomFacilityItemsFromRaw(jsonDecode(trimmed));
    } catch (_) {
      return <String>[trimmed];
    }
  }
  return <String>[
    _stringOrEmpty(raw),
  ].where((value) => value.isNotEmpty).toList();
}

double? _doubleOrNull(Object? raw) {
  if (raw is num) {
    return raw.toDouble();
  }
  return double.tryParse(raw?.toString().trim() ?? '');
}

num? _numOrNull(Object? raw) {
  if (raw is num) {
    return raw;
  }
  return num.tryParse(raw?.toString().trim().replaceAll(',', '') ?? '');
}

String _stringOrEmpty(Object? raw) {
  return raw?.toString().trim() ?? '';
}

String _firstNotEmpty(Iterable<String?> values) {
  for (final value in values) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return '';
}

int? _intOrNull(Object? raw) {
  if (raw is int) {
    return raw;
  }
  if (raw is num) {
    return raw.toInt();
  }
  return int.tryParse(raw?.toString().trim() ?? '');
}

String _normalizeIntlCode(String raw) {
  final trimmed = raw.trim();
  if (trimmed.startsWith('+')) {
    return trimmed.substring(1);
  }
  return trimmed;
}
