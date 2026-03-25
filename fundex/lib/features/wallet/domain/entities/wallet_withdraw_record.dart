class WalletWithdrawRecord {
  const WalletWithdrawRecord({
    this.withdrawId,
    this.memberId,
    this.processId,
    this.amount,
    this.cost,
    this.withdrawType,
    this.applyTime,
    this.bookDate,
    this.bankNumber,
    this.bankName,
    this.bankBranch,
    this.payStatus,
    this.status,
    this.remark,
    this.payTime,
    this.updateTime,
    this.createTime,
  });

  final String? withdrawId;
  final int? memberId;
  final String? processId;
  final num? amount;
  final num? cost;
  final int? withdrawType;
  final String? applyTime;
  final String? bookDate;
  final String? bankNumber;
  final String? bankName;
  final String? bankBranch;
  final int? payStatus;
  final int? status;
  final String? remark;
  final String? payTime;
  final String? updateTime;
  final String? createTime;
}
