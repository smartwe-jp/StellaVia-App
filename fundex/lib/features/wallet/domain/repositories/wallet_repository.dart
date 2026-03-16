import '../entities/wallet_account_history.dart';

abstract class WalletRepository {
  Future<List<WalletAccountHistory>> fetchAccountHistory({
    int startPage = 1,
    int limit = 20,
  });
}
