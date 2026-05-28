class WalletPaymentConfirmationRecord {
  const WalletPaymentConfirmationRecord({
    this.id,
    this.userId,
    this.bizId,
    this.amount,
    this.createTime,
  });

  final int? id;
  final int? userId;
  final String? bizId;
  final num? amount;
  final String? createTime;
}
