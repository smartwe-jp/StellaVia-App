import '../repositories/wallet_repository.dart';

class FetchWalletWithdrawCostUseCase {
  FetchWalletWithdrawCostUseCase(this._repository);

  final WalletRepository _repository;

  Future<num> call({required Object bankId}) {
    return _repository.fetchWithdrawCost(bankId: bankId);
  }
}
