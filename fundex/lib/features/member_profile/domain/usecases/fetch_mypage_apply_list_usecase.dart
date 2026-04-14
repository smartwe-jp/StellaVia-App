import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchMyPageApplyListUseCase {
  const FetchMyPageApplyListUseCase(this._repository);

  final MyPageRepository _repository;

  Future<List<MyPageApplyRecord>> call({
    int? startPage,
    int? limit,
    List<int>? statuses,
  }) {
    return _repository.fetchApplyList(
      startPage: startPage,
      limit: limit,
      statuses: statuses,
    );
  }
}
