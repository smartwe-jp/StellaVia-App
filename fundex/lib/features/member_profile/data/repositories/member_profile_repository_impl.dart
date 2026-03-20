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
      final payload = await _remote.fetchCurrentMemberProfilePayload();
      final profile = MemberProfileCurrentUserPayloadMapper.toEntity(payload);
      if (profile == null) {
        return;
      }
      await _local.saveProfile(MemberProfileDetailsDto.fromEntity(profile));
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
