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
      branchName: branchName.trim(),
      accountType: accountType.trim(),
      accountNumber: accountNumber.trim(),
      accountName: accountHolder.trim(),
    );
  }
}
