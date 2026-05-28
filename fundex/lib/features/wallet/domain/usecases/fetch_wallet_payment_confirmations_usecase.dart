import '../entities/wallet_payment_confirmation_record.dart';
import '../repositories/wallet_repository.dart';

class FetchWalletPaymentConfirmationsUseCase {
  FetchWalletPaymentConfirmationsUseCase(this._repository);

  final WalletRepository _repository;

  Future<List<WalletPaymentConfirmationRecord>> call({
    required String bizId,
    int startPage = 1,
    int limit = 10,
  }) {
    return _repository.fetchPaymentConfirmations(
      bizId: bizId,
      startPage: startPage,
      limit: limit,
    );
  }
}
