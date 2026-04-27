import '../entities/fund_project.dart';
import '../repositories/fund_project_repository.dart';

class FetchFundProjectApplyDetailUseCase {
  const FetchFundProjectApplyDetailUseCase(this._repository);

  final FundProjectRepository _repository;

  Future<FundProjectApplyDetail> call({required String projectId}) {
    return _repository.fetchFundProjectApplyDetail(projectId: projectId);
  }
}
