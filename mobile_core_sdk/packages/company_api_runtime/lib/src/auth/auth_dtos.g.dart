// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) =>
    _AuthSessionDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$AuthSessionDtoToJson(_AuthSessionDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) => _AuthUserDto(
  username: json['username'] as String,
  id: json['id'] as String?,
  avatar: json['avatar'] as String?,
  userId: (json['userId'] as num?)?.toInt(),
  memberId: (json['memberId'] as num?)?.toInt(),
  accountId: json['accountId'] as String?,
  email: json['email'] as String?,
  mobile: json['mobile'] as String?,
  phone: json['phone'] as String?,
  memberLevel: (json['memberLevel'] as num?)?.toInt(),
  intlTelCode: json['intlTelCode'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  firstNameEn: json['firstNameEn'] as String?,
  lastNameEn: json['lastNameEn'] as String?,
  katakana: json['katakana'] as String?,
  taxRadio: (json['taxRadio'] as num?)?.toDouble(),
  expiredTime: json['expiredTime'] as String?,
  taxcountry: json['taxcountry'] as String?,
  nationality: json['nationality'] as String?,
  taxOffice: json['taxOffice'] as String?,
  sex: (json['sex'] as num?)?.toInt(),
  liveJp: (json['liveJp'] as num?)?.toInt(),
  birthday: json['birthday'] as String?,
  zipCode: json['zipCode'] as String?,
  address: json['address'] as String?,
  bank: json['bank'] as Map<String, dynamic>?,
  registerTime: json['registerTime'] as String?,
  checkEmailTime: json['checkEmailTime'] as String?,
  baseinfoTime: json['baseinfoTime'] as String?,
  checkBaseinfoTime: json['checkBaseinfoTime'] as String?,
  status: (json['status'] as num?)?.toInt(),
  frontUrl: json['frontUrl'] as String?,
  backUrl: json['backUrl'] as String?,
  taxpayerNumber: json['taxpayerNumber'] as String?,
  taxpayerManageStatus: (json['taxpayerManageStatus'] as num?)?.toInt(),
);

Map<String, dynamic> _$AuthUserDtoToJson(_AuthUserDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
      'avatar': instance.avatar,
      'userId': instance.userId,
      'memberId': instance.memberId,
      'accountId': instance.accountId,
      'email': instance.email,
      'mobile': instance.mobile,
      'phone': instance.phone,
      'memberLevel': instance.memberLevel,
      'intlTelCode': instance.intlTelCode,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'firstNameEn': instance.firstNameEn,
      'lastNameEn': instance.lastNameEn,
      'katakana': instance.katakana,
      'taxRadio': instance.taxRadio,
      'expiredTime': instance.expiredTime,
      'taxcountry': instance.taxcountry,
      'nationality': instance.nationality,
      'taxOffice': instance.taxOffice,
      'sex': instance.sex,
      'liveJp': instance.liveJp,
      'birthday': instance.birthday,
      'zipCode': instance.zipCode,
      'address': instance.address,
      'bank': instance.bank,
      'registerTime': instance.registerTime,
      'checkEmailTime': instance.checkEmailTime,
      'baseinfoTime': instance.baseinfoTime,
      'checkBaseinfoTime': instance.checkBaseinfoTime,
      'status': instance.status,
      'frontUrl': instance.frontUrl,
      'backUrl': instance.backUrl,
      'taxpayerNumber': instance.taxpayerNumber,
      'taxpayerManageStatus': instance.taxpayerManageStatus,
    };
