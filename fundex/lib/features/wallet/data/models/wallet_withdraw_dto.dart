export 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletWithdrawApplyRequestDto, UserWalletWithdrawRecordDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show UserWalletWithdrawApplyRequestDto, UserWalletWithdrawRecordDto;

import '../../domain/entities/wallet_withdraw_apply_draft.dart';
import '../../domain/entities/wallet_withdraw_record.dart';

typedef WalletWithdrawApplyRequestDto = UserWalletWithdrawApplyRequestDto;
typedef WalletWithdrawRecordDto = UserWalletWithdrawRecordDto;

extension WalletWithdrawApplyDraftMapper on WalletWithdrawApplyDraft {
  WalletWithdrawApplyRequestDto toDto() {
    return WalletWithdrawApplyRequestDto(
      amount: amount,
      bankId: bankId,
      bookCrashAddress: bookCrashAddress,
      bookDate: bookDate,
      withdrawType: withdrawType,
    );
  }
}

extension WalletWithdrawRecordDtoMapper on WalletWithdrawRecordDto {
  WalletWithdrawRecord toEntity() {
    return WalletWithdrawRecord(
      withdrawId: withdrawId,
      amount: amount,
      cost: cost,
      withdrawType: withdrawType,
      applyTime: applyTime,
      bookDate: bookDate,
      bankNumber: bankNumber,
      bankName: bankName,
      bankBranch: bankBranch,
      payStatus: payStatus,
      status: status,
      remark: remark,
      payTime: payTime,
      updateTime: updateTime,
      createTime: createTime,
    );
  }
}
