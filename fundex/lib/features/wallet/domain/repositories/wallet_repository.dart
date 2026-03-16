import '../entities/wallet_account_history.dart';
import '../entities/wallet_bank_account_info.dart';

abstract class WalletRepository {
  Future<List<WalletAccountHistory>> fetchAccountHistory({int accountType = 0});

  Future<WalletBankAccountInfo?> fetchBankAccountInfo();

  Future<void> applyBankAccount();
}
