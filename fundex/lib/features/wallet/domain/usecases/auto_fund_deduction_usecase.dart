import '../repositories/wallet_repository.dart';

class AutoFundDeductionUseCase {
  AutoFundDeductionUseCase(this._repository);

  final WalletRepository _repository;

  Future<bool> call({required String processId}) {
    return _repository.autoFundDeduction(processId: processId);
  }
}
