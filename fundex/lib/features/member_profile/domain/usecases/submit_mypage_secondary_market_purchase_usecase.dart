import '../repositories/mypage_repository.dart';

class SubmitMyPageSecondaryMarketPurchaseUseCase {
  const SubmitMyPageSecondaryMarketPurchaseUseCase(this._repository);

  final MyPageRepository _repository;

  Future<void> call({required String id, required int buyNum}) {
    return _repository.submitSecondaryMarketPurchase(id: id, buyNum: buyNum);
  }
}
