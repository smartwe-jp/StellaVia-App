import '../entities/wallet_bank_account_draft.dart';
import '../repositories/wallet_repository.dart';

class AddWalletBankAccountUseCase {
  AddWalletBankAccountUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call(WalletBankAccountDraft draft) {
    return _repository.addBankAccount(draft);
  }
}
