import '../entities/wallet_bank_account_info.dart';
import '../repositories/wallet_repository.dart';

class FetchWalletBankAccountInfoUseCase {
  FetchWalletBankAccountInfoUseCase(this._repository);

  final WalletRepository _repository;

  Future<WalletBankAccountInfo?> call() {
    return _repository.fetchBankAccountInfo();
  }
}
