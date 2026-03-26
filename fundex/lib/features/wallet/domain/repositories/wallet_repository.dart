import '../entities/wallet_account_history.dart';
import '../entities/wallet_bank_account_draft.dart';
import '../entities/wallet_bank_account_info.dart';
import '../entities/wallet_withdraw_apply_draft.dart';
import '../entities/wallet_withdraw_record.dart';

abstract class WalletRepository {
  Future<List<WalletAccountHistory>> fetchAccountHistory({int accountType = 0});

  Future<WalletBankAccountInfo?> fetchBankAccountInfo();

  Future<List<WalletBankAccountInfo>> fetchBankAccountList();

  Future<void> applyBankAccount();

  Future<void> addBankAccount(WalletBankAccountDraft draft);

  Future<void> deleteBankAccount({required Object id});

  Future<void> sendWithdrawApplyCode();

  Future<void> applyWithdraw(WalletWithdrawApplyDraft draft);

  Future<void> cancelWithdraw(WalletWithdrawRecord record);

  Future<num> fetchWithdrawCost({required Object bankId});

  Future<List<WalletWithdrawRecord>> fetchWithdrawHistory();

  Future<List<WalletWithdrawRecord>> fetchWithdrawingList();
}
