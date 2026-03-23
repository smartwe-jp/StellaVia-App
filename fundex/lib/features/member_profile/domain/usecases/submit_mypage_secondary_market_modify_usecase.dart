import '../repositories/mypage_repository.dart';

class SubmitMyPageSecondaryMarketModifyUseCase {
  const SubmitMyPageSecondaryMarketModifyUseCase(this._repository);

  final MyPageRepository _repository;

  Future<void> call({
    required String id,
    required String fromProcessId,
    required int sellNum,
    required int price,
    required String status,
    int thisTimeSoldNum = 0,
  }) {
    return _repository.submitSecondaryMarketModify(
      id: id,
      fromProcessId: fromProcessId,
      sellNum: sellNum,
      price: price,
      status: status,
      thisTimeSoldNum: thisTimeSoldNum,
    );
  }
}
