import '../entities/wallet_account_history.dart';
import '../repositories/wallet_repository.dart';

class FetchWalletAccountHistoryUseCase {
  FetchWalletAccountHistoryUseCase(this._repository);

  final WalletRepository _repository;

  Future<List<WalletAccountHistory>> call({int startPage = 1, int limit = 20}) {
    return _repository.fetchAccountHistory(startPage: startPage, limit: limit);
  }
}
