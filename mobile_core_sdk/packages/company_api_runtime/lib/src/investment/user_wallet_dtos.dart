class UserWalletAccountHistoryItemDto {
  const UserWalletAccountHistoryItemDto({
    this.id,
    this.userId,
    this.type,
    this.typeName,
    this.money,
    this.balance,
    this.remark,
    this.createTime,
  });

  factory UserWalletAccountHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return UserWalletAccountHistoryItemDto(
      id: _intOrNull(json['id']),
      userId: _intOrNull(json['userId']),
      type: _intOrNull(json['type']),
      typeName: _stringOrNull(json['typeName'] ?? json['typeText']),
      money: _numOrNull(json['money'] ?? json['amount']),
      balance: _numOrNull(json['balance']),
      remark: _stringOrNull(json['remark']),
      createTime: _stringOrNull(json['createTime']),
    );
  }

  final int? id;
  final int? userId;
  final int? type;
  final String? typeName;
  final num? money;
  final num? balance;
  final String? remark;
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
