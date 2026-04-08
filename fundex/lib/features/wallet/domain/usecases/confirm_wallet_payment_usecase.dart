import '../repositories/wallet_repository.dart';

class ConfirmWalletPaymentUseCase {
  ConfirmWalletPaymentUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call({required Object amount}) {
    return _repository.confirmPayment(amount: amount);
  }
}
