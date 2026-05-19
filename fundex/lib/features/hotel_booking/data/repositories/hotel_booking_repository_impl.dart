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
      (_) => const <Map<String, dynamic>>[],
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
  final match = RegExp(r'\d+').firstMatch(text);
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(0)!);
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

double? _doubleOrNull(Object? raw) {
  if (raw is num) {
    return raw.toDouble();
  }
  return double.tryParse(raw?.toString().trim() ?? '');
}

String _stringOrEmpty(Object? raw) {
  return raw?.toString().trim() ?? '';
}
