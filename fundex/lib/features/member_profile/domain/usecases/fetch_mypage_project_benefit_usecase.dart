import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchMyPageProjectBenefitUseCase {
  const FetchMyPageProjectBenefitUseCase(this._repository);

  final MyPageRepository _repository;

  Future<MyPageProjectBenefit> call({required String projectId}) {
    return _repository.fetchProjectBenefit(projectId: projectId);
  }
}
