import '../repositories/member_profile_repository.dart';

class SyncMemberProfileFromRemoteUseCase {
  SyncMemberProfileFromRemoteUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<void> call() {
    return _repository.syncLocalProfileFromRemote();
  }
}
