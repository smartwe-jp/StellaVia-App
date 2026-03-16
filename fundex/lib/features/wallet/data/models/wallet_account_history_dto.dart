export 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletAccountHistoryItemDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletAccountHistoryItemDto;

import '../../domain/entities/wallet_account_history.dart';

typedef WalletAccountHistoryDto = UserWalletAccountHistoryItemDto;

extension WalletAccountHistoryDtoMapper on WalletAccountHistoryDto {
  WalletAccountHistory toEntity() {
    return WalletAccountHistory(
      id: id,
      userId: userId,
      type: type,
      typeName: typeName,
      tradeType: tradeType,
      tradeTypeValue: tradeTypeValue,
      inOut: inOut,
      businessId: businessId,
      amount: amount,
      money: money,
      balance: balance,
      remark: remark,
      status: status,
      createBy: createBy,
      tradeTime: tradeTime,
      createTime: createTime,
    );
  }
}
