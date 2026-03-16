import '../repositories/fund_project_repository.dart';

class SubmitFundLotteryApplyUseCase {
  SubmitFundLotteryApplyUseCase(this._repository);

  final FundProjectRepository _repository;

  Future<void> call({
    required String projectId,
    required int units,
    required int amount,
  }) {
    return _repository.submitLotteryApply(
      projectId: projectId,
      units: units,
      amount: amount,
    );
  }
}
