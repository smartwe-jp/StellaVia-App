export 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletPaymentConfirmationRecordDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletPaymentConfirmationRecordDto;

import '../../domain/entities/wallet_payment_confirmation_record.dart';

typedef WalletPaymentConfirmationRecordDto =
    UserWalletPaymentConfirmationRecordDto;

extension WalletPaymentConfirmationRecordDtoMapper
    on WalletPaymentConfirmationRecordDto {
  WalletPaymentConfirmationRecord toEntity() {
    return WalletPaymentConfirmationRecord(
      id: id,
      userId: userId,
      bizId: bizId,
      amount: amount,
      createTime: createTime,
    );
  }
}
