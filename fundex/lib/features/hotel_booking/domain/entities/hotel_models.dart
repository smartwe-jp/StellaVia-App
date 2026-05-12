class HotelSearchCriteria {
  const HotelSearchCriteria({
    required this.checkInDate,
    required this.checkOutDate,
    this.keyword = '',
    this.area = '',
    this.bookingType,
    this.buildingCode,
    this.priceSort = HotelPriceSort.none,
    this.occupancy = 1,
    this.kids = 0,
    this.roomCount = 1,
  });

  factory HotelSearchCriteria.initial(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return HotelSearchCriteria(
      checkInDate: today,
      checkOutDate: today.add(const Duration(days: 1)),
    );
  }

  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String keyword;
  final String area;
  final int? bookingType;
  final String? buildingCode;
  final HotelPriceSort priceSort;
  final int occupancy;
  final int kids;
  final int roomCount;

  int get nights => checkOutDate.difference(checkInDate).inDays.clamp(1, 365);
  int get guests => occupancy + kids;

  HotelSearchCriteria copyWith({
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? keyword,
    String? area,
    Object? bookingType = _unset,
    Object? buildingCode = _unset,
    HotelPriceSort? priceSort,
    int? occupancy,
    int? kids,
    int? roomCount,
  }) {
    return HotelSearchCriteria(
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      keyword: keyword ?? this.keyword,
      area: area ?? this.area,
      bookingType: identical(bookingType, _unset)
          ? this.bookingType
          : bookingType as int?,
      buildingCode: identical(buildingCode, _unset)
          ? this.buildingCode
          : buildingCode as String?,
      priceSort: priceSort ?? this.priceSort,
      occupancy: occupancy ?? this.occupancy,
      kids: kids ?? this.kids,
      roomCount: roomCount ?? this.roomCount,
    );
  }
}

enum HotelPriceSort { none, ascending, descending }

class HotelSearchResult {
  const HotelSearchResult({required this.hotels, required this.totalCount});

  final List<HotelSummary> hotels;
  final int totalCount;
}

class HotelSummary {
  const HotelSummary({
    required this.id,
    required this.name,
    required this.address,
    required this.area,
    required this.imageUrl,
    required this.lowestPrice,
    required this.beforeDiscountPrice,
    required this.discountName,
    required this.bookingTypeLabel,
    required this.buildingType,
    required this.isBookable,
    required this.tags,
  });

  final String id;
  final String name;
  final String address;
  final String area;
  final String imageUrl;
  final num? lowestPrice;
  final num? beforeDiscountPrice;
  final String discountName;
  final String bookingTypeLabel;
  final String buildingType;
  final bool isBookable;
  final List<String> tags;
}

class HotelBuildingFilter {
  const HotelBuildingFilter({required this.code, required this.name});

  final String code;
  final String name;
}

const Object _unset = Object();
