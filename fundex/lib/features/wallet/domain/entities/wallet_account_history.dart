class WalletAccountHistory {
  const WalletAccountHistory({
    this.id,
    this.userId,
    this.type,
    this.typeName,
    this.tradeType,
    this.tradeTypeValue,
    this.inOut,
    this.businessId,
    this.amount,
    this.money,
    this.balance,
    this.remark,
    this.status,
    this.createBy,
    this.tradeTime,
    this.createTime,
  });

  final int? id;
  final int? userId;
  final int? type;
  final String? typeName;
  final String? tradeType;
  final String? tradeTypeValue;
  final String? inOut;
  final String? businessId;
  final num? amount;
  final num? money;
  final num? balance;
  final String? remark;
  final int? status;
  final String? createBy;
  final String? tradeTime;
  final String? createTime;
}
