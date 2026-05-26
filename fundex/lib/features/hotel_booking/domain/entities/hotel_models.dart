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
    required this.latitude,
    required this.longitude,
    required this.lowestPrice,
    required this.beforeDiscountPrice,
    required this.discount,
    required this.discountName,
    required this.bookingTypeLabel,
    required this.buildingType,
    required this.isBookable,
    required this.remainingRooms,
    required this.tags,
  });

  final String id;
  final String name;
  final String address;
  final String area;
  final String imageUrl;
  final double? latitude;
  final double? longitude;
  final num? lowestPrice;
  final num? beforeDiscountPrice;
  final num? discount;
  final String discountName;
  final String bookingTypeLabel;
  final String buildingType;
  final bool isBookable;
  final int? remainingRooms;
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
    required this.description,
    required this.facilityCategories,
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
  final String description;
  final List<HotelRoomFacilityCategory> facilityCategories;
  final List<HotelDetailImage> images;
  final List<HotelRoomBed> beds;
}

class HotelSelectedRoom {
  const HotelSelectedRoom({required this.room, required this.quantity});

  final HotelRoomPlan room;
  final int quantity;

  num get subtotal => (room.price ?? 0) * quantity;
}

class HotelRoomOccupancyAssignment {
  const HotelRoomOccupancyAssignment({
    required this.roomTypeId,
    required this.occupancy,
  });

  final String roomTypeId;
  final int occupancy;
}

class HotelAssignOccupancyResult {
  const HotelAssignOccupancyResult({
    required this.price,
    required this.message,
    required this.roomTypeCustNums,
  });

  final num? price;
  final String message;
  final List<HotelRoomOccupancyAssignment> roomTypeCustNums;
}

class HotelCountryCode {
  const HotelCountryCode({required this.code, required this.name});

  final String code;
  final String name;
}

class HotelBookingPreparation {
  const HotelBookingPreparation({
    required this.pageTexts,
    required this.countryCodes,
    required this.couponsAvailableCount,
    required this.contactsCount,
    required this.registeredCardCount,
    required this.quotedPrice,
    required this.originalPrice,
  });

  final Map<String, String> pageTexts;
  final List<HotelCountryCode> countryCodes;
  final int couponsAvailableCount;
  final int contactsCount;
  final int registeredCardCount;
  final num? quotedPrice;
  final num? originalPrice;
}

class HotelMemberProfile {
  const HotelMemberProfile({
    required this.id,
    required this.memberName,
    required this.email,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.birthday,
    required this.gender,
    required this.joinDate,
    required this.membersLevel,
    required this.membersLevelCode,
    required this.discount,
    required this.expireDate,
    required this.sourceUserId,
    required this.membersStatus,
  });

  final int? id;
  final String memberName;
  final String email;
  final String phoneCountryCode;
  final String phoneNumber;
  final String birthday;
  final int? gender;
  final String joinDate;
  final String membersLevel;
  final int? membersLevelCode;
  final int? discount;
  final String expireDate;
  final int? sourceUserId;
  final String membersStatus;

  String get phoneDisplay {
    final code = phoneCountryCode.trim();
    final number = phoneNumber.trim();
    final normalizedCode = code.isEmpty
        ? ''
        : code.startsWith('+')
        ? code
        : '+$code';
    return <String>[
      normalizedCode,
      number,
    ].where((value) => value.isNotEmpty).join(' ');
  }

  HotelMemberProfile copyWith({
    int? id,
    String? memberName,
    String? email,
    String? phoneCountryCode,
    String? phoneNumber,
    String? birthday,
    Object? gender = _unset,
    String? joinDate,
    String? membersLevel,
    Object? membersLevelCode = _unset,
    Object? discount = _unset,
    String? expireDate,
    Object? sourceUserId = _unset,
    String? membersStatus,
  }) {
    return HotelMemberProfile(
      id: id ?? this.id,
      memberName: memberName ?? this.memberName,
      email: email ?? this.email,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthday: birthday ?? this.birthday,
      gender: identical(gender, _unset) ? this.gender : gender as int?,
      joinDate: joinDate ?? this.joinDate,
      membersLevel: membersLevel ?? this.membersLevel,
      membersLevelCode: identical(membersLevelCode, _unset)
          ? this.membersLevelCode
          : membersLevelCode as int?,
      discount: identical(discount, _unset) ? this.discount : discount as int?,
      expireDate: expireDate ?? this.expireDate,
      sourceUserId: identical(sourceUserId, _unset)
          ? this.sourceUserId
          : sourceUserId as int?,
      membersStatus: membersStatus ?? this.membersStatus,
    );
  }
}

enum HotelOrderStatusFilter {
  all,
  awaitingPayment,
  booked,
  cancelled;

  int? get wireStatus {
    return switch (this) {
      HotelOrderStatusFilter.all => null,
      HotelOrderStatusFilter.awaitingPayment => 0,
      HotelOrderStatusFilter.booked => 1,
      HotelOrderStatusFilter.cancelled => 3,
    };
  }
}

class HotelOrderListResult {
  const HotelOrderListResult({
    required this.orders,
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  final List<HotelOrderSummary> orders;
  final int totalCount;
  final int page;
  final int limit;

  bool get hasMore => orders.length < totalCount;
}

class HotelOrderSummary {
  const HotelOrderSummary({
    required this.id,
    required this.hotelName,
    required this.buildingName,
    required this.hotelImageUrl,
    required this.hotelAddress,
    required this.checkIn,
    required this.checkOut,
    required this.bookingOrderTime,
    required this.paymentStatus,
    required this.paymentStatusCode,
    required this.orderStatus,
    required this.orderStatusCode,
    required this.totalAmount,
    required this.canPay,
    required this.canRefund,
  });

  final String id;
  final String hotelName;
  final String buildingName;
  final String hotelImageUrl;
  final String hotelAddress;
  final String checkIn;
  final String checkOut;
  final String bookingOrderTime;
  final String paymentStatus;
  final int? paymentStatusCode;
  final String orderStatus;
  final int? orderStatusCode;
  final num? totalAmount;
  final bool canPay;
  final bool canRefund;
}

class HotelBookingConfirmSeed {
  const HotelBookingConfirmSeed({
    required this.detail,
    required this.criteria,
    required this.selectedRooms,
    required this.assignedPrice,
  });

  final HotelDetail detail;
  final HotelSearchCriteria criteria;
  final List<HotelSelectedRoom> selectedRooms;
  final num? assignedPrice;

  num? get fallbackAmount {
    if (assignedPrice != null) {
      return assignedPrice;
    }
    final total = selectedRooms.fold<num>(
      0,
      (sum, selection) => sum + selection.subtotal,
    );
    return total > 0 ? total : detail.lowestRoomPrice;
  }
}

class HotelBookingCreateDraft {
  const HotelBookingCreateDraft({
    required this.seed,
    required this.languageCode,
    required this.totalAmount,
    required this.booker,
    required this.roomGuests,
    required this.receiptTitle,
    required this.comment,
  });

  final HotelBookingConfirmSeed seed;
  final String languageCode;
  final num totalAmount;
  final HotelBookingPersonDraft booker;
  final List<HotelBookingRoomGuestDraft> roomGuests;
  final String receiptTitle;
  final String comment;
}

class HotelBookingPersonDraft {
  const HotelBookingPersonDraft({
    required this.firstName,
    required this.lastName,
    required this.nationality,
    required this.intlCode,
    required this.mobile,
    required this.email,
  });

  final String firstName;
  final String lastName;
  final String nationality;
  final String intlCode;
  final String mobile;
  final String email;

  String get fullName {
    return <String>[
      lastName.trim(),
      firstName.trim(),
    ].where((value) => value.isNotEmpty).join(' ');
  }
}

class HotelBookingRoomGuestDraft {
  const HotelBookingRoomGuestDraft({
    required this.firstName,
    required this.lastName,
    required this.nationality,
    required this.email,
    required this.adults,
    required this.children,
  });

  final String firstName;
  final String lastName;
  final String nationality;
  final String email;
  final int adults;
  final int children;

  String get fullName {
    return <String>[
      lastName.trim(),
      firstName.trim(),
    ].where((value) => value.isNotEmpty).join(' ');
  }
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

class HotelRoomFacilityCategory {
  const HotelRoomFacilityCategory({
    required this.code,
    required this.name,
    required this.items,
  });

  final String code;
  final String name;
  final List<String> items;
}

const Object _unset = Object();
