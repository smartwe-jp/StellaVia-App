import '../repositories/wallet_repository.dart';

class ApplyWalletBankAccountUseCase {
  ApplyWalletBankAccountUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call() {
    return _repository.applyBankAccount();
  }
}
