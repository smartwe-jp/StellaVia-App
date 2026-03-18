import '../repositories/mypage_repository.dart';

class SubmitMyPageSecondaryMarketCreateUseCase {
  const SubmitMyPageSecondaryMarketCreateUseCase(this._repository);

  final MyPageRepository _repository;

  Future<void> call({
    required String fromProcessId,
    required int sellNum,
    required int price,
  }) {
    return _repository.submitSecondaryMarketCreate(
      fromProcessId: fromProcessId,
      sellNum: sellNum,
      price: price,
    );
  }
}
