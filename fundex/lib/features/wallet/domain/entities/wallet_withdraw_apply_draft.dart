class WalletWithdrawApplyDraft {
  const WalletWithdrawApplyDraft({
    required this.amount,
    required this.bankId,
    this.bookCrashAddress,
    this.bookDate,
    this.code,
    this.withdrawType = 0,
  });

  final num amount;
  final Object bankId;
  final String? bookCrashAddress;
  final String? bookDate;
  final String? code;
  final int withdrawType;

  WalletWithdrawApplyDraft copyWith({
    num? amount,
    Object? bankId,
    String? bookCrashAddress,
    String? bookDate,
    String? code,
    int? withdrawType,
  }) {
    return WalletWithdrawApplyDraft(
      amount: amount ?? this.amount,
      bankId: bankId ?? this.bankId,
      bookCrashAddress: bookCrashAddress ?? this.bookCrashAddress,
      bookDate: bookDate ?? this.bookDate,
      code: code ?? this.code,
      withdrawType: withdrawType ?? this.withdrawType,
    );
  }
}
