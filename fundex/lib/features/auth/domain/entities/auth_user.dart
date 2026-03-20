import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String username,
    String? id,
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
  }) = _AuthUser;
}
