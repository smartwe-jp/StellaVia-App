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
      beforeDiscountPrice: json['beforeDiscountPrice'] as num?,
      discount: json['discount'] as num?,
      discountName: json['discountName'] as String?,
      entirePrice: json['entirePrice'] as num?,
      bookingType: json['bookingType'],
      buildingCode: json['buildingCode'] as String?,
      buildingType: json['buildingType'] as String?,
      bookingStatus: json['bookingStatus'] as bool?,
      lat: json['lat'],
      lng: json['lng'],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
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
      'beforeDiscountPrice': instance.beforeDiscountPrice,
      'discount': instance.discount,
      'discountName': instance.discountName,
      'entirePrice': instance.entirePrice,
      'bookingType': instance.bookingType,
      'buildingCode': instance.buildingCode,
      'buildingType': instance.buildingType,
      'bookingStatus': instance.bookingStatus,
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
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
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
      price: json['price'] as num?,
      occupancy: (json['occupancy'] as num?)?.toInt(),
      roomIds:
          (json['roomIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
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
      'price': instance.price,
      'occupancy': instance.occupancy,
      'roomIds': instance.roomIds,
      'roomPictures': instance.pictures,
      'roomTypeBeds': instance.beds,
    };

_HotelRoomBedDto _$HotelRoomBedDtoFromJson(Map<String, dynamic> json) =>
    _HotelRoomBedDto(
      name: json['name'] as String? ?? '',
      count: (json['count'] as num?)?.toInt(),
      num: (json['num'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotelRoomBedDtoToJson(_HotelRoomBedDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
      'num': instance.num,
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

_HotelBookingCreateRequestDto _$HotelBookingCreateRequestDtoFromJson(
  Map<String, dynamic> json,
) => _HotelBookingCreateRequestDto(
  couponsCounts:
      (json['couponsCounts'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const <Map<String, dynamic>>[],
  parent: HotelBookingCreateParentDto.fromJson(
    json['parent'] as Map<String, dynamic>,
  ),
  site: json['site'] as String? ?? '38',
);

Map<String, dynamic> _$HotelBookingCreateRequestDtoToJson(
  _HotelBookingCreateRequestDto instance,
) => <String, dynamic>{
  'couponsCounts': instance.couponsCounts,
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
  brandStr: json['brandStr'] as String? ?? 'glhotel_app',
  adultCount: json['adultCount'] as String,
  checkIn: json['checkIn'] as String,
  checkOut: json['checkOut'] as String,
  bookingDate: json['bookingDate'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  nationality: json['nationality'] as String,
  nationalityText: json['nationalityText'] as String,
  lang: json['lang'] as String,
  hotelInfoId: json['hotelInfoID'] as String,
  roomCount: json['roomCount'] as String? ?? '1',
  totalCount: json['totalCount'] as String,
  kidsCount: json['kidsCount'] as String? ?? '0',
  infantsCount: json['infantsCount'] as String? ?? '0',
  contactIntlCode: json['contactIntlCode'] as String,
  contactMobile: json['contactMobile'] as String,
  contactEmail: json['contactEmail'] as String,
  comment: json['comment'] as String?,
  receiptTitle: json['receiptTitle'] as String?,
  siteId: json['siteID'] as String? ?? '146671713176780822',
  orderRoomTypeData:
      (json['orderRoomTypeData'] as List<dynamic>?)
          ?.map(
            (e) =>
                HotelOrderRoomTypeDataDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <HotelOrderRoomTypeDataDto>[],
);

Map<String, dynamic> _$HotelBookingOrderEntityDtoToJson(
  _HotelBookingOrderEntityDto instance,
) => <String, dynamic>{
  'brandStr': instance.brandStr,
  'adultCount': instance.adultCount,
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
  'bookingDate': instance.bookingDate,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'nationality': instance.nationality,
  'nationalityText': instance.nationalityText,
  'lang': instance.lang,
  'hotelInfoID': instance.hotelInfoId,
  'roomCount': instance.roomCount,
  'totalCount': instance.totalCount,
  'kidsCount': instance.kidsCount,
  'infantsCount': instance.infantsCount,
  'contactIntlCode': instance.contactIntlCode,
  'contactMobile': instance.contactMobile,
  'contactEmail': instance.contactEmail,
  'comment': ?instance.comment,
  'receiptTitle': ?instance.receiptTitle,
  'siteID': instance.siteId,
  'orderRoomTypeData': instance.orderRoomTypeData
      .map((e) => e.toJson())
      .toList(),
};

_HotelOrderRoomTypeDataDto _$HotelOrderRoomTypeDataDtoFromJson(
  Map<String, dynamic> json,
) => _HotelOrderRoomTypeDataDto(
  roomTypeId: json['roomTypeID'] as String,
  roomCount: (json['roomCount'] as num).toInt(),
  roomIds:
      (json['roomIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
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
  'roomIds': instance.roomIds,
  'roomCusts': instance.roomCusts.map((e) => e.toJson()).toList(),
};

_HotelRoomCustomerDto _$HotelRoomCustomerDtoFromJson(
  Map<String, dynamic> json,
) => _HotelRoomCustomerDto(
  name: json['name'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  nationality: json['nationality'] as String?,
  nationalityText: json['nationalityText'] as String?,
  email: json['email'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$HotelRoomCustomerDtoToJson(
  _HotelRoomCustomerDto instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
  'nationality': ?instance.nationality,
  'nationalityText': ?instance.nationalityText,
  'email': ?instance.email,
  'count': instance.count,
};

_HotelOrderListDto _$HotelOrderListDtoFromJson(Map<String, dynamic> json) =>
    _HotelOrderListDto(
      orders:
          (json['bookingOrderList'] as List<dynamic>?)
              ?.map((e) => HotelOrderDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HotelOrderDto>[],
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotelOrderListDtoToJson(_HotelOrderListDto instance) =>
    <String, dynamic>{
      'bookingOrderList': instance.orders,
      'count': instance.count,
    };

_HotelOrderDto _$HotelOrderDtoFromJson(Map<String, dynamic> json) =>
    _HotelOrderDto(
      orderId: json['orderId'] as String? ?? '',
      orderNo: json['orderNo'] as String?,
      serialNo: json['serialNo'] as String?,
      hotelName: json['hotelName'] as String?,
      name: json['name'] as String?,
      checkIn: json['checkIn'] as String?,
      checkOut: json['checkOut'] as String?,
      bookingOrderTime: json['bookingOrderTime'] as String?,
      createdTime: json['createdTime'] as String?,
      paidAmount: json['paidAmount'] as num?,
      totalAmount: json['totalAmount'] as num?,
      pay: json['pay'] as bool?,
      refund: json['refund'] as bool?,
      status: json['status'],
      roomTypeCount: (json['roomTypeCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotelOrderDtoToJson(_HotelOrderDto instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderNo': instance.orderNo,
      'serialNo': instance.serialNo,
      'hotelName': instance.hotelName,
      'name': instance.name,
      'checkIn': instance.checkIn,
      'checkOut': instance.checkOut,
      'bookingOrderTime': instance.bookingOrderTime,
      'createdTime': instance.createdTime,
      'paidAmount': instance.paidAmount,
      'totalAmount': instance.totalAmount,
      'pay': instance.pay,
      'refund': instance.refund,
      'status': instance.status,
      'roomTypeCount': instance.roomTypeCount,
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
