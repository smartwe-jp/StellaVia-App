import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/auth_user_dto.dart';
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
  Future<MemberProfileDetails?> readOnboardingDraft() async {
    try {
      final dto = await _local.readOnboardingDraft();
      return dto?.toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveOnboardingDraft(MemberProfileDetails profile) async {
    try {
      await _local.saveOnboardingDraft(
        MemberProfileDetailsDto.fromEntity(profile),
      );
    } catch (_) {
      // Keep onboarding draft flow available even when local cache fails.
    }
  }

  @override
  Future<void> clearOnboardingDraft() async {
    try {
      await _local.clearOnboardingDraft();
    } catch (_) {
      // Local onboarding draft cache should not block user flows.
    }
  }

  @override
  Future<void> syncLocalProfileFromRemote() async {
    try {
      final payload = await _remote.fetchCurrentMemberProfilePayload();
      final remoteUser = AuthUserDto.tryFromCurrentUserPayload(payload);
      if (remoteUser != null) {
        await _authLocal.saveCurrentUser(remoteUser);
      }
      final remoteProfile = MemberProfileCurrentUserPayloadMapper.toEntity(
        payload,
      );
      if (remoteProfile == null) {
        return;
      }
      await _local.saveProfile(
        MemberProfileDetailsDto.fromEntity(remoteProfile),
      );
    } catch (_) {
      // Keep auth flow and local draft access available on transient sync failures.
    }
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
  Future<String> uploadAvatar({required String filePath}) {
    return _remote.uploadAvatar(filePath: filePath);
  }

  @override
  Future<void> submitProfile(MemberProfileDetails profile) async {
    final authUser = await _authLocal.readCurrentUser();
    final frontUrl =
        _optionalRemotePhotoUrl(profile.idDocumentPhotoPath) ??
        _optionalRemotePhotoUrl(authUser?.frontUrl);
    final isMyNumber =
        profile.ekycDocumentType.trim().toLowerCase() == 'my_number';
    final backUrl = isMyNumber
        ? frontUrl
        : _optionalRemotePhotoUrl(profile.idDocumentBackPhotoPath) ??
              _optionalRemotePhotoUrl(authUser?.backUrl);
    final payload = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
      profile: profile,
      documentFrontImage: frontUrl,
      documentBackImage: backUrl,
      authUser: authUser,
    );
    await _remote.saveMemberInfo(payload: payload);
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
