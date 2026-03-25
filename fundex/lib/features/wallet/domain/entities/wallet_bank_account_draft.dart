enum WalletBankAccountKind { domestic, overseas }

class WalletBankAccountDraft {
  const WalletBankAccountDraft.domestic({
    required this.bankName,
    required this.branchName,
    required this.accountType,
    required this.accountNumber,
    required this.accountHolder,
  }) : kind = WalletBankAccountKind.domestic,
       bankType = 0,
       branchNumber = null,
       accountHolderAddress = null,
       accountHolderNationality = null,
       swiftCode = null,
       bankCountry = null,
       branchAddress = null;

  const WalletBankAccountDraft.overseas({
    required this.bankName,
    required this.branchName,
    required this.branchNumber,
    required this.accountNumber,
    required this.accountHolder,
    required this.accountHolderAddress,
    required this.accountHolderNationality,
    required this.swiftCode,
    required this.bankCountry,
    required this.branchAddress,
  }) : kind = WalletBankAccountKind.overseas,
       bankType = 1,
       accountType = null;

  final WalletBankAccountKind kind;
  final int bankType;

  final String bankName;
  final String branchName;
  final String? accountType;
  final String accountNumber;
  final String accountHolder;
  final String? branchNumber;
  final String? accountHolderAddress;
  final String? accountHolderNationality;
  final String? swiftCode;
  final String? bankCountry;
  final String? branchAddress;
}
