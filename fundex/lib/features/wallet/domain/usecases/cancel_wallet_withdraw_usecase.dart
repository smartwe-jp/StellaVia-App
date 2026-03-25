import '../entities/wallet_withdraw_record.dart';
import '../repositories/wallet_repository.dart';

class CancelWalletWithdrawUseCase {
  CancelWalletWithdrawUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call(WalletWithdrawRecord record) {
    return _repository.cancelWithdraw(record);
  }
}
