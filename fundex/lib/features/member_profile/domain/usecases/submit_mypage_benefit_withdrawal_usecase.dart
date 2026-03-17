import '../repositories/mypage_repository.dart';

class SubmitMyPageBenefitWithdrawalUseCase {
  const SubmitMyPageBenefitWithdrawalUseCase(this._repository);

  final MyPageRepository _repository;

  Future<bool> call({required String benefitId}) {
    return _repository.submitBenefitWithdrawal(benefitId: benefitId);
  }
}
