// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HotelSearchRequestDto _$HotelSearchRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelSearchRequestDto(
  startPage: (json['startPage'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 20,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
  keyWord: json['keyWord'] as String?,
  lang: json['lang'] as String?,
  price: json['price'] as Map<String, dynamic>?,
  filterVal: json['filterVal'] as List<dynamic>?,
  area: json['area'] as String?,
  bookingType: (json['bookingType'] as num?)?.toInt(),
  buildingCode: json['buildingCode'] as String?,
  priceSort: json['priceSort'] as String?,
  occupancy: (json['occupancy'] as num?)?.toInt() ?? 1,
  kids: (json['kids'] as num?)?.toInt() ?? 0,
  roomNum: (json['roomNum'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$HotelSearchRequestDtoToJson(
  _HotelSearchRequestDto instance,
) => <String, dynamic>{
  'startPage': instance.startPage,
  'limit': instance.limit,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'keyWord': ?instance.keyWord,
  'lang': ?instance.lang,
  'price': ?instance.price,
  'filterVal': ?instance.filterVal,
  'area': ?instance.area,
  'bookingType': ?instance.bookingType,
  'buildingCode': ?instance.buildingCode,
  'priceSort': ?instance.priceSort,
  'occupancy': instance.occupancy,
  'kids': instance.kids,
  'roomNum': instance.roomNum,
};

_HotelSearchResultDto _$HotelSearchResultDtoFromJson(
  Map<String, dynamic> json,
) => _HotelSearchResultDto(
  hotels:
      (json['hotels'] as List<dynamic>?)
          ?.map((e) => HotelSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HotelSummaryDto>[],
  count: (json['count'] as num?)?.toInt(),
  showStatus: json['showStatus'],
  showStatusStr: json['showStatusStr'] as String?,
);

Map<String, dynamic> _$HotelSearchResultDtoToJson(
  _HotelSearchResultDto instance,
) => <String, dynamic>{
  'hotels': instance.hotels,
  'count': instance.count,
  'showStatus': instance.showStatus,
  'showStatusStr': instance.showStatusStr,
};

_HotelSummaryDto _$HotelSummaryDtoFromJson(Map<String, dynamic> json) =>
    _HotelSummaryDto(
      id: json['hotelId'] as String? ?? '',
      hotelName: json['hotelName'] as String? ?? '',
      address: json['address'] as String?,
      area: json['area'] as String?,
      image: json['image'] as String?,
      price: json['price'] as num?,
      basePrice: json['basePrice'] as num?,
      basePrice2: json['basePrice2'] as num?,
      beforeDiscountPrice: json['beforeDiscountPrice'] as num?,
      discount: json['discount'] as num?,
      discountName: json['discountName'] as String?,
      discount2: json['discount2'] as num?,
      discountName2: json['discountName2'] as String?,
      entirePrice: json['entirePrice'] as num?,
      bookingType: json['bookingType'],
      buildingCode: json['buildingCode'] as String?,
      buildingType: json['buildingType'] as String?,
      bookingStatus: json['bookingStatus'] as bool?,
      roomCount: (json['roomCount'] as num?)?.toInt(),
      remainRoomNum: json['remainRoomNum'],
      lat: json['lat'],
      lng: json['lng'],
      tags: json['tags'] == null
          ? const <String>[]
          : hotelStringListFromJson(json['tags']),
    );

Map<String, dynamic> _$HotelSummaryDtoToJson(_HotelSummaryDto instance) =>
    <String, dynamic>{
      'hotelId': instance.id,
      'hotelName': instance.hotelName,
      'address': instance.address,
      'area': instance.area,
      'image': instance.image,
      'price': instance.price,
      'basePrice': instance.basePrice,
      'basePrice2': instance.basePrice2,
      'beforeDiscountPrice': instance.beforeDiscountPrice,
      'discount': instance.discount,
      'discountName': instance.discountName,
      'discount2': instance.discount2,
      'discountName2': instance.discountName2,
      'entirePrice': instance.entirePrice,
      'bookingType': instance.bookingType,
      'buildingCode': instance.buildingCode,
      'buildingType': instance.buildingType,
      'bookingStatus': instance.bookingStatus,
      'roomCount': instance.roomCount,
      'remainRoomNum': instance.remainRoomNum,
      'lat': instance.lat,
      'lng': instance.lng,
      'tags': instance.tags,
    };

_HotelBuildingCodeDto _$HotelBuildingCodeDtoFromJson(
  Map<String, dynamic> json,
) => _HotelBuildingCodeDto(
  buildingCode: json['buildingCode'] as String? ?? '',
  buildingName: json['buildingName'] as String? ?? '',
  localizedNames:
      (json['localizedNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$HotelBuildingCodeDtoToJson(
  _HotelBuildingCodeDto instance,
) => <String, dynamic>{
  'buildingCode': instance.buildingCode,
  'buildingName': instance.buildingName,
  'localizedNames': instance.localizedNames,
};

_HotelFacilityFilterDto _$HotelFacilityFilterDtoFromJson(
  Map<String, dynamic> json,
) => _HotelFacilityFilterDto(
  code: json['convertCode'] as String? ?? '',
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$HotelFacilityFilterDtoToJson(
  _HotelFacilityFilterDto instance,
) => <String, dynamic>{'convertCode': instance.code, 'name': instance.name};

_HotelDetailRequestDto _$HotelDetailRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelDetailRequestDto(
  id: json['id'] as String,
  lang: json['lang'] as String,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
  occupancy: (json['occupancy'] as num?)?.toInt(),
);

Map<String, dynamic> _$HotelDetailRequestDtoToJson(
  _HotelDetailRequestDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'lang': instance.lang,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'occupancy': ?instance.occupancy,
};

_HotelDetailDto _$HotelDetailDtoFromJson(Map<String, dynamic> json) =>
    _HotelDetailDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      description: json['description'] as String?,
      lat: json['lat'],
      lng: json['lng'],
      bookingType: (json['bookingType'] as num?)?.toInt(),
      bookingStatus: json['bookingStatus'] as bool?,
      entirePrice: json['entirePrice'] as num?,
      checkInMessage: json['checkInMessage'] as String?,
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      detail: json['detail'] as String?,
      surrounding: json['surrounding'] as String?,
      travel: json['travel'] as String?,
      checkInGuide: json['checkInGuide'] as String?,
      rule: json['rule'] as String?,
      telNo: json['telNo'] as String?,
      propertyFacilities:
          json['propertyFacilities'] as List<dynamic>? ?? const <Object?>[],
      propertyFacilityNames:
          json['propertyFacilityNames'] as Map<String, dynamic>? ??
          const <String, Object?>{},
      pictures:
          (json['hotelPictures'] as List<dynamic>?)
              ?.map((e) => HotelPictureDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HotelPictureDto>[],
      roomTypes:
          (json['roomTypeDTO4APPs'] as List<dynamic>?)
              ?.map((e) => HotelRoomTypeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HotelRoomTypeDto>[],
      tags: json['tags'] == null
          ? const <String>[]
          : hotelStringListFromJson(json['tags']),
    );

Map<String, dynamic> _$HotelDetailDtoToJson(_HotelDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'description': instance.description,
      'lat': instance.lat,
      'lng': instance.lng,
      'bookingType': instance.bookingType,
      'bookingStatus': instance.bookingStatus,
      'entirePrice': instance.entirePrice,
      'checkInMessage': instance.checkInMessage,
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
      'detail': instance.detail,
      'surrounding': instance.surrounding,
      'travel': instance.travel,
      'checkInGuide': instance.checkInGuide,
      'rule': instance.rule,
      'telNo': instance.telNo,
      'propertyFacilities': instance.propertyFacilities,
      'propertyFacilityNames': instance.propertyFacilityNames,
      'hotelPictures': instance.pictures,
      'roomTypeDTO4APPs': instance.roomTypes,
      'tags': instance.tags,
    };

_HotelPictureDto _$HotelPictureDtoFromJson(Map<String, dynamic> json) =>
    _HotelPictureDto(
      relativeUrl: json['relativeUrl'] as String? ?? '',
      description: json['description'] as String?,
    );

Map<String, dynamic> _$HotelPictureDtoToJson(_HotelPictureDto instance) =>
    <String, dynamic>{
      'relativeUrl': instance.relativeUrl,
      'description': instance.description,
    };

_HotelRoomTypeDto _$HotelRoomTypeDtoFromJson(Map<String, dynamic> json) =>
    _HotelRoomTypeDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      showName: json['showName'] as String?,
      price: json['price'] as num?,
      beforeDiscountPrice: json['beforeDiscountPrice'] as num?,
      discount: json['discount'] as num?,
      discountName: json['discountName'] as String?,
      discount2: json['discount2'] as num?,
      discountName2: json['discountName2'] as String?,
      occupancy: (json['occupancy'] as num?)?.toInt(),
      occupantsForBaseRate: (json['occupantsForBaseRate'] as num?)?.toInt(),
      roomSize: json['roomSize'],
      bedRoomCount: (json['bedRoomCount'] as num?)?.toInt(),
      bathRoomCount: (json['bathRoomCount'] as num?)?.toInt(),
      roomCount: (json['roomCount'] as num?)?.toInt(),
      roomFacility: json['roomFacility'],
      roomTypeFacilities: json['roomTypeFacilities'] == null
          ? const <Map<String, Object?>>[]
          : hotelMapListFromJson(json['roomTypeFacilities']),
      description: json['description'] as String?,
      roomIds: json['roomIds'] == null
          ? const <String>[]
          : hotelStringListFromJson(json['roomIds']),
      pictures:
          (json['roomPictures'] as List<dynamic>?)
              ?.map((e) => HotelPictureDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HotelPictureDto>[],
      beds:
          (json['roomTypeBeds'] as List<dynamic>?)
              ?.map((e) => HotelRoomBedDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HotelRoomBedDto>[],
    );

Map<String, dynamic> _$HotelRoomTypeDtoToJson(_HotelRoomTypeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'showName': instance.showName,
      'price': instance.price,
      'beforeDiscountPrice': instance.beforeDiscountPrice,
      'discount': instance.discount,
      'discountName': instance.discountName,
      'discount2': instance.discount2,
      'discountName2': instance.discountName2,
      'occupancy': instance.occupancy,
      'occupantsForBaseRate': instance.occupantsForBaseRate,
      'roomSize': instance.roomSize,
      'bedRoomCount': instance.bedRoomCount,
      'bathRoomCount': instance.bathRoomCount,
      'roomCount': instance.roomCount,
      'roomFacility': instance.roomFacility,
      'roomTypeFacilities': instance.roomTypeFacilities,
      'description': instance.description,
      'roomIds': instance.roomIds,
      'roomPictures': instance.pictures,
      'roomTypeBeds': instance.beds,
    };

_HotelRoomBedDto _$HotelRoomBedDtoFromJson(Map<String, dynamic> json) =>
    _HotelRoomBedDto(
      name: json['name'] as String? ?? '',
      count: (json['count'] as num?)?.toInt(),
      num: (json['num'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      width: json['width'],
      extent: json['extent'],
    );

Map<String, dynamic> _$HotelRoomBedDtoToJson(_HotelRoomBedDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
      'num': instance.num,
      'quantity': instance.quantity,
      'width': instance.width,
      'extent': instance.extent,
    };

_HotelPriceCalendarDto _$HotelPriceCalendarDtoFromJson(
  Map<String, dynamic> json,
) => _HotelPriceCalendarDto(
  pricesByDate:
      json['pricesByDate'] as Map<String, dynamic>? ??
      const <String, Object?>{},
);

Map<String, dynamic> _$HotelPriceCalendarDtoToJson(
  _HotelPriceCalendarDto instance,
) => <String, dynamic>{'pricesByDate': instance.pricesByDate};

_HotelMemberInfoDto _$HotelMemberInfoDtoFromJson(Map<String, dynamic> json) =>
    _HotelMemberInfoDto(
      id: (json['id'] as num?)?.toInt(),
      memberName: json['memberName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneCountryCode: json['phoneCountryCode'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      birthday: hotelBirthdayReadValue(json, 'birthday') as String? ?? '',
      gender: (json['gender'] as num?)?.toInt(),
      joinDate: json['joinDate'] as String? ?? '',
      membersLevel: json['membersLevel'] as String? ?? '',
      membersLevelCode: (json['membersLevelCode'] as num?)?.toInt(),
      discount: (json['discount'] as num?)?.toInt(),
      expireDate: json['expireDate'] as String? ?? '',
      sourceUserId: (json['sourceUserId'] as num?)?.toInt(),
      membersStatus: json['membersStatus'] as String? ?? '',
    );

Map<String, dynamic> _$HotelMemberInfoDtoToJson(_HotelMemberInfoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberName': instance.memberName,
      'email': instance.email,
      'phoneCountryCode': instance.phoneCountryCode,
      'phoneNumber': instance.phoneNumber,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'joinDate': instance.joinDate,
      'membersLevel': instance.membersLevel,
      'membersLevelCode': instance.membersLevelCode,
      'discount': instance.discount,
      'expireDate': instance.expireDate,
      'sourceUserId': instance.sourceUserId,
      'membersStatus': instance.membersStatus,
    };

_HotelMemberInfoUpdateRequestDto _$HotelMemberInfoUpdateRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelMemberInfoUpdateRequestDto(
  id: (json['id'] as num?)?.toInt(),
  memberName: json['memberName'] as String?,
  email: json['email'] as String?,
  phoneCountryCode: json['phoneCountryCode'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  birthday: json['birthday'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  sourceUserId: (json['sourceUserId'] as num?)?.toInt(),
  emailCode: (json['emailCode'] as num?)?.toInt(),
  phoneCode: (json['phoneCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$HotelMemberInfoUpdateRequestDtoToJson(
  _HotelMemberInfoUpdateRequestDto instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'memberName': ?instance.memberName,
  'email': ?instance.email,
  'phoneCountryCode': ?instance.phoneCountryCode,
  'phoneNumber': ?instance.phoneNumber,
  'birthday': ?instance.birthday,
  'gender': ?instance.gender,
  'sourceUserId': ?instance.sourceUserId,
  'emailCode': ?instance.emailCode,
  'phoneCode': ?instance.phoneCode,
};

_HotelRoomTypeRoomNumDto _$HotelRoomTypeRoomNumDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomTypeRoomNumDto(
  roomTypeId: json['roomTypeID'] as String,
  roomNumber: (json['roomNumber'] as num).toInt(),
);

Map<String, dynamic> _$HotelRoomTypeRoomNumDtoToJson(
  _HotelRoomTypeRoomNumDto instance,
) => <String, dynamic>{
  'roomTypeID': instance.roomTypeId,
  'roomNumber': instance.roomNumber,
};

_HotelAssignOccupancyRequestDto _$HotelAssignOccupancyRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelAssignOccupancyRequestDto(
  lang: json['lang'] as String,
  hotelId: json['hotelId'] as String,
  checkIn: json['checkIn'] as String,
  checkOut: json['checkOut'] as String,
  occupancy: (json['occupancy'] as num).toInt(),
  roomTypeRoomNums:
      (json['roomTypeRoomNums'] as List<dynamic>?)
          ?.map(
            (e) => HotelRoomTypeRoomNumDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <HotelRoomTypeRoomNumDto>[],
);

Map<String, dynamic> _$HotelAssignOccupancyRequestDtoToJson(
  _HotelAssignOccupancyRequestDto instance,
) => <String, dynamic>{
  'lang': instance.lang,
  'hotelId': instance.hotelId,
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
  'occupancy': instance.occupancy,
  'roomTypeRoomNums': instance.roomTypeRoomNums.map((e) => e.toJson()).toList(),
};

_HotelAssignOccupancyResultDto _$HotelAssignOccupancyResultDtoFromJson(
  Map<String, dynamic> json,
) => _HotelAssignOccupancyResultDto(
  roomTypeCustNums:
      (json['roomTypeCustNums'] as List<dynamic>?)
          ?.map(
            (e) => HotelRoomTypeCustNumDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <HotelRoomTypeCustNumDto>[],
  roomTypeExtraGuestPrices:
      (json['roomTypeExtraGuestPrices'] as List<dynamic>?)
          ?.map(
            (e) => HotelRoomTypeExtraGuestPriceDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <HotelRoomTypeExtraGuestPriceDto>[],
  message: json['message'] as String?,
  price: json['price'] as num?,
);

Map<String, dynamic> _$HotelAssignOccupancyResultDtoToJson(
  _HotelAssignOccupancyResultDto instance,
) => <String, dynamic>{
  'roomTypeCustNums': instance.roomTypeCustNums,
  'roomTypeExtraGuestPrices': instance.roomTypeExtraGuestPrices,
  'message': instance.message,
  'price': instance.price,
};

_HotelRoomTypeCustNumDto _$HotelRoomTypeCustNumDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomTypeCustNumDto(
  roomTypeId: json['roomTypeID'],
  occupancy: (json['occupancy'] as num?)?.toInt(),
);

Map<String, dynamic> _$HotelRoomTypeCustNumDtoToJson(
  _HotelRoomTypeCustNumDto instance,
) => <String, dynamic>{
  'roomTypeID': instance.roomTypeId,
  'occupancy': instance.occupancy,
};

_HotelRoomTypeExtraGuestPriceDto _$HotelRoomTypeExtraGuestPriceDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomTypeExtraGuestPriceDto(
  roomTypeId: json['roomTypeId'],
  roomTypeName: json['roomTypeName'] as String?,
  roomCount: (json['roomCount'] as num?)?.toInt(),
  totalGuestCount: (json['totalGuestCount'] as num?)?.toInt(),
  extraGuestCount: (json['extraGuestCount'] as num?)?.toInt(),
  extraGuestPrice: json['extraGuestPrice'] as num?,
);

Map<String, dynamic> _$HotelRoomTypeExtraGuestPriceDtoToJson(
  _HotelRoomTypeExtraGuestPriceDto instance,
) => <String, dynamic>{
  'roomTypeId': instance.roomTypeId,
  'roomTypeName': instance.roomTypeName,
  'roomCount': instance.roomCount,
  'totalGuestCount': instance.totalGuestCount,
  'extraGuestCount': instance.extraGuestCount,
  'extraGuestPrice': instance.extraGuestPrice,
};

_HotelRoomTypeCustNumRequestDto _$HotelRoomTypeCustNumRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomTypeCustNumRequestDto(
  roomTypeId: json['roomTypeID'] as String,
  occupancy: json['occupancy'] as String,
);

Map<String, dynamic> _$HotelRoomTypeCustNumRequestDtoToJson(
  _HotelRoomTypeCustNumRequestDto instance,
) => <String, dynamic>{
  'roomTypeID': instance.roomTypeId,
  'occupancy': instance.occupancy,
};

_HotelRoomExtraPersonRequestDto _$HotelRoomExtraPersonRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomExtraPersonRequestDto(
  hotelId: json['hotelId'] as String,
  checkIn: json['checkIn'] as String,
  checkOut: json['checkOut'] as String,
  lang: json['lang'] as String,
  roomTypeCustNums:
      (json['roomTypeCustNums'] as List<dynamic>?)
          ?.map(
            (e) => HotelRoomTypeCustNumRequestDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <HotelRoomTypeCustNumRequestDto>[],
  couponsCounts: json['couponsCounts'] as List<dynamic>? ?? const <Object?>[],
);

Map<String, dynamic> _$HotelRoomExtraPersonRequestDtoToJson(
  _HotelRoomExtraPersonRequestDto instance,
) => <String, dynamic>{
  'hotelId': instance.hotelId,
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
  'lang': instance.lang,
  'roomTypeCustNums': instance.roomTypeCustNums.map((e) => e.toJson()).toList(),
  'couponsCounts': instance.couponsCounts,
};

_HotelRoomExtraPersonResultDto _$HotelRoomExtraPersonResultDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomExtraPersonResultDto(
  priceElement: json['priceElement'] == null
      ? null
      : HotelPriceElementDto.fromJson(
          json['priceElement'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$HotelRoomExtraPersonResultDtoToJson(
  _HotelRoomExtraPersonResultDto instance,
) => <String, dynamic>{'priceElement': instance.priceElement};

_HotelPriceElementDto _$HotelPriceElementDtoFromJson(
  Map<String, dynamic> json,
) => _HotelPriceElementDto(
  price: json['price'] as num?,
  originalPrice: json['originalPrice'] as num?,
  roomPriceElements:
      (json['roomPriceElements'] as List<dynamic>?)
          ?.map(
            (e) => HotelRoomPriceElementDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <HotelRoomPriceElementDto>[],
);

Map<String, dynamic> _$HotelPriceElementDtoToJson(
  _HotelPriceElementDto instance,
) => <String, dynamic>{
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'roomPriceElements': instance.roomPriceElements,
};

_HotelRoomPriceElementDto _$HotelRoomPriceElementDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomPriceElementDto(
  roomTypeId: json['roomTypeId'],
  freeUserPrice: (json['freeUserPrice'] as num?)?.toInt(),
  priceTip: json['priceTip'] as String?,
);

Map<String, dynamic> _$HotelRoomPriceElementDtoToJson(
  _HotelRoomPriceElementDto instance,
) => <String, dynamic>{
  'roomTypeId': instance.roomTypeId,
  'freeUserPrice': instance.freeUserPrice,
  'priceTip': instance.priceTip,
};

_HotelBookingCreateRequestDto _$HotelBookingCreateRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelBookingCreateRequestDto(
  couponsCounts: (json['couponsCounts'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  parent: HotelBookingCreateParentDto.fromJson(
    json['parent'] as Map<String, dynamic>,
  ),
  site: json['site'] as String? ?? '38',
);

Map<String, dynamic> _$HotelBookingCreateRequestDtoToJson(
  _HotelBookingCreateRequestDto instance,
) => <String, dynamic>{
  'couponsCounts': ?instance.couponsCounts,
  'parent': instance.parent.toJson(),
  'site': instance.site,
};

_AirhostBookingOrderRequestDto _$AirhostBookingOrderRequestDtoFromJson(
  Map<String, dynamic> json,
) => _AirhostBookingOrderRequestDto(
  checkIn: json['checkIn'] as String,
  checkOut: json['checkOut'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  lang: json['lang'] as String,
  hotelInfoId: (json['hotelInfoID'] as num).toInt(),
  roomCount: (json['roomCount'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  receiptTitle: json['receiptTitle'] as String?,
  contactIntlCode: json['contactIntlCode'] as String,
  contactMobile: json['contactMobile'] as String,
  contactEmail: json['contactEmail'] as String,
  comment: json['comment'] as String?,
  siteId: (json['siteID'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toInt(),
  brandStr: json['brandStr'] as String?,
  nationality: json['nationality'] as String,
  orderRoomTypeData:
      (json['orderRoomTypeData'] as List<dynamic>?)
          ?.map(
            (e) =>
                AirhostOrderRoomTypeDataDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <AirhostOrderRoomTypeDataDto>[],
  couponsCounts:
      (json['couponsCounts'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$AirhostBookingOrderRequestDtoToJson(
  _AirhostBookingOrderRequestDto instance,
) => <String, dynamic>{
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'lang': instance.lang,
  'hotelInfoID': instance.hotelInfoId,
  'roomCount': instance.roomCount,
  'totalCount': instance.totalCount,
  'receiptTitle': ?instance.receiptTitle,
  'contactIntlCode': instance.contactIntlCode,
  'contactMobile': instance.contactMobile,
  'contactEmail': instance.contactEmail,
  'comment': ?instance.comment,
  'siteID': instance.siteId,
  'totalAmount': instance.totalAmount,
  'brandStr': ?instance.brandStr,
  'nationality': instance.nationality,
  'orderRoomTypeData': instance.orderRoomTypeData
      .map((e) => e.toJson())
      .toList(),
  'couponsCounts': instance.couponsCounts,
};

_AirhostOrderRoomTypeDataDto _$AirhostOrderRoomTypeDataDtoFromJson(
  Map<String, dynamic> json,
) => _AirhostOrderRoomTypeDataDto(
  roomTypeId: (json['roomTypeID'] as num).toInt(),
  roomCount: (json['roomCount'] as num).toInt(),
  roomCusts:
      (json['roomCusts'] as List<dynamic>?)
          ?.map(
            (e) => AirhostOrderRoomCustDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <AirhostOrderRoomCustDto>[],
);

Map<String, dynamic> _$AirhostOrderRoomTypeDataDtoToJson(
  _AirhostOrderRoomTypeDataDto instance,
) => <String, dynamic>{
  'roomTypeID': instance.roomTypeId,
  'roomCount': instance.roomCount,
  'roomCusts': instance.roomCusts.map((e) => e.toJson()).toList(),
};

_AirhostOrderRoomCustDto _$AirhostOrderRoomCustDtoFromJson(
  Map<String, dynamic> json,
) => _AirhostOrderRoomCustDto(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  contactEmail: json['contactEmail'] as String?,
  adultCount: (json['adultCount'] as num?)?.toInt(),
  childCount: (json['childCount'] as num?)?.toInt(),
  nationality: json['nationality'] as String?,
);

Map<String, dynamic> _$AirhostOrderRoomCustDtoToJson(
  _AirhostOrderRoomCustDto instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
  'contactEmail': ?instance.contactEmail,
  'adultCount': ?instance.adultCount,
  'childCount': ?instance.childCount,
  'nationality': ?instance.nationality,
};

_OrderSendPaymentLinkRequestDto _$OrderSendPaymentLinkRequestDtoFromJson(
  Map<String, dynamic> json,
) => _OrderSendPaymentLinkRequestDto(
  id: (json['id'] as num).toInt(),
  lang: json['lang'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$OrderSendPaymentLinkRequestDtoToJson(
  _OrderSendPaymentLinkRequestDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'lang': instance.lang,
  'email': instance.email,
};

_HotelBookingCreateParentDto _$HotelBookingCreateParentDtoFromJson(
  Map<String, dynamic> json,
) => _HotelBookingCreateParentDto(
  bookingOrderEntity: HotelBookingOrderEntityDto.fromJson(
    json['bookingOrderEntity'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$HotelBookingCreateParentDtoToJson(
  _HotelBookingCreateParentDto instance,
) => <String, dynamic>{
  'bookingOrderEntity': instance.bookingOrderEntity.toJson(),
};

_HotelBookingOrderEntityDto _$HotelBookingOrderEntityDtoFromJson(
  Map<String, dynamic> json,
) => _HotelBookingOrderEntityDto(
  brandStr: json['brandStr'] as String? ?? 'gl_web',
  adultCount: json['adultCount'] as String?,
  checkIn: json['checkIn'] as String,
  checkOut: json['checkOut'] as String,
  bookingDate: json['bookingDate'] as String? ?? '',
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  name: json['name'] as String? ?? '',
  nationality: json['nationality'] as String,
  nationalityText: json['nationalityText'] as String?,
  lang: json['lang'] as String,
  hotelInfoId: json['hotelInfoID'] as String,
  roomCount: (json['roomCount'] as num?)?.toInt() ?? 1,
  totalCount: (json['totalCount'] as num).toInt(),
  totalRoomCount: (json['totalRoomCount'] as num?)?.toInt() ?? 1,
  kidsCount: (json['kidsCount'] as num?)?.toInt(),
  infantsCount: (json['infantsCount'] as num?)?.toInt(),
  contactIntlCode: json['contactIntlCode'] as String,
  contactMobile: json['contactMobile'] as String,
  contactEmail: json['contactEmail'] as String,
  comment: json['comment'] as String? ?? '',
  receiptTitle: json['receiptTitle'] as String? ?? '',
  siteId: json['siteID'] as String? ?? '146671713176780822',
  orderRoomTypeData:
      (json['orderRoomTypeData'] as List<dynamic>?)
          ?.map(
            (e) =>
                HotelOrderRoomTypeDataDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <HotelOrderRoomTypeDataDto>[],
  totalAmount: json['totalAmount'] as num,
);

Map<String, dynamic> _$HotelBookingOrderEntityDtoToJson(
  _HotelBookingOrderEntityDto instance,
) => <String, dynamic>{
  'brandStr': instance.brandStr,
  'adultCount': ?instance.adultCount,
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
  'bookingDate': instance.bookingDate,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'name': instance.name,
  'nationality': instance.nationality,
  'nationalityText': ?instance.nationalityText,
  'lang': instance.lang,
  'hotelInfoID': instance.hotelInfoId,
  'roomCount': instance.roomCount,
  'totalCount': instance.totalCount,
  'totalRoomCount': instance.totalRoomCount,
  'kidsCount': ?instance.kidsCount,
  'infantsCount': ?instance.infantsCount,
  'contactIntlCode': instance.contactIntlCode,
  'contactMobile': instance.contactMobile,
  'contactEmail': instance.contactEmail,
  'comment': instance.comment,
  'receiptTitle': instance.receiptTitle,
  'siteID': instance.siteId,
  'orderRoomTypeData': instance.orderRoomTypeData
      .map((e) => e.toJson())
      .toList(),
  'totalAmount': instance.totalAmount,
};

_HotelOrderRoomTypeDataDto _$HotelOrderRoomTypeDataDtoFromJson(
  Map<String, dynamic> json,
) => _HotelOrderRoomTypeDataDto(
  roomTypeId: json['roomTypeID'] as String,
  roomCount: (json['roomCount'] as num).toInt(),
  roomTypename: json['roomTypename'] as String?,
  roomPrice: json['roomPrice'] as num?,
  occupancy: (json['occupancy'] as num?)?.toInt(),
  roomTypeExtraGuestPrices: json['roomTypeExtraGuestPrices'] == null
      ? null
      : HotelRoomTypeExtraGuestPriceDto.fromJson(
          json['roomTypeExtraGuestPrices'] as Map<String, dynamic>,
        ),
  roomIds: (json['roomIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  roomCusts:
      (json['roomCusts'] as List<dynamic>?)
          ?.map((e) => HotelRoomCustomerDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HotelRoomCustomerDto>[],
);

Map<String, dynamic> _$HotelOrderRoomTypeDataDtoToJson(
  _HotelOrderRoomTypeDataDto instance,
) => <String, dynamic>{
  'roomTypeID': instance.roomTypeId,
  'roomCount': instance.roomCount,
  'roomTypename': ?instance.roomTypename,
  'roomPrice': ?instance.roomPrice,
  'occupancy': ?instance.occupancy,
  'roomTypeExtraGuestPrices': ?instance.roomTypeExtraGuestPrices?.toJson(),
  'roomIds': ?instance.roomIds,
  'roomCusts': instance.roomCusts.map((e) => e.toJson()).toList(),
};

_HotelRoomCustomerDto _$HotelRoomCustomerDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomCustomerDto(
  roomTypeId: (json['roomTypeID'] as num?)?.toInt(),
  name: json['name'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  nationality: json['nationality'] as String?,
  nationalityText: json['nationalityText'] as String?,
  email: json['email'] as String?,
  count: (json['count'] as num).toInt(),
  childCount: (json['childCount'] as num?)?.toInt(),
  maxcount: (json['maxcount'] as num?)?.toInt(),
);

Map<String, dynamic> _$HotelRoomCustomerDtoToJson(
  _HotelRoomCustomerDto instance,
) => <String, dynamic>{
  'roomTypeID': ?instance.roomTypeId,
  'name': ?instance.name,
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
  'nationality': ?instance.nationality,
  'nationalityText': ?instance.nationalityText,
  'email': ?instance.email,
  'count': instance.count,
  'childCount': ?instance.childCount,
  'maxcount': ?instance.maxcount,
};

_HotelOrderListDto _$HotelOrderListDtoFromJson(Map<String, dynamic> json) =>
    _HotelOrderListDto(
      startPage: (json['startPage'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      orders:
          (json['bookingOrderList'] as List<dynamic>?)
              ?.map((e) => HotelOrderDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HotelOrderDto>[],
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotelOrderListDtoToJson(_HotelOrderListDto instance) =>
    <String, dynamic>{
      'startPage': instance.startPage,
      'limit': instance.limit,
      'bookingOrderList': instance.orders,
      'count': instance.count,
    };

_HotelOrderDto _$HotelOrderDtoFromJson(Map<String, dynamic> json) =>
    _HotelOrderDto(
      orderId: hotelOrderIdReadValue(json, 'orderId') as String? ?? '',
      id: json['id'] as String?,
      orderNo: json['orderNo'] as String?,
      serialNo: json['serialNo'] as String?,
      hotelName: json['hotelName'] as String?,
      buildingName: json['buildingName'] as String?,
      hotelImage: json['hotelImage'] as String?,
      hotelAddress: json['hotelAddress'] as String?,
      name: json['name'] as String?,
      checkIn: json['checkIn'] as String?,
      checkedIn: json['checkedIn'] as String?,
      checkOut: json['checkOut'] as String?,
      bookingOrderTime: json['bookingOrderTime'] as String?,
      createdTime: json['createdTime'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentStatusCode: (json['paymentStatusCode'] as num?)?.toInt(),
      receiptBookSent: (json['receiptBookSent'] as num?)?.toInt(),
      receiptTitle: json['receiptTitle'] as String?,
      contactEmail: json['contactEmail'] as String?,
      orderStatus: json['orderStatus'] as String?,
      orderStatusStr: json['orderStatusStr'] as String?,
      orderStatusCode: (json['orderStatusCode'] as num?)?.toInt(),
      paidAmount: json['paidAmount'] as num?,
      totalAmount: json['totalAmount'] as num?,
      pay: json['pay'] as bool?,
      refund: json['refund'] as bool?,
      status: json['status'],
      roomTypeCount: (json['roomTypeCount'] as num?)?.toInt(),
      roomId: (json['roomId'] as num?)?.toInt(),
      roomNo: json['roomNo'] as String?,
      bookingType: (json['bookingType'] as num?)?.toInt(),
      sendItem: json['sendItem'],
      roomClear: json['roomClear'],
    );

Map<String, dynamic> _$HotelOrderDtoToJson(_HotelOrderDto instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'id': instance.id,
      'orderNo': instance.orderNo,
      'serialNo': instance.serialNo,
      'hotelName': instance.hotelName,
      'buildingName': instance.buildingName,
      'hotelImage': instance.hotelImage,
      'hotelAddress': instance.hotelAddress,
      'name': instance.name,
      'checkIn': instance.checkIn,
      'checkedIn': instance.checkedIn,
      'checkOut': instance.checkOut,
      'bookingOrderTime': instance.bookingOrderTime,
      'createdTime': instance.createdTime,
      'paymentStatus': instance.paymentStatus,
      'paymentStatusCode': instance.paymentStatusCode,
      'receiptBookSent': instance.receiptBookSent,
      'receiptTitle': instance.receiptTitle,
      'contactEmail': instance.contactEmail,
      'orderStatus': instance.orderStatus,
      'orderStatusStr': instance.orderStatusStr,
      'orderStatusCode': instance.orderStatusCode,
      'paidAmount': instance.paidAmount,
      'totalAmount': instance.totalAmount,
      'pay': instance.pay,
      'refund': instance.refund,
      'status': instance.status,
      'roomTypeCount': instance.roomTypeCount,
      'roomId': instance.roomId,
      'roomNo': instance.roomNo,
      'bookingType': instance.bookingType,
      'sendItem': instance.sendItem,
      'roomClear': instance.roomClear,
    };

_HotelMemberPayInfoDto _$HotelMemberPayInfoDtoFromJson(
  Map<String, dynamic> json,
) => _HotelMemberPayInfoDto(balance: json['balance'] as num?);

Map<String, dynamic> _$HotelMemberPayInfoDtoToJson(
  _HotelMemberPayInfoDto instance,
) => <String, dynamic>{'balance': instance.balance};

_HotelPaymentResultDto _$HotelPaymentResultDtoFromJson(
  Map<String, dynamic> json,
) => _HotelPaymentResultDto(
  pay: json['pay'] as bool?,
  wechatPay: json['wechatPay'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$HotelPaymentResultDtoToJson(
  _HotelPaymentResultDto instance,
) => <String, dynamic>{'pay': instance.pay, 'wechatPay': instance.wechatPay};

_Pay4OrderRequestDto _$Pay4OrderRequestDtoFromJson(Map<String, dynamic> json) =>
    _Pay4OrderRequestDto(
      bookingOrderId: (json['bookingOrderID'] as num).toInt(),
      paymentCode: json['paymentCode'] as String,
      cardNumber: json['cardNumber'] as String?,
      cardExpire: json['cardExpire'] as String?,
      securityCode: json['securityCode'] as String?,
      cardholderName: json['cardholderName'] as String?,
      cardInfo: json['cardInfo'] as String?,
      lang: json['lang'] as String?,
      isCheck: json['isCheck'] as bool?,
      system: json['system'] as String?,
    );

Map<String, dynamic> _$Pay4OrderRequestDtoToJson(
  _Pay4OrderRequestDto instance,
) => <String, dynamic>{
  'bookingOrderID': instance.bookingOrderId,
  'paymentCode': instance.paymentCode,
  'cardNumber': ?instance.cardNumber,
  'cardExpire': ?instance.cardExpire,
  'securityCode': ?instance.securityCode,
  'cardholderName': ?instance.cardholderName,
  'cardInfo': ?instance.cardInfo,
  'lang': ?instance.lang,
  'isCheck': ?instance.isCheck,
  'system': ?instance.system,
};
