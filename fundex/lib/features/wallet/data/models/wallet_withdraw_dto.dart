export 'package:company_api_runtime/company_api_runtime.dart'
    show
        UserWalletWithdrawApplyRequestDto,
        UserWalletWithdrawCancelRequestDto,
        UserWalletWithdrawRecordDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show
        UserWalletWithdrawApplyRequestDto,
        UserWalletWithdrawCancelRequestDto,
        UserWalletWithdrawRecordDto;

import '../../domain/entities/wallet_withdraw_apply_draft.dart';
import '../../domain/entities/wallet_withdraw_record.dart';

typedef WalletWithdrawApplyRequestDto = UserWalletWithdrawApplyRequestDto;
typedef WalletWithdrawCancelRequestDto = UserWalletWithdrawCancelRequestDto;
typedef WalletWithdrawRecordDto = UserWalletWithdrawRecordDto;

extension WalletWithdrawApplyDraftMapper on WalletWithdrawApplyDraft {
  WalletWithdrawApplyRequestDto toDto() {
    return WalletWithdrawApplyRequestDto(
      amount: amount,
      bankId: bankId,
      bookCrashAddress: bookCrashAddress,
      bookDate: bookDate,
      code: code,
      withdrawType: withdrawType,
    );
  }
}

extension WalletWithdrawRecordCancelMapper on WalletWithdrawRecord {
  WalletWithdrawCancelRequestDto toCancelDto() {
    return WalletWithdrawCancelRequestDto(
      withdrawId: withdrawId ?? '',
      amount: amount,
      bankName: bankName,
      bankNumber: bankNumber,
      bookDate: bookDate,
      branchBankName: bankBranch,
      cost: cost,
      memberId: memberId,
      payRemark: remark,
      payStatus: payStatus,
      payTime: payTime,
      withdrawDesc: remark,
      withdrawType: withdrawType,
    );
  }
}

extension WalletWithdrawRecordDtoMapper on WalletWithdrawRecordDto {
  WalletWithdrawRecord toEntity() {
    return WalletWithdrawRecord(
      withdrawId: withdrawId,
      memberId: memberId,
      processId: processId,
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
