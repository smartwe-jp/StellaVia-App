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

class HotelDetail {
  const HotelDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.bookingType,
    required this.isBookable,
    required this.entirePrice,
    required this.checkInMessage,
    required this.checkInTime,
    required this.checkOutTime,
    required this.detailText,
    required this.surroundingText,
    required this.travelText,
    required this.checkInGuide,
    required this.ruleText,
    required this.refundPolicyText,
    required this.telNo,
    required this.facilities,
    required this.images,
    required this.roomPlans,
    required this.tags,
    required this.priceCalendarByDate,
  });

  final String id;
  final String name;
  final String address;
  final String description;
  final double? latitude;
  final double? longitude;
  final int? bookingType;
  final bool isBookable;
  final num? entirePrice;
  final String checkInMessage;
  final String checkInTime;
  final String checkOutTime;
  final String detailText;
  final String surroundingText;
  final String travelText;
  final String checkInGuide;
  final String ruleText;
  final String refundPolicyText;
  final String telNo;
  final List<String> facilities;
  final List<HotelDetailImage> images;
  final List<HotelRoomPlan> roomPlans;
  final List<String> tags;
  final Map<String, Object?> priceCalendarByDate;

  num? get lowestRoomPrice {
    final prices = roomPlans
        .map((room) => room.price)
        .whereType<num>()
        .toList(growable: false);
    if (prices.isEmpty) {
      return entirePrice;
    }
    prices.sort();
    return prices.first;
  }
}

class HotelDetailImage {
  const HotelDetailImage({required this.url, required this.description});

  final String url;
  final String description;
}

class HotelRoomPlan {
  const HotelRoomPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.beforeDiscountPrice,
    required this.discount,
    required this.discountName,
    required this.occupancy,
    required this.baseOccupancy,
    required this.roomSize,
    required this.bedroomCount,
    required this.bathroomCount,
    required this.remainingRooms,
    required this.images,
    required this.beds,
  });

  final String id;
  final String name;
  final num? price;
  final num? beforeDiscountPrice;
  final num? discount;
  final String discountName;
  final int? occupancy;
  final int? baseOccupancy;
  final String roomSize;
  final int? bedroomCount;
  final int? bathroomCount;
  final int? remainingRooms;
  final List<HotelDetailImage> images;
  final List<HotelRoomBed> beds;
}

class HotelRoomBed {
  const HotelRoomBed({
    required this.name,
    required this.quantity,
    required this.width,
  });

  final String name;
  final int? quantity;
  final String width;
}

const Object _unset = Object();
