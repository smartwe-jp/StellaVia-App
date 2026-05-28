import '../repositories/wallet_repository.dart';

class ConfirmWalletPaymentUseCase {
  ConfirmWalletPaymentUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call({required Object amount, Object? bizId}) {
    return _repository.confirmPayment(amount: amount, bizId: bizId);
  }
}
