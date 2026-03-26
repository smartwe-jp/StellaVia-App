class WalletBankAccountInfo {
  const WalletBankAccountInfo({
    this.id,
    this.bankType,
    required this.bankName,
    required this.branchName,
    this.branchNumber,
    required this.accountType,
    required this.accountNumber,
    required this.accountHolder,
    this.accountHolderAddress,
    this.accountHolderNationality,
    this.swiftCode,
    this.bankCountry,
    this.branchAddress,
    this.expireTime,
  });

  final String? id;
  final int? bankType;
  final String bankName;
  final String branchName;
  final String? branchNumber;
  final String accountType;
  final String accountNumber;
  final String accountHolder;
  final String? accountHolderAddress;
  final String? accountHolderNationality;
  final String? swiftCode;
  final String? bankCountry;
  final String? branchAddress;
  final String? expireTime;
}
