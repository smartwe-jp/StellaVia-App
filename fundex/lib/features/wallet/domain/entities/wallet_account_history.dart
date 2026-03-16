class WalletAccountHistory {
  const WalletAccountHistory({
    this.id,
    this.userId,
    this.type,
    this.typeName,
    this.money,
    this.balance,
    this.remark,
    this.createTime,
  });

  final int? id;
  final int? userId;
  final int? type;
  final String? typeName;
  final num? money;
  final num? balance;
  final String? remark;
  final String? createTime;
}
