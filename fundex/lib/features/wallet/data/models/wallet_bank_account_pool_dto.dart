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
      bankName: bankName ?? '--',
      branchName: branchName ?? '--',
      accountType: accountType ?? '--',
      accountNumber: accountNumber ?? '--',
      accountHolder: accountName ?? '--',
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
      accountType: accountType?.trim(),
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
