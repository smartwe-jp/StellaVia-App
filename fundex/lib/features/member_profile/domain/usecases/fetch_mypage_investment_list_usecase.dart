import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchMyPageInvestmentListUseCase {
  const FetchMyPageInvestmentListUseCase(this._repository);

  final MyPageRepository _repository;

  Future<List<MyPageInvestmentRecord>> call({
    int? projectStatus,
    int startPage = 1,
    int limit = 20,
  }) {
    return _repository.fetchInvestmentList(
      startPage: startPage,
      limit: limit,
      projectStatus: projectStatus,
    );
  }
}
