import '../repositories/wallet_repository.dart';

class DeleteWalletBankAccountUseCase {
  DeleteWalletBankAccountUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call({required Object id}) {
    return _repository.deleteBankAccount(id: id);
  }
}
