class WalletBankAccountInfo {
  const WalletBankAccountInfo({
    required this.bankName,
    required this.branchName,
    required this.accountType,
    required this.accountNumber,
    required this.accountHolder,
    this.expireTime,
  });

  final String bankName;
  final String branchName;
  final String accountType;
  final String accountNumber;
  final String accountHolder;
  final String? expireTime;
}
