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

class UserWalletBankAccountPoolDto {
  const UserWalletBankAccountPoolDto({
    this.id,
    this.bankName,
    this.branchName,
    this.accountType,
    this.accountNumber,
    this.accountName,
    this.version,
  });

  factory UserWalletBankAccountPoolDto.fromJson(Map<String, dynamic> json) {
    return UserWalletBankAccountPoolDto(
      id: _stringOrNull(json['id']),
      bankName: _stringOrNull(json['bankName']),
      branchName: _stringOrNull(json['branchName']),
      accountType: _stringOrNull(json['accountType']),
      accountNumber: _stringOrNull(json['accountNumber']),
      accountName: _stringOrNull(json['accountName']),
      version: _intOrNull(json['version']),
    );
  }

  final String? id;
  final String? bankName;
  final String? branchName;
  final String? accountType;
  final String? accountNumber;
  final String? accountName;
  final int? version;
}

class UserWalletBankAccountAddRequestDto {
  const UserWalletBankAccountAddRequestDto({
    required this.bankName,
    required this.branchName,
    required this.accountType,
    required this.accountNumber,
    required this.accountName,
  });

  final String bankName;
  final String branchName;
  final String accountType;
  final String accountNumber;
  final String accountName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bankName': bankName.trim(),
      'branchName': branchName.trim(),
      'accountType': accountType.trim(),
      'accountNumber': accountNumber.trim(),
      'accountName': accountName.trim(),
    };
  }
}

class UserWalletBankAccountInfoDto {
  const UserWalletBankAccountInfoDto({
    this.accountPool,
    this.userId,
    this.bankAccountId,
    this.bindStatus,
    this.expireTime,
    this.zeroBalanceStartTime,
    this.createTime,
    this.updateTime,
  });

  factory UserWalletBankAccountInfoDto.fromJson(Map<String, dynamic> json) {
    final accountPoolMap = json['accountPool'];
    return UserWalletBankAccountInfoDto(
      accountPool: accountPoolMap is Map
          ? UserWalletBankAccountPoolDto.fromJson(
              Map<String, dynamic>.from(accountPoolMap),
            )
          : null,
      userId: _intOrNull(json['userId']),
      bankAccountId: _stringOrNull(json['bankAccountId']),
      bindStatus: _intOrNull(json['bindStatus']),
      expireTime: _stringOrNull(json['expireTime']),
      zeroBalanceStartTime: _stringOrNull(json['zeroBalanceStartTime']),
      createTime: _stringOrNull(json['createTime']),
      updateTime: _stringOrNull(json['updateTime']),
    );
  }

  final UserWalletBankAccountPoolDto? accountPool;
  final int? userId;
  final String? bankAccountId;
  final int? bindStatus;
  final String? expireTime;
  final String? zeroBalanceStartTime;
  final String? createTime;
  final String? updateTime;
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
