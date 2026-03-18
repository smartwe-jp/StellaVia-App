class WalletWithdrawApplyDraft {
  const WalletWithdrawApplyDraft({
    required this.amount,
    required this.bankId,
    this.bookCrashAddress,
    this.bookDate,
    this.withdrawType = 0,
  });

  final num amount;
  final Object bankId;
  final String? bookCrashAddress;
  final String? bookDate;
  final int withdrawType;
}
