import '../repositories/mypage_repository.dart';

class SubmitMyPageUserWithdrawUseCase {
  const SubmitMyPageUserWithdrawUseCase(this._repository);

  final MyPageRepository _repository;

  Future<void> call({required String processId, String? remark}) {
    return _repository.submitUserWithdraw(processId: processId, remark: remark);
  }
}
