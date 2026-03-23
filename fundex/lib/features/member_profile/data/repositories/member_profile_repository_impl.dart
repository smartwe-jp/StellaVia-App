import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/member_profile_details.dart';
import '../../domain/entities/member_profile_region.dart';
import '../../domain/repositories/member_profile_repository.dart';
import '../datasources/member_profile_local_data_source.dart';
import '../datasources/member_profile_remote_data_source.dart';
import '../mappers/member_profile_api_payload_mapper.dart';
import '../mappers/member_profile_current_user_payload_mapper.dart';
import '../models/member_profile_details_dto.dart';
import '../models/member_profile_region_dto.dart';

class MemberProfileRepositoryImpl implements MemberProfileRepository {
  MemberProfileRepositoryImpl({
    required MemberProfileLocalDataSource local,
    required MemberProfileRemoteDataSource remote,
    required AuthLocalDataSource authLocal,
  }) : _local = local,
       _remote = remote,
       _authLocal = authLocal;

  final MemberProfileLocalDataSource _local;
  final MemberProfileRemoteDataSource _remote;
  final AuthLocalDataSource _authLocal;

  @override
  Future<void> clearLocalProfile() async {
    try {
      await _local.clearProfile();
    } catch (_) {
      // Keep member profile features available even when local cache fails.
    }
  }

  @override
  Future<MemberProfileDetails?> readLocalProfile() async {
    try {
      final dto = await _local.readProfile();
      return dto?.toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLocalProfile(MemberProfileDetails profile) async {
    try {
      await _local.saveProfile(MemberProfileDetailsDto.fromEntity(profile));
    } catch (_) {
      // Keep member profile features available even when local cache fails.
    }
  }

  @override
  Future<void> syncLocalProfileFromRemote() async {
    try {
      final existingProfile = await readLocalProfile();
      final payload = await _remote.fetchCurrentMemberProfilePayload();
      final remoteProfile = MemberProfileCurrentUserPayloadMapper.toEntity(
        payload,
      );
      if (remoteProfile == null) {
        return;
      }
      final profile = _mergeRemoteProfileWithLocal(
        remoteProfile: remoteProfile,
        localProfile: existingProfile,
      );
      await _local.saveProfile(MemberProfileDetailsDto.fromEntity(profile));
    } catch (_) {
      // Keep auth flow and local draft access available on transient sync failures.
    }
  }

  MemberProfileDetails _mergeRemoteProfileWithLocal({
    required MemberProfileDetails remoteProfile,
    required MemberProfileDetails? localProfile,
  }) {
    if (localProfile == null) {
      return remoteProfile;
    }

    String mergeString(String remote, String local) {
      final normalizedRemote = remote.trim();
      if (normalizedRemote.isNotEmpty) {
        return normalizedRemote;
      }
      return local.trim();
    }

    String? mergeNullableString(String? remote, String? local) {
      final normalizedRemote = remote?.trim() ?? '';
      if (normalizedRemote.isNotEmpty) {
        return normalizedRemote;
      }
      final normalizedLocal = local?.trim() ?? '';
      return normalizedLocal.isEmpty ? null : normalizedLocal;
    }

    return remoteProfile.copyWith(
      familyName: mergeString(remoteProfile.familyName, localProfile.familyName),
      givenName: mergeString(remoteProfile.givenName, localProfile.givenName),
      familyNameKana: mergeString(
        remoteProfile.familyNameKana,
        localProfile.familyNameKana,
      ),
      givenNameKana: mergeString(
        remoteProfile.givenNameKana,
        localProfile.givenNameKana,
      ),
      familyNameEn: mergeString(
        remoteProfile.familyNameEn,
        localProfile.familyNameEn,
      ),
      givenNameEn: mergeString(
        remoteProfile.givenNameEn,
        localProfile.givenNameEn,
      ),
      nameKanji: mergeString(remoteProfile.nameKanji, localProfile.nameKanji),
      katakana: mergeString(remoteProfile.katakana, localProfile.katakana),
      address: mergeString(remoteProfile.address, localProfile.address),
      birthday: mergeNullableString(
        remoteProfile.birthday,
        localProfile.birthday,
      ),
      zipCode: mergeString(remoteProfile.zipCode, localProfile.zipCode),
      prefectureCode: mergeString(
        remoteProfile.prefectureCode,
        localProfile.prefectureCode,
      ),
      cityAddress: mergeString(
        remoteProfile.cityAddress,
        localProfile.cityAddress,
      ),
      phoneIntlCode: mergeString(
        remoteProfile.phoneIntlCode,
        localProfile.phoneIntlCode,
      ),
      phone: mergeString(remoteProfile.phone, localProfile.phone),
      email: mergeString(remoteProfile.email, localProfile.email),
      occupationCode: mergeString(
        remoteProfile.occupationCode,
        localProfile.occupationCode,
      ),
      annualIncomeCode: mergeString(
        remoteProfile.annualIncomeCode,
        localProfile.annualIncomeCode,
      ),
      financialAssetsCode: mergeString(
        remoteProfile.financialAssetsCode,
        localProfile.financialAssetsCode,
      ),
      investmentExperienceCodes: remoteProfile.investmentExperienceCodes.isNotEmpty
          ? remoteProfile.investmentExperienceCodes
          : localProfile.investmentExperienceCodes,
      investmentPurposeCode: mergeString(
        remoteProfile.investmentPurposeCode,
        localProfile.investmentPurposeCode,
      ),
      fundSourceCode: mergeString(
        remoteProfile.fundSourceCode,
        localProfile.fundSourceCode,
      ),
      riskToleranceCode: mergeString(
        remoteProfile.riskToleranceCode,
        localProfile.riskToleranceCode,
      ),
      ekycDocumentType: mergeString(
        remoteProfile.ekycDocumentType,
        localProfile.ekycDocumentType,
      ),
      idDocumentPhotoPath: mergeNullableString(
        remoteProfile.idDocumentPhotoPath,
        localProfile.idDocumentPhotoPath,
      ),
      idDocumentBackPhotoPath: mergeNullableString(
        remoteProfile.idDocumentBackPhotoPath,
        localProfile.idDocumentBackPhotoPath,
      ),
      selfiePhotoPath: mergeNullableString(
        remoteProfile.selfiePhotoPath,
        localProfile.selfiePhotoPath,
      ),
      bankName: mergeString(remoteProfile.bankName, localProfile.bankName),
      branchBankName: mergeString(
        remoteProfile.branchBankName,
        localProfile.branchBankName,
      ),
      bankNumber: mergeString(remoteProfile.bankNumber, localProfile.bankNumber),
      bankAccountType: mergeString(
        remoteProfile.bankAccountType,
        localProfile.bankAccountType,
      ),
      bankAccountOwnerName: mergeString(
        remoteProfile.bankAccountOwnerName,
        localProfile.bankAccountOwnerName,
      ),
      electronicDeliveryConsent:
          remoteProfile.electronicDeliveryConsent ||
          localProfile.electronicDeliveryConsent,
      antiSocialForcesConsent:
          remoteProfile.antiSocialForcesConsent ||
          localProfile.antiSocialForcesConsent,
      privacyPolicyConsent:
          remoteProfile.privacyPolicyConsent || localProfile.privacyPolicyConsent,
      lastEditingStep: remoteProfile.lastEditingStep > localProfile.lastEditingStep
          ? remoteProfile.lastEditingStep
          : localProfile.lastEditingStep,
      completedAt: localProfile.completedAt ?? remoteProfile.completedAt,
      lastSkippedAt: localProfile.lastSkippedAt ?? remoteProfile.lastSkippedAt,
      lastUpdatedAt: remoteProfile.lastUpdatedAt ?? localProfile.lastUpdatedAt,
    );
  }

  @override
  Future<List<MemberProfileRegion>> fetchRegionsByZip({required String zip}) {
    return _remote
        .fetchRegionsByZip(zip: zip)
        .then((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<String> uploadProfilePhoto({
    required String filePath,
    required bool isSelfie,
  }) {
    return _remote.uploadPhoto(filePath: filePath, isSelfie: isSelfie);
  }

  @override
  Future<void> submitProfile(MemberProfileDetails profile) async {
    final authUser = await _authLocal.readCurrentUser();
    final frontUrl = _requireRemotePhotoUrl(
      profile.idDocumentPhotoPath,
      fallbackMessage: 'Please upload an ID document photo.',
    );
    if (frontUrl == null) {
      throw StateError('Please upload an ID document photo.');
    }
    final backUrl =
        _optionalRemotePhotoUrl(profile.idDocumentBackPhotoPath) ?? frontUrl;
    final payload = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
      profile: profile,
      documentFrontImage: frontUrl,
      documentBackImage: backUrl,
      authUser: authUser,
    );
    await _remote.saveMemberInfo(payload: payload);
  }

  String? _requireRemotePhotoUrl(
    String? pathOrUrl, {
    required String fallbackMessage,
  }) {
    final normalized = pathOrUrl?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    if (_isRemoteUrl(normalized)) {
      return normalized;
    }
    throw StateError(fallbackMessage);
  }

  bool _isRemoteUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  String? _optionalRemotePhotoUrl(String? pathOrUrl) {
    final normalized = pathOrUrl?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    if (_isRemoteUrl(normalized)) {
      return normalized;
    }
    return null;
  }
}
