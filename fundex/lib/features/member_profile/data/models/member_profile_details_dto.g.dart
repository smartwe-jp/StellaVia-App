// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberProfileDetailsDto _$MemberProfileDetailsDtoFromJson(
  Map<String, dynamic> json,
) => _MemberProfileDetailsDto(
  familyName: json['familyName'] as String? ?? '',
  givenName: json['givenName'] as String? ?? '',
  familyNameKana: json['familyNameKana'] as String? ?? '',
  givenNameKana: json['givenNameKana'] as String? ?? '',
  familyNameEn: json['familyNameEn'] as String? ?? '',
  givenNameEn: json['givenNameEn'] as String? ?? '',
  nameKanji: json['nameKanji'] as String? ?? '',
  katakana: json['katakana'] as String? ?? '',
  address: json['address'] as String? ?? '',
  birthday: json['birthday'] as String?,
  sex: (json['sex'] as num?)?.toInt(),
  taxcountry: json['taxcountry'] as String? ?? '',
  zipCode: json['zipCode'] as String? ?? '',
  prefectureCode: json['prefectureCode'] as String? ?? '',
  cityAddress: json['cityAddress'] as String? ?? '',
  phoneIntlCode: json['phoneIntlCode'] as String? ?? '81',
  phone: json['phone'] as String? ?? '',
  email: json['email'] as String? ?? '',
  occupationCode: json['occupationCode'] as String? ?? '',
  annualIncomeCode: json['annualIncomeCode'] as String? ?? '',
  financialAssetsCode: json['financialAssetsCode'] as String? ?? '',
  investmentExperienceCodes:
      (json['investmentExperienceCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  investmentPurposeCode: json['investmentPurposeCode'] as String? ?? '',
  fundSourceCode: json['fundSourceCode'] as String? ?? '',
  riskToleranceCode: json['riskToleranceCode'] as String? ?? '',
  ekycDocumentType: json['ekycDocumentType'] as String? ?? '',
  idDocumentPhotoPath: json['idDocumentPhotoPath'] as String?,
  idDocumentBackPhotoPath: json['idDocumentBackPhotoPath'] as String?,
  selfiePhotoPath: json['selfiePhotoPath'] as String?,
  bankName: json['bankName'] as String? ?? '',
  branchBankName: json['branchBankName'] as String? ?? '',
  branchBankNumber: json['branchBankNumber'] as String? ?? '',
  bankNumber: json['bankNumber'] as String? ?? '',
  bankAccountType: json['bankAccountType'] as String? ?? '',
  bankAccountOwnerName: json['bankAccountOwnerName'] as String? ?? '',
  bankRegionType: json['bankRegionType'] as String? ?? 'domestic',
  bankAccountOwnerAddress: json['bankAccountOwnerAddress'] as String? ?? '',
  bankAccountOwnerNationality:
      json['bankAccountOwnerNationality'] as String? ?? '',
  bankAccountSwiftCode: json['bankAccountSwiftCode'] as String? ?? '',
  bankCountry: json['bankCountry'] as String? ?? '',
  branchBankAddress: json['branchBankAddress'] as String? ?? '',
  electronicDeliveryConsent:
      json['electronicDeliveryConsent'] as bool? ?? false,
  antiSocialForcesConsent: json['antiSocialForcesConsent'] as bool? ?? false,
  privacyPolicyConsent: json['privacyPolicyConsent'] as bool? ?? false,
  lastEditingStep: (json['lastEditingStep'] as num?)?.toInt() ?? 0,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  lastUpdatedAt: json['lastUpdatedAt'] == null
      ? null
      : DateTime.parse(json['lastUpdatedAt'] as String),
  lastSkippedAt: json['lastSkippedAt'] == null
      ? null
      : DateTime.parse(json['lastSkippedAt'] as String),
);

Map<String, dynamic> _$MemberProfileDetailsDtoToJson(
  _MemberProfileDetailsDto instance,
) => <String, dynamic>{
  'familyName': instance.familyName,
  'givenName': instance.givenName,
  'familyNameKana': instance.familyNameKana,
  'givenNameKana': instance.givenNameKana,
  'familyNameEn': instance.familyNameEn,
  'givenNameEn': instance.givenNameEn,
  'nameKanji': instance.nameKanji,
  'katakana': instance.katakana,
  'address': instance.address,
  'birthday': instance.birthday,
  'sex': instance.sex,
  'taxcountry': instance.taxcountry,
  'zipCode': instance.zipCode,
  'prefectureCode': instance.prefectureCode,
  'cityAddress': instance.cityAddress,
  'phoneIntlCode': instance.phoneIntlCode,
  'phone': instance.phone,
  'email': instance.email,
  'occupationCode': instance.occupationCode,
  'annualIncomeCode': instance.annualIncomeCode,
  'financialAssetsCode': instance.financialAssetsCode,
  'investmentExperienceCodes': instance.investmentExperienceCodes,
  'investmentPurposeCode': instance.investmentPurposeCode,
  'fundSourceCode': instance.fundSourceCode,
  'riskToleranceCode': instance.riskToleranceCode,
  'ekycDocumentType': instance.ekycDocumentType,
  'idDocumentPhotoPath': instance.idDocumentPhotoPath,
  'idDocumentBackPhotoPath': instance.idDocumentBackPhotoPath,
  'selfiePhotoPath': instance.selfiePhotoPath,
  'bankName': instance.bankName,
  'branchBankName': instance.branchBankName,
  'branchBankNumber': instance.branchBankNumber,
  'bankNumber': instance.bankNumber,
  'bankAccountType': instance.bankAccountType,
  'bankAccountOwnerName': instance.bankAccountOwnerName,
  'bankRegionType': instance.bankRegionType,
  'bankAccountOwnerAddress': instance.bankAccountOwnerAddress,
  'bankAccountOwnerNationality': instance.bankAccountOwnerNationality,
  'bankAccountSwiftCode': instance.bankAccountSwiftCode,
  'bankCountry': instance.bankCountry,
  'branchBankAddress': instance.branchBankAddress,
  'electronicDeliveryConsent': instance.electronicDeliveryConsent,
  'antiSocialForcesConsent': instance.antiSocialForcesConsent,
  'privacyPolicyConsent': instance.privacyPolicyConsent,
  'lastEditingStep': instance.lastEditingStep,
  'completedAt': instance.completedAt?.toIso8601String(),
  'lastUpdatedAt': instance.lastUpdatedAt?.toIso8601String(),
  'lastSkippedAt': instance.lastSkippedAt?.toIso8601String(),
};
