// ignore_for_file: invalid_annotation_target

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
    String? price,
    String? filterVal,
    String? area,
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
    @Default('') String id,
    @Default('') String hotelName,
    String? address,
    String? area,
    String? image,
    num? price,
    num? entirePrice,
    int? bookingType,
    bool? bookingStatus,
    Object? lat,
    Object? lng,
    @Default(<String>[]) List<String> tags,
  }) = _HotelSummaryDto;

  factory HotelSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$HotelSummaryDtoFromJson(json);
}

@freezed
abstract class HotelBuildingCodeDto with _$HotelBuildingCodeDto {
  const factory HotelBuildingCodeDto({
    @Default('') String buildingCode,
    @Default('') String buildingName,
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
    @JsonKey(name: 'hotelPictures')
    @Default(<HotelPictureDto>[])
    List<HotelPictureDto> pictures,
    @JsonKey(name: 'roomTypeDTO4APPs')
    @Default(<HotelRoomTypeDto>[])
    List<HotelRoomTypeDto> roomTypes,
    @Default(<String>[]) List<String> tags,
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
    num? price,
    int? occupancy,
    @Default(<String>[]) List<String> roomIds,
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
abstract class HotelBookingCreateRequestDto
    with _$HotelBookingCreateRequestDto {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory HotelBookingCreateRequestDto({
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> couponsCounts,
    required HotelBookingCreateParentDto parent,
    @Default('38') String site,
  }) = _HotelBookingCreateRequestDto;

  factory HotelBookingCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HotelBookingCreateRequestDtoFromJson(json);
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
    @Default('glhotel_app') String brandStr,
    required String adultCount,
    required String checkIn,
    required String checkOut,
    required String bookingDate,
    required String firstName,
    required String lastName,
    required String nationality,
    required String nationalityText,
    required String lang,
    @JsonKey(name: 'hotelInfoID') required String hotelInfoId,
    @Default('1') String roomCount,
    required String totalCount,
    @Default('0') String kidsCount,
    @Default('0') String infantsCount,
    required String contactIntlCode,
    required String contactMobile,
    required String contactEmail,
    String? comment,
    String? receiptTitle,
    @JsonKey(name: 'siteID') @Default('146671713176780822') String siteId,
    @Default(<HotelOrderRoomTypeDataDto>[])
    List<HotelOrderRoomTypeDataDto> orderRoomTypeData,
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
    @Default(<String>[]) List<String> roomIds,
    @Default(<HotelRoomCustomerDto>[]) List<HotelRoomCustomerDto> roomCusts,
  }) = _HotelOrderRoomTypeDataDto;

  factory HotelOrderRoomTypeDataDto.fromJson(Map<String, dynamic> json) =>
      _$HotelOrderRoomTypeDataDtoFromJson(json);
}

@freezed
abstract class HotelRoomCustomerDto with _$HotelRoomCustomerDto {
  @JsonSerializable(includeIfNull: false)
  const factory HotelRoomCustomerDto({
    String? name,
    String? firstName,
    String? lastName,
    String? nationality,
    String? nationalityText,
    String? email,
    required int count,
  }) = _HotelRoomCustomerDto;

  factory HotelRoomCustomerDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomCustomerDtoFromJson(json);
}

@freezed
abstract class HotelOrderListDto with _$HotelOrderListDto {
  const factory HotelOrderListDto({
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
    @Default('') String orderId,
    String? orderNo,
    String? serialNo,
    String? hotelName,
    String? name,
    String? checkIn,
    String? checkOut,
    String? bookingOrderTime,
    String? createdTime,
    num? paidAmount,
    num? totalAmount,
    bool? pay,
    bool? refund,
    Object? status,
    int? roomTypeCount,
  }) = _HotelOrderDto;

  factory HotelOrderDto.fromJson(Map<String, dynamic> json) =>
      _$HotelOrderDtoFromJson(json);
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
