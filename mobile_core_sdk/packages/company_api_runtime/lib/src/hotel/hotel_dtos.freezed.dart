// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotel_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HotelSearchRequestDto {

 int get startPage; int get limit; String get startDate; String get endDate; String? get keyWord; String? get lang; Map<String, Object?>? get price; List<Object?>? get filterVal; String? get area; int? get bookingType; String? get buildingCode; String? get priceSort; int get occupancy; int get kids; int get roomNum;
/// Create a copy of HotelSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelSearchRequestDtoCopyWith<HotelSearchRequestDto> get copyWith => _$HotelSearchRequestDtoCopyWithImpl<HotelSearchRequestDto>(this as HotelSearchRequestDto, _$identity);

  /// Serializes this HotelSearchRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelSearchRequestDto&&(identical(other.startPage, startPage) || other.startPage == startPage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.keyWord, keyWord) || other.keyWord == keyWord)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other.price, price)&&const DeepCollectionEquality().equals(other.filterVal, filterVal)&&(identical(other.area, area) || other.area == area)&&(identical(other.bookingType, bookingType) || other.bookingType == bookingType)&&(identical(other.buildingCode, buildingCode) || other.buildingCode == buildingCode)&&(identical(other.priceSort, priceSort) || other.priceSort == priceSort)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.kids, kids) || other.kids == kids)&&(identical(other.roomNum, roomNum) || other.roomNum == roomNum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startPage,limit,startDate,endDate,keyWord,lang,const DeepCollectionEquality().hash(price),const DeepCollectionEquality().hash(filterVal),area,bookingType,buildingCode,priceSort,occupancy,kids,roomNum);

@override
String toString() {
  return 'HotelSearchRequestDto(startPage: $startPage, limit: $limit, startDate: $startDate, endDate: $endDate, keyWord: $keyWord, lang: $lang, price: $price, filterVal: $filterVal, area: $area, bookingType: $bookingType, buildingCode: $buildingCode, priceSort: $priceSort, occupancy: $occupancy, kids: $kids, roomNum: $roomNum)';
}


}

/// @nodoc
abstract mixin class $HotelSearchRequestDtoCopyWith<$Res>  {
  factory $HotelSearchRequestDtoCopyWith(HotelSearchRequestDto value, $Res Function(HotelSearchRequestDto) _then) = _$HotelSearchRequestDtoCopyWithImpl;
@useResult
$Res call({
 int startPage, int limit, String startDate, String endDate, String? keyWord, String? lang, Map<String, Object?>? price, List<Object?>? filterVal, String? area, int? bookingType, String? buildingCode, String? priceSort, int occupancy, int kids, int roomNum
});




}
/// @nodoc
class _$HotelSearchRequestDtoCopyWithImpl<$Res>
    implements $HotelSearchRequestDtoCopyWith<$Res> {
  _$HotelSearchRequestDtoCopyWithImpl(this._self, this._then);

  final HotelSearchRequestDto _self;
  final $Res Function(HotelSearchRequestDto) _then;

/// Create a copy of HotelSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startPage = null,Object? limit = null,Object? startDate = null,Object? endDate = null,Object? keyWord = freezed,Object? lang = freezed,Object? price = freezed,Object? filterVal = freezed,Object? area = freezed,Object? bookingType = freezed,Object? buildingCode = freezed,Object? priceSort = freezed,Object? occupancy = null,Object? kids = null,Object? roomNum = null,}) {
  return _then(_self.copyWith(
startPage: null == startPage ? _self.startPage : startPage // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,keyWord: freezed == keyWord ? _self.keyWord : keyWord // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,filterVal: freezed == filterVal ? _self.filterVal : filterVal // ignore: cast_nullable_to_non_nullable
as List<Object?>?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,bookingType: freezed == bookingType ? _self.bookingType : bookingType // ignore: cast_nullable_to_non_nullable
as int?,buildingCode: freezed == buildingCode ? _self.buildingCode : buildingCode // ignore: cast_nullable_to_non_nullable
as String?,priceSort: freezed == priceSort ? _self.priceSort : priceSort // ignore: cast_nullable_to_non_nullable
as String?,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int,kids: null == kids ? _self.kids : kids // ignore: cast_nullable_to_non_nullable
as int,roomNum: null == roomNum ? _self.roomNum : roomNum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelSearchRequestDto].
extension HotelSearchRequestDtoPatterns on HotelSearchRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelSearchRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelSearchRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelSearchRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelSearchRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelSearchRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelSearchRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int startPage,  int limit,  String startDate,  String endDate,  String? keyWord,  String? lang,  Map<String, Object?>? price,  List<Object?>? filterVal,  String? area,  int? bookingType,  String? buildingCode,  String? priceSort,  int occupancy,  int kids,  int roomNum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelSearchRequestDto() when $default != null:
return $default(_that.startPage,_that.limit,_that.startDate,_that.endDate,_that.keyWord,_that.lang,_that.price,_that.filterVal,_that.area,_that.bookingType,_that.buildingCode,_that.priceSort,_that.occupancy,_that.kids,_that.roomNum);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int startPage,  int limit,  String startDate,  String endDate,  String? keyWord,  String? lang,  Map<String, Object?>? price,  List<Object?>? filterVal,  String? area,  int? bookingType,  String? buildingCode,  String? priceSort,  int occupancy,  int kids,  int roomNum)  $default,) {final _that = this;
switch (_that) {
case _HotelSearchRequestDto():
return $default(_that.startPage,_that.limit,_that.startDate,_that.endDate,_that.keyWord,_that.lang,_that.price,_that.filterVal,_that.area,_that.bookingType,_that.buildingCode,_that.priceSort,_that.occupancy,_that.kids,_that.roomNum);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int startPage,  int limit,  String startDate,  String endDate,  String? keyWord,  String? lang,  Map<String, Object?>? price,  List<Object?>? filterVal,  String? area,  int? bookingType,  String? buildingCode,  String? priceSort,  int occupancy,  int kids,  int roomNum)?  $default,) {final _that = this;
switch (_that) {
case _HotelSearchRequestDto() when $default != null:
return $default(_that.startPage,_that.limit,_that.startDate,_that.endDate,_that.keyWord,_that.lang,_that.price,_that.filterVal,_that.area,_that.bookingType,_that.buildingCode,_that.priceSort,_that.occupancy,_that.kids,_that.roomNum);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _HotelSearchRequestDto implements HotelSearchRequestDto {
  const _HotelSearchRequestDto({this.startPage = 1, this.limit = 20, required this.startDate, required this.endDate, this.keyWord, this.lang, final  Map<String, Object?>? price, final  List<Object?>? filterVal, this.area, this.bookingType, this.buildingCode, this.priceSort, this.occupancy = 1, this.kids = 0, this.roomNum = 1}): _price = price,_filterVal = filterVal;
  factory _HotelSearchRequestDto.fromJson(Map<String, dynamic> json) => _$HotelSearchRequestDtoFromJson(json);

@override@JsonKey() final  int startPage;
@override@JsonKey() final  int limit;
@override final  String startDate;
@override final  String endDate;
@override final  String? keyWord;
@override final  String? lang;
 final  Map<String, Object?>? _price;
@override Map<String, Object?>? get price {
  final value = _price;
  if (value == null) return null;
  if (_price is EqualUnmodifiableMapView) return _price;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<Object?>? _filterVal;
@override List<Object?>? get filterVal {
  final value = _filterVal;
  if (value == null) return null;
  if (_filterVal is EqualUnmodifiableListView) return _filterVal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? area;
@override final  int? bookingType;
@override final  String? buildingCode;
@override final  String? priceSort;
@override@JsonKey() final  int occupancy;
@override@JsonKey() final  int kids;
@override@JsonKey() final  int roomNum;

/// Create a copy of HotelSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelSearchRequestDtoCopyWith<_HotelSearchRequestDto> get copyWith => __$HotelSearchRequestDtoCopyWithImpl<_HotelSearchRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelSearchRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelSearchRequestDto&&(identical(other.startPage, startPage) || other.startPage == startPage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.keyWord, keyWord) || other.keyWord == keyWord)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other._price, _price)&&const DeepCollectionEquality().equals(other._filterVal, _filterVal)&&(identical(other.area, area) || other.area == area)&&(identical(other.bookingType, bookingType) || other.bookingType == bookingType)&&(identical(other.buildingCode, buildingCode) || other.buildingCode == buildingCode)&&(identical(other.priceSort, priceSort) || other.priceSort == priceSort)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.kids, kids) || other.kids == kids)&&(identical(other.roomNum, roomNum) || other.roomNum == roomNum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startPage,limit,startDate,endDate,keyWord,lang,const DeepCollectionEquality().hash(_price),const DeepCollectionEquality().hash(_filterVal),area,bookingType,buildingCode,priceSort,occupancy,kids,roomNum);

@override
String toString() {
  return 'HotelSearchRequestDto(startPage: $startPage, limit: $limit, startDate: $startDate, endDate: $endDate, keyWord: $keyWord, lang: $lang, price: $price, filterVal: $filterVal, area: $area, bookingType: $bookingType, buildingCode: $buildingCode, priceSort: $priceSort, occupancy: $occupancy, kids: $kids, roomNum: $roomNum)';
}


}

/// @nodoc
abstract mixin class _$HotelSearchRequestDtoCopyWith<$Res> implements $HotelSearchRequestDtoCopyWith<$Res> {
  factory _$HotelSearchRequestDtoCopyWith(_HotelSearchRequestDto value, $Res Function(_HotelSearchRequestDto) _then) = __$HotelSearchRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 int startPage, int limit, String startDate, String endDate, String? keyWord, String? lang, Map<String, Object?>? price, List<Object?>? filterVal, String? area, int? bookingType, String? buildingCode, String? priceSort, int occupancy, int kids, int roomNum
});




}
/// @nodoc
class __$HotelSearchRequestDtoCopyWithImpl<$Res>
    implements _$HotelSearchRequestDtoCopyWith<$Res> {
  __$HotelSearchRequestDtoCopyWithImpl(this._self, this._then);

  final _HotelSearchRequestDto _self;
  final $Res Function(_HotelSearchRequestDto) _then;

/// Create a copy of HotelSearchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startPage = null,Object? limit = null,Object? startDate = null,Object? endDate = null,Object? keyWord = freezed,Object? lang = freezed,Object? price = freezed,Object? filterVal = freezed,Object? area = freezed,Object? bookingType = freezed,Object? buildingCode = freezed,Object? priceSort = freezed,Object? occupancy = null,Object? kids = null,Object? roomNum = null,}) {
  return _then(_HotelSearchRequestDto(
startPage: null == startPage ? _self.startPage : startPage // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,keyWord: freezed == keyWord ? _self.keyWord : keyWord // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self._price : price // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,filterVal: freezed == filterVal ? _self._filterVal : filterVal // ignore: cast_nullable_to_non_nullable
as List<Object?>?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,bookingType: freezed == bookingType ? _self.bookingType : bookingType // ignore: cast_nullable_to_non_nullable
as int?,buildingCode: freezed == buildingCode ? _self.buildingCode : buildingCode // ignore: cast_nullable_to_non_nullable
as String?,priceSort: freezed == priceSort ? _self.priceSort : priceSort // ignore: cast_nullable_to_non_nullable
as String?,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int,kids: null == kids ? _self.kids : kids // ignore: cast_nullable_to_non_nullable
as int,roomNum: null == roomNum ? _self.roomNum : roomNum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HotelSearchResultDto {

 List<HotelSummaryDto> get hotels; int? get count; Object? get showStatus; String? get showStatusStr;
/// Create a copy of HotelSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelSearchResultDtoCopyWith<HotelSearchResultDto> get copyWith => _$HotelSearchResultDtoCopyWithImpl<HotelSearchResultDto>(this as HotelSearchResultDto, _$identity);

  /// Serializes this HotelSearchResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelSearchResultDto&&const DeepCollectionEquality().equals(other.hotels, hotels)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.showStatus, showStatus)&&(identical(other.showStatusStr, showStatusStr) || other.showStatusStr == showStatusStr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(hotels),count,const DeepCollectionEquality().hash(showStatus),showStatusStr);

@override
String toString() {
  return 'HotelSearchResultDto(hotels: $hotels, count: $count, showStatus: $showStatus, showStatusStr: $showStatusStr)';
}


}

/// @nodoc
abstract mixin class $HotelSearchResultDtoCopyWith<$Res>  {
  factory $HotelSearchResultDtoCopyWith(HotelSearchResultDto value, $Res Function(HotelSearchResultDto) _then) = _$HotelSearchResultDtoCopyWithImpl;
@useResult
$Res call({
 List<HotelSummaryDto> hotels, int? count, Object? showStatus, String? showStatusStr
});




}
/// @nodoc
class _$HotelSearchResultDtoCopyWithImpl<$Res>
    implements $HotelSearchResultDtoCopyWith<$Res> {
  _$HotelSearchResultDtoCopyWithImpl(this._self, this._then);

  final HotelSearchResultDto _self;
  final $Res Function(HotelSearchResultDto) _then;

/// Create a copy of HotelSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hotels = null,Object? count = freezed,Object? showStatus = freezed,Object? showStatusStr = freezed,}) {
  return _then(_self.copyWith(
hotels: null == hotels ? _self.hotels : hotels // ignore: cast_nullable_to_non_nullable
as List<HotelSummaryDto>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,showStatus: freezed == showStatus ? _self.showStatus : showStatus ,showStatusStr: freezed == showStatusStr ? _self.showStatusStr : showStatusStr // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelSearchResultDto].
extension HotelSearchResultDtoPatterns on HotelSearchResultDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelSearchResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelSearchResultDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelSearchResultDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelSearchResultDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelSearchResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelSearchResultDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HotelSummaryDto> hotels,  int? count,  Object? showStatus,  String? showStatusStr)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelSearchResultDto() when $default != null:
return $default(_that.hotels,_that.count,_that.showStatus,_that.showStatusStr);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HotelSummaryDto> hotels,  int? count,  Object? showStatus,  String? showStatusStr)  $default,) {final _that = this;
switch (_that) {
case _HotelSearchResultDto():
return $default(_that.hotels,_that.count,_that.showStatus,_that.showStatusStr);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HotelSummaryDto> hotels,  int? count,  Object? showStatus,  String? showStatusStr)?  $default,) {final _that = this;
switch (_that) {
case _HotelSearchResultDto() when $default != null:
return $default(_that.hotels,_that.count,_that.showStatus,_that.showStatusStr);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelSearchResultDto implements HotelSearchResultDto {
  const _HotelSearchResultDto({final  List<HotelSummaryDto> hotels = const <HotelSummaryDto>[], this.count, this.showStatus, this.showStatusStr}): _hotels = hotels;
  factory _HotelSearchResultDto.fromJson(Map<String, dynamic> json) => _$HotelSearchResultDtoFromJson(json);

 final  List<HotelSummaryDto> _hotels;
@override@JsonKey() List<HotelSummaryDto> get hotels {
  if (_hotels is EqualUnmodifiableListView) return _hotels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hotels);
}

@override final  int? count;
@override final  Object? showStatus;
@override final  String? showStatusStr;

/// Create a copy of HotelSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelSearchResultDtoCopyWith<_HotelSearchResultDto> get copyWith => __$HotelSearchResultDtoCopyWithImpl<_HotelSearchResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelSearchResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelSearchResultDto&&const DeepCollectionEquality().equals(other._hotels, _hotels)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.showStatus, showStatus)&&(identical(other.showStatusStr, showStatusStr) || other.showStatusStr == showStatusStr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_hotels),count,const DeepCollectionEquality().hash(showStatus),showStatusStr);

@override
String toString() {
  return 'HotelSearchResultDto(hotels: $hotels, count: $count, showStatus: $showStatus, showStatusStr: $showStatusStr)';
}


}

/// @nodoc
abstract mixin class _$HotelSearchResultDtoCopyWith<$Res> implements $HotelSearchResultDtoCopyWith<$Res> {
  factory _$HotelSearchResultDtoCopyWith(_HotelSearchResultDto value, $Res Function(_HotelSearchResultDto) _then) = __$HotelSearchResultDtoCopyWithImpl;
@override @useResult
$Res call({
 List<HotelSummaryDto> hotels, int? count, Object? showStatus, String? showStatusStr
});




}
/// @nodoc
class __$HotelSearchResultDtoCopyWithImpl<$Res>
    implements _$HotelSearchResultDtoCopyWith<$Res> {
  __$HotelSearchResultDtoCopyWithImpl(this._self, this._then);

  final _HotelSearchResultDto _self;
  final $Res Function(_HotelSearchResultDto) _then;

/// Create a copy of HotelSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hotels = null,Object? count = freezed,Object? showStatus = freezed,Object? showStatusStr = freezed,}) {
  return _then(_HotelSearchResultDto(
hotels: null == hotels ? _self._hotels : hotels // ignore: cast_nullable_to_non_nullable
as List<HotelSummaryDto>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,showStatus: freezed == showStatus ? _self.showStatus : showStatus ,showStatusStr: freezed == showStatusStr ? _self.showStatusStr : showStatusStr // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HotelSummaryDto {

@JsonKey(name: 'hotelId') String get id; String get hotelName; String? get address; String? get area; String? get image; num? get price; num? get basePrice; num? get beforeDiscountPrice; num? get discount; String? get discountName; num? get entirePrice; Object? get bookingType; String? get buildingCode; String? get buildingType; bool? get bookingStatus; Object? get lat; Object? get lng;@JsonKey(fromJson: hotelStringListFromJson) List<String> get tags;
/// Create a copy of HotelSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelSummaryDtoCopyWith<HotelSummaryDto> get copyWith => _$HotelSummaryDtoCopyWithImpl<HotelSummaryDto>(this as HotelSummaryDto, _$identity);

  /// Serializes this HotelSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelSummaryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.hotelName, hotelName) || other.hotelName == hotelName)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.beforeDiscountPrice, beforeDiscountPrice) || other.beforeDiscountPrice == beforeDiscountPrice)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountName, discountName) || other.discountName == discountName)&&(identical(other.entirePrice, entirePrice) || other.entirePrice == entirePrice)&&const DeepCollectionEquality().equals(other.bookingType, bookingType)&&(identical(other.buildingCode, buildingCode) || other.buildingCode == buildingCode)&&(identical(other.buildingType, buildingType) || other.buildingType == buildingType)&&(identical(other.bookingStatus, bookingStatus) || other.bookingStatus == bookingStatus)&&const DeepCollectionEquality().equals(other.lat, lat)&&const DeepCollectionEquality().equals(other.lng, lng)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hotelName,address,area,image,price,basePrice,beforeDiscountPrice,discount,discountName,entirePrice,const DeepCollectionEquality().hash(bookingType),buildingCode,buildingType,bookingStatus,const DeepCollectionEquality().hash(lat),const DeepCollectionEquality().hash(lng),const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'HotelSummaryDto(id: $id, hotelName: $hotelName, address: $address, area: $area, image: $image, price: $price, basePrice: $basePrice, beforeDiscountPrice: $beforeDiscountPrice, discount: $discount, discountName: $discountName, entirePrice: $entirePrice, bookingType: $bookingType, buildingCode: $buildingCode, buildingType: $buildingType, bookingStatus: $bookingStatus, lat: $lat, lng: $lng, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $HotelSummaryDtoCopyWith<$Res>  {
  factory $HotelSummaryDtoCopyWith(HotelSummaryDto value, $Res Function(HotelSummaryDto) _then) = _$HotelSummaryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'hotelId') String id, String hotelName, String? address, String? area, String? image, num? price, num? basePrice, num? beforeDiscountPrice, num? discount, String? discountName, num? entirePrice, Object? bookingType, String? buildingCode, String? buildingType, bool? bookingStatus, Object? lat, Object? lng,@JsonKey(fromJson: hotelStringListFromJson) List<String> tags
});




}
/// @nodoc
class _$HotelSummaryDtoCopyWithImpl<$Res>
    implements $HotelSummaryDtoCopyWith<$Res> {
  _$HotelSummaryDtoCopyWithImpl(this._self, this._then);

  final HotelSummaryDto _self;
  final $Res Function(HotelSummaryDto) _then;

/// Create a copy of HotelSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hotelName = null,Object? address = freezed,Object? area = freezed,Object? image = freezed,Object? price = freezed,Object? basePrice = freezed,Object? beforeDiscountPrice = freezed,Object? discount = freezed,Object? discountName = freezed,Object? entirePrice = freezed,Object? bookingType = freezed,Object? buildingCode = freezed,Object? buildingType = freezed,Object? bookingStatus = freezed,Object? lat = freezed,Object? lng = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hotelName: null == hotelName ? _self.hotelName : hotelName // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num?,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as num?,beforeDiscountPrice: freezed == beforeDiscountPrice ? _self.beforeDiscountPrice : beforeDiscountPrice // ignore: cast_nullable_to_non_nullable
as num?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num?,discountName: freezed == discountName ? _self.discountName : discountName // ignore: cast_nullable_to_non_nullable
as String?,entirePrice: freezed == entirePrice ? _self.entirePrice : entirePrice // ignore: cast_nullable_to_non_nullable
as num?,bookingType: freezed == bookingType ? _self.bookingType : bookingType ,buildingCode: freezed == buildingCode ? _self.buildingCode : buildingCode // ignore: cast_nullable_to_non_nullable
as String?,buildingType: freezed == buildingType ? _self.buildingType : buildingType // ignore: cast_nullable_to_non_nullable
as String?,bookingStatus: freezed == bookingStatus ? _self.bookingStatus : bookingStatus // ignore: cast_nullable_to_non_nullable
as bool?,lat: freezed == lat ? _self.lat : lat ,lng: freezed == lng ? _self.lng : lng ,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelSummaryDto].
extension HotelSummaryDtoPatterns on HotelSummaryDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelSummaryDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelSummaryDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelSummaryDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'hotelId')  String id,  String hotelName,  String? address,  String? area,  String? image,  num? price,  num? basePrice,  num? beforeDiscountPrice,  num? discount,  String? discountName,  num? entirePrice,  Object? bookingType,  String? buildingCode,  String? buildingType,  bool? bookingStatus,  Object? lat,  Object? lng, @JsonKey(fromJson: hotelStringListFromJson)  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelSummaryDto() when $default != null:
return $default(_that.id,_that.hotelName,_that.address,_that.area,_that.image,_that.price,_that.basePrice,_that.beforeDiscountPrice,_that.discount,_that.discountName,_that.entirePrice,_that.bookingType,_that.buildingCode,_that.buildingType,_that.bookingStatus,_that.lat,_that.lng,_that.tags);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'hotelId')  String id,  String hotelName,  String? address,  String? area,  String? image,  num? price,  num? basePrice,  num? beforeDiscountPrice,  num? discount,  String? discountName,  num? entirePrice,  Object? bookingType,  String? buildingCode,  String? buildingType,  bool? bookingStatus,  Object? lat,  Object? lng, @JsonKey(fromJson: hotelStringListFromJson)  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _HotelSummaryDto():
return $default(_that.id,_that.hotelName,_that.address,_that.area,_that.image,_that.price,_that.basePrice,_that.beforeDiscountPrice,_that.discount,_that.discountName,_that.entirePrice,_that.bookingType,_that.buildingCode,_that.buildingType,_that.bookingStatus,_that.lat,_that.lng,_that.tags);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'hotelId')  String id,  String hotelName,  String? address,  String? area,  String? image,  num? price,  num? basePrice,  num? beforeDiscountPrice,  num? discount,  String? discountName,  num? entirePrice,  Object? bookingType,  String? buildingCode,  String? buildingType,  bool? bookingStatus,  Object? lat,  Object? lng, @JsonKey(fromJson: hotelStringListFromJson)  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _HotelSummaryDto() when $default != null:
return $default(_that.id,_that.hotelName,_that.address,_that.area,_that.image,_that.price,_that.basePrice,_that.beforeDiscountPrice,_that.discount,_that.discountName,_that.entirePrice,_that.bookingType,_that.buildingCode,_that.buildingType,_that.bookingStatus,_that.lat,_that.lng,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelSummaryDto implements HotelSummaryDto {
  const _HotelSummaryDto({@JsonKey(name: 'hotelId') this.id = '', this.hotelName = '', this.address, this.area, this.image, this.price, this.basePrice, this.beforeDiscountPrice, this.discount, this.discountName, this.entirePrice, this.bookingType, this.buildingCode, this.buildingType, this.bookingStatus, this.lat, this.lng, @JsonKey(fromJson: hotelStringListFromJson) final  List<String> tags = const <String>[]}): _tags = tags;
  factory _HotelSummaryDto.fromJson(Map<String, dynamic> json) => _$HotelSummaryDtoFromJson(json);

@override@JsonKey(name: 'hotelId') final  String id;
@override@JsonKey() final  String hotelName;
@override final  String? address;
@override final  String? area;
@override final  String? image;
@override final  num? price;
@override final  num? basePrice;
@override final  num? beforeDiscountPrice;
@override final  num? discount;
@override final  String? discountName;
@override final  num? entirePrice;
@override final  Object? bookingType;
@override final  String? buildingCode;
@override final  String? buildingType;
@override final  bool? bookingStatus;
@override final  Object? lat;
@override final  Object? lng;
 final  List<String> _tags;
@override@JsonKey(fromJson: hotelStringListFromJson) List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of HotelSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelSummaryDtoCopyWith<_HotelSummaryDto> get copyWith => __$HotelSummaryDtoCopyWithImpl<_HotelSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelSummaryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.hotelName, hotelName) || other.hotelName == hotelName)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.beforeDiscountPrice, beforeDiscountPrice) || other.beforeDiscountPrice == beforeDiscountPrice)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountName, discountName) || other.discountName == discountName)&&(identical(other.entirePrice, entirePrice) || other.entirePrice == entirePrice)&&const DeepCollectionEquality().equals(other.bookingType, bookingType)&&(identical(other.buildingCode, buildingCode) || other.buildingCode == buildingCode)&&(identical(other.buildingType, buildingType) || other.buildingType == buildingType)&&(identical(other.bookingStatus, bookingStatus) || other.bookingStatus == bookingStatus)&&const DeepCollectionEquality().equals(other.lat, lat)&&const DeepCollectionEquality().equals(other.lng, lng)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hotelName,address,area,image,price,basePrice,beforeDiscountPrice,discount,discountName,entirePrice,const DeepCollectionEquality().hash(bookingType),buildingCode,buildingType,bookingStatus,const DeepCollectionEquality().hash(lat),const DeepCollectionEquality().hash(lng),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'HotelSummaryDto(id: $id, hotelName: $hotelName, address: $address, area: $area, image: $image, price: $price, basePrice: $basePrice, beforeDiscountPrice: $beforeDiscountPrice, discount: $discount, discountName: $discountName, entirePrice: $entirePrice, bookingType: $bookingType, buildingCode: $buildingCode, buildingType: $buildingType, bookingStatus: $bookingStatus, lat: $lat, lng: $lng, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$HotelSummaryDtoCopyWith<$Res> implements $HotelSummaryDtoCopyWith<$Res> {
  factory _$HotelSummaryDtoCopyWith(_HotelSummaryDto value, $Res Function(_HotelSummaryDto) _then) = __$HotelSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'hotelId') String id, String hotelName, String? address, String? area, String? image, num? price, num? basePrice, num? beforeDiscountPrice, num? discount, String? discountName, num? entirePrice, Object? bookingType, String? buildingCode, String? buildingType, bool? bookingStatus, Object? lat, Object? lng,@JsonKey(fromJson: hotelStringListFromJson) List<String> tags
});




}
/// @nodoc
class __$HotelSummaryDtoCopyWithImpl<$Res>
    implements _$HotelSummaryDtoCopyWith<$Res> {
  __$HotelSummaryDtoCopyWithImpl(this._self, this._then);

  final _HotelSummaryDto _self;
  final $Res Function(_HotelSummaryDto) _then;

/// Create a copy of HotelSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hotelName = null,Object? address = freezed,Object? area = freezed,Object? image = freezed,Object? price = freezed,Object? basePrice = freezed,Object? beforeDiscountPrice = freezed,Object? discount = freezed,Object? discountName = freezed,Object? entirePrice = freezed,Object? bookingType = freezed,Object? buildingCode = freezed,Object? buildingType = freezed,Object? bookingStatus = freezed,Object? lat = freezed,Object? lng = freezed,Object? tags = null,}) {
  return _then(_HotelSummaryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hotelName: null == hotelName ? _self.hotelName : hotelName // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num?,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as num?,beforeDiscountPrice: freezed == beforeDiscountPrice ? _self.beforeDiscountPrice : beforeDiscountPrice // ignore: cast_nullable_to_non_nullable
as num?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num?,discountName: freezed == discountName ? _self.discountName : discountName // ignore: cast_nullable_to_non_nullable
as String?,entirePrice: freezed == entirePrice ? _self.entirePrice : entirePrice // ignore: cast_nullable_to_non_nullable
as num?,bookingType: freezed == bookingType ? _self.bookingType : bookingType ,buildingCode: freezed == buildingCode ? _self.buildingCode : buildingCode // ignore: cast_nullable_to_non_nullable
as String?,buildingType: freezed == buildingType ? _self.buildingType : buildingType // ignore: cast_nullable_to_non_nullable
as String?,bookingStatus: freezed == bookingStatus ? _self.bookingStatus : bookingStatus // ignore: cast_nullable_to_non_nullable
as bool?,lat: freezed == lat ? _self.lat : lat ,lng: freezed == lng ? _self.lng : lng ,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$HotelBuildingCodeDto {

 String get buildingCode; String get buildingName; Map<String, String> get localizedNames;
/// Create a copy of HotelBuildingCodeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelBuildingCodeDtoCopyWith<HotelBuildingCodeDto> get copyWith => _$HotelBuildingCodeDtoCopyWithImpl<HotelBuildingCodeDto>(this as HotelBuildingCodeDto, _$identity);

  /// Serializes this HotelBuildingCodeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelBuildingCodeDto&&(identical(other.buildingCode, buildingCode) || other.buildingCode == buildingCode)&&(identical(other.buildingName, buildingName) || other.buildingName == buildingName)&&const DeepCollectionEquality().equals(other.localizedNames, localizedNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,buildingCode,buildingName,const DeepCollectionEquality().hash(localizedNames));

@override
String toString() {
  return 'HotelBuildingCodeDto(buildingCode: $buildingCode, buildingName: $buildingName, localizedNames: $localizedNames)';
}


}

/// @nodoc
abstract mixin class $HotelBuildingCodeDtoCopyWith<$Res>  {
  factory $HotelBuildingCodeDtoCopyWith(HotelBuildingCodeDto value, $Res Function(HotelBuildingCodeDto) _then) = _$HotelBuildingCodeDtoCopyWithImpl;
@useResult
$Res call({
 String buildingCode, String buildingName, Map<String, String> localizedNames
});




}
/// @nodoc
class _$HotelBuildingCodeDtoCopyWithImpl<$Res>
    implements $HotelBuildingCodeDtoCopyWith<$Res> {
  _$HotelBuildingCodeDtoCopyWithImpl(this._self, this._then);

  final HotelBuildingCodeDto _self;
  final $Res Function(HotelBuildingCodeDto) _then;

/// Create a copy of HotelBuildingCodeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? buildingCode = null,Object? buildingName = null,Object? localizedNames = null,}) {
  return _then(_self.copyWith(
buildingCode: null == buildingCode ? _self.buildingCode : buildingCode // ignore: cast_nullable_to_non_nullable
as String,buildingName: null == buildingName ? _self.buildingName : buildingName // ignore: cast_nullable_to_non_nullable
as String,localizedNames: null == localizedNames ? _self.localizedNames : localizedNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelBuildingCodeDto].
extension HotelBuildingCodeDtoPatterns on HotelBuildingCodeDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelBuildingCodeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelBuildingCodeDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelBuildingCodeDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelBuildingCodeDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelBuildingCodeDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelBuildingCodeDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String buildingCode,  String buildingName,  Map<String, String> localizedNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelBuildingCodeDto() when $default != null:
return $default(_that.buildingCode,_that.buildingName,_that.localizedNames);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String buildingCode,  String buildingName,  Map<String, String> localizedNames)  $default,) {final _that = this;
switch (_that) {
case _HotelBuildingCodeDto():
return $default(_that.buildingCode,_that.buildingName,_that.localizedNames);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String buildingCode,  String buildingName,  Map<String, String> localizedNames)?  $default,) {final _that = this;
switch (_that) {
case _HotelBuildingCodeDto() when $default != null:
return $default(_that.buildingCode,_that.buildingName,_that.localizedNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelBuildingCodeDto implements HotelBuildingCodeDto {
  const _HotelBuildingCodeDto({this.buildingCode = '', this.buildingName = '', final  Map<String, String> localizedNames = const <String, String>{}}): _localizedNames = localizedNames;
  factory _HotelBuildingCodeDto.fromJson(Map<String, dynamic> json) => _$HotelBuildingCodeDtoFromJson(json);

@override@JsonKey() final  String buildingCode;
@override@JsonKey() final  String buildingName;
 final  Map<String, String> _localizedNames;
@override@JsonKey() Map<String, String> get localizedNames {
  if (_localizedNames is EqualUnmodifiableMapView) return _localizedNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_localizedNames);
}


/// Create a copy of HotelBuildingCodeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelBuildingCodeDtoCopyWith<_HotelBuildingCodeDto> get copyWith => __$HotelBuildingCodeDtoCopyWithImpl<_HotelBuildingCodeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelBuildingCodeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelBuildingCodeDto&&(identical(other.buildingCode, buildingCode) || other.buildingCode == buildingCode)&&(identical(other.buildingName, buildingName) || other.buildingName == buildingName)&&const DeepCollectionEquality().equals(other._localizedNames, _localizedNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,buildingCode,buildingName,const DeepCollectionEquality().hash(_localizedNames));

@override
String toString() {
  return 'HotelBuildingCodeDto(buildingCode: $buildingCode, buildingName: $buildingName, localizedNames: $localizedNames)';
}


}

/// @nodoc
abstract mixin class _$HotelBuildingCodeDtoCopyWith<$Res> implements $HotelBuildingCodeDtoCopyWith<$Res> {
  factory _$HotelBuildingCodeDtoCopyWith(_HotelBuildingCodeDto value, $Res Function(_HotelBuildingCodeDto) _then) = __$HotelBuildingCodeDtoCopyWithImpl;
@override @useResult
$Res call({
 String buildingCode, String buildingName, Map<String, String> localizedNames
});




}
/// @nodoc
class __$HotelBuildingCodeDtoCopyWithImpl<$Res>
    implements _$HotelBuildingCodeDtoCopyWith<$Res> {
  __$HotelBuildingCodeDtoCopyWithImpl(this._self, this._then);

  final _HotelBuildingCodeDto _self;
  final $Res Function(_HotelBuildingCodeDto) _then;

/// Create a copy of HotelBuildingCodeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? buildingCode = null,Object? buildingName = null,Object? localizedNames = null,}) {
  return _then(_HotelBuildingCodeDto(
buildingCode: null == buildingCode ? _self.buildingCode : buildingCode // ignore: cast_nullable_to_non_nullable
as String,buildingName: null == buildingName ? _self.buildingName : buildingName // ignore: cast_nullable_to_non_nullable
as String,localizedNames: null == localizedNames ? _self._localizedNames : localizedNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$HotelFacilityFilterDto {

@JsonKey(name: 'convertCode') String get code; String get name;
/// Create a copy of HotelFacilityFilterDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelFacilityFilterDtoCopyWith<HotelFacilityFilterDto> get copyWith => _$HotelFacilityFilterDtoCopyWithImpl<HotelFacilityFilterDto>(this as HotelFacilityFilterDto, _$identity);

  /// Serializes this HotelFacilityFilterDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelFacilityFilterDto&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name);

@override
String toString() {
  return 'HotelFacilityFilterDto(code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class $HotelFacilityFilterDtoCopyWith<$Res>  {
  factory $HotelFacilityFilterDtoCopyWith(HotelFacilityFilterDto value, $Res Function(HotelFacilityFilterDto) _then) = _$HotelFacilityFilterDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'convertCode') String code, String name
});




}
/// @nodoc
class _$HotelFacilityFilterDtoCopyWithImpl<$Res>
    implements $HotelFacilityFilterDtoCopyWith<$Res> {
  _$HotelFacilityFilterDtoCopyWithImpl(this._self, this._then);

  final HotelFacilityFilterDto _self;
  final $Res Function(HotelFacilityFilterDto) _then;

/// Create a copy of HotelFacilityFilterDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelFacilityFilterDto].
extension HotelFacilityFilterDtoPatterns on HotelFacilityFilterDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelFacilityFilterDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelFacilityFilterDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelFacilityFilterDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelFacilityFilterDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelFacilityFilterDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelFacilityFilterDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'convertCode')  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelFacilityFilterDto() when $default != null:
return $default(_that.code,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'convertCode')  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _HotelFacilityFilterDto():
return $default(_that.code,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'convertCode')  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _HotelFacilityFilterDto() when $default != null:
return $default(_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelFacilityFilterDto implements HotelFacilityFilterDto {
  const _HotelFacilityFilterDto({@JsonKey(name: 'convertCode') this.code = '', this.name = ''});
  factory _HotelFacilityFilterDto.fromJson(Map<String, dynamic> json) => _$HotelFacilityFilterDtoFromJson(json);

@override@JsonKey(name: 'convertCode') final  String code;
@override@JsonKey() final  String name;

/// Create a copy of HotelFacilityFilterDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelFacilityFilterDtoCopyWith<_HotelFacilityFilterDto> get copyWith => __$HotelFacilityFilterDtoCopyWithImpl<_HotelFacilityFilterDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelFacilityFilterDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelFacilityFilterDto&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name);

@override
String toString() {
  return 'HotelFacilityFilterDto(code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$HotelFacilityFilterDtoCopyWith<$Res> implements $HotelFacilityFilterDtoCopyWith<$Res> {
  factory _$HotelFacilityFilterDtoCopyWith(_HotelFacilityFilterDto value, $Res Function(_HotelFacilityFilterDto) _then) = __$HotelFacilityFilterDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'convertCode') String code, String name
});




}
/// @nodoc
class __$HotelFacilityFilterDtoCopyWithImpl<$Res>
    implements _$HotelFacilityFilterDtoCopyWith<$Res> {
  __$HotelFacilityFilterDtoCopyWithImpl(this._self, this._then);

  final _HotelFacilityFilterDto _self;
  final $Res Function(_HotelFacilityFilterDto) _then;

/// Create a copy of HotelFacilityFilterDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,}) {
  return _then(_HotelFacilityFilterDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HotelDetailRequestDto {

 String get id; String get lang; String get startDate; String get endDate; int? get occupancy;
/// Create a copy of HotelDetailRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelDetailRequestDtoCopyWith<HotelDetailRequestDto> get copyWith => _$HotelDetailRequestDtoCopyWithImpl<HotelDetailRequestDto>(this as HotelDetailRequestDto, _$identity);

  /// Serializes this HotelDetailRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelDetailRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lang,startDate,endDate,occupancy);

@override
String toString() {
  return 'HotelDetailRequestDto(id: $id, lang: $lang, startDate: $startDate, endDate: $endDate, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class $HotelDetailRequestDtoCopyWith<$Res>  {
  factory $HotelDetailRequestDtoCopyWith(HotelDetailRequestDto value, $Res Function(HotelDetailRequestDto) _then) = _$HotelDetailRequestDtoCopyWithImpl;
@useResult
$Res call({
 String id, String lang, String startDate, String endDate, int? occupancy
});




}
/// @nodoc
class _$HotelDetailRequestDtoCopyWithImpl<$Res>
    implements $HotelDetailRequestDtoCopyWith<$Res> {
  _$HotelDetailRequestDtoCopyWithImpl(this._self, this._then);

  final HotelDetailRequestDto _self;
  final $Res Function(HotelDetailRequestDto) _then;

/// Create a copy of HotelDetailRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lang = null,Object? startDate = null,Object? endDate = null,Object? occupancy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelDetailRequestDto].
extension HotelDetailRequestDtoPatterns on HotelDetailRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelDetailRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelDetailRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelDetailRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelDetailRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelDetailRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelDetailRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String lang,  String startDate,  String endDate,  int? occupancy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelDetailRequestDto() when $default != null:
return $default(_that.id,_that.lang,_that.startDate,_that.endDate,_that.occupancy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String lang,  String startDate,  String endDate,  int? occupancy)  $default,) {final _that = this;
switch (_that) {
case _HotelDetailRequestDto():
return $default(_that.id,_that.lang,_that.startDate,_that.endDate,_that.occupancy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String lang,  String startDate,  String endDate,  int? occupancy)?  $default,) {final _that = this;
switch (_that) {
case _HotelDetailRequestDto() when $default != null:
return $default(_that.id,_that.lang,_that.startDate,_that.endDate,_that.occupancy);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _HotelDetailRequestDto implements HotelDetailRequestDto {
  const _HotelDetailRequestDto({required this.id, required this.lang, required this.startDate, required this.endDate, this.occupancy});
  factory _HotelDetailRequestDto.fromJson(Map<String, dynamic> json) => _$HotelDetailRequestDtoFromJson(json);

@override final  String id;
@override final  String lang;
@override final  String startDate;
@override final  String endDate;
@override final  int? occupancy;

/// Create a copy of HotelDetailRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelDetailRequestDtoCopyWith<_HotelDetailRequestDto> get copyWith => __$HotelDetailRequestDtoCopyWithImpl<_HotelDetailRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelDetailRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelDetailRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lang,startDate,endDate,occupancy);

@override
String toString() {
  return 'HotelDetailRequestDto(id: $id, lang: $lang, startDate: $startDate, endDate: $endDate, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class _$HotelDetailRequestDtoCopyWith<$Res> implements $HotelDetailRequestDtoCopyWith<$Res> {
  factory _$HotelDetailRequestDtoCopyWith(_HotelDetailRequestDto value, $Res Function(_HotelDetailRequestDto) _then) = __$HotelDetailRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String lang, String startDate, String endDate, int? occupancy
});




}
/// @nodoc
class __$HotelDetailRequestDtoCopyWithImpl<$Res>
    implements _$HotelDetailRequestDtoCopyWith<$Res> {
  __$HotelDetailRequestDtoCopyWithImpl(this._self, this._then);

  final _HotelDetailRequestDto _self;
  final $Res Function(_HotelDetailRequestDto) _then;

/// Create a copy of HotelDetailRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lang = null,Object? startDate = null,Object? endDate = null,Object? occupancy = freezed,}) {
  return _then(_HotelDetailRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$HotelDetailDto {

 String get id; String get name; String? get address; String? get description; Object? get lat; Object? get lng; int? get bookingType; bool? get bookingStatus; num? get entirePrice; String? get checkInMessage; String? get checkInTime; String? get checkOutTime; String? get detail; String? get surrounding; String? get travel; String? get checkInGuide; String? get rule; String? get telNo; List<Object?> get propertyFacilities; Map<String, Object?> get propertyFacilityNames;@JsonKey(name: 'hotelPictures') List<HotelPictureDto> get pictures;@JsonKey(name: 'roomTypeDTO4APPs') List<HotelRoomTypeDto> get roomTypes;@JsonKey(fromJson: hotelStringListFromJson) List<String> get tags;
/// Create a copy of HotelDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelDetailDtoCopyWith<HotelDetailDto> get copyWith => _$HotelDetailDtoCopyWithImpl<HotelDetailDto>(this as HotelDetailDto, _$identity);

  /// Serializes this HotelDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.lat, lat)&&const DeepCollectionEquality().equals(other.lng, lng)&&(identical(other.bookingType, bookingType) || other.bookingType == bookingType)&&(identical(other.bookingStatus, bookingStatus) || other.bookingStatus == bookingStatus)&&(identical(other.entirePrice, entirePrice) || other.entirePrice == entirePrice)&&(identical(other.checkInMessage, checkInMessage) || other.checkInMessage == checkInMessage)&&(identical(other.checkInTime, checkInTime) || other.checkInTime == checkInTime)&&(identical(other.checkOutTime, checkOutTime) || other.checkOutTime == checkOutTime)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.surrounding, surrounding) || other.surrounding == surrounding)&&(identical(other.travel, travel) || other.travel == travel)&&(identical(other.checkInGuide, checkInGuide) || other.checkInGuide == checkInGuide)&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.telNo, telNo) || other.telNo == telNo)&&const DeepCollectionEquality().equals(other.propertyFacilities, propertyFacilities)&&const DeepCollectionEquality().equals(other.propertyFacilityNames, propertyFacilityNames)&&const DeepCollectionEquality().equals(other.pictures, pictures)&&const DeepCollectionEquality().equals(other.roomTypes, roomTypes)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,address,description,const DeepCollectionEquality().hash(lat),const DeepCollectionEquality().hash(lng),bookingType,bookingStatus,entirePrice,checkInMessage,checkInTime,checkOutTime,detail,surrounding,travel,checkInGuide,rule,telNo,const DeepCollectionEquality().hash(propertyFacilities),const DeepCollectionEquality().hash(propertyFacilityNames),const DeepCollectionEquality().hash(pictures),const DeepCollectionEquality().hash(roomTypes),const DeepCollectionEquality().hash(tags)]);

@override
String toString() {
  return 'HotelDetailDto(id: $id, name: $name, address: $address, description: $description, lat: $lat, lng: $lng, bookingType: $bookingType, bookingStatus: $bookingStatus, entirePrice: $entirePrice, checkInMessage: $checkInMessage, checkInTime: $checkInTime, checkOutTime: $checkOutTime, detail: $detail, surrounding: $surrounding, travel: $travel, checkInGuide: $checkInGuide, rule: $rule, telNo: $telNo, propertyFacilities: $propertyFacilities, propertyFacilityNames: $propertyFacilityNames, pictures: $pictures, roomTypes: $roomTypes, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $HotelDetailDtoCopyWith<$Res>  {
  factory $HotelDetailDtoCopyWith(HotelDetailDto value, $Res Function(HotelDetailDto) _then) = _$HotelDetailDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, String? description, Object? lat, Object? lng, int? bookingType, bool? bookingStatus, num? entirePrice, String? checkInMessage, String? checkInTime, String? checkOutTime, String? detail, String? surrounding, String? travel, String? checkInGuide, String? rule, String? telNo, List<Object?> propertyFacilities, Map<String, Object?> propertyFacilityNames,@JsonKey(name: 'hotelPictures') List<HotelPictureDto> pictures,@JsonKey(name: 'roomTypeDTO4APPs') List<HotelRoomTypeDto> roomTypes,@JsonKey(fromJson: hotelStringListFromJson) List<String> tags
});




}
/// @nodoc
class _$HotelDetailDtoCopyWithImpl<$Res>
    implements $HotelDetailDtoCopyWith<$Res> {
  _$HotelDetailDtoCopyWithImpl(this._self, this._then);

  final HotelDetailDto _self;
  final $Res Function(HotelDetailDto) _then;

/// Create a copy of HotelDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? description = freezed,Object? lat = freezed,Object? lng = freezed,Object? bookingType = freezed,Object? bookingStatus = freezed,Object? entirePrice = freezed,Object? checkInMessage = freezed,Object? checkInTime = freezed,Object? checkOutTime = freezed,Object? detail = freezed,Object? surrounding = freezed,Object? travel = freezed,Object? checkInGuide = freezed,Object? rule = freezed,Object? telNo = freezed,Object? propertyFacilities = null,Object? propertyFacilityNames = null,Object? pictures = null,Object? roomTypes = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat ,lng: freezed == lng ? _self.lng : lng ,bookingType: freezed == bookingType ? _self.bookingType : bookingType // ignore: cast_nullable_to_non_nullable
as int?,bookingStatus: freezed == bookingStatus ? _self.bookingStatus : bookingStatus // ignore: cast_nullable_to_non_nullable
as bool?,entirePrice: freezed == entirePrice ? _self.entirePrice : entirePrice // ignore: cast_nullable_to_non_nullable
as num?,checkInMessage: freezed == checkInMessage ? _self.checkInMessage : checkInMessage // ignore: cast_nullable_to_non_nullable
as String?,checkInTime: freezed == checkInTime ? _self.checkInTime : checkInTime // ignore: cast_nullable_to_non_nullable
as String?,checkOutTime: freezed == checkOutTime ? _self.checkOutTime : checkOutTime // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,surrounding: freezed == surrounding ? _self.surrounding : surrounding // ignore: cast_nullable_to_non_nullable
as String?,travel: freezed == travel ? _self.travel : travel // ignore: cast_nullable_to_non_nullable
as String?,checkInGuide: freezed == checkInGuide ? _self.checkInGuide : checkInGuide // ignore: cast_nullable_to_non_nullable
as String?,rule: freezed == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String?,telNo: freezed == telNo ? _self.telNo : telNo // ignore: cast_nullable_to_non_nullable
as String?,propertyFacilities: null == propertyFacilities ? _self.propertyFacilities : propertyFacilities // ignore: cast_nullable_to_non_nullable
as List<Object?>,propertyFacilityNames: null == propertyFacilityNames ? _self.propertyFacilityNames : propertyFacilityNames // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,pictures: null == pictures ? _self.pictures : pictures // ignore: cast_nullable_to_non_nullable
as List<HotelPictureDto>,roomTypes: null == roomTypes ? _self.roomTypes : roomTypes // ignore: cast_nullable_to_non_nullable
as List<HotelRoomTypeDto>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelDetailDto].
extension HotelDetailDtoPatterns on HotelDetailDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelDetailDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelDetailDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelDetailDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String? description,  Object? lat,  Object? lng,  int? bookingType,  bool? bookingStatus,  num? entirePrice,  String? checkInMessage,  String? checkInTime,  String? checkOutTime,  String? detail,  String? surrounding,  String? travel,  String? checkInGuide,  String? rule,  String? telNo,  List<Object?> propertyFacilities,  Map<String, Object?> propertyFacilityNames, @JsonKey(name: 'hotelPictures')  List<HotelPictureDto> pictures, @JsonKey(name: 'roomTypeDTO4APPs')  List<HotelRoomTypeDto> roomTypes, @JsonKey(fromJson: hotelStringListFromJson)  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelDetailDto() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.description,_that.lat,_that.lng,_that.bookingType,_that.bookingStatus,_that.entirePrice,_that.checkInMessage,_that.checkInTime,_that.checkOutTime,_that.detail,_that.surrounding,_that.travel,_that.checkInGuide,_that.rule,_that.telNo,_that.propertyFacilities,_that.propertyFacilityNames,_that.pictures,_that.roomTypes,_that.tags);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String? description,  Object? lat,  Object? lng,  int? bookingType,  bool? bookingStatus,  num? entirePrice,  String? checkInMessage,  String? checkInTime,  String? checkOutTime,  String? detail,  String? surrounding,  String? travel,  String? checkInGuide,  String? rule,  String? telNo,  List<Object?> propertyFacilities,  Map<String, Object?> propertyFacilityNames, @JsonKey(name: 'hotelPictures')  List<HotelPictureDto> pictures, @JsonKey(name: 'roomTypeDTO4APPs')  List<HotelRoomTypeDto> roomTypes, @JsonKey(fromJson: hotelStringListFromJson)  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _HotelDetailDto():
return $default(_that.id,_that.name,_that.address,_that.description,_that.lat,_that.lng,_that.bookingType,_that.bookingStatus,_that.entirePrice,_that.checkInMessage,_that.checkInTime,_that.checkOutTime,_that.detail,_that.surrounding,_that.travel,_that.checkInGuide,_that.rule,_that.telNo,_that.propertyFacilities,_that.propertyFacilityNames,_that.pictures,_that.roomTypes,_that.tags);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  String? description,  Object? lat,  Object? lng,  int? bookingType,  bool? bookingStatus,  num? entirePrice,  String? checkInMessage,  String? checkInTime,  String? checkOutTime,  String? detail,  String? surrounding,  String? travel,  String? checkInGuide,  String? rule,  String? telNo,  List<Object?> propertyFacilities,  Map<String, Object?> propertyFacilityNames, @JsonKey(name: 'hotelPictures')  List<HotelPictureDto> pictures, @JsonKey(name: 'roomTypeDTO4APPs')  List<HotelRoomTypeDto> roomTypes, @JsonKey(fromJson: hotelStringListFromJson)  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _HotelDetailDto() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.description,_that.lat,_that.lng,_that.bookingType,_that.bookingStatus,_that.entirePrice,_that.checkInMessage,_that.checkInTime,_that.checkOutTime,_that.detail,_that.surrounding,_that.travel,_that.checkInGuide,_that.rule,_that.telNo,_that.propertyFacilities,_that.propertyFacilityNames,_that.pictures,_that.roomTypes,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelDetailDto implements HotelDetailDto {
  const _HotelDetailDto({this.id = '', this.name = '', this.address, this.description, this.lat, this.lng, this.bookingType, this.bookingStatus, this.entirePrice, this.checkInMessage, this.checkInTime, this.checkOutTime, this.detail, this.surrounding, this.travel, this.checkInGuide, this.rule, this.telNo, final  List<Object?> propertyFacilities = const <Object?>[], final  Map<String, Object?> propertyFacilityNames = const <String, Object?>{}, @JsonKey(name: 'hotelPictures') final  List<HotelPictureDto> pictures = const <HotelPictureDto>[], @JsonKey(name: 'roomTypeDTO4APPs') final  List<HotelRoomTypeDto> roomTypes = const <HotelRoomTypeDto>[], @JsonKey(fromJson: hotelStringListFromJson) final  List<String> tags = const <String>[]}): _propertyFacilities = propertyFacilities,_propertyFacilityNames = propertyFacilityNames,_pictures = pictures,_roomTypes = roomTypes,_tags = tags;
  factory _HotelDetailDto.fromJson(Map<String, dynamic> json) => _$HotelDetailDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override final  String? address;
@override final  String? description;
@override final  Object? lat;
@override final  Object? lng;
@override final  int? bookingType;
@override final  bool? bookingStatus;
@override final  num? entirePrice;
@override final  String? checkInMessage;
@override final  String? checkInTime;
@override final  String? checkOutTime;
@override final  String? detail;
@override final  String? surrounding;
@override final  String? travel;
@override final  String? checkInGuide;
@override final  String? rule;
@override final  String? telNo;
 final  List<Object?> _propertyFacilities;
@override@JsonKey() List<Object?> get propertyFacilities {
  if (_propertyFacilities is EqualUnmodifiableListView) return _propertyFacilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_propertyFacilities);
}

 final  Map<String, Object?> _propertyFacilityNames;
@override@JsonKey() Map<String, Object?> get propertyFacilityNames {
  if (_propertyFacilityNames is EqualUnmodifiableMapView) return _propertyFacilityNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_propertyFacilityNames);
}

 final  List<HotelPictureDto> _pictures;
@override@JsonKey(name: 'hotelPictures') List<HotelPictureDto> get pictures {
  if (_pictures is EqualUnmodifiableListView) return _pictures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pictures);
}

 final  List<HotelRoomTypeDto> _roomTypes;
@override@JsonKey(name: 'roomTypeDTO4APPs') List<HotelRoomTypeDto> get roomTypes {
  if (_roomTypes is EqualUnmodifiableListView) return _roomTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomTypes);
}

 final  List<String> _tags;
@override@JsonKey(fromJson: hotelStringListFromJson) List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of HotelDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelDetailDtoCopyWith<_HotelDetailDto> get copyWith => __$HotelDetailDtoCopyWithImpl<_HotelDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.lat, lat)&&const DeepCollectionEquality().equals(other.lng, lng)&&(identical(other.bookingType, bookingType) || other.bookingType == bookingType)&&(identical(other.bookingStatus, bookingStatus) || other.bookingStatus == bookingStatus)&&(identical(other.entirePrice, entirePrice) || other.entirePrice == entirePrice)&&(identical(other.checkInMessage, checkInMessage) || other.checkInMessage == checkInMessage)&&(identical(other.checkInTime, checkInTime) || other.checkInTime == checkInTime)&&(identical(other.checkOutTime, checkOutTime) || other.checkOutTime == checkOutTime)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.surrounding, surrounding) || other.surrounding == surrounding)&&(identical(other.travel, travel) || other.travel == travel)&&(identical(other.checkInGuide, checkInGuide) || other.checkInGuide == checkInGuide)&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.telNo, telNo) || other.telNo == telNo)&&const DeepCollectionEquality().equals(other._propertyFacilities, _propertyFacilities)&&const DeepCollectionEquality().equals(other._propertyFacilityNames, _propertyFacilityNames)&&const DeepCollectionEquality().equals(other._pictures, _pictures)&&const DeepCollectionEquality().equals(other._roomTypes, _roomTypes)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,address,description,const DeepCollectionEquality().hash(lat),const DeepCollectionEquality().hash(lng),bookingType,bookingStatus,entirePrice,checkInMessage,checkInTime,checkOutTime,detail,surrounding,travel,checkInGuide,rule,telNo,const DeepCollectionEquality().hash(_propertyFacilities),const DeepCollectionEquality().hash(_propertyFacilityNames),const DeepCollectionEquality().hash(_pictures),const DeepCollectionEquality().hash(_roomTypes),const DeepCollectionEquality().hash(_tags)]);

@override
String toString() {
  return 'HotelDetailDto(id: $id, name: $name, address: $address, description: $description, lat: $lat, lng: $lng, bookingType: $bookingType, bookingStatus: $bookingStatus, entirePrice: $entirePrice, checkInMessage: $checkInMessage, checkInTime: $checkInTime, checkOutTime: $checkOutTime, detail: $detail, surrounding: $surrounding, travel: $travel, checkInGuide: $checkInGuide, rule: $rule, telNo: $telNo, propertyFacilities: $propertyFacilities, propertyFacilityNames: $propertyFacilityNames, pictures: $pictures, roomTypes: $roomTypes, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$HotelDetailDtoCopyWith<$Res> implements $HotelDetailDtoCopyWith<$Res> {
  factory _$HotelDetailDtoCopyWith(_HotelDetailDto value, $Res Function(_HotelDetailDto) _then) = __$HotelDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, String? description, Object? lat, Object? lng, int? bookingType, bool? bookingStatus, num? entirePrice, String? checkInMessage, String? checkInTime, String? checkOutTime, String? detail, String? surrounding, String? travel, String? checkInGuide, String? rule, String? telNo, List<Object?> propertyFacilities, Map<String, Object?> propertyFacilityNames,@JsonKey(name: 'hotelPictures') List<HotelPictureDto> pictures,@JsonKey(name: 'roomTypeDTO4APPs') List<HotelRoomTypeDto> roomTypes,@JsonKey(fromJson: hotelStringListFromJson) List<String> tags
});




}
/// @nodoc
class __$HotelDetailDtoCopyWithImpl<$Res>
    implements _$HotelDetailDtoCopyWith<$Res> {
  __$HotelDetailDtoCopyWithImpl(this._self, this._then);

  final _HotelDetailDto _self;
  final $Res Function(_HotelDetailDto) _then;

/// Create a copy of HotelDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? description = freezed,Object? lat = freezed,Object? lng = freezed,Object? bookingType = freezed,Object? bookingStatus = freezed,Object? entirePrice = freezed,Object? checkInMessage = freezed,Object? checkInTime = freezed,Object? checkOutTime = freezed,Object? detail = freezed,Object? surrounding = freezed,Object? travel = freezed,Object? checkInGuide = freezed,Object? rule = freezed,Object? telNo = freezed,Object? propertyFacilities = null,Object? propertyFacilityNames = null,Object? pictures = null,Object? roomTypes = null,Object? tags = null,}) {
  return _then(_HotelDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat ,lng: freezed == lng ? _self.lng : lng ,bookingType: freezed == bookingType ? _self.bookingType : bookingType // ignore: cast_nullable_to_non_nullable
as int?,bookingStatus: freezed == bookingStatus ? _self.bookingStatus : bookingStatus // ignore: cast_nullable_to_non_nullable
as bool?,entirePrice: freezed == entirePrice ? _self.entirePrice : entirePrice // ignore: cast_nullable_to_non_nullable
as num?,checkInMessage: freezed == checkInMessage ? _self.checkInMessage : checkInMessage // ignore: cast_nullable_to_non_nullable
as String?,checkInTime: freezed == checkInTime ? _self.checkInTime : checkInTime // ignore: cast_nullable_to_non_nullable
as String?,checkOutTime: freezed == checkOutTime ? _self.checkOutTime : checkOutTime // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,surrounding: freezed == surrounding ? _self.surrounding : surrounding // ignore: cast_nullable_to_non_nullable
as String?,travel: freezed == travel ? _self.travel : travel // ignore: cast_nullable_to_non_nullable
as String?,checkInGuide: freezed == checkInGuide ? _self.checkInGuide : checkInGuide // ignore: cast_nullable_to_non_nullable
as String?,rule: freezed == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String?,telNo: freezed == telNo ? _self.telNo : telNo // ignore: cast_nullable_to_non_nullable
as String?,propertyFacilities: null == propertyFacilities ? _self._propertyFacilities : propertyFacilities // ignore: cast_nullable_to_non_nullable
as List<Object?>,propertyFacilityNames: null == propertyFacilityNames ? _self._propertyFacilityNames : propertyFacilityNames // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,pictures: null == pictures ? _self._pictures : pictures // ignore: cast_nullable_to_non_nullable
as List<HotelPictureDto>,roomTypes: null == roomTypes ? _self._roomTypes : roomTypes // ignore: cast_nullable_to_non_nullable
as List<HotelRoomTypeDto>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$HotelPictureDto {

 String get relativeUrl; String? get description;
/// Create a copy of HotelPictureDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelPictureDtoCopyWith<HotelPictureDto> get copyWith => _$HotelPictureDtoCopyWithImpl<HotelPictureDto>(this as HotelPictureDto, _$identity);

  /// Serializes this HotelPictureDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelPictureDto&&(identical(other.relativeUrl, relativeUrl) || other.relativeUrl == relativeUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relativeUrl,description);

@override
String toString() {
  return 'HotelPictureDto(relativeUrl: $relativeUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $HotelPictureDtoCopyWith<$Res>  {
  factory $HotelPictureDtoCopyWith(HotelPictureDto value, $Res Function(HotelPictureDto) _then) = _$HotelPictureDtoCopyWithImpl;
@useResult
$Res call({
 String relativeUrl, String? description
});




}
/// @nodoc
class _$HotelPictureDtoCopyWithImpl<$Res>
    implements $HotelPictureDtoCopyWith<$Res> {
  _$HotelPictureDtoCopyWithImpl(this._self, this._then);

  final HotelPictureDto _self;
  final $Res Function(HotelPictureDto) _then;

/// Create a copy of HotelPictureDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? relativeUrl = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
relativeUrl: null == relativeUrl ? _self.relativeUrl : relativeUrl // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelPictureDto].
extension HotelPictureDtoPatterns on HotelPictureDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelPictureDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelPictureDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelPictureDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelPictureDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelPictureDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelPictureDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String relativeUrl,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelPictureDto() when $default != null:
return $default(_that.relativeUrl,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String relativeUrl,  String? description)  $default,) {final _that = this;
switch (_that) {
case _HotelPictureDto():
return $default(_that.relativeUrl,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String relativeUrl,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _HotelPictureDto() when $default != null:
return $default(_that.relativeUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelPictureDto implements HotelPictureDto {
  const _HotelPictureDto({this.relativeUrl = '', this.description});
  factory _HotelPictureDto.fromJson(Map<String, dynamic> json) => _$HotelPictureDtoFromJson(json);

@override@JsonKey() final  String relativeUrl;
@override final  String? description;

/// Create a copy of HotelPictureDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelPictureDtoCopyWith<_HotelPictureDto> get copyWith => __$HotelPictureDtoCopyWithImpl<_HotelPictureDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelPictureDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelPictureDto&&(identical(other.relativeUrl, relativeUrl) || other.relativeUrl == relativeUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relativeUrl,description);

@override
String toString() {
  return 'HotelPictureDto(relativeUrl: $relativeUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$HotelPictureDtoCopyWith<$Res> implements $HotelPictureDtoCopyWith<$Res> {
  factory _$HotelPictureDtoCopyWith(_HotelPictureDto value, $Res Function(_HotelPictureDto) _then) = __$HotelPictureDtoCopyWithImpl;
@override @useResult
$Res call({
 String relativeUrl, String? description
});




}
/// @nodoc
class __$HotelPictureDtoCopyWithImpl<$Res>
    implements _$HotelPictureDtoCopyWith<$Res> {
  __$HotelPictureDtoCopyWithImpl(this._self, this._then);

  final _HotelPictureDto _self;
  final $Res Function(_HotelPictureDto) _then;

/// Create a copy of HotelPictureDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? relativeUrl = null,Object? description = freezed,}) {
  return _then(_HotelPictureDto(
relativeUrl: null == relativeUrl ? _self.relativeUrl : relativeUrl // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HotelRoomTypeDto {

 String get id; String get name; String? get showName; num? get price; num? get beforeDiscountPrice; num? get discount; String? get discountName; num? get discount2; String? get discountName2; int? get occupancy; int? get occupantsForBaseRate; Object? get roomSize; int? get bedRoomCount; int? get bathRoomCount; int? get roomCount;@JsonKey(fromJson: hotelStringListFromJson) List<String> get roomIds;@JsonKey(name: 'roomPictures') List<HotelPictureDto> get pictures;@JsonKey(name: 'roomTypeBeds') List<HotelRoomBedDto> get beds;
/// Create a copy of HotelRoomTypeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelRoomTypeDtoCopyWith<HotelRoomTypeDto> get copyWith => _$HotelRoomTypeDtoCopyWithImpl<HotelRoomTypeDto>(this as HotelRoomTypeDto, _$identity);

  /// Serializes this HotelRoomTypeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelRoomTypeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.showName, showName) || other.showName == showName)&&(identical(other.price, price) || other.price == price)&&(identical(other.beforeDiscountPrice, beforeDiscountPrice) || other.beforeDiscountPrice == beforeDiscountPrice)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountName, discountName) || other.discountName == discountName)&&(identical(other.discount2, discount2) || other.discount2 == discount2)&&(identical(other.discountName2, discountName2) || other.discountName2 == discountName2)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.occupantsForBaseRate, occupantsForBaseRate) || other.occupantsForBaseRate == occupantsForBaseRate)&&const DeepCollectionEquality().equals(other.roomSize, roomSize)&&(identical(other.bedRoomCount, bedRoomCount) || other.bedRoomCount == bedRoomCount)&&(identical(other.bathRoomCount, bathRoomCount) || other.bathRoomCount == bathRoomCount)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other.roomIds, roomIds)&&const DeepCollectionEquality().equals(other.pictures, pictures)&&const DeepCollectionEquality().equals(other.beds, beds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,showName,price,beforeDiscountPrice,discount,discountName,discount2,discountName2,occupancy,occupantsForBaseRate,const DeepCollectionEquality().hash(roomSize),bedRoomCount,bathRoomCount,roomCount,const DeepCollectionEquality().hash(roomIds),const DeepCollectionEquality().hash(pictures),const DeepCollectionEquality().hash(beds));

@override
String toString() {
  return 'HotelRoomTypeDto(id: $id, name: $name, showName: $showName, price: $price, beforeDiscountPrice: $beforeDiscountPrice, discount: $discount, discountName: $discountName, discount2: $discount2, discountName2: $discountName2, occupancy: $occupancy, occupantsForBaseRate: $occupantsForBaseRate, roomSize: $roomSize, bedRoomCount: $bedRoomCount, bathRoomCount: $bathRoomCount, roomCount: $roomCount, roomIds: $roomIds, pictures: $pictures, beds: $beds)';
}


}

/// @nodoc
abstract mixin class $HotelRoomTypeDtoCopyWith<$Res>  {
  factory $HotelRoomTypeDtoCopyWith(HotelRoomTypeDto value, $Res Function(HotelRoomTypeDto) _then) = _$HotelRoomTypeDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? showName, num? price, num? beforeDiscountPrice, num? discount, String? discountName, num? discount2, String? discountName2, int? occupancy, int? occupantsForBaseRate, Object? roomSize, int? bedRoomCount, int? bathRoomCount, int? roomCount,@JsonKey(fromJson: hotelStringListFromJson) List<String> roomIds,@JsonKey(name: 'roomPictures') List<HotelPictureDto> pictures,@JsonKey(name: 'roomTypeBeds') List<HotelRoomBedDto> beds
});




}
/// @nodoc
class _$HotelRoomTypeDtoCopyWithImpl<$Res>
    implements $HotelRoomTypeDtoCopyWith<$Res> {
  _$HotelRoomTypeDtoCopyWithImpl(this._self, this._then);

  final HotelRoomTypeDto _self;
  final $Res Function(HotelRoomTypeDto) _then;

/// Create a copy of HotelRoomTypeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? showName = freezed,Object? price = freezed,Object? beforeDiscountPrice = freezed,Object? discount = freezed,Object? discountName = freezed,Object? discount2 = freezed,Object? discountName2 = freezed,Object? occupancy = freezed,Object? occupantsForBaseRate = freezed,Object? roomSize = freezed,Object? bedRoomCount = freezed,Object? bathRoomCount = freezed,Object? roomCount = freezed,Object? roomIds = null,Object? pictures = null,Object? beds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,showName: freezed == showName ? _self.showName : showName // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num?,beforeDiscountPrice: freezed == beforeDiscountPrice ? _self.beforeDiscountPrice : beforeDiscountPrice // ignore: cast_nullable_to_non_nullable
as num?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num?,discountName: freezed == discountName ? _self.discountName : discountName // ignore: cast_nullable_to_non_nullable
as String?,discount2: freezed == discount2 ? _self.discount2 : discount2 // ignore: cast_nullable_to_non_nullable
as num?,discountName2: freezed == discountName2 ? _self.discountName2 : discountName2 // ignore: cast_nullable_to_non_nullable
as String?,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int?,occupantsForBaseRate: freezed == occupantsForBaseRate ? _self.occupantsForBaseRate : occupantsForBaseRate // ignore: cast_nullable_to_non_nullable
as int?,roomSize: freezed == roomSize ? _self.roomSize : roomSize ,bedRoomCount: freezed == bedRoomCount ? _self.bedRoomCount : bedRoomCount // ignore: cast_nullable_to_non_nullable
as int?,bathRoomCount: freezed == bathRoomCount ? _self.bathRoomCount : bathRoomCount // ignore: cast_nullable_to_non_nullable
as int?,roomCount: freezed == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int?,roomIds: null == roomIds ? _self.roomIds : roomIds // ignore: cast_nullable_to_non_nullable
as List<String>,pictures: null == pictures ? _self.pictures : pictures // ignore: cast_nullable_to_non_nullable
as List<HotelPictureDto>,beds: null == beds ? _self.beds : beds // ignore: cast_nullable_to_non_nullable
as List<HotelRoomBedDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelRoomTypeDto].
extension HotelRoomTypeDtoPatterns on HotelRoomTypeDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelRoomTypeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelRoomTypeDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelRoomTypeDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelRoomTypeDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelRoomTypeDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelRoomTypeDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? showName,  num? price,  num? beforeDiscountPrice,  num? discount,  String? discountName,  num? discount2,  String? discountName2,  int? occupancy,  int? occupantsForBaseRate,  Object? roomSize,  int? bedRoomCount,  int? bathRoomCount,  int? roomCount, @JsonKey(fromJson: hotelStringListFromJson)  List<String> roomIds, @JsonKey(name: 'roomPictures')  List<HotelPictureDto> pictures, @JsonKey(name: 'roomTypeBeds')  List<HotelRoomBedDto> beds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelRoomTypeDto() when $default != null:
return $default(_that.id,_that.name,_that.showName,_that.price,_that.beforeDiscountPrice,_that.discount,_that.discountName,_that.discount2,_that.discountName2,_that.occupancy,_that.occupantsForBaseRate,_that.roomSize,_that.bedRoomCount,_that.bathRoomCount,_that.roomCount,_that.roomIds,_that.pictures,_that.beds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? showName,  num? price,  num? beforeDiscountPrice,  num? discount,  String? discountName,  num? discount2,  String? discountName2,  int? occupancy,  int? occupantsForBaseRate,  Object? roomSize,  int? bedRoomCount,  int? bathRoomCount,  int? roomCount, @JsonKey(fromJson: hotelStringListFromJson)  List<String> roomIds, @JsonKey(name: 'roomPictures')  List<HotelPictureDto> pictures, @JsonKey(name: 'roomTypeBeds')  List<HotelRoomBedDto> beds)  $default,) {final _that = this;
switch (_that) {
case _HotelRoomTypeDto():
return $default(_that.id,_that.name,_that.showName,_that.price,_that.beforeDiscountPrice,_that.discount,_that.discountName,_that.discount2,_that.discountName2,_that.occupancy,_that.occupantsForBaseRate,_that.roomSize,_that.bedRoomCount,_that.bathRoomCount,_that.roomCount,_that.roomIds,_that.pictures,_that.beds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? showName,  num? price,  num? beforeDiscountPrice,  num? discount,  String? discountName,  num? discount2,  String? discountName2,  int? occupancy,  int? occupantsForBaseRate,  Object? roomSize,  int? bedRoomCount,  int? bathRoomCount,  int? roomCount, @JsonKey(fromJson: hotelStringListFromJson)  List<String> roomIds, @JsonKey(name: 'roomPictures')  List<HotelPictureDto> pictures, @JsonKey(name: 'roomTypeBeds')  List<HotelRoomBedDto> beds)?  $default,) {final _that = this;
switch (_that) {
case _HotelRoomTypeDto() when $default != null:
return $default(_that.id,_that.name,_that.showName,_that.price,_that.beforeDiscountPrice,_that.discount,_that.discountName,_that.discount2,_that.discountName2,_that.occupancy,_that.occupantsForBaseRate,_that.roomSize,_that.bedRoomCount,_that.bathRoomCount,_that.roomCount,_that.roomIds,_that.pictures,_that.beds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelRoomTypeDto implements HotelRoomTypeDto {
  const _HotelRoomTypeDto({this.id = '', this.name = '', this.showName, this.price, this.beforeDiscountPrice, this.discount, this.discountName, this.discount2, this.discountName2, this.occupancy, this.occupantsForBaseRate, this.roomSize, this.bedRoomCount, this.bathRoomCount, this.roomCount, @JsonKey(fromJson: hotelStringListFromJson) final  List<String> roomIds = const <String>[], @JsonKey(name: 'roomPictures') final  List<HotelPictureDto> pictures = const <HotelPictureDto>[], @JsonKey(name: 'roomTypeBeds') final  List<HotelRoomBedDto> beds = const <HotelRoomBedDto>[]}): _roomIds = roomIds,_pictures = pictures,_beds = beds;
  factory _HotelRoomTypeDto.fromJson(Map<String, dynamic> json) => _$HotelRoomTypeDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override final  String? showName;
@override final  num? price;
@override final  num? beforeDiscountPrice;
@override final  num? discount;
@override final  String? discountName;
@override final  num? discount2;
@override final  String? discountName2;
@override final  int? occupancy;
@override final  int? occupantsForBaseRate;
@override final  Object? roomSize;
@override final  int? bedRoomCount;
@override final  int? bathRoomCount;
@override final  int? roomCount;
 final  List<String> _roomIds;
@override@JsonKey(fromJson: hotelStringListFromJson) List<String> get roomIds {
  if (_roomIds is EqualUnmodifiableListView) return _roomIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomIds);
}

 final  List<HotelPictureDto> _pictures;
@override@JsonKey(name: 'roomPictures') List<HotelPictureDto> get pictures {
  if (_pictures is EqualUnmodifiableListView) return _pictures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pictures);
}

 final  List<HotelRoomBedDto> _beds;
@override@JsonKey(name: 'roomTypeBeds') List<HotelRoomBedDto> get beds {
  if (_beds is EqualUnmodifiableListView) return _beds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_beds);
}


/// Create a copy of HotelRoomTypeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelRoomTypeDtoCopyWith<_HotelRoomTypeDto> get copyWith => __$HotelRoomTypeDtoCopyWithImpl<_HotelRoomTypeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelRoomTypeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelRoomTypeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.showName, showName) || other.showName == showName)&&(identical(other.price, price) || other.price == price)&&(identical(other.beforeDiscountPrice, beforeDiscountPrice) || other.beforeDiscountPrice == beforeDiscountPrice)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountName, discountName) || other.discountName == discountName)&&(identical(other.discount2, discount2) || other.discount2 == discount2)&&(identical(other.discountName2, discountName2) || other.discountName2 == discountName2)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&(identical(other.occupantsForBaseRate, occupantsForBaseRate) || other.occupantsForBaseRate == occupantsForBaseRate)&&const DeepCollectionEquality().equals(other.roomSize, roomSize)&&(identical(other.bedRoomCount, bedRoomCount) || other.bedRoomCount == bedRoomCount)&&(identical(other.bathRoomCount, bathRoomCount) || other.bathRoomCount == bathRoomCount)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other._roomIds, _roomIds)&&const DeepCollectionEquality().equals(other._pictures, _pictures)&&const DeepCollectionEquality().equals(other._beds, _beds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,showName,price,beforeDiscountPrice,discount,discountName,discount2,discountName2,occupancy,occupantsForBaseRate,const DeepCollectionEquality().hash(roomSize),bedRoomCount,bathRoomCount,roomCount,const DeepCollectionEquality().hash(_roomIds),const DeepCollectionEquality().hash(_pictures),const DeepCollectionEquality().hash(_beds));

@override
String toString() {
  return 'HotelRoomTypeDto(id: $id, name: $name, showName: $showName, price: $price, beforeDiscountPrice: $beforeDiscountPrice, discount: $discount, discountName: $discountName, discount2: $discount2, discountName2: $discountName2, occupancy: $occupancy, occupantsForBaseRate: $occupantsForBaseRate, roomSize: $roomSize, bedRoomCount: $bedRoomCount, bathRoomCount: $bathRoomCount, roomCount: $roomCount, roomIds: $roomIds, pictures: $pictures, beds: $beds)';
}


}

/// @nodoc
abstract mixin class _$HotelRoomTypeDtoCopyWith<$Res> implements $HotelRoomTypeDtoCopyWith<$Res> {
  factory _$HotelRoomTypeDtoCopyWith(_HotelRoomTypeDto value, $Res Function(_HotelRoomTypeDto) _then) = __$HotelRoomTypeDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? showName, num? price, num? beforeDiscountPrice, num? discount, String? discountName, num? discount2, String? discountName2, int? occupancy, int? occupantsForBaseRate, Object? roomSize, int? bedRoomCount, int? bathRoomCount, int? roomCount,@JsonKey(fromJson: hotelStringListFromJson) List<String> roomIds,@JsonKey(name: 'roomPictures') List<HotelPictureDto> pictures,@JsonKey(name: 'roomTypeBeds') List<HotelRoomBedDto> beds
});




}
/// @nodoc
class __$HotelRoomTypeDtoCopyWithImpl<$Res>
    implements _$HotelRoomTypeDtoCopyWith<$Res> {
  __$HotelRoomTypeDtoCopyWithImpl(this._self, this._then);

  final _HotelRoomTypeDto _self;
  final $Res Function(_HotelRoomTypeDto) _then;

/// Create a copy of HotelRoomTypeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? showName = freezed,Object? price = freezed,Object? beforeDiscountPrice = freezed,Object? discount = freezed,Object? discountName = freezed,Object? discount2 = freezed,Object? discountName2 = freezed,Object? occupancy = freezed,Object? occupantsForBaseRate = freezed,Object? roomSize = freezed,Object? bedRoomCount = freezed,Object? bathRoomCount = freezed,Object? roomCount = freezed,Object? roomIds = null,Object? pictures = null,Object? beds = null,}) {
  return _then(_HotelRoomTypeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,showName: freezed == showName ? _self.showName : showName // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num?,beforeDiscountPrice: freezed == beforeDiscountPrice ? _self.beforeDiscountPrice : beforeDiscountPrice // ignore: cast_nullable_to_non_nullable
as num?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num?,discountName: freezed == discountName ? _self.discountName : discountName // ignore: cast_nullable_to_non_nullable
as String?,discount2: freezed == discount2 ? _self.discount2 : discount2 // ignore: cast_nullable_to_non_nullable
as num?,discountName2: freezed == discountName2 ? _self.discountName2 : discountName2 // ignore: cast_nullable_to_non_nullable
as String?,occupancy: freezed == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as int?,occupantsForBaseRate: freezed == occupantsForBaseRate ? _self.occupantsForBaseRate : occupantsForBaseRate // ignore: cast_nullable_to_non_nullable
as int?,roomSize: freezed == roomSize ? _self.roomSize : roomSize ,bedRoomCount: freezed == bedRoomCount ? _self.bedRoomCount : bedRoomCount // ignore: cast_nullable_to_non_nullable
as int?,bathRoomCount: freezed == bathRoomCount ? _self.bathRoomCount : bathRoomCount // ignore: cast_nullable_to_non_nullable
as int?,roomCount: freezed == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int?,roomIds: null == roomIds ? _self._roomIds : roomIds // ignore: cast_nullable_to_non_nullable
as List<String>,pictures: null == pictures ? _self._pictures : pictures // ignore: cast_nullable_to_non_nullable
as List<HotelPictureDto>,beds: null == beds ? _self._beds : beds // ignore: cast_nullable_to_non_nullable
as List<HotelRoomBedDto>,
  ));
}


}


/// @nodoc
mixin _$HotelRoomBedDto {

 String get name; int? get count; int? get num; int? get quantity; Object? get width; Object? get extent;
/// Create a copy of HotelRoomBedDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelRoomBedDtoCopyWith<HotelRoomBedDto> get copyWith => _$HotelRoomBedDtoCopyWithImpl<HotelRoomBedDto>(this as HotelRoomBedDto, _$identity);

  /// Serializes this HotelRoomBedDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelRoomBedDto&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&(identical(other.num, num) || other.num == num)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.width, width)&&const DeepCollectionEquality().equals(other.extent, extent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,count,num,quantity,const DeepCollectionEquality().hash(width),const DeepCollectionEquality().hash(extent));

@override
String toString() {
  return 'HotelRoomBedDto(name: $name, count: $count, num: $num, quantity: $quantity, width: $width, extent: $extent)';
}


}

/// @nodoc
abstract mixin class $HotelRoomBedDtoCopyWith<$Res>  {
  factory $HotelRoomBedDtoCopyWith(HotelRoomBedDto value, $Res Function(HotelRoomBedDto) _then) = _$HotelRoomBedDtoCopyWithImpl;
@useResult
$Res call({
 String name, int? count, int? num, int? quantity, Object? width, Object? extent
});




}
/// @nodoc
class _$HotelRoomBedDtoCopyWithImpl<$Res>
    implements $HotelRoomBedDtoCopyWith<$Res> {
  _$HotelRoomBedDtoCopyWithImpl(this._self, this._then);

  final HotelRoomBedDto _self;
  final $Res Function(HotelRoomBedDto) _then;

/// Create a copy of HotelRoomBedDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? count = freezed,Object? num = freezed,Object? quantity = freezed,Object? width = freezed,Object? extent = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,num: freezed == num ? _self.num : num // ignore: cast_nullable_to_non_nullable
as int?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width ,extent: freezed == extent ? _self.extent : extent ,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelRoomBedDto].
extension HotelRoomBedDtoPatterns on HotelRoomBedDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelRoomBedDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelRoomBedDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelRoomBedDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelRoomBedDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelRoomBedDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelRoomBedDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int? count,  int? num,  int? quantity,  Object? width,  Object? extent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelRoomBedDto() when $default != null:
return $default(_that.name,_that.count,_that.num,_that.quantity,_that.width,_that.extent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int? count,  int? num,  int? quantity,  Object? width,  Object? extent)  $default,) {final _that = this;
switch (_that) {
case _HotelRoomBedDto():
return $default(_that.name,_that.count,_that.num,_that.quantity,_that.width,_that.extent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int? count,  int? num,  int? quantity,  Object? width,  Object? extent)?  $default,) {final _that = this;
switch (_that) {
case _HotelRoomBedDto() when $default != null:
return $default(_that.name,_that.count,_that.num,_that.quantity,_that.width,_that.extent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelRoomBedDto implements HotelRoomBedDto {
  const _HotelRoomBedDto({this.name = '', this.count, this.num, this.quantity, this.width, this.extent});
  factory _HotelRoomBedDto.fromJson(Map<String, dynamic> json) => _$HotelRoomBedDtoFromJson(json);

@override@JsonKey() final  String name;
@override final  int? count;
@override final  int? num;
@override final  int? quantity;
@override final  Object? width;
@override final  Object? extent;

/// Create a copy of HotelRoomBedDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelRoomBedDtoCopyWith<_HotelRoomBedDto> get copyWith => __$HotelRoomBedDtoCopyWithImpl<_HotelRoomBedDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelRoomBedDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelRoomBedDto&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&(identical(other.num, num) || other.num == num)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.width, width)&&const DeepCollectionEquality().equals(other.extent, extent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,count,num,quantity,const DeepCollectionEquality().hash(width),const DeepCollectionEquality().hash(extent));

@override
String toString() {
  return 'HotelRoomBedDto(name: $name, count: $count, num: $num, quantity: $quantity, width: $width, extent: $extent)';
}


}

/// @nodoc
abstract mixin class _$HotelRoomBedDtoCopyWith<$Res> implements $HotelRoomBedDtoCopyWith<$Res> {
  factory _$HotelRoomBedDtoCopyWith(_HotelRoomBedDto value, $Res Function(_HotelRoomBedDto) _then) = __$HotelRoomBedDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, int? count, int? num, int? quantity, Object? width, Object? extent
});




}
/// @nodoc
class __$HotelRoomBedDtoCopyWithImpl<$Res>
    implements _$HotelRoomBedDtoCopyWith<$Res> {
  __$HotelRoomBedDtoCopyWithImpl(this._self, this._then);

  final _HotelRoomBedDto _self;
  final $Res Function(_HotelRoomBedDto) _then;

/// Create a copy of HotelRoomBedDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? count = freezed,Object? num = freezed,Object? quantity = freezed,Object? width = freezed,Object? extent = freezed,}) {
  return _then(_HotelRoomBedDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,num: freezed == num ? _self.num : num // ignore: cast_nullable_to_non_nullable
as int?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width ,extent: freezed == extent ? _self.extent : extent ,
  ));
}


}


/// @nodoc
mixin _$HotelPriceCalendarDto {

 Map<String, Object?> get pricesByDate;
/// Create a copy of HotelPriceCalendarDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelPriceCalendarDtoCopyWith<HotelPriceCalendarDto> get copyWith => _$HotelPriceCalendarDtoCopyWithImpl<HotelPriceCalendarDto>(this as HotelPriceCalendarDto, _$identity);

  /// Serializes this HotelPriceCalendarDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelPriceCalendarDto&&const DeepCollectionEquality().equals(other.pricesByDate, pricesByDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pricesByDate));

@override
String toString() {
  return 'HotelPriceCalendarDto(pricesByDate: $pricesByDate)';
}


}

/// @nodoc
abstract mixin class $HotelPriceCalendarDtoCopyWith<$Res>  {
  factory $HotelPriceCalendarDtoCopyWith(HotelPriceCalendarDto value, $Res Function(HotelPriceCalendarDto) _then) = _$HotelPriceCalendarDtoCopyWithImpl;
@useResult
$Res call({
 Map<String, Object?> pricesByDate
});




}
/// @nodoc
class _$HotelPriceCalendarDtoCopyWithImpl<$Res>
    implements $HotelPriceCalendarDtoCopyWith<$Res> {
  _$HotelPriceCalendarDtoCopyWithImpl(this._self, this._then);

  final HotelPriceCalendarDto _self;
  final $Res Function(HotelPriceCalendarDto) _then;

/// Create a copy of HotelPriceCalendarDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pricesByDate = null,}) {
  return _then(_self.copyWith(
pricesByDate: null == pricesByDate ? _self.pricesByDate : pricesByDate // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelPriceCalendarDto].
extension HotelPriceCalendarDtoPatterns on HotelPriceCalendarDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelPriceCalendarDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelPriceCalendarDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelPriceCalendarDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelPriceCalendarDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelPriceCalendarDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelPriceCalendarDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Object?> pricesByDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelPriceCalendarDto() when $default != null:
return $default(_that.pricesByDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Object?> pricesByDate)  $default,) {final _that = this;
switch (_that) {
case _HotelPriceCalendarDto():
return $default(_that.pricesByDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Object?> pricesByDate)?  $default,) {final _that = this;
switch (_that) {
case _HotelPriceCalendarDto() when $default != null:
return $default(_that.pricesByDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelPriceCalendarDto implements HotelPriceCalendarDto {
  const _HotelPriceCalendarDto({final  Map<String, Object?> pricesByDate = const <String, Object?>{}}): _pricesByDate = pricesByDate;
  factory _HotelPriceCalendarDto.fromJson(Map<String, dynamic> json) => _$HotelPriceCalendarDtoFromJson(json);

 final  Map<String, Object?> _pricesByDate;
@override@JsonKey() Map<String, Object?> get pricesByDate {
  if (_pricesByDate is EqualUnmodifiableMapView) return _pricesByDate;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pricesByDate);
}


/// Create a copy of HotelPriceCalendarDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelPriceCalendarDtoCopyWith<_HotelPriceCalendarDto> get copyWith => __$HotelPriceCalendarDtoCopyWithImpl<_HotelPriceCalendarDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelPriceCalendarDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelPriceCalendarDto&&const DeepCollectionEquality().equals(other._pricesByDate, _pricesByDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pricesByDate));

@override
String toString() {
  return 'HotelPriceCalendarDto(pricesByDate: $pricesByDate)';
}


}

/// @nodoc
abstract mixin class _$HotelPriceCalendarDtoCopyWith<$Res> implements $HotelPriceCalendarDtoCopyWith<$Res> {
  factory _$HotelPriceCalendarDtoCopyWith(_HotelPriceCalendarDto value, $Res Function(_HotelPriceCalendarDto) _then) = __$HotelPriceCalendarDtoCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Object?> pricesByDate
});




}
/// @nodoc
class __$HotelPriceCalendarDtoCopyWithImpl<$Res>
    implements _$HotelPriceCalendarDtoCopyWith<$Res> {
  __$HotelPriceCalendarDtoCopyWithImpl(this._self, this._then);

  final _HotelPriceCalendarDto _self;
  final $Res Function(_HotelPriceCalendarDto) _then;

/// Create a copy of HotelPriceCalendarDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pricesByDate = null,}) {
  return _then(_HotelPriceCalendarDto(
pricesByDate: null == pricesByDate ? _self._pricesByDate : pricesByDate // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}


/// @nodoc
mixin _$HotelBookingCreateRequestDto {

 List<Map<String, dynamic>> get couponsCounts; HotelBookingCreateParentDto get parent; String get site;
/// Create a copy of HotelBookingCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelBookingCreateRequestDtoCopyWith<HotelBookingCreateRequestDto> get copyWith => _$HotelBookingCreateRequestDtoCopyWithImpl<HotelBookingCreateRequestDto>(this as HotelBookingCreateRequestDto, _$identity);

  /// Serializes this HotelBookingCreateRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelBookingCreateRequestDto&&const DeepCollectionEquality().equals(other.couponsCounts, couponsCounts)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.site, site) || other.site == site));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(couponsCounts),parent,site);

@override
String toString() {
  return 'HotelBookingCreateRequestDto(couponsCounts: $couponsCounts, parent: $parent, site: $site)';
}


}

/// @nodoc
abstract mixin class $HotelBookingCreateRequestDtoCopyWith<$Res>  {
  factory $HotelBookingCreateRequestDtoCopyWith(HotelBookingCreateRequestDto value, $Res Function(HotelBookingCreateRequestDto) _then) = _$HotelBookingCreateRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> couponsCounts, HotelBookingCreateParentDto parent, String site
});


$HotelBookingCreateParentDtoCopyWith<$Res> get parent;

}
/// @nodoc
class _$HotelBookingCreateRequestDtoCopyWithImpl<$Res>
    implements $HotelBookingCreateRequestDtoCopyWith<$Res> {
  _$HotelBookingCreateRequestDtoCopyWithImpl(this._self, this._then);

  final HotelBookingCreateRequestDto _self;
  final $Res Function(HotelBookingCreateRequestDto) _then;

/// Create a copy of HotelBookingCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? couponsCounts = null,Object? parent = null,Object? site = null,}) {
  return _then(_self.copyWith(
couponsCounts: null == couponsCounts ? _self.couponsCounts : couponsCounts // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,parent: null == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as HotelBookingCreateParentDto,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of HotelBookingCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotelBookingCreateParentDtoCopyWith<$Res> get parent {
  
  return $HotelBookingCreateParentDtoCopyWith<$Res>(_self.parent, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}


/// Adds pattern-matching-related methods to [HotelBookingCreateRequestDto].
extension HotelBookingCreateRequestDtoPatterns on HotelBookingCreateRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelBookingCreateRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelBookingCreateRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelBookingCreateRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelBookingCreateRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelBookingCreateRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelBookingCreateRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> couponsCounts,  HotelBookingCreateParentDto parent,  String site)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelBookingCreateRequestDto() when $default != null:
return $default(_that.couponsCounts,_that.parent,_that.site);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> couponsCounts,  HotelBookingCreateParentDto parent,  String site)  $default,) {final _that = this;
switch (_that) {
case _HotelBookingCreateRequestDto():
return $default(_that.couponsCounts,_that.parent,_that.site);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> couponsCounts,  HotelBookingCreateParentDto parent,  String site)?  $default,) {final _that = this;
switch (_that) {
case _HotelBookingCreateRequestDto() when $default != null:
return $default(_that.couponsCounts,_that.parent,_that.site);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _HotelBookingCreateRequestDto implements HotelBookingCreateRequestDto {
  const _HotelBookingCreateRequestDto({final  List<Map<String, dynamic>> couponsCounts = const <Map<String, dynamic>>[], required this.parent, this.site = '38'}): _couponsCounts = couponsCounts;
  factory _HotelBookingCreateRequestDto.fromJson(Map<String, dynamic> json) => _$HotelBookingCreateRequestDtoFromJson(json);

 final  List<Map<String, dynamic>> _couponsCounts;
@override@JsonKey() List<Map<String, dynamic>> get couponsCounts {
  if (_couponsCounts is EqualUnmodifiableListView) return _couponsCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_couponsCounts);
}

@override final  HotelBookingCreateParentDto parent;
@override@JsonKey() final  String site;

/// Create a copy of HotelBookingCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelBookingCreateRequestDtoCopyWith<_HotelBookingCreateRequestDto> get copyWith => __$HotelBookingCreateRequestDtoCopyWithImpl<_HotelBookingCreateRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelBookingCreateRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelBookingCreateRequestDto&&const DeepCollectionEquality().equals(other._couponsCounts, _couponsCounts)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.site, site) || other.site == site));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_couponsCounts),parent,site);

@override
String toString() {
  return 'HotelBookingCreateRequestDto(couponsCounts: $couponsCounts, parent: $parent, site: $site)';
}


}

/// @nodoc
abstract mixin class _$HotelBookingCreateRequestDtoCopyWith<$Res> implements $HotelBookingCreateRequestDtoCopyWith<$Res> {
  factory _$HotelBookingCreateRequestDtoCopyWith(_HotelBookingCreateRequestDto value, $Res Function(_HotelBookingCreateRequestDto) _then) = __$HotelBookingCreateRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> couponsCounts, HotelBookingCreateParentDto parent, String site
});


@override $HotelBookingCreateParentDtoCopyWith<$Res> get parent;

}
/// @nodoc
class __$HotelBookingCreateRequestDtoCopyWithImpl<$Res>
    implements _$HotelBookingCreateRequestDtoCopyWith<$Res> {
  __$HotelBookingCreateRequestDtoCopyWithImpl(this._self, this._then);

  final _HotelBookingCreateRequestDto _self;
  final $Res Function(_HotelBookingCreateRequestDto) _then;

/// Create a copy of HotelBookingCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? couponsCounts = null,Object? parent = null,Object? site = null,}) {
  return _then(_HotelBookingCreateRequestDto(
couponsCounts: null == couponsCounts ? _self._couponsCounts : couponsCounts // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,parent: null == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as HotelBookingCreateParentDto,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of HotelBookingCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotelBookingCreateParentDtoCopyWith<$Res> get parent {
  
  return $HotelBookingCreateParentDtoCopyWith<$Res>(_self.parent, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}


/// @nodoc
mixin _$AirhostBookingOrderRequestDto {

 String get checkIn; String get checkOut; String get firstName; String get lastName; String get lang;@JsonKey(name: 'hotelInfoID') int get hotelInfoId; int get roomCount; int get totalCount; String? get receiptTitle; String get contactIntlCode; String get contactMobile; String get contactEmail; String? get comment;@JsonKey(name: 'siteID') int get siteId; int get totalAmount; String? get brandStr; String get nationality; List<AirhostOrderRoomTypeDataDto> get orderRoomTypeData; List<int> get couponsCounts;
/// Create a copy of AirhostBookingOrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirhostBookingOrderRequestDtoCopyWith<AirhostBookingOrderRequestDto> get copyWith => _$AirhostBookingOrderRequestDtoCopyWithImpl<AirhostBookingOrderRequestDto>(this as AirhostBookingOrderRequestDto, _$identity);

  /// Serializes this AirhostBookingOrderRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirhostBookingOrderRequestDto&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.hotelInfoId, hotelInfoId) || other.hotelInfoId == hotelInfoId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.receiptTitle, receiptTitle) || other.receiptTitle == receiptTitle)&&(identical(other.contactIntlCode, contactIntlCode) || other.contactIntlCode == contactIntlCode)&&(identical(other.contactMobile, contactMobile) || other.contactMobile == contactMobile)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.brandStr, brandStr) || other.brandStr == brandStr)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&const DeepCollectionEquality().equals(other.orderRoomTypeData, orderRoomTypeData)&&const DeepCollectionEquality().equals(other.couponsCounts, couponsCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,checkIn,checkOut,firstName,lastName,lang,hotelInfoId,roomCount,totalCount,receiptTitle,contactIntlCode,contactMobile,contactEmail,comment,siteId,totalAmount,brandStr,nationality,const DeepCollectionEquality().hash(orderRoomTypeData),const DeepCollectionEquality().hash(couponsCounts)]);

@override
String toString() {
  return 'AirhostBookingOrderRequestDto(checkIn: $checkIn, checkOut: $checkOut, firstName: $firstName, lastName: $lastName, lang: $lang, hotelInfoId: $hotelInfoId, roomCount: $roomCount, totalCount: $totalCount, receiptTitle: $receiptTitle, contactIntlCode: $contactIntlCode, contactMobile: $contactMobile, contactEmail: $contactEmail, comment: $comment, siteId: $siteId, totalAmount: $totalAmount, brandStr: $brandStr, nationality: $nationality, orderRoomTypeData: $orderRoomTypeData, couponsCounts: $couponsCounts)';
}


}

/// @nodoc
abstract mixin class $AirhostBookingOrderRequestDtoCopyWith<$Res>  {
  factory $AirhostBookingOrderRequestDtoCopyWith(AirhostBookingOrderRequestDto value, $Res Function(AirhostBookingOrderRequestDto) _then) = _$AirhostBookingOrderRequestDtoCopyWithImpl;
@useResult
$Res call({
 String checkIn, String checkOut, String firstName, String lastName, String lang,@JsonKey(name: 'hotelInfoID') int hotelInfoId, int roomCount, int totalCount, String? receiptTitle, String contactIntlCode, String contactMobile, String contactEmail, String? comment,@JsonKey(name: 'siteID') int siteId, int totalAmount, String? brandStr, String nationality, List<AirhostOrderRoomTypeDataDto> orderRoomTypeData, List<int> couponsCounts
});




}
/// @nodoc
class _$AirhostBookingOrderRequestDtoCopyWithImpl<$Res>
    implements $AirhostBookingOrderRequestDtoCopyWith<$Res> {
  _$AirhostBookingOrderRequestDtoCopyWithImpl(this._self, this._then);

  final AirhostBookingOrderRequestDto _self;
  final $Res Function(AirhostBookingOrderRequestDto) _then;

/// Create a copy of AirhostBookingOrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkIn = null,Object? checkOut = null,Object? firstName = null,Object? lastName = null,Object? lang = null,Object? hotelInfoId = null,Object? roomCount = null,Object? totalCount = null,Object? receiptTitle = freezed,Object? contactIntlCode = null,Object? contactMobile = null,Object? contactEmail = null,Object? comment = freezed,Object? siteId = null,Object? totalAmount = null,Object? brandStr = freezed,Object? nationality = null,Object? orderRoomTypeData = null,Object? couponsCounts = null,}) {
  return _then(_self.copyWith(
checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,hotelInfoId: null == hotelInfoId ? _self.hotelInfoId : hotelInfoId // ignore: cast_nullable_to_non_nullable
as int,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,receiptTitle: freezed == receiptTitle ? _self.receiptTitle : receiptTitle // ignore: cast_nullable_to_non_nullable
as String?,contactIntlCode: null == contactIntlCode ? _self.contactIntlCode : contactIntlCode // ignore: cast_nullable_to_non_nullable
as String,contactMobile: null == contactMobile ? _self.contactMobile : contactMobile // ignore: cast_nullable_to_non_nullable
as String,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,siteId: null == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,brandStr: freezed == brandStr ? _self.brandStr : brandStr // ignore: cast_nullable_to_non_nullable
as String?,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,orderRoomTypeData: null == orderRoomTypeData ? _self.orderRoomTypeData : orderRoomTypeData // ignore: cast_nullable_to_non_nullable
as List<AirhostOrderRoomTypeDataDto>,couponsCounts: null == couponsCounts ? _self.couponsCounts : couponsCounts // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [AirhostBookingOrderRequestDto].
extension AirhostBookingOrderRequestDtoPatterns on AirhostBookingOrderRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AirhostBookingOrderRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AirhostBookingOrderRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AirhostBookingOrderRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _AirhostBookingOrderRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AirhostBookingOrderRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _AirhostBookingOrderRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String checkIn,  String checkOut,  String firstName,  String lastName,  String lang, @JsonKey(name: 'hotelInfoID')  int hotelInfoId,  int roomCount,  int totalCount,  String? receiptTitle,  String contactIntlCode,  String contactMobile,  String contactEmail,  String? comment, @JsonKey(name: 'siteID')  int siteId,  int totalAmount,  String? brandStr,  String nationality,  List<AirhostOrderRoomTypeDataDto> orderRoomTypeData,  List<int> couponsCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AirhostBookingOrderRequestDto() when $default != null:
return $default(_that.checkIn,_that.checkOut,_that.firstName,_that.lastName,_that.lang,_that.hotelInfoId,_that.roomCount,_that.totalCount,_that.receiptTitle,_that.contactIntlCode,_that.contactMobile,_that.contactEmail,_that.comment,_that.siteId,_that.totalAmount,_that.brandStr,_that.nationality,_that.orderRoomTypeData,_that.couponsCounts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String checkIn,  String checkOut,  String firstName,  String lastName,  String lang, @JsonKey(name: 'hotelInfoID')  int hotelInfoId,  int roomCount,  int totalCount,  String? receiptTitle,  String contactIntlCode,  String contactMobile,  String contactEmail,  String? comment, @JsonKey(name: 'siteID')  int siteId,  int totalAmount,  String? brandStr,  String nationality,  List<AirhostOrderRoomTypeDataDto> orderRoomTypeData,  List<int> couponsCounts)  $default,) {final _that = this;
switch (_that) {
case _AirhostBookingOrderRequestDto():
return $default(_that.checkIn,_that.checkOut,_that.firstName,_that.lastName,_that.lang,_that.hotelInfoId,_that.roomCount,_that.totalCount,_that.receiptTitle,_that.contactIntlCode,_that.contactMobile,_that.contactEmail,_that.comment,_that.siteId,_that.totalAmount,_that.brandStr,_that.nationality,_that.orderRoomTypeData,_that.couponsCounts);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String checkIn,  String checkOut,  String firstName,  String lastName,  String lang, @JsonKey(name: 'hotelInfoID')  int hotelInfoId,  int roomCount,  int totalCount,  String? receiptTitle,  String contactIntlCode,  String contactMobile,  String contactEmail,  String? comment, @JsonKey(name: 'siteID')  int siteId,  int totalAmount,  String? brandStr,  String nationality,  List<AirhostOrderRoomTypeDataDto> orderRoomTypeData,  List<int> couponsCounts)?  $default,) {final _that = this;
switch (_that) {
case _AirhostBookingOrderRequestDto() when $default != null:
return $default(_that.checkIn,_that.checkOut,_that.firstName,_that.lastName,_that.lang,_that.hotelInfoId,_that.roomCount,_that.totalCount,_that.receiptTitle,_that.contactIntlCode,_that.contactMobile,_that.contactEmail,_that.comment,_that.siteId,_that.totalAmount,_that.brandStr,_that.nationality,_that.orderRoomTypeData,_that.couponsCounts);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _AirhostBookingOrderRequestDto implements AirhostBookingOrderRequestDto {
  const _AirhostBookingOrderRequestDto({required this.checkIn, required this.checkOut, required this.firstName, required this.lastName, required this.lang, @JsonKey(name: 'hotelInfoID') required this.hotelInfoId, required this.roomCount, required this.totalCount, this.receiptTitle, required this.contactIntlCode, required this.contactMobile, required this.contactEmail, this.comment, @JsonKey(name: 'siteID') required this.siteId, required this.totalAmount, this.brandStr, required this.nationality, final  List<AirhostOrderRoomTypeDataDto> orderRoomTypeData = const <AirhostOrderRoomTypeDataDto>[], final  List<int> couponsCounts = const <int>[]}): _orderRoomTypeData = orderRoomTypeData,_couponsCounts = couponsCounts;
  factory _AirhostBookingOrderRequestDto.fromJson(Map<String, dynamic> json) => _$AirhostBookingOrderRequestDtoFromJson(json);

@override final  String checkIn;
@override final  String checkOut;
@override final  String firstName;
@override final  String lastName;
@override final  String lang;
@override@JsonKey(name: 'hotelInfoID') final  int hotelInfoId;
@override final  int roomCount;
@override final  int totalCount;
@override final  String? receiptTitle;
@override final  String contactIntlCode;
@override final  String contactMobile;
@override final  String contactEmail;
@override final  String? comment;
@override@JsonKey(name: 'siteID') final  int siteId;
@override final  int totalAmount;
@override final  String? brandStr;
@override final  String nationality;
 final  List<AirhostOrderRoomTypeDataDto> _orderRoomTypeData;
@override@JsonKey() List<AirhostOrderRoomTypeDataDto> get orderRoomTypeData {
  if (_orderRoomTypeData is EqualUnmodifiableListView) return _orderRoomTypeData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orderRoomTypeData);
}

 final  List<int> _couponsCounts;
@override@JsonKey() List<int> get couponsCounts {
  if (_couponsCounts is EqualUnmodifiableListView) return _couponsCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_couponsCounts);
}


/// Create a copy of AirhostBookingOrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AirhostBookingOrderRequestDtoCopyWith<_AirhostBookingOrderRequestDto> get copyWith => __$AirhostBookingOrderRequestDtoCopyWithImpl<_AirhostBookingOrderRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AirhostBookingOrderRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AirhostBookingOrderRequestDto&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.hotelInfoId, hotelInfoId) || other.hotelInfoId == hotelInfoId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.receiptTitle, receiptTitle) || other.receiptTitle == receiptTitle)&&(identical(other.contactIntlCode, contactIntlCode) || other.contactIntlCode == contactIntlCode)&&(identical(other.contactMobile, contactMobile) || other.contactMobile == contactMobile)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.brandStr, brandStr) || other.brandStr == brandStr)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&const DeepCollectionEquality().equals(other._orderRoomTypeData, _orderRoomTypeData)&&const DeepCollectionEquality().equals(other._couponsCounts, _couponsCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,checkIn,checkOut,firstName,lastName,lang,hotelInfoId,roomCount,totalCount,receiptTitle,contactIntlCode,contactMobile,contactEmail,comment,siteId,totalAmount,brandStr,nationality,const DeepCollectionEquality().hash(_orderRoomTypeData),const DeepCollectionEquality().hash(_couponsCounts)]);

@override
String toString() {
  return 'AirhostBookingOrderRequestDto(checkIn: $checkIn, checkOut: $checkOut, firstName: $firstName, lastName: $lastName, lang: $lang, hotelInfoId: $hotelInfoId, roomCount: $roomCount, totalCount: $totalCount, receiptTitle: $receiptTitle, contactIntlCode: $contactIntlCode, contactMobile: $contactMobile, contactEmail: $contactEmail, comment: $comment, siteId: $siteId, totalAmount: $totalAmount, brandStr: $brandStr, nationality: $nationality, orderRoomTypeData: $orderRoomTypeData, couponsCounts: $couponsCounts)';
}


}

/// @nodoc
abstract mixin class _$AirhostBookingOrderRequestDtoCopyWith<$Res> implements $AirhostBookingOrderRequestDtoCopyWith<$Res> {
  factory _$AirhostBookingOrderRequestDtoCopyWith(_AirhostBookingOrderRequestDto value, $Res Function(_AirhostBookingOrderRequestDto) _then) = __$AirhostBookingOrderRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String checkIn, String checkOut, String firstName, String lastName, String lang,@JsonKey(name: 'hotelInfoID') int hotelInfoId, int roomCount, int totalCount, String? receiptTitle, String contactIntlCode, String contactMobile, String contactEmail, String? comment,@JsonKey(name: 'siteID') int siteId, int totalAmount, String? brandStr, String nationality, List<AirhostOrderRoomTypeDataDto> orderRoomTypeData, List<int> couponsCounts
});




}
/// @nodoc
class __$AirhostBookingOrderRequestDtoCopyWithImpl<$Res>
    implements _$AirhostBookingOrderRequestDtoCopyWith<$Res> {
  __$AirhostBookingOrderRequestDtoCopyWithImpl(this._self, this._then);

  final _AirhostBookingOrderRequestDto _self;
  final $Res Function(_AirhostBookingOrderRequestDto) _then;

/// Create a copy of AirhostBookingOrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkIn = null,Object? checkOut = null,Object? firstName = null,Object? lastName = null,Object? lang = null,Object? hotelInfoId = null,Object? roomCount = null,Object? totalCount = null,Object? receiptTitle = freezed,Object? contactIntlCode = null,Object? contactMobile = null,Object? contactEmail = null,Object? comment = freezed,Object? siteId = null,Object? totalAmount = null,Object? brandStr = freezed,Object? nationality = null,Object? orderRoomTypeData = null,Object? couponsCounts = null,}) {
  return _then(_AirhostBookingOrderRequestDto(
checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,hotelInfoId: null == hotelInfoId ? _self.hotelInfoId : hotelInfoId // ignore: cast_nullable_to_non_nullable
as int,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,receiptTitle: freezed == receiptTitle ? _self.receiptTitle : receiptTitle // ignore: cast_nullable_to_non_nullable
as String?,contactIntlCode: null == contactIntlCode ? _self.contactIntlCode : contactIntlCode // ignore: cast_nullable_to_non_nullable
as String,contactMobile: null == contactMobile ? _self.contactMobile : contactMobile // ignore: cast_nullable_to_non_nullable
as String,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,siteId: null == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,brandStr: freezed == brandStr ? _self.brandStr : brandStr // ignore: cast_nullable_to_non_nullable
as String?,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,orderRoomTypeData: null == orderRoomTypeData ? _self._orderRoomTypeData : orderRoomTypeData // ignore: cast_nullable_to_non_nullable
as List<AirhostOrderRoomTypeDataDto>,couponsCounts: null == couponsCounts ? _self._couponsCounts : couponsCounts // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$AirhostOrderRoomTypeDataDto {

@JsonKey(name: 'roomTypeID') int get roomTypeId; int get roomCount; List<AirhostOrderRoomCustDto> get roomCusts;
/// Create a copy of AirhostOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirhostOrderRoomTypeDataDtoCopyWith<AirhostOrderRoomTypeDataDto> get copyWith => _$AirhostOrderRoomTypeDataDtoCopyWithImpl<AirhostOrderRoomTypeDataDto>(this as AirhostOrderRoomTypeDataDto, _$identity);

  /// Serializes this AirhostOrderRoomTypeDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirhostOrderRoomTypeDataDto&&(identical(other.roomTypeId, roomTypeId) || other.roomTypeId == roomTypeId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other.roomCusts, roomCusts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomTypeId,roomCount,const DeepCollectionEquality().hash(roomCusts));

@override
String toString() {
  return 'AirhostOrderRoomTypeDataDto(roomTypeId: $roomTypeId, roomCount: $roomCount, roomCusts: $roomCusts)';
}


}

/// @nodoc
abstract mixin class $AirhostOrderRoomTypeDataDtoCopyWith<$Res>  {
  factory $AirhostOrderRoomTypeDataDtoCopyWith(AirhostOrderRoomTypeDataDto value, $Res Function(AirhostOrderRoomTypeDataDto) _then) = _$AirhostOrderRoomTypeDataDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'roomTypeID') int roomTypeId, int roomCount, List<AirhostOrderRoomCustDto> roomCusts
});




}
/// @nodoc
class _$AirhostOrderRoomTypeDataDtoCopyWithImpl<$Res>
    implements $AirhostOrderRoomTypeDataDtoCopyWith<$Res> {
  _$AirhostOrderRoomTypeDataDtoCopyWithImpl(this._self, this._then);

  final AirhostOrderRoomTypeDataDto _self;
  final $Res Function(AirhostOrderRoomTypeDataDto) _then;

/// Create a copy of AirhostOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomTypeId = null,Object? roomCount = null,Object? roomCusts = null,}) {
  return _then(_self.copyWith(
roomTypeId: null == roomTypeId ? _self.roomTypeId : roomTypeId // ignore: cast_nullable_to_non_nullable
as int,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int,roomCusts: null == roomCusts ? _self.roomCusts : roomCusts // ignore: cast_nullable_to_non_nullable
as List<AirhostOrderRoomCustDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [AirhostOrderRoomTypeDataDto].
extension AirhostOrderRoomTypeDataDtoPatterns on AirhostOrderRoomTypeDataDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AirhostOrderRoomTypeDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AirhostOrderRoomTypeDataDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AirhostOrderRoomTypeDataDto value)  $default,){
final _that = this;
switch (_that) {
case _AirhostOrderRoomTypeDataDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AirhostOrderRoomTypeDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _AirhostOrderRoomTypeDataDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'roomTypeID')  int roomTypeId,  int roomCount,  List<AirhostOrderRoomCustDto> roomCusts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AirhostOrderRoomTypeDataDto() when $default != null:
return $default(_that.roomTypeId,_that.roomCount,_that.roomCusts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'roomTypeID')  int roomTypeId,  int roomCount,  List<AirhostOrderRoomCustDto> roomCusts)  $default,) {final _that = this;
switch (_that) {
case _AirhostOrderRoomTypeDataDto():
return $default(_that.roomTypeId,_that.roomCount,_that.roomCusts);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'roomTypeID')  int roomTypeId,  int roomCount,  List<AirhostOrderRoomCustDto> roomCusts)?  $default,) {final _that = this;
switch (_that) {
case _AirhostOrderRoomTypeDataDto() when $default != null:
return $default(_that.roomTypeId,_that.roomCount,_that.roomCusts);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _AirhostOrderRoomTypeDataDto implements AirhostOrderRoomTypeDataDto {
  const _AirhostOrderRoomTypeDataDto({@JsonKey(name: 'roomTypeID') required this.roomTypeId, required this.roomCount, final  List<AirhostOrderRoomCustDto> roomCusts = const <AirhostOrderRoomCustDto>[]}): _roomCusts = roomCusts;
  factory _AirhostOrderRoomTypeDataDto.fromJson(Map<String, dynamic> json) => _$AirhostOrderRoomTypeDataDtoFromJson(json);

@override@JsonKey(name: 'roomTypeID') final  int roomTypeId;
@override final  int roomCount;
 final  List<AirhostOrderRoomCustDto> _roomCusts;
@override@JsonKey() List<AirhostOrderRoomCustDto> get roomCusts {
  if (_roomCusts is EqualUnmodifiableListView) return _roomCusts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomCusts);
}


/// Create a copy of AirhostOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AirhostOrderRoomTypeDataDtoCopyWith<_AirhostOrderRoomTypeDataDto> get copyWith => __$AirhostOrderRoomTypeDataDtoCopyWithImpl<_AirhostOrderRoomTypeDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AirhostOrderRoomTypeDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AirhostOrderRoomTypeDataDto&&(identical(other.roomTypeId, roomTypeId) || other.roomTypeId == roomTypeId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other._roomCusts, _roomCusts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomTypeId,roomCount,const DeepCollectionEquality().hash(_roomCusts));

@override
String toString() {
  return 'AirhostOrderRoomTypeDataDto(roomTypeId: $roomTypeId, roomCount: $roomCount, roomCusts: $roomCusts)';
}


}

/// @nodoc
abstract mixin class _$AirhostOrderRoomTypeDataDtoCopyWith<$Res> implements $AirhostOrderRoomTypeDataDtoCopyWith<$Res> {
  factory _$AirhostOrderRoomTypeDataDtoCopyWith(_AirhostOrderRoomTypeDataDto value, $Res Function(_AirhostOrderRoomTypeDataDto) _then) = __$AirhostOrderRoomTypeDataDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'roomTypeID') int roomTypeId, int roomCount, List<AirhostOrderRoomCustDto> roomCusts
});




}
/// @nodoc
class __$AirhostOrderRoomTypeDataDtoCopyWithImpl<$Res>
    implements _$AirhostOrderRoomTypeDataDtoCopyWith<$Res> {
  __$AirhostOrderRoomTypeDataDtoCopyWithImpl(this._self, this._then);

  final _AirhostOrderRoomTypeDataDto _self;
  final $Res Function(_AirhostOrderRoomTypeDataDto) _then;

/// Create a copy of AirhostOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomTypeId = null,Object? roomCount = null,Object? roomCusts = null,}) {
  return _then(_AirhostOrderRoomTypeDataDto(
roomTypeId: null == roomTypeId ? _self.roomTypeId : roomTypeId // ignore: cast_nullable_to_non_nullable
as int,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int,roomCusts: null == roomCusts ? _self._roomCusts : roomCusts // ignore: cast_nullable_to_non_nullable
as List<AirhostOrderRoomCustDto>,
  ));
}


}


/// @nodoc
mixin _$AirhostOrderRoomCustDto {

 int? get id; String? get firstName; String? get lastName; String? get contactEmail; int? get adultCount; int? get childCount; String? get nationality;
/// Create a copy of AirhostOrderRoomCustDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirhostOrderRoomCustDtoCopyWith<AirhostOrderRoomCustDto> get copyWith => _$AirhostOrderRoomCustDtoCopyWithImpl<AirhostOrderRoomCustDto>(this as AirhostOrderRoomCustDto, _$identity);

  /// Serializes this AirhostOrderRoomCustDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirhostOrderRoomCustDto&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.adultCount, adultCount) || other.adultCount == adultCount)&&(identical(other.childCount, childCount) || other.childCount == childCount)&&(identical(other.nationality, nationality) || other.nationality == nationality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,contactEmail,adultCount,childCount,nationality);

@override
String toString() {
  return 'AirhostOrderRoomCustDto(id: $id, firstName: $firstName, lastName: $lastName, contactEmail: $contactEmail, adultCount: $adultCount, childCount: $childCount, nationality: $nationality)';
}


}

/// @nodoc
abstract mixin class $AirhostOrderRoomCustDtoCopyWith<$Res>  {
  factory $AirhostOrderRoomCustDtoCopyWith(AirhostOrderRoomCustDto value, $Res Function(AirhostOrderRoomCustDto) _then) = _$AirhostOrderRoomCustDtoCopyWithImpl;
@useResult
$Res call({
 int? id, String? firstName, String? lastName, String? contactEmail, int? adultCount, int? childCount, String? nationality
});




}
/// @nodoc
class _$AirhostOrderRoomCustDtoCopyWithImpl<$Res>
    implements $AirhostOrderRoomCustDtoCopyWith<$Res> {
  _$AirhostOrderRoomCustDtoCopyWithImpl(this._self, this._then);

  final AirhostOrderRoomCustDto _self;
  final $Res Function(AirhostOrderRoomCustDto) _then;

/// Create a copy of AirhostOrderRoomCustDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? contactEmail = freezed,Object? adultCount = freezed,Object? childCount = freezed,Object? nationality = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,adultCount: freezed == adultCount ? _self.adultCount : adultCount // ignore: cast_nullable_to_non_nullable
as int?,childCount: freezed == childCount ? _self.childCount : childCount // ignore: cast_nullable_to_non_nullable
as int?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AirhostOrderRoomCustDto].
extension AirhostOrderRoomCustDtoPatterns on AirhostOrderRoomCustDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AirhostOrderRoomCustDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AirhostOrderRoomCustDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AirhostOrderRoomCustDto value)  $default,){
final _that = this;
switch (_that) {
case _AirhostOrderRoomCustDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AirhostOrderRoomCustDto value)?  $default,){
final _that = this;
switch (_that) {
case _AirhostOrderRoomCustDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? firstName,  String? lastName,  String? contactEmail,  int? adultCount,  int? childCount,  String? nationality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AirhostOrderRoomCustDto() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.contactEmail,_that.adultCount,_that.childCount,_that.nationality);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? firstName,  String? lastName,  String? contactEmail,  int? adultCount,  int? childCount,  String? nationality)  $default,) {final _that = this;
switch (_that) {
case _AirhostOrderRoomCustDto():
return $default(_that.id,_that.firstName,_that.lastName,_that.contactEmail,_that.adultCount,_that.childCount,_that.nationality);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? firstName,  String? lastName,  String? contactEmail,  int? adultCount,  int? childCount,  String? nationality)?  $default,) {final _that = this;
switch (_that) {
case _AirhostOrderRoomCustDto() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.contactEmail,_that.adultCount,_that.childCount,_that.nationality);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _AirhostOrderRoomCustDto implements AirhostOrderRoomCustDto {
  const _AirhostOrderRoomCustDto({this.id, this.firstName, this.lastName, this.contactEmail, this.adultCount, this.childCount, this.nationality});
  factory _AirhostOrderRoomCustDto.fromJson(Map<String, dynamic> json) => _$AirhostOrderRoomCustDtoFromJson(json);

@override final  int? id;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? contactEmail;
@override final  int? adultCount;
@override final  int? childCount;
@override final  String? nationality;

/// Create a copy of AirhostOrderRoomCustDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AirhostOrderRoomCustDtoCopyWith<_AirhostOrderRoomCustDto> get copyWith => __$AirhostOrderRoomCustDtoCopyWithImpl<_AirhostOrderRoomCustDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AirhostOrderRoomCustDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AirhostOrderRoomCustDto&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.adultCount, adultCount) || other.adultCount == adultCount)&&(identical(other.childCount, childCount) || other.childCount == childCount)&&(identical(other.nationality, nationality) || other.nationality == nationality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,contactEmail,adultCount,childCount,nationality);

@override
String toString() {
  return 'AirhostOrderRoomCustDto(id: $id, firstName: $firstName, lastName: $lastName, contactEmail: $contactEmail, adultCount: $adultCount, childCount: $childCount, nationality: $nationality)';
}


}

/// @nodoc
abstract mixin class _$AirhostOrderRoomCustDtoCopyWith<$Res> implements $AirhostOrderRoomCustDtoCopyWith<$Res> {
  factory _$AirhostOrderRoomCustDtoCopyWith(_AirhostOrderRoomCustDto value, $Res Function(_AirhostOrderRoomCustDto) _then) = __$AirhostOrderRoomCustDtoCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? firstName, String? lastName, String? contactEmail, int? adultCount, int? childCount, String? nationality
});




}
/// @nodoc
class __$AirhostOrderRoomCustDtoCopyWithImpl<$Res>
    implements _$AirhostOrderRoomCustDtoCopyWith<$Res> {
  __$AirhostOrderRoomCustDtoCopyWithImpl(this._self, this._then);

  final _AirhostOrderRoomCustDto _self;
  final $Res Function(_AirhostOrderRoomCustDto) _then;

/// Create a copy of AirhostOrderRoomCustDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? contactEmail = freezed,Object? adultCount = freezed,Object? childCount = freezed,Object? nationality = freezed,}) {
  return _then(_AirhostOrderRoomCustDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,adultCount: freezed == adultCount ? _self.adultCount : adultCount // ignore: cast_nullable_to_non_nullable
as int?,childCount: freezed == childCount ? _self.childCount : childCount // ignore: cast_nullable_to_non_nullable
as int?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderSendPaymentLinkRequestDto {

 int get id; String get lang; String get email;
/// Create a copy of OrderSendPaymentLinkRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSendPaymentLinkRequestDtoCopyWith<OrderSendPaymentLinkRequestDto> get copyWith => _$OrderSendPaymentLinkRequestDtoCopyWithImpl<OrderSendPaymentLinkRequestDto>(this as OrderSendPaymentLinkRequestDto, _$identity);

  /// Serializes this OrderSendPaymentLinkRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSendPaymentLinkRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lang,email);

@override
String toString() {
  return 'OrderSendPaymentLinkRequestDto(id: $id, lang: $lang, email: $email)';
}


}

/// @nodoc
abstract mixin class $OrderSendPaymentLinkRequestDtoCopyWith<$Res>  {
  factory $OrderSendPaymentLinkRequestDtoCopyWith(OrderSendPaymentLinkRequestDto value, $Res Function(OrderSendPaymentLinkRequestDto) _then) = _$OrderSendPaymentLinkRequestDtoCopyWithImpl;
@useResult
$Res call({
 int id, String lang, String email
});




}
/// @nodoc
class _$OrderSendPaymentLinkRequestDtoCopyWithImpl<$Res>
    implements $OrderSendPaymentLinkRequestDtoCopyWith<$Res> {
  _$OrderSendPaymentLinkRequestDtoCopyWithImpl(this._self, this._then);

  final OrderSendPaymentLinkRequestDto _self;
  final $Res Function(OrderSendPaymentLinkRequestDto) _then;

/// Create a copy of OrderSendPaymentLinkRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lang = null,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderSendPaymentLinkRequestDto].
extension OrderSendPaymentLinkRequestDtoPatterns on OrderSendPaymentLinkRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSendPaymentLinkRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSendPaymentLinkRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSendPaymentLinkRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _OrderSendPaymentLinkRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSendPaymentLinkRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSendPaymentLinkRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String lang,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSendPaymentLinkRequestDto() when $default != null:
return $default(_that.id,_that.lang,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String lang,  String email)  $default,) {final _that = this;
switch (_that) {
case _OrderSendPaymentLinkRequestDto():
return $default(_that.id,_that.lang,_that.email);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String lang,  String email)?  $default,) {final _that = this;
switch (_that) {
case _OrderSendPaymentLinkRequestDto() when $default != null:
return $default(_that.id,_that.lang,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSendPaymentLinkRequestDto implements OrderSendPaymentLinkRequestDto {
  const _OrderSendPaymentLinkRequestDto({required this.id, required this.lang, required this.email});
  factory _OrderSendPaymentLinkRequestDto.fromJson(Map<String, dynamic> json) => _$OrderSendPaymentLinkRequestDtoFromJson(json);

@override final  int id;
@override final  String lang;
@override final  String email;

/// Create a copy of OrderSendPaymentLinkRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSendPaymentLinkRequestDtoCopyWith<_OrderSendPaymentLinkRequestDto> get copyWith => __$OrderSendPaymentLinkRequestDtoCopyWithImpl<_OrderSendPaymentLinkRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSendPaymentLinkRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSendPaymentLinkRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lang,email);

@override
String toString() {
  return 'OrderSendPaymentLinkRequestDto(id: $id, lang: $lang, email: $email)';
}


}

/// @nodoc
abstract mixin class _$OrderSendPaymentLinkRequestDtoCopyWith<$Res> implements $OrderSendPaymentLinkRequestDtoCopyWith<$Res> {
  factory _$OrderSendPaymentLinkRequestDtoCopyWith(_OrderSendPaymentLinkRequestDto value, $Res Function(_OrderSendPaymentLinkRequestDto) _then) = __$OrderSendPaymentLinkRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String lang, String email
});




}
/// @nodoc
class __$OrderSendPaymentLinkRequestDtoCopyWithImpl<$Res>
    implements _$OrderSendPaymentLinkRequestDtoCopyWith<$Res> {
  __$OrderSendPaymentLinkRequestDtoCopyWithImpl(this._self, this._then);

  final _OrderSendPaymentLinkRequestDto _self;
  final $Res Function(_OrderSendPaymentLinkRequestDto) _then;

/// Create a copy of OrderSendPaymentLinkRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lang = null,Object? email = null,}) {
  return _then(_OrderSendPaymentLinkRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HotelBookingCreateParentDto {

 HotelBookingOrderEntityDto get bookingOrderEntity;
/// Create a copy of HotelBookingCreateParentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelBookingCreateParentDtoCopyWith<HotelBookingCreateParentDto> get copyWith => _$HotelBookingCreateParentDtoCopyWithImpl<HotelBookingCreateParentDto>(this as HotelBookingCreateParentDto, _$identity);

  /// Serializes this HotelBookingCreateParentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelBookingCreateParentDto&&(identical(other.bookingOrderEntity, bookingOrderEntity) || other.bookingOrderEntity == bookingOrderEntity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookingOrderEntity);

@override
String toString() {
  return 'HotelBookingCreateParentDto(bookingOrderEntity: $bookingOrderEntity)';
}


}

/// @nodoc
abstract mixin class $HotelBookingCreateParentDtoCopyWith<$Res>  {
  factory $HotelBookingCreateParentDtoCopyWith(HotelBookingCreateParentDto value, $Res Function(HotelBookingCreateParentDto) _then) = _$HotelBookingCreateParentDtoCopyWithImpl;
@useResult
$Res call({
 HotelBookingOrderEntityDto bookingOrderEntity
});


$HotelBookingOrderEntityDtoCopyWith<$Res> get bookingOrderEntity;

}
/// @nodoc
class _$HotelBookingCreateParentDtoCopyWithImpl<$Res>
    implements $HotelBookingCreateParentDtoCopyWith<$Res> {
  _$HotelBookingCreateParentDtoCopyWithImpl(this._self, this._then);

  final HotelBookingCreateParentDto _self;
  final $Res Function(HotelBookingCreateParentDto) _then;

/// Create a copy of HotelBookingCreateParentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingOrderEntity = null,}) {
  return _then(_self.copyWith(
bookingOrderEntity: null == bookingOrderEntity ? _self.bookingOrderEntity : bookingOrderEntity // ignore: cast_nullable_to_non_nullable
as HotelBookingOrderEntityDto,
  ));
}
/// Create a copy of HotelBookingCreateParentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotelBookingOrderEntityDtoCopyWith<$Res> get bookingOrderEntity {
  
  return $HotelBookingOrderEntityDtoCopyWith<$Res>(_self.bookingOrderEntity, (value) {
    return _then(_self.copyWith(bookingOrderEntity: value));
  });
}
}


/// Adds pattern-matching-related methods to [HotelBookingCreateParentDto].
extension HotelBookingCreateParentDtoPatterns on HotelBookingCreateParentDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelBookingCreateParentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelBookingCreateParentDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelBookingCreateParentDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelBookingCreateParentDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelBookingCreateParentDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelBookingCreateParentDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HotelBookingOrderEntityDto bookingOrderEntity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelBookingCreateParentDto() when $default != null:
return $default(_that.bookingOrderEntity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HotelBookingOrderEntityDto bookingOrderEntity)  $default,) {final _that = this;
switch (_that) {
case _HotelBookingCreateParentDto():
return $default(_that.bookingOrderEntity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HotelBookingOrderEntityDto bookingOrderEntity)?  $default,) {final _that = this;
switch (_that) {
case _HotelBookingCreateParentDto() when $default != null:
return $default(_that.bookingOrderEntity);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HotelBookingCreateParentDto implements HotelBookingCreateParentDto {
  const _HotelBookingCreateParentDto({required this.bookingOrderEntity});
  factory _HotelBookingCreateParentDto.fromJson(Map<String, dynamic> json) => _$HotelBookingCreateParentDtoFromJson(json);

@override final  HotelBookingOrderEntityDto bookingOrderEntity;

/// Create a copy of HotelBookingCreateParentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelBookingCreateParentDtoCopyWith<_HotelBookingCreateParentDto> get copyWith => __$HotelBookingCreateParentDtoCopyWithImpl<_HotelBookingCreateParentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelBookingCreateParentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelBookingCreateParentDto&&(identical(other.bookingOrderEntity, bookingOrderEntity) || other.bookingOrderEntity == bookingOrderEntity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookingOrderEntity);

@override
String toString() {
  return 'HotelBookingCreateParentDto(bookingOrderEntity: $bookingOrderEntity)';
}


}

/// @nodoc
abstract mixin class _$HotelBookingCreateParentDtoCopyWith<$Res> implements $HotelBookingCreateParentDtoCopyWith<$Res> {
  factory _$HotelBookingCreateParentDtoCopyWith(_HotelBookingCreateParentDto value, $Res Function(_HotelBookingCreateParentDto) _then) = __$HotelBookingCreateParentDtoCopyWithImpl;
@override @useResult
$Res call({
 HotelBookingOrderEntityDto bookingOrderEntity
});


@override $HotelBookingOrderEntityDtoCopyWith<$Res> get bookingOrderEntity;

}
/// @nodoc
class __$HotelBookingCreateParentDtoCopyWithImpl<$Res>
    implements _$HotelBookingCreateParentDtoCopyWith<$Res> {
  __$HotelBookingCreateParentDtoCopyWithImpl(this._self, this._then);

  final _HotelBookingCreateParentDto _self;
  final $Res Function(_HotelBookingCreateParentDto) _then;

/// Create a copy of HotelBookingCreateParentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingOrderEntity = null,}) {
  return _then(_HotelBookingCreateParentDto(
bookingOrderEntity: null == bookingOrderEntity ? _self.bookingOrderEntity : bookingOrderEntity // ignore: cast_nullable_to_non_nullable
as HotelBookingOrderEntityDto,
  ));
}

/// Create a copy of HotelBookingCreateParentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotelBookingOrderEntityDtoCopyWith<$Res> get bookingOrderEntity {
  
  return $HotelBookingOrderEntityDtoCopyWith<$Res>(_self.bookingOrderEntity, (value) {
    return _then(_self.copyWith(bookingOrderEntity: value));
  });
}
}


/// @nodoc
mixin _$HotelBookingOrderEntityDto {

 String get brandStr; String get adultCount; String get checkIn; String get checkOut; String get bookingDate; String get firstName; String get lastName; String get nationality; String get nationalityText; String get lang;@JsonKey(name: 'hotelInfoID') String get hotelInfoId; String get roomCount; String get totalCount; String get kidsCount; String get infantsCount; String get contactIntlCode; String get contactMobile; String get contactEmail; String? get comment; String? get receiptTitle;@JsonKey(name: 'siteID') String get siteId; List<HotelOrderRoomTypeDataDto> get orderRoomTypeData;
/// Create a copy of HotelBookingOrderEntityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelBookingOrderEntityDtoCopyWith<HotelBookingOrderEntityDto> get copyWith => _$HotelBookingOrderEntityDtoCopyWithImpl<HotelBookingOrderEntityDto>(this as HotelBookingOrderEntityDto, _$identity);

  /// Serializes this HotelBookingOrderEntityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelBookingOrderEntityDto&&(identical(other.brandStr, brandStr) || other.brandStr == brandStr)&&(identical(other.adultCount, adultCount) || other.adultCount == adultCount)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.nationalityText, nationalityText) || other.nationalityText == nationalityText)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.hotelInfoId, hotelInfoId) || other.hotelInfoId == hotelInfoId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.kidsCount, kidsCount) || other.kidsCount == kidsCount)&&(identical(other.infantsCount, infantsCount) || other.infantsCount == infantsCount)&&(identical(other.contactIntlCode, contactIntlCode) || other.contactIntlCode == contactIntlCode)&&(identical(other.contactMobile, contactMobile) || other.contactMobile == contactMobile)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.receiptTitle, receiptTitle) || other.receiptTitle == receiptTitle)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&const DeepCollectionEquality().equals(other.orderRoomTypeData, orderRoomTypeData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,brandStr,adultCount,checkIn,checkOut,bookingDate,firstName,lastName,nationality,nationalityText,lang,hotelInfoId,roomCount,totalCount,kidsCount,infantsCount,contactIntlCode,contactMobile,contactEmail,comment,receiptTitle,siteId,const DeepCollectionEquality().hash(orderRoomTypeData)]);

@override
String toString() {
  return 'HotelBookingOrderEntityDto(brandStr: $brandStr, adultCount: $adultCount, checkIn: $checkIn, checkOut: $checkOut, bookingDate: $bookingDate, firstName: $firstName, lastName: $lastName, nationality: $nationality, nationalityText: $nationalityText, lang: $lang, hotelInfoId: $hotelInfoId, roomCount: $roomCount, totalCount: $totalCount, kidsCount: $kidsCount, infantsCount: $infantsCount, contactIntlCode: $contactIntlCode, contactMobile: $contactMobile, contactEmail: $contactEmail, comment: $comment, receiptTitle: $receiptTitle, siteId: $siteId, orderRoomTypeData: $orderRoomTypeData)';
}


}

/// @nodoc
abstract mixin class $HotelBookingOrderEntityDtoCopyWith<$Res>  {
  factory $HotelBookingOrderEntityDtoCopyWith(HotelBookingOrderEntityDto value, $Res Function(HotelBookingOrderEntityDto) _then) = _$HotelBookingOrderEntityDtoCopyWithImpl;
@useResult
$Res call({
 String brandStr, String adultCount, String checkIn, String checkOut, String bookingDate, String firstName, String lastName, String nationality, String nationalityText, String lang,@JsonKey(name: 'hotelInfoID') String hotelInfoId, String roomCount, String totalCount, String kidsCount, String infantsCount, String contactIntlCode, String contactMobile, String contactEmail, String? comment, String? receiptTitle,@JsonKey(name: 'siteID') String siteId, List<HotelOrderRoomTypeDataDto> orderRoomTypeData
});




}
/// @nodoc
class _$HotelBookingOrderEntityDtoCopyWithImpl<$Res>
    implements $HotelBookingOrderEntityDtoCopyWith<$Res> {
  _$HotelBookingOrderEntityDtoCopyWithImpl(this._self, this._then);

  final HotelBookingOrderEntityDto _self;
  final $Res Function(HotelBookingOrderEntityDto) _then;

/// Create a copy of HotelBookingOrderEntityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brandStr = null,Object? adultCount = null,Object? checkIn = null,Object? checkOut = null,Object? bookingDate = null,Object? firstName = null,Object? lastName = null,Object? nationality = null,Object? nationalityText = null,Object? lang = null,Object? hotelInfoId = null,Object? roomCount = null,Object? totalCount = null,Object? kidsCount = null,Object? infantsCount = null,Object? contactIntlCode = null,Object? contactMobile = null,Object? contactEmail = null,Object? comment = freezed,Object? receiptTitle = freezed,Object? siteId = null,Object? orderRoomTypeData = null,}) {
  return _then(_self.copyWith(
brandStr: null == brandStr ? _self.brandStr : brandStr // ignore: cast_nullable_to_non_nullable
as String,adultCount: null == adultCount ? _self.adultCount : adultCount // ignore: cast_nullable_to_non_nullable
as String,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,nationalityText: null == nationalityText ? _self.nationalityText : nationalityText // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,hotelInfoId: null == hotelInfoId ? _self.hotelInfoId : hotelInfoId // ignore: cast_nullable_to_non_nullable
as String,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as String,kidsCount: null == kidsCount ? _self.kidsCount : kidsCount // ignore: cast_nullable_to_non_nullable
as String,infantsCount: null == infantsCount ? _self.infantsCount : infantsCount // ignore: cast_nullable_to_non_nullable
as String,contactIntlCode: null == contactIntlCode ? _self.contactIntlCode : contactIntlCode // ignore: cast_nullable_to_non_nullable
as String,contactMobile: null == contactMobile ? _self.contactMobile : contactMobile // ignore: cast_nullable_to_non_nullable
as String,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,receiptTitle: freezed == receiptTitle ? _self.receiptTitle : receiptTitle // ignore: cast_nullable_to_non_nullable
as String?,siteId: null == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String,orderRoomTypeData: null == orderRoomTypeData ? _self.orderRoomTypeData : orderRoomTypeData // ignore: cast_nullable_to_non_nullable
as List<HotelOrderRoomTypeDataDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelBookingOrderEntityDto].
extension HotelBookingOrderEntityDtoPatterns on HotelBookingOrderEntityDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelBookingOrderEntityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelBookingOrderEntityDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelBookingOrderEntityDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelBookingOrderEntityDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelBookingOrderEntityDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelBookingOrderEntityDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brandStr,  String adultCount,  String checkIn,  String checkOut,  String bookingDate,  String firstName,  String lastName,  String nationality,  String nationalityText,  String lang, @JsonKey(name: 'hotelInfoID')  String hotelInfoId,  String roomCount,  String totalCount,  String kidsCount,  String infantsCount,  String contactIntlCode,  String contactMobile,  String contactEmail,  String? comment,  String? receiptTitle, @JsonKey(name: 'siteID')  String siteId,  List<HotelOrderRoomTypeDataDto> orderRoomTypeData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelBookingOrderEntityDto() when $default != null:
return $default(_that.brandStr,_that.adultCount,_that.checkIn,_that.checkOut,_that.bookingDate,_that.firstName,_that.lastName,_that.nationality,_that.nationalityText,_that.lang,_that.hotelInfoId,_that.roomCount,_that.totalCount,_that.kidsCount,_that.infantsCount,_that.contactIntlCode,_that.contactMobile,_that.contactEmail,_that.comment,_that.receiptTitle,_that.siteId,_that.orderRoomTypeData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brandStr,  String adultCount,  String checkIn,  String checkOut,  String bookingDate,  String firstName,  String lastName,  String nationality,  String nationalityText,  String lang, @JsonKey(name: 'hotelInfoID')  String hotelInfoId,  String roomCount,  String totalCount,  String kidsCount,  String infantsCount,  String contactIntlCode,  String contactMobile,  String contactEmail,  String? comment,  String? receiptTitle, @JsonKey(name: 'siteID')  String siteId,  List<HotelOrderRoomTypeDataDto> orderRoomTypeData)  $default,) {final _that = this;
switch (_that) {
case _HotelBookingOrderEntityDto():
return $default(_that.brandStr,_that.adultCount,_that.checkIn,_that.checkOut,_that.bookingDate,_that.firstName,_that.lastName,_that.nationality,_that.nationalityText,_that.lang,_that.hotelInfoId,_that.roomCount,_that.totalCount,_that.kidsCount,_that.infantsCount,_that.contactIntlCode,_that.contactMobile,_that.contactEmail,_that.comment,_that.receiptTitle,_that.siteId,_that.orderRoomTypeData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brandStr,  String adultCount,  String checkIn,  String checkOut,  String bookingDate,  String firstName,  String lastName,  String nationality,  String nationalityText,  String lang, @JsonKey(name: 'hotelInfoID')  String hotelInfoId,  String roomCount,  String totalCount,  String kidsCount,  String infantsCount,  String contactIntlCode,  String contactMobile,  String contactEmail,  String? comment,  String? receiptTitle, @JsonKey(name: 'siteID')  String siteId,  List<HotelOrderRoomTypeDataDto> orderRoomTypeData)?  $default,) {final _that = this;
switch (_that) {
case _HotelBookingOrderEntityDto() when $default != null:
return $default(_that.brandStr,_that.adultCount,_that.checkIn,_that.checkOut,_that.bookingDate,_that.firstName,_that.lastName,_that.nationality,_that.nationalityText,_that.lang,_that.hotelInfoId,_that.roomCount,_that.totalCount,_that.kidsCount,_that.infantsCount,_that.contactIntlCode,_that.contactMobile,_that.contactEmail,_that.comment,_that.receiptTitle,_that.siteId,_that.orderRoomTypeData);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _HotelBookingOrderEntityDto implements HotelBookingOrderEntityDto {
  const _HotelBookingOrderEntityDto({this.brandStr = 'glhotel_app', required this.adultCount, required this.checkIn, required this.checkOut, required this.bookingDate, required this.firstName, required this.lastName, required this.nationality, required this.nationalityText, required this.lang, @JsonKey(name: 'hotelInfoID') required this.hotelInfoId, this.roomCount = '1', required this.totalCount, this.kidsCount = '0', this.infantsCount = '0', required this.contactIntlCode, required this.contactMobile, required this.contactEmail, this.comment, this.receiptTitle, @JsonKey(name: 'siteID') this.siteId = '146671713176780822', final  List<HotelOrderRoomTypeDataDto> orderRoomTypeData = const <HotelOrderRoomTypeDataDto>[]}): _orderRoomTypeData = orderRoomTypeData;
  factory _HotelBookingOrderEntityDto.fromJson(Map<String, dynamic> json) => _$HotelBookingOrderEntityDtoFromJson(json);

@override@JsonKey() final  String brandStr;
@override final  String adultCount;
@override final  String checkIn;
@override final  String checkOut;
@override final  String bookingDate;
@override final  String firstName;
@override final  String lastName;
@override final  String nationality;
@override final  String nationalityText;
@override final  String lang;
@override@JsonKey(name: 'hotelInfoID') final  String hotelInfoId;
@override@JsonKey() final  String roomCount;
@override final  String totalCount;
@override@JsonKey() final  String kidsCount;
@override@JsonKey() final  String infantsCount;
@override final  String contactIntlCode;
@override final  String contactMobile;
@override final  String contactEmail;
@override final  String? comment;
@override final  String? receiptTitle;
@override@JsonKey(name: 'siteID') final  String siteId;
 final  List<HotelOrderRoomTypeDataDto> _orderRoomTypeData;
@override@JsonKey() List<HotelOrderRoomTypeDataDto> get orderRoomTypeData {
  if (_orderRoomTypeData is EqualUnmodifiableListView) return _orderRoomTypeData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orderRoomTypeData);
}


/// Create a copy of HotelBookingOrderEntityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelBookingOrderEntityDtoCopyWith<_HotelBookingOrderEntityDto> get copyWith => __$HotelBookingOrderEntityDtoCopyWithImpl<_HotelBookingOrderEntityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelBookingOrderEntityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelBookingOrderEntityDto&&(identical(other.brandStr, brandStr) || other.brandStr == brandStr)&&(identical(other.adultCount, adultCount) || other.adultCount == adultCount)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.nationalityText, nationalityText) || other.nationalityText == nationalityText)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.hotelInfoId, hotelInfoId) || other.hotelInfoId == hotelInfoId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.kidsCount, kidsCount) || other.kidsCount == kidsCount)&&(identical(other.infantsCount, infantsCount) || other.infantsCount == infantsCount)&&(identical(other.contactIntlCode, contactIntlCode) || other.contactIntlCode == contactIntlCode)&&(identical(other.contactMobile, contactMobile) || other.contactMobile == contactMobile)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.receiptTitle, receiptTitle) || other.receiptTitle == receiptTitle)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&const DeepCollectionEquality().equals(other._orderRoomTypeData, _orderRoomTypeData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,brandStr,adultCount,checkIn,checkOut,bookingDate,firstName,lastName,nationality,nationalityText,lang,hotelInfoId,roomCount,totalCount,kidsCount,infantsCount,contactIntlCode,contactMobile,contactEmail,comment,receiptTitle,siteId,const DeepCollectionEquality().hash(_orderRoomTypeData)]);

@override
String toString() {
  return 'HotelBookingOrderEntityDto(brandStr: $brandStr, adultCount: $adultCount, checkIn: $checkIn, checkOut: $checkOut, bookingDate: $bookingDate, firstName: $firstName, lastName: $lastName, nationality: $nationality, nationalityText: $nationalityText, lang: $lang, hotelInfoId: $hotelInfoId, roomCount: $roomCount, totalCount: $totalCount, kidsCount: $kidsCount, infantsCount: $infantsCount, contactIntlCode: $contactIntlCode, contactMobile: $contactMobile, contactEmail: $contactEmail, comment: $comment, receiptTitle: $receiptTitle, siteId: $siteId, orderRoomTypeData: $orderRoomTypeData)';
}


}

/// @nodoc
abstract mixin class _$HotelBookingOrderEntityDtoCopyWith<$Res> implements $HotelBookingOrderEntityDtoCopyWith<$Res> {
  factory _$HotelBookingOrderEntityDtoCopyWith(_HotelBookingOrderEntityDto value, $Res Function(_HotelBookingOrderEntityDto) _then) = __$HotelBookingOrderEntityDtoCopyWithImpl;
@override @useResult
$Res call({
 String brandStr, String adultCount, String checkIn, String checkOut, String bookingDate, String firstName, String lastName, String nationality, String nationalityText, String lang,@JsonKey(name: 'hotelInfoID') String hotelInfoId, String roomCount, String totalCount, String kidsCount, String infantsCount, String contactIntlCode, String contactMobile, String contactEmail, String? comment, String? receiptTitle,@JsonKey(name: 'siteID') String siteId, List<HotelOrderRoomTypeDataDto> orderRoomTypeData
});




}
/// @nodoc
class __$HotelBookingOrderEntityDtoCopyWithImpl<$Res>
    implements _$HotelBookingOrderEntityDtoCopyWith<$Res> {
  __$HotelBookingOrderEntityDtoCopyWithImpl(this._self, this._then);

  final _HotelBookingOrderEntityDto _self;
  final $Res Function(_HotelBookingOrderEntityDto) _then;

/// Create a copy of HotelBookingOrderEntityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brandStr = null,Object? adultCount = null,Object? checkIn = null,Object? checkOut = null,Object? bookingDate = null,Object? firstName = null,Object? lastName = null,Object? nationality = null,Object? nationalityText = null,Object? lang = null,Object? hotelInfoId = null,Object? roomCount = null,Object? totalCount = null,Object? kidsCount = null,Object? infantsCount = null,Object? contactIntlCode = null,Object? contactMobile = null,Object? contactEmail = null,Object? comment = freezed,Object? receiptTitle = freezed,Object? siteId = null,Object? orderRoomTypeData = null,}) {
  return _then(_HotelBookingOrderEntityDto(
brandStr: null == brandStr ? _self.brandStr : brandStr // ignore: cast_nullable_to_non_nullable
as String,adultCount: null == adultCount ? _self.adultCount : adultCount // ignore: cast_nullable_to_non_nullable
as String,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,nationalityText: null == nationalityText ? _self.nationalityText : nationalityText // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,hotelInfoId: null == hotelInfoId ? _self.hotelInfoId : hotelInfoId // ignore: cast_nullable_to_non_nullable
as String,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as String,kidsCount: null == kidsCount ? _self.kidsCount : kidsCount // ignore: cast_nullable_to_non_nullable
as String,infantsCount: null == infantsCount ? _self.infantsCount : infantsCount // ignore: cast_nullable_to_non_nullable
as String,contactIntlCode: null == contactIntlCode ? _self.contactIntlCode : contactIntlCode // ignore: cast_nullable_to_non_nullable
as String,contactMobile: null == contactMobile ? _self.contactMobile : contactMobile // ignore: cast_nullable_to_non_nullable
as String,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,receiptTitle: freezed == receiptTitle ? _self.receiptTitle : receiptTitle // ignore: cast_nullable_to_non_nullable
as String?,siteId: null == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String,orderRoomTypeData: null == orderRoomTypeData ? _self._orderRoomTypeData : orderRoomTypeData // ignore: cast_nullable_to_non_nullable
as List<HotelOrderRoomTypeDataDto>,
  ));
}


}


/// @nodoc
mixin _$HotelOrderRoomTypeDataDto {

@JsonKey(name: 'roomTypeID') String get roomTypeId; int get roomCount; List<String> get roomIds; List<HotelRoomCustomerDto> get roomCusts;
/// Create a copy of HotelOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelOrderRoomTypeDataDtoCopyWith<HotelOrderRoomTypeDataDto> get copyWith => _$HotelOrderRoomTypeDataDtoCopyWithImpl<HotelOrderRoomTypeDataDto>(this as HotelOrderRoomTypeDataDto, _$identity);

  /// Serializes this HotelOrderRoomTypeDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelOrderRoomTypeDataDto&&(identical(other.roomTypeId, roomTypeId) || other.roomTypeId == roomTypeId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other.roomIds, roomIds)&&const DeepCollectionEquality().equals(other.roomCusts, roomCusts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomTypeId,roomCount,const DeepCollectionEquality().hash(roomIds),const DeepCollectionEquality().hash(roomCusts));

@override
String toString() {
  return 'HotelOrderRoomTypeDataDto(roomTypeId: $roomTypeId, roomCount: $roomCount, roomIds: $roomIds, roomCusts: $roomCusts)';
}


}

/// @nodoc
abstract mixin class $HotelOrderRoomTypeDataDtoCopyWith<$Res>  {
  factory $HotelOrderRoomTypeDataDtoCopyWith(HotelOrderRoomTypeDataDto value, $Res Function(HotelOrderRoomTypeDataDto) _then) = _$HotelOrderRoomTypeDataDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'roomTypeID') String roomTypeId, int roomCount, List<String> roomIds, List<HotelRoomCustomerDto> roomCusts
});




}
/// @nodoc
class _$HotelOrderRoomTypeDataDtoCopyWithImpl<$Res>
    implements $HotelOrderRoomTypeDataDtoCopyWith<$Res> {
  _$HotelOrderRoomTypeDataDtoCopyWithImpl(this._self, this._then);

  final HotelOrderRoomTypeDataDto _self;
  final $Res Function(HotelOrderRoomTypeDataDto) _then;

/// Create a copy of HotelOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomTypeId = null,Object? roomCount = null,Object? roomIds = null,Object? roomCusts = null,}) {
  return _then(_self.copyWith(
roomTypeId: null == roomTypeId ? _self.roomTypeId : roomTypeId // ignore: cast_nullable_to_non_nullable
as String,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int,roomIds: null == roomIds ? _self.roomIds : roomIds // ignore: cast_nullable_to_non_nullable
as List<String>,roomCusts: null == roomCusts ? _self.roomCusts : roomCusts // ignore: cast_nullable_to_non_nullable
as List<HotelRoomCustomerDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelOrderRoomTypeDataDto].
extension HotelOrderRoomTypeDataDtoPatterns on HotelOrderRoomTypeDataDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelOrderRoomTypeDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelOrderRoomTypeDataDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelOrderRoomTypeDataDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelOrderRoomTypeDataDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelOrderRoomTypeDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelOrderRoomTypeDataDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'roomTypeID')  String roomTypeId,  int roomCount,  List<String> roomIds,  List<HotelRoomCustomerDto> roomCusts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelOrderRoomTypeDataDto() when $default != null:
return $default(_that.roomTypeId,_that.roomCount,_that.roomIds,_that.roomCusts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'roomTypeID')  String roomTypeId,  int roomCount,  List<String> roomIds,  List<HotelRoomCustomerDto> roomCusts)  $default,) {final _that = this;
switch (_that) {
case _HotelOrderRoomTypeDataDto():
return $default(_that.roomTypeId,_that.roomCount,_that.roomIds,_that.roomCusts);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'roomTypeID')  String roomTypeId,  int roomCount,  List<String> roomIds,  List<HotelRoomCustomerDto> roomCusts)?  $default,) {final _that = this;
switch (_that) {
case _HotelOrderRoomTypeDataDto() when $default != null:
return $default(_that.roomTypeId,_that.roomCount,_that.roomIds,_that.roomCusts);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _HotelOrderRoomTypeDataDto implements HotelOrderRoomTypeDataDto {
  const _HotelOrderRoomTypeDataDto({@JsonKey(name: 'roomTypeID') required this.roomTypeId, required this.roomCount, final  List<String> roomIds = const <String>[], final  List<HotelRoomCustomerDto> roomCusts = const <HotelRoomCustomerDto>[]}): _roomIds = roomIds,_roomCusts = roomCusts;
  factory _HotelOrderRoomTypeDataDto.fromJson(Map<String, dynamic> json) => _$HotelOrderRoomTypeDataDtoFromJson(json);

@override@JsonKey(name: 'roomTypeID') final  String roomTypeId;
@override final  int roomCount;
 final  List<String> _roomIds;
@override@JsonKey() List<String> get roomIds {
  if (_roomIds is EqualUnmodifiableListView) return _roomIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomIds);
}

 final  List<HotelRoomCustomerDto> _roomCusts;
@override@JsonKey() List<HotelRoomCustomerDto> get roomCusts {
  if (_roomCusts is EqualUnmodifiableListView) return _roomCusts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomCusts);
}


/// Create a copy of HotelOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelOrderRoomTypeDataDtoCopyWith<_HotelOrderRoomTypeDataDto> get copyWith => __$HotelOrderRoomTypeDataDtoCopyWithImpl<_HotelOrderRoomTypeDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelOrderRoomTypeDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelOrderRoomTypeDataDto&&(identical(other.roomTypeId, roomTypeId) || other.roomTypeId == roomTypeId)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other._roomIds, _roomIds)&&const DeepCollectionEquality().equals(other._roomCusts, _roomCusts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomTypeId,roomCount,const DeepCollectionEquality().hash(_roomIds),const DeepCollectionEquality().hash(_roomCusts));

@override
String toString() {
  return 'HotelOrderRoomTypeDataDto(roomTypeId: $roomTypeId, roomCount: $roomCount, roomIds: $roomIds, roomCusts: $roomCusts)';
}


}

/// @nodoc
abstract mixin class _$HotelOrderRoomTypeDataDtoCopyWith<$Res> implements $HotelOrderRoomTypeDataDtoCopyWith<$Res> {
  factory _$HotelOrderRoomTypeDataDtoCopyWith(_HotelOrderRoomTypeDataDto value, $Res Function(_HotelOrderRoomTypeDataDto) _then) = __$HotelOrderRoomTypeDataDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'roomTypeID') String roomTypeId, int roomCount, List<String> roomIds, List<HotelRoomCustomerDto> roomCusts
});




}
/// @nodoc
class __$HotelOrderRoomTypeDataDtoCopyWithImpl<$Res>
    implements _$HotelOrderRoomTypeDataDtoCopyWith<$Res> {
  __$HotelOrderRoomTypeDataDtoCopyWithImpl(this._self, this._then);

  final _HotelOrderRoomTypeDataDto _self;
  final $Res Function(_HotelOrderRoomTypeDataDto) _then;

/// Create a copy of HotelOrderRoomTypeDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomTypeId = null,Object? roomCount = null,Object? roomIds = null,Object? roomCusts = null,}) {
  return _then(_HotelOrderRoomTypeDataDto(
roomTypeId: null == roomTypeId ? _self.roomTypeId : roomTypeId // ignore: cast_nullable_to_non_nullable
as String,roomCount: null == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int,roomIds: null == roomIds ? _self._roomIds : roomIds // ignore: cast_nullable_to_non_nullable
as List<String>,roomCusts: null == roomCusts ? _self._roomCusts : roomCusts // ignore: cast_nullable_to_non_nullable
as List<HotelRoomCustomerDto>,
  ));
}


}


/// @nodoc
mixin _$HotelRoomCustomerDto {

 String? get name; String? get firstName; String? get lastName; String? get nationality; String? get nationalityText; String? get email; int get count;
/// Create a copy of HotelRoomCustomerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelRoomCustomerDtoCopyWith<HotelRoomCustomerDto> get copyWith => _$HotelRoomCustomerDtoCopyWithImpl<HotelRoomCustomerDto>(this as HotelRoomCustomerDto, _$identity);

  /// Serializes this HotelRoomCustomerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelRoomCustomerDto&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.nationalityText, nationalityText) || other.nationalityText == nationalityText)&&(identical(other.email, email) || other.email == email)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,firstName,lastName,nationality,nationalityText,email,count);

@override
String toString() {
  return 'HotelRoomCustomerDto(name: $name, firstName: $firstName, lastName: $lastName, nationality: $nationality, nationalityText: $nationalityText, email: $email, count: $count)';
}


}

/// @nodoc
abstract mixin class $HotelRoomCustomerDtoCopyWith<$Res>  {
  factory $HotelRoomCustomerDtoCopyWith(HotelRoomCustomerDto value, $Res Function(HotelRoomCustomerDto) _then) = _$HotelRoomCustomerDtoCopyWithImpl;
@useResult
$Res call({
 String? name, String? firstName, String? lastName, String? nationality, String? nationalityText, String? email, int count
});




}
/// @nodoc
class _$HotelRoomCustomerDtoCopyWithImpl<$Res>
    implements $HotelRoomCustomerDtoCopyWith<$Res> {
  _$HotelRoomCustomerDtoCopyWithImpl(this._self, this._then);

  final HotelRoomCustomerDto _self;
  final $Res Function(HotelRoomCustomerDto) _then;

/// Create a copy of HotelRoomCustomerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? nationality = freezed,Object? nationalityText = freezed,Object? email = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,nationalityText: freezed == nationalityText ? _self.nationalityText : nationalityText // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelRoomCustomerDto].
extension HotelRoomCustomerDtoPatterns on HotelRoomCustomerDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelRoomCustomerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelRoomCustomerDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelRoomCustomerDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelRoomCustomerDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelRoomCustomerDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelRoomCustomerDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? firstName,  String? lastName,  String? nationality,  String? nationalityText,  String? email,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelRoomCustomerDto() when $default != null:
return $default(_that.name,_that.firstName,_that.lastName,_that.nationality,_that.nationalityText,_that.email,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? firstName,  String? lastName,  String? nationality,  String? nationalityText,  String? email,  int count)  $default,) {final _that = this;
switch (_that) {
case _HotelRoomCustomerDto():
return $default(_that.name,_that.firstName,_that.lastName,_that.nationality,_that.nationalityText,_that.email,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? firstName,  String? lastName,  String? nationality,  String? nationalityText,  String? email,  int count)?  $default,) {final _that = this;
switch (_that) {
case _HotelRoomCustomerDto() when $default != null:
return $default(_that.name,_that.firstName,_that.lastName,_that.nationality,_that.nationalityText,_that.email,_that.count);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _HotelRoomCustomerDto implements HotelRoomCustomerDto {
  const _HotelRoomCustomerDto({this.name, this.firstName, this.lastName, this.nationality, this.nationalityText, this.email, required this.count});
  factory _HotelRoomCustomerDto.fromJson(Map<String, dynamic> json) => _$HotelRoomCustomerDtoFromJson(json);

@override final  String? name;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? nationality;
@override final  String? nationalityText;
@override final  String? email;
@override final  int count;

/// Create a copy of HotelRoomCustomerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelRoomCustomerDtoCopyWith<_HotelRoomCustomerDto> get copyWith => __$HotelRoomCustomerDtoCopyWithImpl<_HotelRoomCustomerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelRoomCustomerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelRoomCustomerDto&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.nationalityText, nationalityText) || other.nationalityText == nationalityText)&&(identical(other.email, email) || other.email == email)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,firstName,lastName,nationality,nationalityText,email,count);

@override
String toString() {
  return 'HotelRoomCustomerDto(name: $name, firstName: $firstName, lastName: $lastName, nationality: $nationality, nationalityText: $nationalityText, email: $email, count: $count)';
}


}

/// @nodoc
abstract mixin class _$HotelRoomCustomerDtoCopyWith<$Res> implements $HotelRoomCustomerDtoCopyWith<$Res> {
  factory _$HotelRoomCustomerDtoCopyWith(_HotelRoomCustomerDto value, $Res Function(_HotelRoomCustomerDto) _then) = __$HotelRoomCustomerDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? firstName, String? lastName, String? nationality, String? nationalityText, String? email, int count
});




}
/// @nodoc
class __$HotelRoomCustomerDtoCopyWithImpl<$Res>
    implements _$HotelRoomCustomerDtoCopyWith<$Res> {
  __$HotelRoomCustomerDtoCopyWithImpl(this._self, this._then);

  final _HotelRoomCustomerDto _self;
  final $Res Function(_HotelRoomCustomerDto) _then;

/// Create a copy of HotelRoomCustomerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? nationality = freezed,Object? nationalityText = freezed,Object? email = freezed,Object? count = null,}) {
  return _then(_HotelRoomCustomerDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,nationalityText: freezed == nationalityText ? _self.nationalityText : nationalityText // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HotelOrderListDto {

@JsonKey(name: 'bookingOrderList') List<HotelOrderDto> get orders; int? get count;
/// Create a copy of HotelOrderListDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelOrderListDtoCopyWith<HotelOrderListDto> get copyWith => _$HotelOrderListDtoCopyWithImpl<HotelOrderListDto>(this as HotelOrderListDto, _$identity);

  /// Serializes this HotelOrderListDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelOrderListDto&&const DeepCollectionEquality().equals(other.orders, orders)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(orders),count);

@override
String toString() {
  return 'HotelOrderListDto(orders: $orders, count: $count)';
}


}

/// @nodoc
abstract mixin class $HotelOrderListDtoCopyWith<$Res>  {
  factory $HotelOrderListDtoCopyWith(HotelOrderListDto value, $Res Function(HotelOrderListDto) _then) = _$HotelOrderListDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bookingOrderList') List<HotelOrderDto> orders, int? count
});




}
/// @nodoc
class _$HotelOrderListDtoCopyWithImpl<$Res>
    implements $HotelOrderListDtoCopyWith<$Res> {
  _$HotelOrderListDtoCopyWithImpl(this._self, this._then);

  final HotelOrderListDto _self;
  final $Res Function(HotelOrderListDto) _then;

/// Create a copy of HotelOrderListDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,Object? count = freezed,}) {
  return _then(_self.copyWith(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<HotelOrderDto>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelOrderListDto].
extension HotelOrderListDtoPatterns on HotelOrderListDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelOrderListDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelOrderListDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelOrderListDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelOrderListDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelOrderListDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelOrderListDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookingOrderList')  List<HotelOrderDto> orders,  int? count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelOrderListDto() when $default != null:
return $default(_that.orders,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookingOrderList')  List<HotelOrderDto> orders,  int? count)  $default,) {final _that = this;
switch (_that) {
case _HotelOrderListDto():
return $default(_that.orders,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bookingOrderList')  List<HotelOrderDto> orders,  int? count)?  $default,) {final _that = this;
switch (_that) {
case _HotelOrderListDto() when $default != null:
return $default(_that.orders,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelOrderListDto implements HotelOrderListDto {
  const _HotelOrderListDto({@JsonKey(name: 'bookingOrderList') final  List<HotelOrderDto> orders = const <HotelOrderDto>[], this.count}): _orders = orders;
  factory _HotelOrderListDto.fromJson(Map<String, dynamic> json) => _$HotelOrderListDtoFromJson(json);

 final  List<HotelOrderDto> _orders;
@override@JsonKey(name: 'bookingOrderList') List<HotelOrderDto> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

@override final  int? count;

/// Create a copy of HotelOrderListDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelOrderListDtoCopyWith<_HotelOrderListDto> get copyWith => __$HotelOrderListDtoCopyWithImpl<_HotelOrderListDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelOrderListDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelOrderListDto&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders),count);

@override
String toString() {
  return 'HotelOrderListDto(orders: $orders, count: $count)';
}


}

/// @nodoc
abstract mixin class _$HotelOrderListDtoCopyWith<$Res> implements $HotelOrderListDtoCopyWith<$Res> {
  factory _$HotelOrderListDtoCopyWith(_HotelOrderListDto value, $Res Function(_HotelOrderListDto) _then) = __$HotelOrderListDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bookingOrderList') List<HotelOrderDto> orders, int? count
});




}
/// @nodoc
class __$HotelOrderListDtoCopyWithImpl<$Res>
    implements _$HotelOrderListDtoCopyWith<$Res> {
  __$HotelOrderListDtoCopyWithImpl(this._self, this._then);

  final _HotelOrderListDto _self;
  final $Res Function(_HotelOrderListDto) _then;

/// Create a copy of HotelOrderListDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,Object? count = freezed,}) {
  return _then(_HotelOrderListDto(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<HotelOrderDto>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$HotelOrderDto {

 String get orderId; String? get orderNo; String? get serialNo; String? get hotelName; String? get name; String? get checkIn; String? get checkOut; String? get bookingOrderTime; String? get createdTime; num? get paidAmount; num? get totalAmount; bool? get pay; bool? get refund; Object? get status; int? get roomTypeCount;
/// Create a copy of HotelOrderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelOrderDtoCopyWith<HotelOrderDto> get copyWith => _$HotelOrderDtoCopyWithImpl<HotelOrderDto>(this as HotelOrderDto, _$identity);

  /// Serializes this HotelOrderDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelOrderDto&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&(identical(other.hotelName, hotelName) || other.hotelName == hotelName)&&(identical(other.name, name) || other.name == name)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.bookingOrderTime, bookingOrderTime) || other.bookingOrderTime == bookingOrderTime)&&(identical(other.createdTime, createdTime) || other.createdTime == createdTime)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.pay, pay) || other.pay == pay)&&(identical(other.refund, refund) || other.refund == refund)&&const DeepCollectionEquality().equals(other.status, status)&&(identical(other.roomTypeCount, roomTypeCount) || other.roomTypeCount == roomTypeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,orderNo,serialNo,hotelName,name,checkIn,checkOut,bookingOrderTime,createdTime,paidAmount,totalAmount,pay,refund,const DeepCollectionEquality().hash(status),roomTypeCount);

@override
String toString() {
  return 'HotelOrderDto(orderId: $orderId, orderNo: $orderNo, serialNo: $serialNo, hotelName: $hotelName, name: $name, checkIn: $checkIn, checkOut: $checkOut, bookingOrderTime: $bookingOrderTime, createdTime: $createdTime, paidAmount: $paidAmount, totalAmount: $totalAmount, pay: $pay, refund: $refund, status: $status, roomTypeCount: $roomTypeCount)';
}


}

/// @nodoc
abstract mixin class $HotelOrderDtoCopyWith<$Res>  {
  factory $HotelOrderDtoCopyWith(HotelOrderDto value, $Res Function(HotelOrderDto) _then) = _$HotelOrderDtoCopyWithImpl;
@useResult
$Res call({
 String orderId, String? orderNo, String? serialNo, String? hotelName, String? name, String? checkIn, String? checkOut, String? bookingOrderTime, String? createdTime, num? paidAmount, num? totalAmount, bool? pay, bool? refund, Object? status, int? roomTypeCount
});




}
/// @nodoc
class _$HotelOrderDtoCopyWithImpl<$Res>
    implements $HotelOrderDtoCopyWith<$Res> {
  _$HotelOrderDtoCopyWithImpl(this._self, this._then);

  final HotelOrderDto _self;
  final $Res Function(HotelOrderDto) _then;

/// Create a copy of HotelOrderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? orderNo = freezed,Object? serialNo = freezed,Object? hotelName = freezed,Object? name = freezed,Object? checkIn = freezed,Object? checkOut = freezed,Object? bookingOrderTime = freezed,Object? createdTime = freezed,Object? paidAmount = freezed,Object? totalAmount = freezed,Object? pay = freezed,Object? refund = freezed,Object? status = freezed,Object? roomTypeCount = freezed,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String?,hotelName: freezed == hotelName ? _self.hotelName : hotelName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String?,bookingOrderTime: freezed == bookingOrderTime ? _self.bookingOrderTime : bookingOrderTime // ignore: cast_nullable_to_non_nullable
as String?,createdTime: freezed == createdTime ? _self.createdTime : createdTime // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as num?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num?,pay: freezed == pay ? _self.pay : pay // ignore: cast_nullable_to_non_nullable
as bool?,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as bool?,status: freezed == status ? _self.status : status ,roomTypeCount: freezed == roomTypeCount ? _self.roomTypeCount : roomTypeCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelOrderDto].
extension HotelOrderDtoPatterns on HotelOrderDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelOrderDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelOrderDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelOrderDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelOrderDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelOrderDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelOrderDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String? orderNo,  String? serialNo,  String? hotelName,  String? name,  String? checkIn,  String? checkOut,  String? bookingOrderTime,  String? createdTime,  num? paidAmount,  num? totalAmount,  bool? pay,  bool? refund,  Object? status,  int? roomTypeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelOrderDto() when $default != null:
return $default(_that.orderId,_that.orderNo,_that.serialNo,_that.hotelName,_that.name,_that.checkIn,_that.checkOut,_that.bookingOrderTime,_that.createdTime,_that.paidAmount,_that.totalAmount,_that.pay,_that.refund,_that.status,_that.roomTypeCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String? orderNo,  String? serialNo,  String? hotelName,  String? name,  String? checkIn,  String? checkOut,  String? bookingOrderTime,  String? createdTime,  num? paidAmount,  num? totalAmount,  bool? pay,  bool? refund,  Object? status,  int? roomTypeCount)  $default,) {final _that = this;
switch (_that) {
case _HotelOrderDto():
return $default(_that.orderId,_that.orderNo,_that.serialNo,_that.hotelName,_that.name,_that.checkIn,_that.checkOut,_that.bookingOrderTime,_that.createdTime,_that.paidAmount,_that.totalAmount,_that.pay,_that.refund,_that.status,_that.roomTypeCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String? orderNo,  String? serialNo,  String? hotelName,  String? name,  String? checkIn,  String? checkOut,  String? bookingOrderTime,  String? createdTime,  num? paidAmount,  num? totalAmount,  bool? pay,  bool? refund,  Object? status,  int? roomTypeCount)?  $default,) {final _that = this;
switch (_that) {
case _HotelOrderDto() when $default != null:
return $default(_that.orderId,_that.orderNo,_that.serialNo,_that.hotelName,_that.name,_that.checkIn,_that.checkOut,_that.bookingOrderTime,_that.createdTime,_that.paidAmount,_that.totalAmount,_that.pay,_that.refund,_that.status,_that.roomTypeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelOrderDto implements HotelOrderDto {
  const _HotelOrderDto({this.orderId = '', this.orderNo, this.serialNo, this.hotelName, this.name, this.checkIn, this.checkOut, this.bookingOrderTime, this.createdTime, this.paidAmount, this.totalAmount, this.pay, this.refund, this.status, this.roomTypeCount});
  factory _HotelOrderDto.fromJson(Map<String, dynamic> json) => _$HotelOrderDtoFromJson(json);

@override@JsonKey() final  String orderId;
@override final  String? orderNo;
@override final  String? serialNo;
@override final  String? hotelName;
@override final  String? name;
@override final  String? checkIn;
@override final  String? checkOut;
@override final  String? bookingOrderTime;
@override final  String? createdTime;
@override final  num? paidAmount;
@override final  num? totalAmount;
@override final  bool? pay;
@override final  bool? refund;
@override final  Object? status;
@override final  int? roomTypeCount;

/// Create a copy of HotelOrderDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelOrderDtoCopyWith<_HotelOrderDto> get copyWith => __$HotelOrderDtoCopyWithImpl<_HotelOrderDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelOrderDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelOrderDto&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&(identical(other.hotelName, hotelName) || other.hotelName == hotelName)&&(identical(other.name, name) || other.name == name)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.bookingOrderTime, bookingOrderTime) || other.bookingOrderTime == bookingOrderTime)&&(identical(other.createdTime, createdTime) || other.createdTime == createdTime)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.pay, pay) || other.pay == pay)&&(identical(other.refund, refund) || other.refund == refund)&&const DeepCollectionEquality().equals(other.status, status)&&(identical(other.roomTypeCount, roomTypeCount) || other.roomTypeCount == roomTypeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,orderNo,serialNo,hotelName,name,checkIn,checkOut,bookingOrderTime,createdTime,paidAmount,totalAmount,pay,refund,const DeepCollectionEquality().hash(status),roomTypeCount);

@override
String toString() {
  return 'HotelOrderDto(orderId: $orderId, orderNo: $orderNo, serialNo: $serialNo, hotelName: $hotelName, name: $name, checkIn: $checkIn, checkOut: $checkOut, bookingOrderTime: $bookingOrderTime, createdTime: $createdTime, paidAmount: $paidAmount, totalAmount: $totalAmount, pay: $pay, refund: $refund, status: $status, roomTypeCount: $roomTypeCount)';
}


}

/// @nodoc
abstract mixin class _$HotelOrderDtoCopyWith<$Res> implements $HotelOrderDtoCopyWith<$Res> {
  factory _$HotelOrderDtoCopyWith(_HotelOrderDto value, $Res Function(_HotelOrderDto) _then) = __$HotelOrderDtoCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String? orderNo, String? serialNo, String? hotelName, String? name, String? checkIn, String? checkOut, String? bookingOrderTime, String? createdTime, num? paidAmount, num? totalAmount, bool? pay, bool? refund, Object? status, int? roomTypeCount
});




}
/// @nodoc
class __$HotelOrderDtoCopyWithImpl<$Res>
    implements _$HotelOrderDtoCopyWith<$Res> {
  __$HotelOrderDtoCopyWithImpl(this._self, this._then);

  final _HotelOrderDto _self;
  final $Res Function(_HotelOrderDto) _then;

/// Create a copy of HotelOrderDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderNo = freezed,Object? serialNo = freezed,Object? hotelName = freezed,Object? name = freezed,Object? checkIn = freezed,Object? checkOut = freezed,Object? bookingOrderTime = freezed,Object? createdTime = freezed,Object? paidAmount = freezed,Object? totalAmount = freezed,Object? pay = freezed,Object? refund = freezed,Object? status = freezed,Object? roomTypeCount = freezed,}) {
  return _then(_HotelOrderDto(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String?,hotelName: freezed == hotelName ? _self.hotelName : hotelName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String?,bookingOrderTime: freezed == bookingOrderTime ? _self.bookingOrderTime : bookingOrderTime // ignore: cast_nullable_to_non_nullable
as String?,createdTime: freezed == createdTime ? _self.createdTime : createdTime // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as num?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num?,pay: freezed == pay ? _self.pay : pay // ignore: cast_nullable_to_non_nullable
as bool?,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as bool?,status: freezed == status ? _self.status : status ,roomTypeCount: freezed == roomTypeCount ? _self.roomTypeCount : roomTypeCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$HotelMemberPayInfoDto {

 num? get balance;
/// Create a copy of HotelMemberPayInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelMemberPayInfoDtoCopyWith<HotelMemberPayInfoDto> get copyWith => _$HotelMemberPayInfoDtoCopyWithImpl<HotelMemberPayInfoDto>(this as HotelMemberPayInfoDto, _$identity);

  /// Serializes this HotelMemberPayInfoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelMemberPayInfoDto&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'HotelMemberPayInfoDto(balance: $balance)';
}


}

/// @nodoc
abstract mixin class $HotelMemberPayInfoDtoCopyWith<$Res>  {
  factory $HotelMemberPayInfoDtoCopyWith(HotelMemberPayInfoDto value, $Res Function(HotelMemberPayInfoDto) _then) = _$HotelMemberPayInfoDtoCopyWithImpl;
@useResult
$Res call({
 num? balance
});




}
/// @nodoc
class _$HotelMemberPayInfoDtoCopyWithImpl<$Res>
    implements $HotelMemberPayInfoDtoCopyWith<$Res> {
  _$HotelMemberPayInfoDtoCopyWithImpl(this._self, this._then);

  final HotelMemberPayInfoDto _self;
  final $Res Function(HotelMemberPayInfoDto) _then;

/// Create a copy of HotelMemberPayInfoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = freezed,}) {
  return _then(_self.copyWith(
balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelMemberPayInfoDto].
extension HotelMemberPayInfoDtoPatterns on HotelMemberPayInfoDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelMemberPayInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelMemberPayInfoDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelMemberPayInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelMemberPayInfoDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelMemberPayInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelMemberPayInfoDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelMemberPayInfoDto() when $default != null:
return $default(_that.balance);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? balance)  $default,) {final _that = this;
switch (_that) {
case _HotelMemberPayInfoDto():
return $default(_that.balance);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? balance)?  $default,) {final _that = this;
switch (_that) {
case _HotelMemberPayInfoDto() when $default != null:
return $default(_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelMemberPayInfoDto implements HotelMemberPayInfoDto {
  const _HotelMemberPayInfoDto({this.balance});
  factory _HotelMemberPayInfoDto.fromJson(Map<String, dynamic> json) => _$HotelMemberPayInfoDtoFromJson(json);

@override final  num? balance;

/// Create a copy of HotelMemberPayInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelMemberPayInfoDtoCopyWith<_HotelMemberPayInfoDto> get copyWith => __$HotelMemberPayInfoDtoCopyWithImpl<_HotelMemberPayInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelMemberPayInfoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelMemberPayInfoDto&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'HotelMemberPayInfoDto(balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$HotelMemberPayInfoDtoCopyWith<$Res> implements $HotelMemberPayInfoDtoCopyWith<$Res> {
  factory _$HotelMemberPayInfoDtoCopyWith(_HotelMemberPayInfoDto value, $Res Function(_HotelMemberPayInfoDto) _then) = __$HotelMemberPayInfoDtoCopyWithImpl;
@override @useResult
$Res call({
 num? balance
});




}
/// @nodoc
class __$HotelMemberPayInfoDtoCopyWithImpl<$Res>
    implements _$HotelMemberPayInfoDtoCopyWith<$Res> {
  __$HotelMemberPayInfoDtoCopyWithImpl(this._self, this._then);

  final _HotelMemberPayInfoDto _self;
  final $Res Function(_HotelMemberPayInfoDto) _then;

/// Create a copy of HotelMemberPayInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = freezed,}) {
  return _then(_HotelMemberPayInfoDto(
balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$HotelPaymentResultDto {

 bool? get pay; Map<String, dynamic>? get wechatPay;
/// Create a copy of HotelPaymentResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelPaymentResultDtoCopyWith<HotelPaymentResultDto> get copyWith => _$HotelPaymentResultDtoCopyWithImpl<HotelPaymentResultDto>(this as HotelPaymentResultDto, _$identity);

  /// Serializes this HotelPaymentResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelPaymentResultDto&&(identical(other.pay, pay) || other.pay == pay)&&const DeepCollectionEquality().equals(other.wechatPay, wechatPay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pay,const DeepCollectionEquality().hash(wechatPay));

@override
String toString() {
  return 'HotelPaymentResultDto(pay: $pay, wechatPay: $wechatPay)';
}


}

/// @nodoc
abstract mixin class $HotelPaymentResultDtoCopyWith<$Res>  {
  factory $HotelPaymentResultDtoCopyWith(HotelPaymentResultDto value, $Res Function(HotelPaymentResultDto) _then) = _$HotelPaymentResultDtoCopyWithImpl;
@useResult
$Res call({
 bool? pay, Map<String, dynamic>? wechatPay
});




}
/// @nodoc
class _$HotelPaymentResultDtoCopyWithImpl<$Res>
    implements $HotelPaymentResultDtoCopyWith<$Res> {
  _$HotelPaymentResultDtoCopyWithImpl(this._self, this._then);

  final HotelPaymentResultDto _self;
  final $Res Function(HotelPaymentResultDto) _then;

/// Create a copy of HotelPaymentResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pay = freezed,Object? wechatPay = freezed,}) {
  return _then(_self.copyWith(
pay: freezed == pay ? _self.pay : pay // ignore: cast_nullable_to_non_nullable
as bool?,wechatPay: freezed == wechatPay ? _self.wechatPay : wechatPay // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelPaymentResultDto].
extension HotelPaymentResultDtoPatterns on HotelPaymentResultDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelPaymentResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelPaymentResultDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelPaymentResultDto value)  $default,){
final _that = this;
switch (_that) {
case _HotelPaymentResultDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelPaymentResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _HotelPaymentResultDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? pay,  Map<String, dynamic>? wechatPay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelPaymentResultDto() when $default != null:
return $default(_that.pay,_that.wechatPay);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? pay,  Map<String, dynamic>? wechatPay)  $default,) {final _that = this;
switch (_that) {
case _HotelPaymentResultDto():
return $default(_that.pay,_that.wechatPay);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? pay,  Map<String, dynamic>? wechatPay)?  $default,) {final _that = this;
switch (_that) {
case _HotelPaymentResultDto() when $default != null:
return $default(_that.pay,_that.wechatPay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelPaymentResultDto implements HotelPaymentResultDto {
  const _HotelPaymentResultDto({this.pay, final  Map<String, dynamic>? wechatPay}): _wechatPay = wechatPay;
  factory _HotelPaymentResultDto.fromJson(Map<String, dynamic> json) => _$HotelPaymentResultDtoFromJson(json);

@override final  bool? pay;
 final  Map<String, dynamic>? _wechatPay;
@override Map<String, dynamic>? get wechatPay {
  final value = _wechatPay;
  if (value == null) return null;
  if (_wechatPay is EqualUnmodifiableMapView) return _wechatPay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HotelPaymentResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelPaymentResultDtoCopyWith<_HotelPaymentResultDto> get copyWith => __$HotelPaymentResultDtoCopyWithImpl<_HotelPaymentResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelPaymentResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelPaymentResultDto&&(identical(other.pay, pay) || other.pay == pay)&&const DeepCollectionEquality().equals(other._wechatPay, _wechatPay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pay,const DeepCollectionEquality().hash(_wechatPay));

@override
String toString() {
  return 'HotelPaymentResultDto(pay: $pay, wechatPay: $wechatPay)';
}


}

/// @nodoc
abstract mixin class _$HotelPaymentResultDtoCopyWith<$Res> implements $HotelPaymentResultDtoCopyWith<$Res> {
  factory _$HotelPaymentResultDtoCopyWith(_HotelPaymentResultDto value, $Res Function(_HotelPaymentResultDto) _then) = __$HotelPaymentResultDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? pay, Map<String, dynamic>? wechatPay
});




}
/// @nodoc
class __$HotelPaymentResultDtoCopyWithImpl<$Res>
    implements _$HotelPaymentResultDtoCopyWith<$Res> {
  __$HotelPaymentResultDtoCopyWithImpl(this._self, this._then);

  final _HotelPaymentResultDto _self;
  final $Res Function(_HotelPaymentResultDto) _then;

/// Create a copy of HotelPaymentResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pay = freezed,Object? wechatPay = freezed,}) {
  return _then(_HotelPaymentResultDto(
pay: freezed == pay ? _self.pay : pay // ignore: cast_nullable_to_non_nullable
as bool?,wechatPay: freezed == wechatPay ? _self._wechatPay : wechatPay // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$Pay4OrderRequestDto {

@JsonKey(name: 'bookingOrderID') int get bookingOrderId; String get paymentCode; String? get cardNumber; String? get cardExpire; String? get securityCode; String? get cardholderName; String? get cardInfo; String? get lang; bool? get isCheck; String? get system;
/// Create a copy of Pay4OrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Pay4OrderRequestDtoCopyWith<Pay4OrderRequestDto> get copyWith => _$Pay4OrderRequestDtoCopyWithImpl<Pay4OrderRequestDto>(this as Pay4OrderRequestDto, _$identity);

  /// Serializes this Pay4OrderRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pay4OrderRequestDto&&(identical(other.bookingOrderId, bookingOrderId) || other.bookingOrderId == bookingOrderId)&&(identical(other.paymentCode, paymentCode) || other.paymentCode == paymentCode)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardExpire, cardExpire) || other.cardExpire == cardExpire)&&(identical(other.securityCode, securityCode) || other.securityCode == securityCode)&&(identical(other.cardholderName, cardholderName) || other.cardholderName == cardholderName)&&(identical(other.cardInfo, cardInfo) || other.cardInfo == cardInfo)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.isCheck, isCheck) || other.isCheck == isCheck)&&(identical(other.system, system) || other.system == system));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookingOrderId,paymentCode,cardNumber,cardExpire,securityCode,cardholderName,cardInfo,lang,isCheck,system);

@override
String toString() {
  return 'Pay4OrderRequestDto(bookingOrderId: $bookingOrderId, paymentCode: $paymentCode, cardNumber: $cardNumber, cardExpire: $cardExpire, securityCode: $securityCode, cardholderName: $cardholderName, cardInfo: $cardInfo, lang: $lang, isCheck: $isCheck, system: $system)';
}


}

/// @nodoc
abstract mixin class $Pay4OrderRequestDtoCopyWith<$Res>  {
  factory $Pay4OrderRequestDtoCopyWith(Pay4OrderRequestDto value, $Res Function(Pay4OrderRequestDto) _then) = _$Pay4OrderRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bookingOrderID') int bookingOrderId, String paymentCode, String? cardNumber, String? cardExpire, String? securityCode, String? cardholderName, String? cardInfo, String? lang, bool? isCheck, String? system
});




}
/// @nodoc
class _$Pay4OrderRequestDtoCopyWithImpl<$Res>
    implements $Pay4OrderRequestDtoCopyWith<$Res> {
  _$Pay4OrderRequestDtoCopyWithImpl(this._self, this._then);

  final Pay4OrderRequestDto _self;
  final $Res Function(Pay4OrderRequestDto) _then;

/// Create a copy of Pay4OrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingOrderId = null,Object? paymentCode = null,Object? cardNumber = freezed,Object? cardExpire = freezed,Object? securityCode = freezed,Object? cardholderName = freezed,Object? cardInfo = freezed,Object? lang = freezed,Object? isCheck = freezed,Object? system = freezed,}) {
  return _then(_self.copyWith(
bookingOrderId: null == bookingOrderId ? _self.bookingOrderId : bookingOrderId // ignore: cast_nullable_to_non_nullable
as int,paymentCode: null == paymentCode ? _self.paymentCode : paymentCode // ignore: cast_nullable_to_non_nullable
as String,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardExpire: freezed == cardExpire ? _self.cardExpire : cardExpire // ignore: cast_nullable_to_non_nullable
as String?,securityCode: freezed == securityCode ? _self.securityCode : securityCode // ignore: cast_nullable_to_non_nullable
as String?,cardholderName: freezed == cardholderName ? _self.cardholderName : cardholderName // ignore: cast_nullable_to_non_nullable
as String?,cardInfo: freezed == cardInfo ? _self.cardInfo : cardInfo // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,isCheck: freezed == isCheck ? _self.isCheck : isCheck // ignore: cast_nullable_to_non_nullable
as bool?,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Pay4OrderRequestDto].
extension Pay4OrderRequestDtoPatterns on Pay4OrderRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pay4OrderRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pay4OrderRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pay4OrderRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _Pay4OrderRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pay4OrderRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _Pay4OrderRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookingOrderID')  int bookingOrderId,  String paymentCode,  String? cardNumber,  String? cardExpire,  String? securityCode,  String? cardholderName,  String? cardInfo,  String? lang,  bool? isCheck,  String? system)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pay4OrderRequestDto() when $default != null:
return $default(_that.bookingOrderId,_that.paymentCode,_that.cardNumber,_that.cardExpire,_that.securityCode,_that.cardholderName,_that.cardInfo,_that.lang,_that.isCheck,_that.system);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookingOrderID')  int bookingOrderId,  String paymentCode,  String? cardNumber,  String? cardExpire,  String? securityCode,  String? cardholderName,  String? cardInfo,  String? lang,  bool? isCheck,  String? system)  $default,) {final _that = this;
switch (_that) {
case _Pay4OrderRequestDto():
return $default(_that.bookingOrderId,_that.paymentCode,_that.cardNumber,_that.cardExpire,_that.securityCode,_that.cardholderName,_that.cardInfo,_that.lang,_that.isCheck,_that.system);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bookingOrderID')  int bookingOrderId,  String paymentCode,  String? cardNumber,  String? cardExpire,  String? securityCode,  String? cardholderName,  String? cardInfo,  String? lang,  bool? isCheck,  String? system)?  $default,) {final _that = this;
switch (_that) {
case _Pay4OrderRequestDto() when $default != null:
return $default(_that.bookingOrderId,_that.paymentCode,_that.cardNumber,_that.cardExpire,_that.securityCode,_that.cardholderName,_that.cardInfo,_that.lang,_that.isCheck,_that.system);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _Pay4OrderRequestDto implements Pay4OrderRequestDto {
  const _Pay4OrderRequestDto({@JsonKey(name: 'bookingOrderID') required this.bookingOrderId, required this.paymentCode, this.cardNumber, this.cardExpire, this.securityCode, this.cardholderName, this.cardInfo, this.lang, this.isCheck, this.system});
  factory _Pay4OrderRequestDto.fromJson(Map<String, dynamic> json) => _$Pay4OrderRequestDtoFromJson(json);

@override@JsonKey(name: 'bookingOrderID') final  int bookingOrderId;
@override final  String paymentCode;
@override final  String? cardNumber;
@override final  String? cardExpire;
@override final  String? securityCode;
@override final  String? cardholderName;
@override final  String? cardInfo;
@override final  String? lang;
@override final  bool? isCheck;
@override final  String? system;

/// Create a copy of Pay4OrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Pay4OrderRequestDtoCopyWith<_Pay4OrderRequestDto> get copyWith => __$Pay4OrderRequestDtoCopyWithImpl<_Pay4OrderRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Pay4OrderRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pay4OrderRequestDto&&(identical(other.bookingOrderId, bookingOrderId) || other.bookingOrderId == bookingOrderId)&&(identical(other.paymentCode, paymentCode) || other.paymentCode == paymentCode)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardExpire, cardExpire) || other.cardExpire == cardExpire)&&(identical(other.securityCode, securityCode) || other.securityCode == securityCode)&&(identical(other.cardholderName, cardholderName) || other.cardholderName == cardholderName)&&(identical(other.cardInfo, cardInfo) || other.cardInfo == cardInfo)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.isCheck, isCheck) || other.isCheck == isCheck)&&(identical(other.system, system) || other.system == system));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookingOrderId,paymentCode,cardNumber,cardExpire,securityCode,cardholderName,cardInfo,lang,isCheck,system);

@override
String toString() {
  return 'Pay4OrderRequestDto(bookingOrderId: $bookingOrderId, paymentCode: $paymentCode, cardNumber: $cardNumber, cardExpire: $cardExpire, securityCode: $securityCode, cardholderName: $cardholderName, cardInfo: $cardInfo, lang: $lang, isCheck: $isCheck, system: $system)';
}


}

/// @nodoc
abstract mixin class _$Pay4OrderRequestDtoCopyWith<$Res> implements $Pay4OrderRequestDtoCopyWith<$Res> {
  factory _$Pay4OrderRequestDtoCopyWith(_Pay4OrderRequestDto value, $Res Function(_Pay4OrderRequestDto) _then) = __$Pay4OrderRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bookingOrderID') int bookingOrderId, String paymentCode, String? cardNumber, String? cardExpire, String? securityCode, String? cardholderName, String? cardInfo, String? lang, bool? isCheck, String? system
});




}
/// @nodoc
class __$Pay4OrderRequestDtoCopyWithImpl<$Res>
    implements _$Pay4OrderRequestDtoCopyWith<$Res> {
  __$Pay4OrderRequestDtoCopyWithImpl(this._self, this._then);

  final _Pay4OrderRequestDto _self;
  final $Res Function(_Pay4OrderRequestDto) _then;

/// Create a copy of Pay4OrderRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingOrderId = null,Object? paymentCode = null,Object? cardNumber = freezed,Object? cardExpire = freezed,Object? securityCode = freezed,Object? cardholderName = freezed,Object? cardInfo = freezed,Object? lang = freezed,Object? isCheck = freezed,Object? system = freezed,}) {
  return _then(_Pay4OrderRequestDto(
bookingOrderId: null == bookingOrderId ? _self.bookingOrderId : bookingOrderId // ignore: cast_nullable_to_non_nullable
as int,paymentCode: null == paymentCode ? _self.paymentCode : paymentCode // ignore: cast_nullable_to_non_nullable
as String,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardExpire: freezed == cardExpire ? _self.cardExpire : cardExpire // ignore: cast_nullable_to_non_nullable
as String?,securityCode: freezed == securityCode ? _self.securityCode : securityCode // ignore: cast_nullable_to_non_nullable
as String?,cardholderName: freezed == cardholderName ? _self.cardholderName : cardholderName // ignore: cast_nullable_to_non_nullable
as String?,cardInfo: freezed == cardInfo ? _self.cardInfo : cardInfo // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,isCheck: freezed == isCheck ? _self.isCheck : isCheck // ignore: cast_nullable_to_non_nullable
as bool?,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
