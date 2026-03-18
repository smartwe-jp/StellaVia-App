import '../entities/wallet_withdraw_record.dart';
import '../repositories/wallet_repository.dart';

class FetchWalletWithdrawingListUseCase {
  FetchWalletWithdrawingListUseCase(this._repository);

  final WalletRepository _repository;

  Future<List<WalletWithdrawRecord>> call() {
    return _repository.fetchWithdrawingList();
  }
}
