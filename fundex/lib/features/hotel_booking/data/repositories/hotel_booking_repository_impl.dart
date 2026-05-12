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
        area: criteria.area.trim().isEmpty ? null : criteria.area.trim(),
        bookingType: criteria.bookingType,
        buildingCode:
            criteria.buildingCode == null || criteria.buildingCode!.isEmpty
            ? null
            : criteria.buildingCode,
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
        .where((row) => row.buildingCode.trim().isNotEmpty)
        .map(
          (row) => HotelBuildingFilter(
            code: row.buildingCode.trim(),
            name: row.buildingName.trim().isEmpty
                ? row.buildingCode.trim()
                : row.buildingName.trim(),
          ),
        )
        .toList(growable: false);
  }
}

HotelSummary _mapHotelSummary(HotelSummaryDto dto) {
  final price = dto.basePrice ?? dto.price ?? dto.entirePrice;
  return HotelSummary(
    id: dto.id,
    name: dto.hotelName.trim(),
    address: dto.address?.trim() ?? '',
    area: dto.area?.trim() ?? '',
    imageUrl: dto.image?.trim() ?? '',
    lowestPrice: price,
    beforeDiscountPrice: dto.beforeDiscountPrice,
    discountName: dto.discountName?.trim() ?? '',
    bookingTypeLabel: _formatBookingType(dto.bookingType),
    buildingType: dto.buildingType?.trim() ?? '',
    isBookable: dto.bookingStatus ?? true,
    tags: dto.tags
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false),
  );
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
