import '../../domain/entities/wallet_account_history.dart';

class WalletDedicatedBankInfo {
  const WalletDedicatedBankInfo({
    required this.bankName,
    required this.branchName,
    required this.accountType,
    required this.accountNumber,
    required this.accountHolder,
  });

  final String bankName;
  final String branchName;
  final String accountType;
  final String accountNumber;
  final String accountHolder;
}

class WalletDepositPageViewData {
  const WalletDepositPageViewData({
    required this.bankInfo,
    required this.standbyBalance,
    required this.recentHistory,
  });

  final WalletDedicatedBankInfo bankInfo;
  final num? standbyBalance;
  final List<WalletAccountHistory> recentHistory;
}
