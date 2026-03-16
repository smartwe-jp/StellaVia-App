import '../entities/wallet_account_history.dart';
import '../repositories/wallet_repository.dart';

class FetchWalletAccountHistoryUseCase {
  FetchWalletAccountHistoryUseCase(this._repository);

  final WalletRepository _repository;

  Future<List<WalletAccountHistory>> call({int accountType = 0}) {
    return _repository.fetchAccountHistory(accountType: accountType);
  }
}
