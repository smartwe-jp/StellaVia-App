import '../entities/wallet_bank_account_info.dart';
import '../repositories/wallet_repository.dart';

class FetchWalletBankAccountListUseCase {
  FetchWalletBankAccountListUseCase(this._repository);

  final WalletRepository _repository;

  Future<List<WalletBankAccountInfo>> call() {
    return _repository.fetchBankAccountList();
  }
}
