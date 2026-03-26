export 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletBankAccountAddRequestDto, UserWalletBankAccountPoolDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletBankAccountAddRequestDto, UserWalletBankAccountPoolDto;

import '../../domain/entities/wallet_bank_account_draft.dart';
import '../../domain/entities/wallet_bank_account_info.dart';

typedef WalletBankAccountPoolDto = UserWalletBankAccountPoolDto;
typedef WalletBankAccountAddRequestDto = UserWalletBankAccountAddRequestDto;

extension WalletBankAccountPoolDtoMapper on WalletBankAccountPoolDto {
  WalletBankAccountInfo toEntity() {
    return WalletBankAccountInfo(
      id: id,
      bankType: bankType,
      bankName: bankName ?? '--',
      branchName: branchName ?? '--',
      branchNumber: branchBankNumber,
      accountType: _resolveAccountTypeLabel(
        accountType: accountType,
        bankAccountType: bankAccountType,
      ),
      accountNumber: accountNumber ?? '--',
      accountHolder: accountName ?? '--',
      accountHolderAddress: bankAccountOwnerAddress,
      accountHolderNationality: bankAccountOwnerNationality,
      swiftCode: bankAccountSwiftCode,
      bankCountry: bankCountry,
      branchAddress: branchBankAddress,
    );
  }
}

extension WalletBankAccountDraftMapper on WalletBankAccountDraft {
  WalletBankAccountAddRequestDto toDto() {
    return WalletBankAccountAddRequestDto(
      bankName: bankName.trim(),
      bankType: bankType,
      branchName: branchName.trim(),
      branchBankName: branchName.trim(),
      branchBankNumber: branchNumber?.trim(),
      bankAccountType: _mapBankAccountType(accountType),
      accountNumber: accountNumber.trim(),
      bankNumber: accountNumber.trim(),
      accountName: accountHolder.trim(),
      bankAccountOwnerName: accountHolder.trim(),
      bankAccountOwnerAddress: accountHolderAddress?.trim(),
      bankAccountOwnerNationality: accountHolderNationality?.trim(),
      bankAccountSwiftCode: swiftCode?.trim(),
      bankCountry: bankCountry?.trim(),
      branchBankAddress: branchAddress?.trim(),
    );
  }
}

int? _mapBankAccountType(String? value) {
  final normalized = value?.trim().toLowerCase() ?? '';
  if (normalized.isEmpty) {
    return null;
  }
  switch (normalized) {
    case '1':
    case 'ordinary':
    case '普通':
    case '普通預金':
      return 1;
    case '2':
    case 'checking':
    case 'current':
    case '当座':
    case '当座預金':
      return 2;
    default:
      return int.tryParse(normalized);
  }
}

String _resolveAccountTypeLabel({
  required String? accountType,
  required int? bankAccountType,
}) {
  final normalized = accountType?.trim().toLowerCase() ?? '';
  if (normalized.isNotEmpty) {
    switch (normalized) {
      case '1':
      case 'ordinary':
      case '普通':
      case '普通預金':
        return '普通';
      case '2':
      case 'checking':
      case 'current':
      case '当座':
      case '当座預金':
        return '当座';
    }
  }
  switch (bankAccountType) {
    case 1:
      return '普通';
    case 2:
      return '当座';
    default:
      return '--';
  }
}
