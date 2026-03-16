class WalletBankAccountDraft {
  const WalletBankAccountDraft({
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
