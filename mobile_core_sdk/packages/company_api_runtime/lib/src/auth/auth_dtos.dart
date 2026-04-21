import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dtos.freezed.dart';
part 'auth_dtos.g.dart';

@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const AuthSessionDto._();

  const factory AuthSessionDto({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthSessionDto;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(_normalizedSessionJson(json));
}

@freezed
abstract class AuthUserDto with _$AuthUserDto {
  const AuthUserDto._();

  const factory AuthUserDto({
    required String username,
    String? id,
    String? avatar,
    int? userId,
    int? memberId,
    String? accountId,
    String? email,
    String? mobile,
    String? phone,
    int? memberLevel,
    String? intlTelCode,
    String? firstName,
    String? lastName,
    String? firstNameEn,
    String? lastNameEn,
    String? katakana,
    double? taxRadio,
    String? expiredTime,
    String? taxcountry,
    String? nationality,
    String? taxOffice,
    int? sex,
    int? liveJp,
    String? birthday,
    String? zipCode,
    String? address,
    Map<String, dynamic>? bank,
    String? registerTime,
    String? checkEmailTime,
    String? baseinfoTime,
    String? checkBaseinfoTime,
    int? status,
    String? frontUrl,
    String? backUrl,
    String? taxpayerNumber,
    int? taxpayerManageStatus,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(_normalizedUserJson(json));

  static AuthUserDto? tryFromLoginPayload(Map<String, dynamic> json) {
    final dto = AuthUserDto.fromJson(json);
    final hasMeaningfulData =
        dto.username.trim().isNotEmpty ||
        dto.userId != null ||
        dto.memberLevel != null;
    if (!hasMeaningfulData) {
      return null;
    }
    return dto;
  }

  static AuthUserDto? tryFromCurrentUserPayload(Map<String, dynamic> json) {
    final dto = AuthUserDto.fromJson(json);
    final hasMeaningfulData =
        (dto.id?.trim().isNotEmpty ?? false) ||
        dto.memberId != null ||
        dto.userId != null ||
        (dto.accountId?.trim().isNotEmpty ?? false) ||
        (dto.email?.trim().isNotEmpty ?? false) ||
        (dto.phone?.trim().isNotEmpty ?? false) ||
        (dto.mobile?.trim().isNotEmpty ?? false);
    if (!hasMeaningfulData) {
      return null;
    }
    return dto;
  }
}

class AuthMemberLoginIndexDto {
  const AuthMemberLoginIndexDto({
    required this.currentDeviceVerificationStatus,
    required this.email,
    required this.emailAccept,
    required this.emailAuth,
    required this.infoReceiveStatus,
    required this.legalPersonStatus,
    required this.memberLevel,
    required this.mobileAuth,
    required this.ownerId,
    required this.ownerName,
    required this.verificationStatus,
  });

  factory AuthMemberLoginIndexDto.fromJson(Map<String, dynamic> json) {
    return AuthMemberLoginIndexDto(
      currentDeviceVerificationStatus: json['currentDeviceVerificationStatus'],
      email: _normalizedOptionalString(json['email']),
      emailAccept: json['emailAccept'],
      emailAuth: json['emailAuth'],
      infoReceiveStatus: _intOrNull(json['infoReceiveStatus']),
      legalPersonStatus: json['legalPersonStatus'],
      memberLevel: _intOrNull(json['memberLevel']),
      mobileAuth: json['mobileAuth'],
      ownerId: _intOrNull(json['ownerId']),
      ownerName: _normalizedOptionalString(json['ownerName']),
      verificationStatus: json['verificationStatus'],
    );
  }

  final Object? currentDeviceVerificationStatus;
  final String? email;
  final Object? emailAccept;
  final Object? emailAuth;
  final int? infoReceiveStatus;
  final Object? legalPersonStatus;
  final int? memberLevel;
  final Object? mobileAuth;
  final int? ownerId;
  final String? ownerName;
  final Object? verificationStatus;

  bool get isPhoneVerified => _isVerifiedFlag(mobileAuth);
  bool get isEmailVerified => _isVerifiedFlag(emailAuth);
  bool get isRealPersonVerified => _isVerifiedFlag(verificationStatus);
  bool get isCurrentDeviceVerified =>
      _isVerifiedFlag(currentDeviceVerificationStatus);

  static bool _isVerifiedFlag(Object? value) {
    if (value == null) {
      return false;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value.toInt() == 1;
    }
    final normalized = value.toString().trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    if (normalized == 'true') {
      return true;
    }
    return int.tryParse(normalized) == 1;
  }
}

@freezed
abstract class AuthLoginResultDto with _$AuthLoginResultDto {
  const factory AuthLoginResultDto({
    required AuthSessionDto session,
    AuthUserDto? user,
  }) = _AuthLoginResultDto;
}

Map<String, dynamic> _normalizedSessionJson(Map<String, dynamic> json) {
  final accessToken =
      _tokenStringOrNull(json['accessToken']) ??
      _tokenStringOrNull(json['access_token']);
  final refreshToken =
      _tokenStringOrNull(json['refreshToken']) ??
      _tokenStringOrNull(json['refresh_token']);

  if (accessToken == null || refreshToken == null) {
    throw const FormatException('Invalid auth session payload.');
  }

  return <String, dynamic>{
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': _parseExpiresAt(json).toIso8601String(),
  };
}

DateTime _parseExpiresAt(Map<String, dynamic> json) {
  final expiresAt = _dateTimeOrNull(json['expiresAt']);
  if (expiresAt != null) {
    return expiresAt;
  }

  final expiresInValue = _intOrNull(json['expires_in'] ?? json['expiresIn']);
  if (expiresInValue != null) {
    return DateTime.now().toUtc().add(Duration(seconds: expiresInValue));
  }

  return DateTime.now().toUtc().add(const Duration(hours: 4));
}

Map<String, dynamic> _normalizedUserJson(Map<String, dynamic> json) {
  final username =
      _stringOrNull(json['username']) ??
      _stringOrNull(json['usename']) ??
      _stringOrNull(json['email']) ??
      _stringOrNull(json['phone']) ??
      _stringOrNull(json['mobile']) ??
      _stringOrNull(json['accountId']) ??
      _stringOrNull(json['memberId']) ??
      '';
  final phone = _normalizedOptionalString(json['phone']);
  final mobile = _normalizedOptionalString(json['mobile']) ?? phone;
  final normalizedPhone = phone ?? mobile;
  final normalizedUserId =
      _intOrNull(json['userId']) ?? _intOrNull(json['memberId']);
  final normalizedMemberId =
      _intOrNull(json['memberId']) ?? _intOrNull(json['userId']);
  final normalizedEmail =
      _normalizedOptionalString(json['email']) ??
      (_looksLikeEmail(username) ? username.trim() : null);

  return <String, dynamic>{
    'username': username,
    'id': _normalizedOptionalString(json['id']),
    'avatar': _normalizedOptionalString(json['avatar']),
    'userId': normalizedUserId,
    'memberId': normalizedMemberId,
    'accountId': _normalizedOptionalString(json['accountId']),
    'email': normalizedEmail,
    'mobile': mobile,
    'phone': normalizedPhone,
    'memberLevel': _intOrNull(json['memberLevel']),
    'intlTelCode': _normalizedOptionalString(json['intlTelCode']),
    'firstName': _normalizedOptionalString(json['firstName']),
    'lastName': _normalizedOptionalString(json['lastName']),
    'firstNameEn': _normalizedOptionalString(json['firstNameEn']),
    'lastNameEn': _normalizedOptionalString(json['lastNameEn']),
    'katakana': _normalizedOptionalString(json['katakana']),
    'taxRadio': _doubleOrNull(json['taxRadio']),
    'expiredTime': _normalizedOptionalString(json['expiredTime']),
    'taxcountry': _normalizedOptionalString(json['taxcountry']),
    'nationality': _normalizedOptionalString(json['nationality']),
    'taxOffice': _normalizedOptionalString(json['taxOffice']),
    'sex': _intOrNull(json['sex']),
    'liveJp': _intOrNull(json['liveJp']),
    'birthday': _normalizedOptionalString(json['birthday']),
    'zipCode': _normalizedOptionalString(json['zipCode']),
    'address': _normalizedOptionalString(json['address']),
    'bank': _mapOrNull(json['bank']),
    'registerTime': _normalizedOptionalString(json['registerTime']),
    'checkEmailTime': _normalizedOptionalString(json['checkEmailTime']),
    'baseinfoTime': _normalizedOptionalString(json['baseinfoTime']),
    'checkBaseinfoTime': _normalizedOptionalString(json['checkBaseinfoTime']),
    'status': _intOrNull(json['status']),
    'frontUrl': _normalizedOptionalString(json['frontUrl']),
    'backUrl': _normalizedOptionalString(json['backUrl']),
    'taxpayerNumber': _normalizedOptionalString(json['taxpayerNumber']),
    'taxpayerManageStatus': _intOrNull(json['taxpayerManageStatus']),
  };
}

String? _tokenStringOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is! String && value is! num) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.toUtc();
  }

  final text = value.toString().trim();
  if (text.isEmpty) {
    return null;
  }

  try {
    return DateTime.parse(text).toUtc();
  } on FormatException {
    return null;
  }
}

String? _stringOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  final text = value.toString();
  return text.trim().isEmpty ? null : text;
}

String? _normalizedOptionalString(Object? value) {
  final text = _stringOrNull(value);
  if (text == null) {
    return null;
  }
  return text.trim();
}

int? _intOrNull(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}

double? _doubleOrNull(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value == null) {
    return null;
  }
  return double.tryParse(value.toString());
}

Map<String, dynamic>? _mapOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

bool _looksLikeEmail(String value) {
  return value.contains('@') && value.contains('.');
}
