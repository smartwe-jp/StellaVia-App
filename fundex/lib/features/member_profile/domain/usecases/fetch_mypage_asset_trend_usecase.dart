import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchMyPageAssetTrendUseCase {
  const FetchMyPageAssetTrendUseCase(this._repository);

  final MyPageRepository _repository;

  Future<List<MyPageAssetTrend>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _repository.fetchAssetTrend(startDate: startDate, endDate: endDate);
  }
}
