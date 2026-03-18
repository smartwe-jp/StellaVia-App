import '../entities/wallet_withdraw_apply_draft.dart';
import '../repositories/wallet_repository.dart';

class SubmitWalletWithdrawApplyUseCase {
  SubmitWalletWithdrawApplyUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call(WalletWithdrawApplyDraft draft) {
    return _repository.applyWithdraw(draft);
  }
}
