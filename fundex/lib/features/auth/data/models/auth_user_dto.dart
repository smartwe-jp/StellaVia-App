export 'package:company_api_runtime/company_api_runtime.dart' show AuthUserDto;

import 'package:company_api_runtime/company_api_runtime.dart' show AuthUserDto;

import '../../domain/entities/auth_user.dart';

extension AuthUserDtoMapper on AuthUserDto {
  AuthUser toEntity() {
    return AuthUser(
      username: username,
      id: id,
      avatar: avatar,
      userId: userId,
      memberId: memberId,
      accountId: accountId,
      email: email,
      mobile: mobile,
      phone: phone,
      memberLevel: memberLevel,
      intlTelCode: intlTelCode,
      firstName: firstName,
      lastName: lastName,
      firstNameEn: firstNameEn,
      lastNameEn: lastNameEn,
      katakana: katakana,
      taxRadio: taxRadio,
      expiredTime: expiredTime,
      taxcountry: taxcountry,
      nationality: nationality,
      taxOffice: taxOffice,
      sex: sex,
      liveJp: liveJp,
      birthday: birthday,
      zipCode: zipCode,
      address: address,
      bank: bank == null ? null : Map<String, dynamic>.from(bank!),
      registerTime: registerTime,
      checkEmailTime: checkEmailTime,
      baseinfoTime: baseinfoTime,
      checkBaseinfoTime: checkBaseinfoTime,
      status: status,
      frontUrl: frontUrl,
      backUrl: backUrl,
      taxpayerNumber: taxpayerNumber,
      taxpayerManageStatus: taxpayerManageStatus,
    );
  }
}
