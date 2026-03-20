import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_profile_details.freezed.dart';

@freezed
abstract class MemberProfileDetails with _$MemberProfileDetails {
  const MemberProfileDetails._();

  static const int flowStepCount = 6;

  const factory MemberProfileDetails({
    @Default('') String familyName,
    @Default('') String givenName,
    @Default('') String familyNameKana,
    @Default('') String givenNameKana,
    @Default('') String familyNameEn,
    @Default('') String givenNameEn,
    @Default('') String nameKanji,
    @Default('') String katakana,
    @Default('') String address,
    String? birthday,
    @Default('') String zipCode,
    @Default('') String prefectureCode,
    @Default('') String cityAddress,
    @Default('81') String phoneIntlCode,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String occupationCode,
    @Default('') String annualIncomeCode,
    @Default('') String financialAssetsCode,
    @Default(<String>[]) List<String> investmentExperienceCodes,
    @Default('') String investmentPurposeCode,
    @Default('') String fundSourceCode,
    @Default('') String riskToleranceCode,
    @Default('') String ekycDocumentType,
    String? idDocumentPhotoPath,
    String? idDocumentBackPhotoPath,
    String? selfiePhotoPath,
    @Default('') String bankName,
    @Default('') String branchBankName,
    @Default('') String bankNumber,
    @Default('') String bankAccountType,
    @Default('') String bankAccountOwnerName,
    @Default(false) bool electronicDeliveryConsent,
    @Default(false) bool antiSocialForcesConsent,
    @Default(false) bool privacyPolicyConsent,
    @Default(0) int lastEditingStep,
    DateTime? completedAt,
    DateTime? lastUpdatedAt,
    DateTime? lastSkippedAt,
  }) = _MemberProfileDetails;

  bool get isComplete => isEditFlowComplete;

  bool get isEditFlowComplete => completedAt != null || _isFlowComplete;

  int get completedFlowStepCount {
    final List<bool> stepCompletion = <bool>[
      _isBasicInfoStepComplete,
      _isAddressInfoStepComplete,
      _isSuitabilityStepComplete,
      _isEkycStepComplete,
      _isBankAccountStepComplete,
      _isConsentStepComplete,
    ];

    int count = 0;
    for (final isComplete in stepCompletion) {
      if (!isComplete) {
        break;
      }
      count += 1;
    }
    return count;
  }

  int get currentFlowStepIndex => completedFlowStepCount >= flowStepCount
      ? flowStepCount - 1
      : completedFlowStepCount;

  bool get hasAnyInput =>
      familyName.trim().isNotEmpty ||
      givenName.trim().isNotEmpty ||
      familyNameKana.trim().isNotEmpty ||
      givenNameKana.trim().isNotEmpty ||
      familyNameEn.trim().isNotEmpty ||
      givenNameEn.trim().isNotEmpty ||
      nameKanji.trim().isNotEmpty ||
      katakana.trim().isNotEmpty ||
      address.trim().isNotEmpty ||
      (birthday?.trim().isNotEmpty ?? false) ||
      zipCode.trim().isNotEmpty ||
      prefectureCode.trim().isNotEmpty ||
      cityAddress.trim().isNotEmpty ||
      phone.trim().isNotEmpty ||
      email.trim().isNotEmpty ||
      occupationCode.trim().isNotEmpty ||
      annualIncomeCode.trim().isNotEmpty ||
      financialAssetsCode.trim().isNotEmpty ||
      investmentExperienceCodes.isNotEmpty ||
      investmentPurposeCode.trim().isNotEmpty ||
      fundSourceCode.trim().isNotEmpty ||
      riskToleranceCode.trim().isNotEmpty ||
      ekycDocumentType.trim().isNotEmpty ||
      (idDocumentPhotoPath?.trim().isNotEmpty ?? false) ||
      (idDocumentBackPhotoPath?.trim().isNotEmpty ?? false) ||
      (selfiePhotoPath?.trim().isNotEmpty ?? false) ||
      bankName.trim().isNotEmpty ||
      branchBankName.trim().isNotEmpty ||
      bankNumber.trim().isNotEmpty ||
      bankAccountType.trim().isNotEmpty ||
      bankAccountOwnerName.trim().isNotEmpty ||
      electronicDeliveryConsent ||
      antiSocialForcesConsent ||
      privacyPolicyConsent;

  MemberProfileDetails mergeWithSeed({
    String? familyName,
    String? givenName,
    String? familyNameKana,
    String? givenNameKana,
    String? familyNameEn,
    String? givenNameEn,
    String? nameKanji,
    String? katakana,
    String? address,
    String? birthday,
    String? phone,
    String? phoneIntlCode,
    String? email,
    String? zipCode,
  }) {
    String mergeString(String current, String? seed) {
      if (current.trim().isNotEmpty) {
        return current;
      }
      final normalizedSeed = seed?.trim() ?? '';
      return normalizedSeed;
    }

    return copyWith(
      familyName: mergeString(this.familyName, familyName),
      givenName: mergeString(this.givenName, givenName),
      familyNameKana: mergeString(this.familyNameKana, familyNameKana),
      givenNameKana: mergeString(this.givenNameKana, givenNameKana),
      familyNameEn: mergeString(this.familyNameEn, familyNameEn),
      givenNameEn: mergeString(this.givenNameEn, givenNameEn),
      nameKanji: mergeString(this.nameKanji, nameKanji),
      katakana: mergeString(this.katakana, katakana),
      address: mergeString(this.address, address),
      birthday: mergeNullableString(this.birthday, birthday),
      phoneIntlCode: mergeString(this.phoneIntlCode, phoneIntlCode),
      phone: mergeString(this.phone, phone),
      email: mergeString(this.email, email),
      zipCode: mergeString(this.zipCode, zipCode),
    );
  }

  bool get _isBasicInfoStepComplete =>
      (familyName.trim().isNotEmpty || nameKanji.trim().isNotEmpty) &&
      (givenName.trim().isNotEmpty || nameKanji.trim().isNotEmpty) &&
      (familyNameKana.trim().isNotEmpty || katakana.trim().isNotEmpty) &&
      (givenNameKana.trim().isNotEmpty || katakana.trim().isNotEmpty) &&
      familyNameEn.trim().isNotEmpty &&
      givenNameEn.trim().isNotEmpty &&
      (birthday?.trim().isNotEmpty ?? false) &&
      phone.trim().isNotEmpty;

  bool get _isAddressInfoStepComplete =>
      zipCode.trim().isNotEmpty &&
      prefectureCode.trim().isNotEmpty &&
      (cityAddress.trim().isNotEmpty || address.trim().isNotEmpty);

  bool get _isSuitabilityStepComplete =>
      occupationCode.trim().isNotEmpty &&
      annualIncomeCode.trim().isNotEmpty &&
      financialAssetsCode.trim().isNotEmpty &&
      investmentPurposeCode.trim().isNotEmpty &&
      fundSourceCode.trim().isNotEmpty &&
      riskToleranceCode.trim().isNotEmpty;

  bool get _isEkycStepComplete =>
      ekycDocumentType.trim().isNotEmpty &&
      (idDocumentPhotoPath?.trim().isNotEmpty ?? false) &&
      (selfiePhotoPath?.trim().isNotEmpty ?? false);

  bool get _isBankAccountStepComplete =>
      bankName.trim().isNotEmpty &&
      branchBankName.trim().isNotEmpty &&
      bankNumber.trim().isNotEmpty &&
      bankAccountType.trim().isNotEmpty &&
      bankAccountOwnerName.trim().isNotEmpty;

  bool get _isConsentStepComplete =>
      electronicDeliveryConsent &&
      antiSocialForcesConsent &&
      privacyPolicyConsent;

  bool get _isFlowComplete =>
      _isBasicInfoStepComplete &&
      _isAddressInfoStepComplete &&
      _isSuitabilityStepComplete &&
      _isEkycStepComplete &&
      _isBankAccountStepComplete &&
      _isConsentStepComplete;

  static String? mergeNullableString(String? current, String? seed) {
    final currentValue = current?.trim() ?? '';
    if (currentValue.isNotEmpty) {
      return currentValue;
    }
    final normalizedSeed = seed?.trim() ?? '';
    return normalizedSeed.isEmpty ? null : normalizedSeed;
  }
}
