import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchMyPageOrderInquiryListUseCase {
  const FetchMyPageOrderInquiryListUseCase(this._repository);

  final MyPageRepository _repository;

  Future<List<MyPageOrderInquiryRecord>> call({
    int? userId,
    String? status,
    int startPage = 1,
    int limit = 20,
  }) {
    return _repository.fetchOrderInquiryList(
      userId: userId,
      status: status,
      startPage: startPage,
      limit: limit,
    );
  }
}
