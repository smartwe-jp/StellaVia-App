import '../../domain/entities/wallet_bank_account_info.dart';
import '../../domain/entities/wallet_withdraw_apply_draft.dart';

class WalletWithdrawConfirmSeed {
  const WalletWithdrawConfirmSeed({
    required this.draft,
    required this.account,
  });

  final WalletWithdrawApplyDraft draft;
  final WalletBankAccountInfo account;
}
