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
    final quoteFuture = _remote
        .fetchRoomExtraPerson(
          HotelRoomExtraPersonRequestDto(
            hotelId: seed.detail.id,
            checkIn: checkIn,
            checkOut: checkOut,
            lang: languageCode,
            roomTypeCustNums: seed.selectedRooms
                .map(
                  (selection) => HotelRoomTypeCustNumRequestDto(
                    roomTypeId: selection.room.id,
                    occupancy:
                        (selection.room.occupancy ?? seed.criteria.occupancy)
                            .toString(),
                  ),
                )
                .toList(growable: false),
          ),
        )
        .catchError((_) => const HotelRoomExtraPersonResultDto());
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

    return HotelBookingPreparation(
      pageTexts: Map<String, String>.unmodifiable(pageTexts),
      countryCodes: _mapCountryCodes(countryCodes),
      couponsAvailableCount: _listCount(coupons['availableList']),
      contactsCount: contacts.length,
      registeredCardCount: cards.length,
      quotedPrice: quote.priceElement?.price,
      originalPrice: quote.priceElement?.originalPrice,
    );
  }

  @override
  Future<String> createBooking(HotelBookingCreateDraft draft) {
    return _remote.createBooking(_mapBookingCreateRequest(draft));
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
    for (var index = 0; index < seed.selectedRooms.length; index++) {
      final selection = seed.selectedRooms[index];
      final room = selection.room;
      final guest = index < draft.roomGuests.length
          ? draft.roomGuests[index]
          : HotelBookingRoomGuestDraft(
              firstName: draft.booker.firstName,
              lastName: draft.booker.lastName,
              nationality: draft.booker.nationality,
              email: draft.booker.email,
              adults: seed.criteria.occupancy,
              children: seed.criteria.kids,
            );
      final roomTypeId = _intOrNull(room.id);
      final maxAdults = room.baseOccupancy ?? room.occupancy ?? guest.adults;
      final fallbackRoomPrice = totalRoomCount <= 0
          ? 0
          : draft.totalAmount / totalRoomCount;
      final roomPrice = room.price ?? fallbackRoomPrice;
      final guestCount = guest.adults + guest.children;
      final extraGuestCount = (guestCount - maxAdults).clamp(0, 999).toInt();
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
            totalGuestCount: guestCount,
            extraGuestCount: extraGuestCount,
            extraGuestPrice: 0,
          ),
          roomCusts: <HotelRoomCustomerDto>[
            HotelRoomCustomerDto(
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
          ],
        ),
      );
    }

    return HotelBookingCreateRequestDto(
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
    bookingTypeLabel: _formatBookingType(dto.bookingType),
    buildingType: dto.buildingType?.trim() ?? '',
    isBookable: dto.bookingStatus ?? true,
    remainingRooms: _mapSummaryRemainingRooms(dto),
    tags: dto.tags
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false),
  );
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
    baseOccupancy: dto.occupantsForBaseRate,
    roomSize: _stringOrEmpty(dto.roomSize),
    bedroomCount: dto.bedRoomCount,
    bathroomCount: dto.bathRoomCount,
    remainingRooms: dto.roomCount,
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
  );
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

int _listCount(Object? raw) {
  if (raw is List) {
    return raw.length;
  }
  return 0;
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
    checkedInText: dto.checkedInText?.trim() ?? '',
    adultCount: dto.adultCount,
    childCount: dto.childCount,
    paidAmount: dto.paidAmount,
    originalAmount: _numOrNull(dto.priceElement['originalPrice']),
    couponDiscountAmount: _numOrNull(dto.priceElement['coupons']),
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
    roomNo: dto.roomNo?.trim() ?? '',
    bookingType: dto.bookingType,
    pageTexts: pageTexts,
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
    roomNo: _stringOrEmpty(raw['roomNo']),
    name: _stringOrEmpty(raw['custName']),
    nationalityText: _stringOrEmpty(raw['nationalityText']),
    guestCount: _intOrNull(raw['custNum']) ?? _intOrNull(raw['count']),
    email: _firstNotEmpty(<String?>[
      _stringOrEmpty(raw['email']),
      _stringOrEmpty(raw['custEmail']),
      _stringOrEmpty(raw['contactEmail']),
    ]),
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
