class UserWalletAccountHistoryItemDto {
  const UserWalletAccountHistoryItemDto({
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

  factory UserWalletAccountHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return UserWalletAccountHistoryItemDto(
      id: _intOrNull(json['id']),
      userId: _intOrNull(json['userId']),
      type: _intOrNull(json['type']),
      typeName: _stringOrNull(json['typeName'] ?? json['typeText']),
      tradeType: _stringOrNull(json['tradeType']),
      tradeTypeValue: _stringOrNull(json['tradeTypeValue']),
      inOut: _stringOrNull(json['inOut']),
      businessId: _stringOrNull(json['businessId']),
      amount: _numOrNull(json['amount'] ?? json['money']),
      money: _numOrNull(json['money'] ?? json['amount']),
      balance: _numOrNull(json['balance']),
      remark: _stringOrNull(json['remark']),
      status: _intOrNull(json['status']),
      createBy: _stringOrNull(json['createBy']),
      tradeTime: _stringOrNull(json['tradeTime']),
      createTime: _stringOrNull(json['createTime']),
    );
  }

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

int? _intOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

num? _numOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value;
  }
  return num.tryParse(value.toString());
}

String? _stringOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
