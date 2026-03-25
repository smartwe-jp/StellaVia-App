import '../repositories/wallet_repository.dart';

class SendWalletWithdrawApplyCodeUseCase {
  SendWalletWithdrawApplyCodeUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call() {
    return _repository.sendWithdrawApplyCode();
  }
}
