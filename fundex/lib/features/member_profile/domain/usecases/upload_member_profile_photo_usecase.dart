import '../constants/member_profile_upload_markers.dart';
import '../repositories/member_profile_repository.dart';

class UploadMemberProfilePhotoUseCase {
  UploadMemberProfilePhotoUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<String> call({
    required String filePath,
    required bool isSelfie,
    bool allowTestSelfieUploadFailure = false,
  }) async {
    try {
      return await _repository.uploadProfilePhoto(
        filePath: filePath,
        isSelfie: isSelfie,
      );
    } catch (_) {
      if (isSelfie && allowTestSelfieUploadFailure) {
        return testSelfieUploadFallbackMarker;
      }
      rethrow;
    }
  }
}
