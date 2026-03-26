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
      id: bankAccountId ?? pool.id,
      bankName: pool.bankName ?? '--',
      branchName: pool.branchName ?? '--',
      accountType: _resolveAccountTypeLabel(
        accountType: pool.accountType,
        bankAccountType: pool.bankAccountType,
      ),
      accountNumber: pool.accountNumber ?? '--',
      accountHolder: pool.accountName ?? '--',
      expireTime: expireTime,
    );
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
