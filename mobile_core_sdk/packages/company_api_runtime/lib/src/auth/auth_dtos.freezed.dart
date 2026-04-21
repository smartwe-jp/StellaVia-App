// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthSessionDto {

 String get accessToken; String get refreshToken; DateTime get expiresAt;
/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionDtoCopyWith<AuthSessionDto> get copyWith => _$AuthSessionDtoCopyWithImpl<AuthSessionDto>(this as AuthSessionDto, _$identity);

  /// Serializes this AuthSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'AuthSessionDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $AuthSessionDtoCopyWith<$Res>  {
  factory $AuthSessionDtoCopyWith(AuthSessionDto value, $Res Function(AuthSessionDto) _then) = _$AuthSessionDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, DateTime expiresAt
});




}
/// @nodoc
class _$AuthSessionDtoCopyWithImpl<$Res>
    implements $AuthSessionDtoCopyWith<$Res> {
  _$AuthSessionDtoCopyWithImpl(this._self, this._then);

  final AuthSessionDto _self;
  final $Res Function(AuthSessionDto) _then;

/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthSessionDto].
extension AuthSessionDtoPatterns on AuthSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSessionDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _AuthSessionDto():
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _AuthSessionDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSessionDto extends AuthSessionDto {
  const _AuthSessionDto({required this.accessToken, required this.refreshToken, required this.expiresAt}): super._();
  factory _AuthSessionDto.fromJson(Map<String, dynamic> json) => _$AuthSessionDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  DateTime expiresAt;

/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSessionDtoCopyWith<_AuthSessionDto> get copyWith => __$AuthSessionDtoCopyWithImpl<_AuthSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSessionDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'AuthSessionDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$AuthSessionDtoCopyWith<$Res> implements $AuthSessionDtoCopyWith<$Res> {
  factory _$AuthSessionDtoCopyWith(_AuthSessionDto value, $Res Function(_AuthSessionDto) _then) = __$AuthSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, DateTime expiresAt
});




}
/// @nodoc
class __$AuthSessionDtoCopyWithImpl<$Res>
    implements _$AuthSessionDtoCopyWith<$Res> {
  __$AuthSessionDtoCopyWithImpl(this._self, this._then);

  final _AuthSessionDto _self;
  final $Res Function(_AuthSessionDto) _then;

/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_AuthSessionDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AuthUserDto {

 String get username; String? get id; String? get avatar; int? get userId; int? get memberId; String? get accountId; String? get email; String? get mobile; String? get phone; int? get memberLevel; String? get intlTelCode; String? get firstName; String? get lastName; String? get firstNameEn; String? get lastNameEn; String? get katakana; double? get taxRadio; String? get expiredTime; String? get taxcountry; String? get nationality; String? get taxOffice; int? get sex; int? get liveJp; String? get birthday; String? get zipCode; String? get address; Map<String, dynamic>? get bank; String? get registerTime; String? get checkEmailTime; String? get baseinfoTime; String? get checkBaseinfoTime; int? get status; String? get frontUrl; String? get backUrl; String? get taxpayerNumber; int? get taxpayerManageStatus;
/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<AuthUserDto> get copyWith => _$AuthUserDtoCopyWithImpl<AuthUserDto>(this as AuthUserDto, _$identity);

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUserDto&&(identical(other.username, username) || other.username == username)&&(identical(other.id, id) || other.id == id)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.memberLevel, memberLevel) || other.memberLevel == memberLevel)&&(identical(other.intlTelCode, intlTelCode) || other.intlTelCode == intlTelCode)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firstNameEn, firstNameEn) || other.firstNameEn == firstNameEn)&&(identical(other.lastNameEn, lastNameEn) || other.lastNameEn == lastNameEn)&&(identical(other.katakana, katakana) || other.katakana == katakana)&&(identical(other.taxRadio, taxRadio) || other.taxRadio == taxRadio)&&(identical(other.expiredTime, expiredTime) || other.expiredTime == expiredTime)&&(identical(other.taxcountry, taxcountry) || other.taxcountry == taxcountry)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.taxOffice, taxOffice) || other.taxOffice == taxOffice)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.liveJp, liveJp) || other.liveJp == liveJp)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.bank, bank)&&(identical(other.registerTime, registerTime) || other.registerTime == registerTime)&&(identical(other.checkEmailTime, checkEmailTime) || other.checkEmailTime == checkEmailTime)&&(identical(other.baseinfoTime, baseinfoTime) || other.baseinfoTime == baseinfoTime)&&(identical(other.checkBaseinfoTime, checkBaseinfoTime) || other.checkBaseinfoTime == checkBaseinfoTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.frontUrl, frontUrl) || other.frontUrl == frontUrl)&&(identical(other.backUrl, backUrl) || other.backUrl == backUrl)&&(identical(other.taxpayerNumber, taxpayerNumber) || other.taxpayerNumber == taxpayerNumber)&&(identical(other.taxpayerManageStatus, taxpayerManageStatus) || other.taxpayerManageStatus == taxpayerManageStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,username,id,avatar,userId,memberId,accountId,email,mobile,phone,memberLevel,intlTelCode,firstName,lastName,firstNameEn,lastNameEn,katakana,taxRadio,expiredTime,taxcountry,nationality,taxOffice,sex,liveJp,birthday,zipCode,address,const DeepCollectionEquality().hash(bank),registerTime,checkEmailTime,baseinfoTime,checkBaseinfoTime,status,frontUrl,backUrl,taxpayerNumber,taxpayerManageStatus]);

@override
String toString() {
  return 'AuthUserDto(username: $username, id: $id, avatar: $avatar, userId: $userId, memberId: $memberId, accountId: $accountId, email: $email, mobile: $mobile, phone: $phone, memberLevel: $memberLevel, intlTelCode: $intlTelCode, firstName: $firstName, lastName: $lastName, firstNameEn: $firstNameEn, lastNameEn: $lastNameEn, katakana: $katakana, taxRadio: $taxRadio, expiredTime: $expiredTime, taxcountry: $taxcountry, nationality: $nationality, taxOffice: $taxOffice, sex: $sex, liveJp: $liveJp, birthday: $birthday, zipCode: $zipCode, address: $address, bank: $bank, registerTime: $registerTime, checkEmailTime: $checkEmailTime, baseinfoTime: $baseinfoTime, checkBaseinfoTime: $checkBaseinfoTime, status: $status, frontUrl: $frontUrl, backUrl: $backUrl, taxpayerNumber: $taxpayerNumber, taxpayerManageStatus: $taxpayerManageStatus)';
}


}

/// @nodoc
abstract mixin class $AuthUserDtoCopyWith<$Res>  {
  factory $AuthUserDtoCopyWith(AuthUserDto value, $Res Function(AuthUserDto) _then) = _$AuthUserDtoCopyWithImpl;
@useResult
$Res call({
 String username, String? id, String? avatar, int? userId, int? memberId, String? accountId, String? email, String? mobile, String? phone, int? memberLevel, String? intlTelCode, String? firstName, String? lastName, String? firstNameEn, String? lastNameEn, String? katakana, double? taxRadio, String? expiredTime, String? taxcountry, String? nationality, String? taxOffice, int? sex, int? liveJp, String? birthday, String? zipCode, String? address, Map<String, dynamic>? bank, String? registerTime, String? checkEmailTime, String? baseinfoTime, String? checkBaseinfoTime, int? status, String? frontUrl, String? backUrl, String? taxpayerNumber, int? taxpayerManageStatus
});




}
/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._self, this._then);

  final AuthUserDto _self;
  final $Res Function(AuthUserDto) _then;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? id = freezed,Object? avatar = freezed,Object? userId = freezed,Object? memberId = freezed,Object? accountId = freezed,Object? email = freezed,Object? mobile = freezed,Object? phone = freezed,Object? memberLevel = freezed,Object? intlTelCode = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? firstNameEn = freezed,Object? lastNameEn = freezed,Object? katakana = freezed,Object? taxRadio = freezed,Object? expiredTime = freezed,Object? taxcountry = freezed,Object? nationality = freezed,Object? taxOffice = freezed,Object? sex = freezed,Object? liveJp = freezed,Object? birthday = freezed,Object? zipCode = freezed,Object? address = freezed,Object? bank = freezed,Object? registerTime = freezed,Object? checkEmailTime = freezed,Object? baseinfoTime = freezed,Object? checkBaseinfoTime = freezed,Object? status = freezed,Object? frontUrl = freezed,Object? backUrl = freezed,Object? taxpayerNumber = freezed,Object? taxpayerManageStatus = freezed,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,memberLevel: freezed == memberLevel ? _self.memberLevel : memberLevel // ignore: cast_nullable_to_non_nullable
as int?,intlTelCode: freezed == intlTelCode ? _self.intlTelCode : intlTelCode // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,firstNameEn: freezed == firstNameEn ? _self.firstNameEn : firstNameEn // ignore: cast_nullable_to_non_nullable
as String?,lastNameEn: freezed == lastNameEn ? _self.lastNameEn : lastNameEn // ignore: cast_nullable_to_non_nullable
as String?,katakana: freezed == katakana ? _self.katakana : katakana // ignore: cast_nullable_to_non_nullable
as String?,taxRadio: freezed == taxRadio ? _self.taxRadio : taxRadio // ignore: cast_nullable_to_non_nullable
as double?,expiredTime: freezed == expiredTime ? _self.expiredTime : expiredTime // ignore: cast_nullable_to_non_nullable
as String?,taxcountry: freezed == taxcountry ? _self.taxcountry : taxcountry // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,taxOffice: freezed == taxOffice ? _self.taxOffice : taxOffice // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as int?,liveJp: freezed == liveJp ? _self.liveJp : liveJp // ignore: cast_nullable_to_non_nullable
as int?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,registerTime: freezed == registerTime ? _self.registerTime : registerTime // ignore: cast_nullable_to_non_nullable
as String?,checkEmailTime: freezed == checkEmailTime ? _self.checkEmailTime : checkEmailTime // ignore: cast_nullable_to_non_nullable
as String?,baseinfoTime: freezed == baseinfoTime ? _self.baseinfoTime : baseinfoTime // ignore: cast_nullable_to_non_nullable
as String?,checkBaseinfoTime: freezed == checkBaseinfoTime ? _self.checkBaseinfoTime : checkBaseinfoTime // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,frontUrl: freezed == frontUrl ? _self.frontUrl : frontUrl // ignore: cast_nullable_to_non_nullable
as String?,backUrl: freezed == backUrl ? _self.backUrl : backUrl // ignore: cast_nullable_to_non_nullable
as String?,taxpayerNumber: freezed == taxpayerNumber ? _self.taxpayerNumber : taxpayerNumber // ignore: cast_nullable_to_non_nullable
as String?,taxpayerManageStatus: freezed == taxpayerManageStatus ? _self.taxpayerManageStatus : taxpayerManageStatus // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUserDto].
extension AuthUserDtoPatterns on AuthUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUserDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String? id,  String? avatar,  int? userId,  int? memberId,  String? accountId,  String? email,  String? mobile,  String? phone,  int? memberLevel,  String? intlTelCode,  String? firstName,  String? lastName,  String? firstNameEn,  String? lastNameEn,  String? katakana,  double? taxRadio,  String? expiredTime,  String? taxcountry,  String? nationality,  String? taxOffice,  int? sex,  int? liveJp,  String? birthday,  String? zipCode,  String? address,  Map<String, dynamic>? bank,  String? registerTime,  String? checkEmailTime,  String? baseinfoTime,  String? checkBaseinfoTime,  int? status,  String? frontUrl,  String? backUrl,  String? taxpayerNumber,  int? taxpayerManageStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
return $default(_that.username,_that.id,_that.avatar,_that.userId,_that.memberId,_that.accountId,_that.email,_that.mobile,_that.phone,_that.memberLevel,_that.intlTelCode,_that.firstName,_that.lastName,_that.firstNameEn,_that.lastNameEn,_that.katakana,_that.taxRadio,_that.expiredTime,_that.taxcountry,_that.nationality,_that.taxOffice,_that.sex,_that.liveJp,_that.birthday,_that.zipCode,_that.address,_that.bank,_that.registerTime,_that.checkEmailTime,_that.baseinfoTime,_that.checkBaseinfoTime,_that.status,_that.frontUrl,_that.backUrl,_that.taxpayerNumber,_that.taxpayerManageStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String? id,  String? avatar,  int? userId,  int? memberId,  String? accountId,  String? email,  String? mobile,  String? phone,  int? memberLevel,  String? intlTelCode,  String? firstName,  String? lastName,  String? firstNameEn,  String? lastNameEn,  String? katakana,  double? taxRadio,  String? expiredTime,  String? taxcountry,  String? nationality,  String? taxOffice,  int? sex,  int? liveJp,  String? birthday,  String? zipCode,  String? address,  Map<String, dynamic>? bank,  String? registerTime,  String? checkEmailTime,  String? baseinfoTime,  String? checkBaseinfoTime,  int? status,  String? frontUrl,  String? backUrl,  String? taxpayerNumber,  int? taxpayerManageStatus)  $default,) {final _that = this;
switch (_that) {
case _AuthUserDto():
return $default(_that.username,_that.id,_that.avatar,_that.userId,_that.memberId,_that.accountId,_that.email,_that.mobile,_that.phone,_that.memberLevel,_that.intlTelCode,_that.firstName,_that.lastName,_that.firstNameEn,_that.lastNameEn,_that.katakana,_that.taxRadio,_that.expiredTime,_that.taxcountry,_that.nationality,_that.taxOffice,_that.sex,_that.liveJp,_that.birthday,_that.zipCode,_that.address,_that.bank,_that.registerTime,_that.checkEmailTime,_that.baseinfoTime,_that.checkBaseinfoTime,_that.status,_that.frontUrl,_that.backUrl,_that.taxpayerNumber,_that.taxpayerManageStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String? id,  String? avatar,  int? userId,  int? memberId,  String? accountId,  String? email,  String? mobile,  String? phone,  int? memberLevel,  String? intlTelCode,  String? firstName,  String? lastName,  String? firstNameEn,  String? lastNameEn,  String? katakana,  double? taxRadio,  String? expiredTime,  String? taxcountry,  String? nationality,  String? taxOffice,  int? sex,  int? liveJp,  String? birthday,  String? zipCode,  String? address,  Map<String, dynamic>? bank,  String? registerTime,  String? checkEmailTime,  String? baseinfoTime,  String? checkBaseinfoTime,  int? status,  String? frontUrl,  String? backUrl,  String? taxpayerNumber,  int? taxpayerManageStatus)?  $default,) {final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
return $default(_that.username,_that.id,_that.avatar,_that.userId,_that.memberId,_that.accountId,_that.email,_that.mobile,_that.phone,_that.memberLevel,_that.intlTelCode,_that.firstName,_that.lastName,_that.firstNameEn,_that.lastNameEn,_that.katakana,_that.taxRadio,_that.expiredTime,_that.taxcountry,_that.nationality,_that.taxOffice,_that.sex,_that.liveJp,_that.birthday,_that.zipCode,_that.address,_that.bank,_that.registerTime,_that.checkEmailTime,_that.baseinfoTime,_that.checkBaseinfoTime,_that.status,_that.frontUrl,_that.backUrl,_that.taxpayerNumber,_that.taxpayerManageStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthUserDto extends AuthUserDto {
  const _AuthUserDto({required this.username, this.id, this.avatar, this.userId, this.memberId, this.accountId, this.email, this.mobile, this.phone, this.memberLevel, this.intlTelCode, this.firstName, this.lastName, this.firstNameEn, this.lastNameEn, this.katakana, this.taxRadio, this.expiredTime, this.taxcountry, this.nationality, this.taxOffice, this.sex, this.liveJp, this.birthday, this.zipCode, this.address, final  Map<String, dynamic>? bank, this.registerTime, this.checkEmailTime, this.baseinfoTime, this.checkBaseinfoTime, this.status, this.frontUrl, this.backUrl, this.taxpayerNumber, this.taxpayerManageStatus}): _bank = bank,super._();
  factory _AuthUserDto.fromJson(Map<String, dynamic> json) => _$AuthUserDtoFromJson(json);

@override final  String username;
@override final  String? id;
@override final  String? avatar;
@override final  int? userId;
@override final  int? memberId;
@override final  String? accountId;
@override final  String? email;
@override final  String? mobile;
@override final  String? phone;
@override final  int? memberLevel;
@override final  String? intlTelCode;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? firstNameEn;
@override final  String? lastNameEn;
@override final  String? katakana;
@override final  double? taxRadio;
@override final  String? expiredTime;
@override final  String? taxcountry;
@override final  String? nationality;
@override final  String? taxOffice;
@override final  int? sex;
@override final  int? liveJp;
@override final  String? birthday;
@override final  String? zipCode;
@override final  String? address;
 final  Map<String, dynamic>? _bank;
@override Map<String, dynamic>? get bank {
  final value = _bank;
  if (value == null) return null;
  if (_bank is EqualUnmodifiableMapView) return _bank;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? registerTime;
@override final  String? checkEmailTime;
@override final  String? baseinfoTime;
@override final  String? checkBaseinfoTime;
@override final  int? status;
@override final  String? frontUrl;
@override final  String? backUrl;
@override final  String? taxpayerNumber;
@override final  int? taxpayerManageStatus;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserDtoCopyWith<_AuthUserDto> get copyWith => __$AuthUserDtoCopyWithImpl<_AuthUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUserDto&&(identical(other.username, username) || other.username == username)&&(identical(other.id, id) || other.id == id)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.memberLevel, memberLevel) || other.memberLevel == memberLevel)&&(identical(other.intlTelCode, intlTelCode) || other.intlTelCode == intlTelCode)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firstNameEn, firstNameEn) || other.firstNameEn == firstNameEn)&&(identical(other.lastNameEn, lastNameEn) || other.lastNameEn == lastNameEn)&&(identical(other.katakana, katakana) || other.katakana == katakana)&&(identical(other.taxRadio, taxRadio) || other.taxRadio == taxRadio)&&(identical(other.expiredTime, expiredTime) || other.expiredTime == expiredTime)&&(identical(other.taxcountry, taxcountry) || other.taxcountry == taxcountry)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.taxOffice, taxOffice) || other.taxOffice == taxOffice)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.liveJp, liveJp) || other.liveJp == liveJp)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other._bank, _bank)&&(identical(other.registerTime, registerTime) || other.registerTime == registerTime)&&(identical(other.checkEmailTime, checkEmailTime) || other.checkEmailTime == checkEmailTime)&&(identical(other.baseinfoTime, baseinfoTime) || other.baseinfoTime == baseinfoTime)&&(identical(other.checkBaseinfoTime, checkBaseinfoTime) || other.checkBaseinfoTime == checkBaseinfoTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.frontUrl, frontUrl) || other.frontUrl == frontUrl)&&(identical(other.backUrl, backUrl) || other.backUrl == backUrl)&&(identical(other.taxpayerNumber, taxpayerNumber) || other.taxpayerNumber == taxpayerNumber)&&(identical(other.taxpayerManageStatus, taxpayerManageStatus) || other.taxpayerManageStatus == taxpayerManageStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,username,id,avatar,userId,memberId,accountId,email,mobile,phone,memberLevel,intlTelCode,firstName,lastName,firstNameEn,lastNameEn,katakana,taxRadio,expiredTime,taxcountry,nationality,taxOffice,sex,liveJp,birthday,zipCode,address,const DeepCollectionEquality().hash(_bank),registerTime,checkEmailTime,baseinfoTime,checkBaseinfoTime,status,frontUrl,backUrl,taxpayerNumber,taxpayerManageStatus]);

@override
String toString() {
  return 'AuthUserDto(username: $username, id: $id, avatar: $avatar, userId: $userId, memberId: $memberId, accountId: $accountId, email: $email, mobile: $mobile, phone: $phone, memberLevel: $memberLevel, intlTelCode: $intlTelCode, firstName: $firstName, lastName: $lastName, firstNameEn: $firstNameEn, lastNameEn: $lastNameEn, katakana: $katakana, taxRadio: $taxRadio, expiredTime: $expiredTime, taxcountry: $taxcountry, nationality: $nationality, taxOffice: $taxOffice, sex: $sex, liveJp: $liveJp, birthday: $birthday, zipCode: $zipCode, address: $address, bank: $bank, registerTime: $registerTime, checkEmailTime: $checkEmailTime, baseinfoTime: $baseinfoTime, checkBaseinfoTime: $checkBaseinfoTime, status: $status, frontUrl: $frontUrl, backUrl: $backUrl, taxpayerNumber: $taxpayerNumber, taxpayerManageStatus: $taxpayerManageStatus)';
}


}

/// @nodoc
abstract mixin class _$AuthUserDtoCopyWith<$Res> implements $AuthUserDtoCopyWith<$Res> {
  factory _$AuthUserDtoCopyWith(_AuthUserDto value, $Res Function(_AuthUserDto) _then) = __$AuthUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String username, String? id, String? avatar, int? userId, int? memberId, String? accountId, String? email, String? mobile, String? phone, int? memberLevel, String? intlTelCode, String? firstName, String? lastName, String? firstNameEn, String? lastNameEn, String? katakana, double? taxRadio, String? expiredTime, String? taxcountry, String? nationality, String? taxOffice, int? sex, int? liveJp, String? birthday, String? zipCode, String? address, Map<String, dynamic>? bank, String? registerTime, String? checkEmailTime, String? baseinfoTime, String? checkBaseinfoTime, int? status, String? frontUrl, String? backUrl, String? taxpayerNumber, int? taxpayerManageStatus
});




}
/// @nodoc
class __$AuthUserDtoCopyWithImpl<$Res>
    implements _$AuthUserDtoCopyWith<$Res> {
  __$AuthUserDtoCopyWithImpl(this._self, this._then);

  final _AuthUserDto _self;
  final $Res Function(_AuthUserDto) _then;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? id = freezed,Object? avatar = freezed,Object? userId = freezed,Object? memberId = freezed,Object? accountId = freezed,Object? email = freezed,Object? mobile = freezed,Object? phone = freezed,Object? memberLevel = freezed,Object? intlTelCode = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? firstNameEn = freezed,Object? lastNameEn = freezed,Object? katakana = freezed,Object? taxRadio = freezed,Object? expiredTime = freezed,Object? taxcountry = freezed,Object? nationality = freezed,Object? taxOffice = freezed,Object? sex = freezed,Object? liveJp = freezed,Object? birthday = freezed,Object? zipCode = freezed,Object? address = freezed,Object? bank = freezed,Object? registerTime = freezed,Object? checkEmailTime = freezed,Object? baseinfoTime = freezed,Object? checkBaseinfoTime = freezed,Object? status = freezed,Object? frontUrl = freezed,Object? backUrl = freezed,Object? taxpayerNumber = freezed,Object? taxpayerManageStatus = freezed,}) {
  return _then(_AuthUserDto(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,memberLevel: freezed == memberLevel ? _self.memberLevel : memberLevel // ignore: cast_nullable_to_non_nullable
as int?,intlTelCode: freezed == intlTelCode ? _self.intlTelCode : intlTelCode // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,firstNameEn: freezed == firstNameEn ? _self.firstNameEn : firstNameEn // ignore: cast_nullable_to_non_nullable
as String?,lastNameEn: freezed == lastNameEn ? _self.lastNameEn : lastNameEn // ignore: cast_nullable_to_non_nullable
as String?,katakana: freezed == katakana ? _self.katakana : katakana // ignore: cast_nullable_to_non_nullable
as String?,taxRadio: freezed == taxRadio ? _self.taxRadio : taxRadio // ignore: cast_nullable_to_non_nullable
as double?,expiredTime: freezed == expiredTime ? _self.expiredTime : expiredTime // ignore: cast_nullable_to_non_nullable
as String?,taxcountry: freezed == taxcountry ? _self.taxcountry : taxcountry // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,taxOffice: freezed == taxOffice ? _self.taxOffice : taxOffice // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as int?,liveJp: freezed == liveJp ? _self.liveJp : liveJp // ignore: cast_nullable_to_non_nullable
as int?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self._bank : bank // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,registerTime: freezed == registerTime ? _self.registerTime : registerTime // ignore: cast_nullable_to_non_nullable
as String?,checkEmailTime: freezed == checkEmailTime ? _self.checkEmailTime : checkEmailTime // ignore: cast_nullable_to_non_nullable
as String?,baseinfoTime: freezed == baseinfoTime ? _self.baseinfoTime : baseinfoTime // ignore: cast_nullable_to_non_nullable
as String?,checkBaseinfoTime: freezed == checkBaseinfoTime ? _self.checkBaseinfoTime : checkBaseinfoTime // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,frontUrl: freezed == frontUrl ? _self.frontUrl : frontUrl // ignore: cast_nullable_to_non_nullable
as String?,backUrl: freezed == backUrl ? _self.backUrl : backUrl // ignore: cast_nullable_to_non_nullable
as String?,taxpayerNumber: freezed == taxpayerNumber ? _self.taxpayerNumber : taxpayerNumber // ignore: cast_nullable_to_non_nullable
as String?,taxpayerManageStatus: freezed == taxpayerManageStatus ? _self.taxpayerManageStatus : taxpayerManageStatus // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$AuthLoginResultDto {

 AuthSessionDto get session; AuthUserDto? get user;
/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthLoginResultDtoCopyWith<AuthLoginResultDto> get copyWith => _$AuthLoginResultDtoCopyWithImpl<AuthLoginResultDto>(this as AuthLoginResultDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoginResultDto&&(identical(other.session, session) || other.session == session)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,session,user);

@override
String toString() {
  return 'AuthLoginResultDto(session: $session, user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthLoginResultDtoCopyWith<$Res>  {
  factory $AuthLoginResultDtoCopyWith(AuthLoginResultDto value, $Res Function(AuthLoginResultDto) _then) = _$AuthLoginResultDtoCopyWithImpl;
@useResult
$Res call({
 AuthSessionDto session, AuthUserDto? user
});


$AuthSessionDtoCopyWith<$Res> get session;$AuthUserDtoCopyWith<$Res>? get user;

}
/// @nodoc
class _$AuthLoginResultDtoCopyWithImpl<$Res>
    implements $AuthLoginResultDtoCopyWith<$Res> {
  _$AuthLoginResultDtoCopyWithImpl(this._self, this._then);

  final AuthLoginResultDto _self;
  final $Res Function(AuthLoginResultDto) _then;

/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? user = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSessionDto,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto?,
  ));
}
/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthSessionDtoCopyWith<$Res> get session {
  
  return $AuthSessionDtoCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthLoginResultDto].
extension AuthLoginResultDtoPatterns on AuthLoginResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthLoginResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthLoginResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthLoginResultDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthLoginResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthLoginResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthLoginResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthSessionDto session,  AuthUserDto? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthLoginResultDto() when $default != null:
return $default(_that.session,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthSessionDto session,  AuthUserDto? user)  $default,) {final _that = this;
switch (_that) {
case _AuthLoginResultDto():
return $default(_that.session,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthSessionDto session,  AuthUserDto? user)?  $default,) {final _that = this;
switch (_that) {
case _AuthLoginResultDto() when $default != null:
return $default(_that.session,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _AuthLoginResultDto implements AuthLoginResultDto {
  const _AuthLoginResultDto({required this.session, this.user});
  

@override final  AuthSessionDto session;
@override final  AuthUserDto? user;

/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthLoginResultDtoCopyWith<_AuthLoginResultDto> get copyWith => __$AuthLoginResultDtoCopyWithImpl<_AuthLoginResultDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthLoginResultDto&&(identical(other.session, session) || other.session == session)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,session,user);

@override
String toString() {
  return 'AuthLoginResultDto(session: $session, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthLoginResultDtoCopyWith<$Res> implements $AuthLoginResultDtoCopyWith<$Res> {
  factory _$AuthLoginResultDtoCopyWith(_AuthLoginResultDto value, $Res Function(_AuthLoginResultDto) _then) = __$AuthLoginResultDtoCopyWithImpl;
@override @useResult
$Res call({
 AuthSessionDto session, AuthUserDto? user
});


@override $AuthSessionDtoCopyWith<$Res> get session;@override $AuthUserDtoCopyWith<$Res>? get user;

}
/// @nodoc
class __$AuthLoginResultDtoCopyWithImpl<$Res>
    implements _$AuthLoginResultDtoCopyWith<$Res> {
  __$AuthLoginResultDtoCopyWithImpl(this._self, this._then);

  final _AuthLoginResultDto _self;
  final $Res Function(_AuthLoginResultDto) _then;

/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? user = freezed,}) {
  return _then(_AuthLoginResultDto(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSessionDto,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto?,
  ));
}

/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthSessionDtoCopyWith<$Res> get session {
  
  return $AuthSessionDtoCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AuthLoginResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
