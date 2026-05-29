// ignore_for_file: invalid_annotation_target

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_dtos.freezed.dart';
part 'hotel_dtos.g.dart';

@freezed
abstract class HotelSearchRequestDto with _$HotelSearchRequestDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelSearchRequestDto({
    @Default(1) int startPage,
    @Default(20) int limit,
    required String startDate,
    required String endDate,
    String? keyWord,
    String? lang,
    Map<String, Object?>? price,
    List<Object?>? filterVal,
    String? area,
    int? bookingType,
    String? buildingCode,
    String? priceSort,
    @Default(1) int occupancy,
    @Default(0) int kids,
    @Default(1) int roomNum,
  }) = _HotelSearchRequestDto;

  factory HotelSearchRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelSearchRequestDtoFromJson(json);
}

@freezed
abstract class HotelSearchResultDto with _$HotelSearchResultDto {
  const factory HotelSearchResultDto({
    @Default(<HotelSummaryDto>[]) List<HotelSummaryDto> hotels,
    int? count,
    Object? showStatus,
    String? showStatusStr,
  }) = _HotelSearchResultDto;

  factory HotelSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$HotelSearchResultDtoFromJson(json);
}

@freezed
abstract class HotelSummaryDto with _$HotelSummaryDto {
  const factory HotelSummaryDto({
    @JsonKey(name: 'hotelId') @Default('') String id,
    @Default('') String hotelName,
    String? address,
    String? area,
    String? image,
    num? price,
    num? basePrice,
    num? basePrice2,
    num? beforeDiscountPrice,
    num? discount,
    String? discountName,
    num? discount2,
    String? discountName2,
    num? entirePrice,
    Object? bookingType,
    String? buildingCode,
    String? buildingType,
    bool? bookingStatus,
    int? roomCount,
    Object? remainRoomNum,
    Object? lat,
    Object? lng,
    @JsonKey(fromJson: hotelStringListFromJson)
    @Default(<String>[])
    List<String> tags,
  }) = _HotelSummaryDto;

  factory HotelSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$HotelSummaryDtoFromJson(json);
}

@freezed
abstract class HotelBuildingCodeDto with _$HotelBuildingCodeDto {
  const factory HotelBuildingCodeDto({
    @Default('') String buildingCode,
    @Default('') String buildingName,
    @Default(<String, String>{}) Map<String, String> localizedNames,
  }) = _HotelBuildingCodeDto;

  factory HotelBuildingCodeDto.fromJson(Map<String, dynamic> json) =>
      _$HotelBuildingCodeDtoFromJson(json);
}

@freezed
abstract class HotelFacilityFilterDto with _$HotelFacilityFilterDto {
  const factory HotelFacilityFilterDto({
    @JsonKey(name: 'convertCode') @Default('') String code,
    @Default('') String name,
  }) = _HotelFacilityFilterDto;

  factory HotelFacilityFilterDto.fromJson(Map<String, dynamic> json) =>
      _$HotelFacilityFilterDtoFromJson(json);
}

@freezed
abstract class HotelDetailRequestDto with _$HotelDetailRequestDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelDetailRequestDto({
    required String id,
    required String lang,
    required String startDate,
    required String endDate,
    int? occupancy,
  }) = _HotelDetailRequestDto;

  factory HotelDetailRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelDetailRequestDtoFromJson(json);
}

@freezed
abstract class HotelDetailDto with _$HotelDetailDto {
  const factory HotelDetailDto({
    @Default('') String id,
    @Default('') String name,
    String? address,
    String? description,
    Object? lat,
    Object? lng,
    int? bookingType,
    bool? bookingStatus,
    num? entirePrice,
    String? checkInMessage,
    String? checkInTime,
    String? checkOutTime,
    String? detail,
    String? surrounding,
    String? travel,
    String? checkInGuide,
    String? rule,
    String? telNo,
    @Default(<Object?>[]) List<Object?> propertyFacilities,
    @Default(<String, Object?>{}) Map<String, Object?> propertyFacilityNames,
    @JsonKey(name: 'hotelPictures')
    @Default(<HotelPictureDto>[])
    List<HotelPictureDto> pictures,
    @JsonKey(name: 'roomTypeDTO4APPs')
    @Default(<HotelRoomTypeDto>[])
    List<HotelRoomTypeDto> roomTypes,
    @JsonKey(fromJson: hotelStringListFromJson)
    @Default(<String>[])
    List<String> tags,
  }) = _HotelDetailDto;

  factory HotelDetailDto.fromJson(Map<String, dynamic> json) =>
      _$HotelDetailDtoFromJson(json);
}

@freezed
abstract class HotelPictureDto with _$HotelPictureDto {
  const factory HotelPictureDto({
    @Default('') String relativeUrl,
    String? description,
  }) = _HotelPictureDto;

  factory HotelPictureDto.fromJson(Map<String, dynamic> json) =>
      _$HotelPictureDtoFromJson(json);
}

@freezed
abstract class HotelRoomTypeDto with _$HotelRoomTypeDto {
  const factory HotelRoomTypeDto({
    @Default('') String id,
    @Default('') String name,
    String? showName,
    num? price,
    num? beforeDiscountPrice,
    num? discount,
    String? discountName,
    num? discount2,
    String? discountName2,
    int? occupancy,
    int? occupantsForBaseRate,
    Object? roomSize,
    int? bedRoomCount,
    int? bathRoomCount,
    int? roomCount,
    Object? roomFacility,
    @JsonKey(fromJson: hotelMapListFromJson)
    @Default(<Map<String, Object?>>[])
    List<Map<String, Object?>> roomTypeFacilities,
    String? description,
    @JsonKey(fromJson: hotelStringListFromJson)
    @Default(<String>[])
    List<String> roomIds,
    @JsonKey(name: 'roomPictures')
    @Default(<HotelPictureDto>[])
    List<HotelPictureDto> pictures,
    @JsonKey(name: 'roomTypeBeds')
    @Default(<HotelRoomBedDto>[])
    List<HotelRoomBedDto> beds,
  }) = _HotelRoomTypeDto;

  factory HotelRoomTypeDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomTypeDtoFromJson(json);
}

@freezed
abstract class HotelRoomBedDto with _$HotelRoomBedDto {
  const factory HotelRoomBedDto({
    @Default('') String name,
    int? count,
    int? num,
    int? quantity,
    Object? width,
    Object? extent,
  }) = _HotelRoomBedDto;

  factory HotelRoomBedDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomBedDtoFromJson(json);
}

@freezed
abstract class HotelPriceCalendarDto with _$HotelPriceCalendarDto {
  const factory HotelPriceCalendarDto({
    @Default(<String, Object?>{}) Map<String, Object?> pricesByDate,
  }) = _HotelPriceCalendarDto;

  factory HotelPriceCalendarDto.fromJson(Map<String, dynamic> json) =>
      _$HotelPriceCalendarDtoFromJson(json);
}

@freezed
abstract class HotelMemberInfoDto with _$HotelMemberInfoDto {
  const factory HotelMemberInfoDto({
    int? id,
    @Default('') String memberName,
    @Default('') String email,
    @Default('') String phoneCountryCode,
    @Default('') String phoneNumber,
    @JsonKey(name: 'birthday', readValue: hotelBirthdayReadValue)
    @Default('')
    String birthday,
    int? gender,
    @Default('') String joinDate,
    @Default('') String membersLevel,
    int? membersLevelCode,
    int? discount,
    @Default('') String expireDate,
    int? sourceUserId,
    @Default('') String membersStatus,
  }) = _HotelMemberInfoDto;

  factory HotelMemberInfoDto.fromJson(Map<String, dynamic> json) =>
      _$HotelMemberInfoDtoFromJson(json);
}

@freezed
abstract class HotelMemberInfoUpdateRequestDto
    with _$HotelMemberInfoUpdateRequestDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelMemberInfoUpdateRequestDto({
    int? id,
    String? memberName,
    String? email,
    String? phoneCountryCode,
    String? phoneNumber,
    String? birthday,
    int? gender,
    int? sourceUserId,
    int? emailCode,
    int? phoneCode,
  }) = _HotelMemberInfoUpdateRequestDto;

  factory HotelMemberInfoUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelMemberInfoUpdateRequestDtoFromJson(json);
}

Object? hotelBirthdayReadValue(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['生日'];
}

@freezed
abstract class HotelCreditCardDto with _$HotelCreditCardDto {
  const factory HotelCreditCardDto({
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String cardId,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String cardNumber,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String cardExpire,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String cardholderName,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String defaultCard,
    @JsonKey(fromJson: hotelNullableStringFromJson) String? acquireCode3,
    @JsonKey(fromJson: hotelNullableStringFromJson) String? kindCode,
    @JsonKey(fromJson: hotelNullableStringFromJson) String? originalCardId,
  }) = _HotelCreditCardDto;

  factory HotelCreditCardDto.fromJson(Map<String, dynamic> json) =>
      _$HotelCreditCardDtoFromJson(json);
}

@freezed
abstract class HotelCreditCardTokenDto with _$HotelCreditCardTokenDto {
  const factory HotelCreditCardTokenDto({
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String token,
    @JsonKey(name: 'token_expire_date', fromJson: hotelStringFromJson)
    @Default('')
    String tokenExpireDate,
    @JsonKey(name: 'req_card_number', fromJson: hotelStringFromJson)
    @Default('')
    String reqCardNumber,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String status,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String code,
    @JsonKey(fromJson: hotelStringFromJson) @Default('') String message,
  }) = _HotelCreditCardTokenDto;

  factory HotelCreditCardTokenDto.fromJson(Map<String, dynamic> json) =>
      _$HotelCreditCardTokenDtoFromJson(json);
}

@freezed
abstract class HotelCreditCardRegisterRequestDto
    with _$HotelCreditCardRegisterRequestDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelCreditCardRegisterRequestDto({
    required HotelCreditCardTokenDto cardToken,
    @Default('') String bookingOrderId,
    @Default(1) int defaultFlag,
    String? cardholderMobilePhoneCountry,
    String? cardholderMobilePhoneNumber,
    String? cardholderEmail,
  }) = _HotelCreditCardRegisterRequestDto;

  factory HotelCreditCardRegisterRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$HotelCreditCardRegisterRequestDtoFromJson(json);
}

@freezed
abstract class HotelRegisteredCardPaymentRequestDto
    with _$HotelRegisteredCardPaymentRequestDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelRegisteredCardPaymentRequestDto({
    required String cardId,
    required String bookingOrderId,
  }) = _HotelRegisteredCardPaymentRequestDto;

  factory HotelRegisteredCardPaymentRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$HotelRegisteredCardPaymentRequestDtoFromJson(json);
}

@freezed
abstract class HotelCreditCardPaymentResultDto
    with _$HotelCreditCardPaymentResultDto {
  const factory HotelCreditCardPaymentResultDto({
    bool? pay,
    @JsonKey(fromJson: hotelNullableStringFromJson) String? url,
  }) = _HotelCreditCardPaymentResultDto;

  factory HotelCreditCardPaymentResultDto.fromJson(Map<String, dynamic> json) =>
      _$HotelCreditCardPaymentResultDtoFromJson(json);
}

@freezed
abstract class HotelRoomTypeRoomNumDto with _$HotelRoomTypeRoomNumDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelRoomTypeRoomNumDto({
    @JsonKey(name: 'roomTypeID') required String roomTypeId,
    required int roomNumber,
  }) = _HotelRoomTypeRoomNumDto;

  factory HotelRoomTypeRoomNumDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomTypeRoomNumDtoFromJson(json);
}

@freezed
abstract class HotelAssignOccupancyRequestDto
    with _$HotelAssignOccupancyRequestDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelAssignOccupancyRequestDto({
    required String lang,
    required String hotelId,
    required String checkIn,
    required String checkOut,
    required int occupancy,
    @Default(<HotelRoomTypeRoomNumDto>[])
    List<HotelRoomTypeRoomNumDto> roomTypeRoomNums,
  }) = _HotelAssignOccupancyRequestDto;

  factory HotelAssignOccupancyRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelAssignOccupancyRequestDtoFromJson(json);
}

@freezed
abstract class HotelAssignOccupancyResultDto
    with _$HotelAssignOccupancyResultDto {
  const factory HotelAssignOccupancyResultDto({
    @Default(<HotelRoomTypeCustNumDto>[])
    List<HotelRoomTypeCustNumDto> roomTypeCustNums,
    @Default(<HotelRoomTypeExtraGuestPriceDto>[])
    List<HotelRoomTypeExtraGuestPriceDto> roomTypeExtraGuestPrices,
    String? message,
    num? price,
  }) = _HotelAssignOccupancyResultDto;

  factory HotelAssignOccupancyResultDto.fromJson(Map<String, dynamic> json) =>
      _$HotelAssignOccupancyResultDtoFromJson(json);
}

@freezed
abstract class HotelRoomTypeCustNumDto with _$HotelRoomTypeCustNumDto {
  const factory HotelRoomTypeCustNumDto({
    @JsonKey(name: 'roomTypeID') Object? roomTypeId,
    int? occupancy,
  }) = _HotelRoomTypeCustNumDto;

  factory HotelRoomTypeCustNumDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomTypeCustNumDtoFromJson(json);
}

@freezed
abstract class HotelRoomTypeExtraGuestPriceDto
    with _$HotelRoomTypeExtraGuestPriceDto {
  const factory HotelRoomTypeExtraGuestPriceDto({
    Object? roomTypeId,
    String? roomTypeName,
    int? roomCount,
    int? totalGuestCount,
    int? extraGuestCount,
    num? extraGuestPrice,
  }) = _HotelRoomTypeExtraGuestPriceDto;

  factory HotelRoomTypeExtraGuestPriceDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomTypeExtraGuestPriceDtoFromJson(json);
}

@freezed
abstract class HotelRoomTypeCustNumRequestDto
    with _$HotelRoomTypeCustNumRequestDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelRoomTypeCustNumRequestDto({
    @JsonKey(name: 'roomTypeID') required String roomTypeId,
    required String occupancy,
  }) = _HotelRoomTypeCustNumRequestDto;

  factory HotelRoomTypeCustNumRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomTypeCustNumRequestDtoFromJson(json);
}

@freezed
abstract class HotelRoomExtraPersonRequestDto
    with _$HotelRoomExtraPersonRequestDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelRoomExtraPersonRequestDto({
    required String hotelId,
    required String checkIn,
    required String checkOut,
    required String lang,
    @Default(<HotelRoomTypeCustNumRequestDto>[])
    List<HotelRoomTypeCustNumRequestDto> roomTypeCustNums,
    @Default(<Object?>[]) List<Object?> couponsCounts,
  }) = _HotelRoomExtraPersonRequestDto;

  factory HotelRoomExtraPersonRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomExtraPersonRequestDtoFromJson(json);
}

@freezed
abstract class HotelRoomExtraPersonResultDto
    with _$HotelRoomExtraPersonResultDto {
  const factory HotelRoomExtraPersonResultDto({
    HotelPriceElementDto? priceElement,
  }) = _HotelRoomExtraPersonResultDto;

  factory HotelRoomExtraPersonResultDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomExtraPersonResultDtoFromJson(json);
}

@freezed
abstract class HotelPriceElementDto with _$HotelPriceElementDto {
  const factory HotelPriceElementDto({
    num? price,
    num? originalPrice,
    @Default(<HotelRoomPriceElementDto>[])
    List<HotelRoomPriceElementDto> roomPriceElements,
  }) = _HotelPriceElementDto;

  factory HotelPriceElementDto.fromJson(Map<String, dynamic> json) =>
      _$HotelPriceElementDtoFromJson(json);
}

@freezed
abstract class HotelRoomPriceElementDto with _$HotelRoomPriceElementDto {
  const factory HotelRoomPriceElementDto({
    Object? roomTypeId,
    int? freeUserPrice,
    String? priceTip,
  }) = _HotelRoomPriceElementDto;

  factory HotelRoomPriceElementDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomPriceElementDtoFromJson(json);
}

List<String> hotelStringListFromJson(Object? raw) {
  if (raw == null) {
    return const <String>[];
  }
  if (raw is List) {
    return raw
        .map((value) => value?.toString().trim() ?? '')
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
  }
  if (raw is String) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const <String>[];
    }
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map && decoded['tags'] != null) {
        return hotelStringListFromJson(decoded['tags']);
      }
      return hotelStringListFromJson(decoded);
    } catch (_) {
      return <String>[trimmed];
    }
  }
  return <String>[raw.toString()];
}

List<Map<String, Object?>> hotelMapListFromJson(Object? raw) {
  if (raw == null) {
    return const <Map<String, Object?>>[];
  }
  if (raw is List) {
    return raw
        .whereType<Map>()
        .map(
          (value) => value.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList(growable: false);
  }
  if (raw is String) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const <Map<String, Object?>>[];
    }
    try {
      return hotelMapListFromJson(jsonDecode(trimmed));
    } catch (_) {
      return const <Map<String, Object?>>[];
    }
  }
  if (raw is Map) {
    return <Map<String, Object?>>[
      raw.map((key, value) => MapEntry(key.toString(), value)),
    ];
  }
  return const <Map<String, Object?>>[];
}

class HotelOrderCancelRuleResultDto {
  const HotelOrderCancelRuleResultDto({
    required this.canCancel,
    required this.message,
  });

  final bool canCancel;
  final String message;
}

class HotelCouponDto {
  const HotelCouponDto({
    required this.couponsId,
    required this.couponsName,
    required this.number,
    required this.detail,
    required this.type,
    required this.discount,
    required this.amount,
    required this.amountEvery,
    required this.hotelNames,
    required this.beginDate,
    required this.endDate,
    required this.createdTime,
    required this.use,
  });

  factory HotelCouponDto.fromJson(Map<String, dynamic> json) {
    return HotelCouponDto(
      couponsId: _hotelIntFromJson(json['couponsId']),
      couponsName: hotelStringFromJson(json['couponsName']),
      number: _hotelIntFromJson(json['number']) ?? 0,
      detail: hotelStringFromJson(json['detail']),
      type: _hotelIntFromJson(json['type']) ?? 0,
      discount: _hotelNumFromJson(json['discount']),
      amount: _hotelNumFromJson(json['amount']),
      amountEvery: hotelStringFromJson(json['amountEvery']),
      hotelNames: hotelStringFromJson(json['hotelNames']),
      beginDate: hotelStringFromJson(json['beginDate']),
      endDate: hotelStringFromJson(json['endDate']),
      createdTime: hotelStringFromJson(json['createdTime']),
      use: _hotelBoolFromJson(json['use']),
    );
  }

  final int? couponsId;
  final String couponsName;
  final int number;
  final String detail;
  final int type;
  final num? discount;
  final num? amount;
  final String amountEvery;
  final String hotelNames;
  final String beginDate;
  final String endDate;
  final String createdTime;
  final bool? use;
}

int? _hotelIntFromJson(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is int) {
    return raw;
  }
  if (raw is num) {
    return raw.toInt();
  }
  return int.tryParse(raw.toString().trim());
}

num? _hotelNumFromJson(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is num) {
    return raw;
  }
  return num.tryParse(raw.toString().trim());
}

bool? _hotelBoolFromJson(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is bool) {
    return raw;
  }
  if (raw is num) {
    return raw != 0;
  }
  final text = raw.toString().trim().toLowerCase();
  if (text == 'true' || text == '1' || text == 'yes') {
    return true;
  }
  if (text == 'false' || text == '0' || text == 'no') {
    return false;
  }
  return null;
}

@freezed
abstract class HotelBookingCreateRequestDto
    with _$HotelBookingCreateRequestDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelBookingCreateRequestDto({
    List<Map<String, dynamic>>? couponsCounts,
    required HotelBookingCreateParentDto parent,
    @Default('38') String site,
  }) = _HotelBookingCreateRequestDto;

  factory HotelBookingCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelBookingCreateRequestDtoFromJson(json);
}

@freezed
abstract class AirhostBookingOrderRequestDto
    with _$AirhostBookingOrderRequestDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory AirhostBookingOrderRequestDto({
    required String checkIn,
    required String checkOut,
    required String firstName,
    required String lastName,
    required String lang,
    @JsonKey(name: 'hotelInfoID') required int hotelInfoId,
    required int roomCount,
    required int totalCount,
    String? receiptTitle,
    required String contactIntlCode,
    required String contactMobile,
    required String contactEmail,
    String? comment,
    @JsonKey(name: 'siteID') required int siteId,
    required int totalAmount,
    String? brandStr,
    required String nationality,
    @Default(<AirhostOrderRoomTypeDataDto>[])
    List<AirhostOrderRoomTypeDataDto> orderRoomTypeData,
    @Default(<int>[]) List<int> couponsCounts,
  }) = _AirhostBookingOrderRequestDto;

  factory AirhostBookingOrderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AirhostBookingOrderRequestDtoFromJson(json);
}

@freezed
abstract class AirhostOrderRoomTypeDataDto with _$AirhostOrderRoomTypeDataDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory AirhostOrderRoomTypeDataDto({
    @JsonKey(name: 'roomTypeID') required int roomTypeId,
    required int roomCount,
    @Default(<AirhostOrderRoomCustDto>[])
    List<AirhostOrderRoomCustDto> roomCusts,
  }) = _AirhostOrderRoomTypeDataDto;

  factory AirhostOrderRoomTypeDataDto.fromJson(Map<String, dynamic> json) =>
      _$AirhostOrderRoomTypeDataDtoFromJson(json);
}

@freezed
abstract class AirhostOrderRoomCustDto with _$AirhostOrderRoomCustDto {
  @JsonSerializable(includeIfNull: false)
  const factory AirhostOrderRoomCustDto({
    int? id,
    String? firstName,
    String? lastName,
    String? contactEmail,
    int? adultCount,
    int? childCount,
    String? nationality,
  }) = _AirhostOrderRoomCustDto;

  factory AirhostOrderRoomCustDto.fromJson(Map<String, dynamic> json) =>
      _$AirhostOrderRoomCustDtoFromJson(json);
}

@freezed
abstract class OrderSendPaymentLinkRequestDto
    with _$OrderSendPaymentLinkRequestDto {
  const factory OrderSendPaymentLinkRequestDto({
    required int id,
    required String lang,
    required String email,
  }) = _OrderSendPaymentLinkRequestDto;

  factory OrderSendPaymentLinkRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OrderSendPaymentLinkRequestDtoFromJson(json);
}

@freezed
abstract class HotelBookingCreateParentDto with _$HotelBookingCreateParentDto {
  @JsonSerializable(explicitToJson: true)
  const factory HotelBookingCreateParentDto({
    required HotelBookingOrderEntityDto bookingOrderEntity,
  }) = _HotelBookingCreateParentDto;

  factory HotelBookingCreateParentDto.fromJson(Map<String, dynamic> json) =>
      _$HotelBookingCreateParentDtoFromJson(json);
}

@freezed
abstract class HotelBookingOrderEntityDto with _$HotelBookingOrderEntityDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelBookingOrderEntityDto({
    @Default('gl_web') String brandStr,
    String? adultCount,
    required String checkIn,
    required String checkOut,
    @Default('') String bookingDate,
    required String firstName,
    required String lastName,
    @Default('') String name,
    required String nationality,
    String? nationalityText,
    required String lang,
    @JsonKey(name: 'hotelInfoID') required String hotelInfoId,
    @Default(1) int roomCount,
    required int totalCount,
    @Default(1) int totalRoomCount,
    int? kidsCount,
    int? infantsCount,
    required String contactIntlCode,
    required String contactMobile,
    required String contactEmail,
    @Default('') String comment,
    @Default('') String receiptTitle,
    @JsonKey(name: 'siteID') @Default('146671713176780822') String siteId,
    @Default(<HotelOrderRoomTypeDataDto>[])
    List<HotelOrderRoomTypeDataDto> orderRoomTypeData,
    required num totalAmount,
  }) = _HotelBookingOrderEntityDto;

  factory HotelBookingOrderEntityDto.fromJson(Map<String, dynamic> json) =>
      _$HotelBookingOrderEntityDtoFromJson(json);
}

@freezed
abstract class HotelOrderRoomTypeDataDto with _$HotelOrderRoomTypeDataDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelOrderRoomTypeDataDto({
    @JsonKey(name: 'roomTypeID') required String roomTypeId,
    required int roomCount,
    String? roomTypename,
    num? roomPrice,
    int? occupancy,
    HotelRoomTypeExtraGuestPriceDto? roomTypeExtraGuestPrices,
    List<String>? roomIds,
    @Default(<HotelRoomCustomerDto>[]) List<HotelRoomCustomerDto> roomCusts,
  }) = _HotelOrderRoomTypeDataDto;

  factory HotelOrderRoomTypeDataDto.fromJson(Map<String, dynamic> json) =>
      _$HotelOrderRoomTypeDataDtoFromJson(json);
}

@freezed
abstract class HotelRoomCustomerDto with _$HotelRoomCustomerDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelRoomCustomerDto({
    @JsonKey(name: 'roomTypeID') int? roomTypeId,
    String? name,
    String? firstName,
    String? lastName,
    String? nationality,
    String? nationalityText,
    String? email,
    required int count,
    int? childCount,
    int? maxcount,
  }) = _HotelRoomCustomerDto;

  factory HotelRoomCustomerDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomCustomerDtoFromJson(json);
}

@freezed
abstract class HotelOrderListDto with _$HotelOrderListDto {
  const factory HotelOrderListDto({
    int? startPage,
    int? limit,
    @JsonKey(name: 'bookingOrderList')
    @Default(<HotelOrderDto>[])
    List<HotelOrderDto> orders,
    int? count,
  }) = _HotelOrderListDto;

  factory HotelOrderListDto.fromJson(Map<String, dynamic> json) =>
      _$HotelOrderListDtoFromJson(json);
}

@freezed
abstract class HotelOrderDto with _$HotelOrderDto {
  const factory HotelOrderDto({
    @JsonKey(readValue: hotelOrderIdReadValue, fromJson: hotelStringFromJson)
    @Default('')
    String orderId,
    @JsonKey(name: 'id', fromJson: hotelNullableStringFromJson) String? id,
    String? orderNo,
    String? serialNo,
    @JsonKey(fromJson: hotelNullableStringFromJson) String? hotelId,
    String? hotelName,
    String? buildingName,
    String? hotelImage,
    String? hotelHomeImage,
    String? hotelAddress,
    String? address,
    Object? lat,
    Object? lng,
    String? name,
    String? checkIn,
    String? checkedIn,
    String? checkOut,
    String? bookingOrderTime,
    String? createdTime,
    String? paymentStatus,
    int? paymentStatusCode,
    int? receiptBookSent,
    String? receiptTitle,
    String? contactEmail,
    String? contactIntlCode,
    String? contactMobile,
    String? nationalityText,
    String? orderStatus,
    String? orderStatusStr,
    int? orderStatusCode,
    String? checkedInText,
    int? adultCount,
    int? childCount,
    num? paidAmount,
    num? totalAmount,
    String? payName,
    String? payCode,
    String? paymentTime,
    bool? pay,
    bool? refund,
    bool? modify,
    bool? canCheckIn,
    Object? status,
    String? comment,
    String? checkInGuide,
    String? cancelRule,
    @JsonKey(fromJson: hotelMapFromJson)
    @Default(<String, Object?>{})
    Map<String, Object?> priceElement,
    @JsonKey(fromJson: hotelMapListFromJson)
    @Default(<Map<String, Object?>>[])
    List<Map<String, Object?>> roomTypeCount,
    int? roomId,
    String? roomNo,
    int? bookingType,
    Object? sendItem,
    Object? roomClear,
  }) = _HotelOrderDto;

  factory HotelOrderDto.fromJson(Map<String, dynamic> json) =>
      _$HotelOrderDtoFromJson(json);
}

Object? hotelOrderIdReadValue(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['id'];
}

String hotelStringFromJson(Object? raw) {
  return raw?.toString().trim() ?? '';
}

String? hotelNullableStringFromJson(Object? raw) {
  final value = hotelStringFromJson(raw);
  return value.isEmpty ? null : value;
}

Map<String, Object?> hotelMapFromJson(Object? raw) {
  if (raw == null) {
    return const <String, Object?>{};
  }
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  if (raw is String) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const <String, Object?>{};
    }
    try {
      return hotelMapFromJson(jsonDecode(trimmed));
    } catch (_) {
      return const <String, Object?>{};
    }
  }
  return const <String, Object?>{};
}

@freezed
abstract class HotelMemberPayInfoDto with _$HotelMemberPayInfoDto {
  const factory HotelMemberPayInfoDto({num? balance}) = _HotelMemberPayInfoDto;

  factory HotelMemberPayInfoDto.fromJson(Map<String, dynamic> json) =>
      _$HotelMemberPayInfoDtoFromJson(json);
}

@freezed
abstract class HotelPaymentResultDto with _$HotelPaymentResultDto {
  const factory HotelPaymentResultDto({
    bool? pay,
    Map<String, dynamic>? wechatPay,
  }) = _HotelPaymentResultDto;

  factory HotelPaymentResultDto.fromJson(Map<String, dynamic> json) =>
      _$HotelPaymentResultDtoFromJson(json);
}

@freezed
abstract class Pay4OrderRequestDto with _$Pay4OrderRequestDto {
  @JsonSerializable(includeIfNull: false)
  const factory Pay4OrderRequestDto({
    @JsonKey(name: 'bookingOrderID') required int bookingOrderId,
    required String paymentCode,
    String? cardNumber,
    String? cardExpire,
    String? securityCode,
    String? cardholderName,
    String? cardInfo,
    String? lang,
    bool? isCheck,
    String? system,
  }) = _Pay4OrderRequestDto;

  factory Pay4OrderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$Pay4OrderRequestDtoFromJson(json);
}
