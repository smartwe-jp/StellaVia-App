export 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletBankAccountInfoDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletBankAccountInfoDto;

import '../../domain/entities/wallet_bank_account_info.dart';

typedef WalletBankAccountInfoDto = UserWalletBankAccountInfoDto;

extension WalletBankAccountInfoDtoMapper on WalletBankAccountInfoDto {
  WalletBankAccountInfo? toEntityOrNull() {
    final pool = accountPool;
    if (pool == null) {
      return null;
    }

    return WalletBankAccountInfo(
      bankName: pool.bankName ?? '--',
      branchName: pool.branchName ?? '--',
      accountType: pool.accountType ?? '--',
      accountNumber: pool.accountNumber ?? '--',
      accountHolder: pool.accountName ?? '--',
      expireTime: expireTime,
    );
  }
}
