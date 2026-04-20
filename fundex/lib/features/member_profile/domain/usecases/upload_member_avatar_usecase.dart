import '../repositories/member_profile_repository.dart';

class UploadMemberAvatarUseCase {
  const UploadMemberAvatarUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<String> call({required String filePath}) {
    return _repository.uploadAvatar(filePath: filePath);
  }
}
