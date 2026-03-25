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
      branchName: _stringOrNull(json['branchName'] ?? json['branchBankName']),
      accountType: _stringOrNull(
        json['accountType'] ?? json['bankAccountType'],
      ),
      accountNumber: _stringOrNull(json['accountNumber'] ?? json['bankNumber']),
      accountName: _stringOrNull(
        json['accountName'] ?? json['bankAccountOwnerName'],
      ),
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
    required this.bankType,
    this.branchName,
    this.branchBankName,
    this.branchBankNumber,
    this.accountType,
    this.accountNumber,
    this.bankNumber,
    this.accountName,
    this.bankAccountOwnerName,
    this.bankAccountOwnerAddress,
    this.bankAccountOwnerNationality,
    this.bankAccountSwiftCode,
    this.bankCountry,
    this.branchBankAddress,
  });

  final String bankName;
  final int bankType;
  final String? branchName;
  final String? branchBankName;
  final String? branchBankNumber;
  final String? accountType;
  final String? accountNumber;
  final String? bankNumber;
  final String? accountName;
  final String? bankAccountOwnerName;
  final String? bankAccountOwnerAddress;
  final String? bankAccountOwnerNationality;
  final String? bankAccountSwiftCode;
  final String? bankCountry;
  final String? branchBankAddress;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bankName': bankName.trim(),
      'bankType': bankType,
      'branchName': _stringOrNull(branchName ?? branchBankName),
      'branchBankName': _stringOrNull(branchBankName ?? branchName),
      'branchBankNumber': _stringOrNull(branchBankNumber),
      'accountType': _stringOrNull(accountType),
      'bankAccountType': _stringOrNull(accountType),
      'accountNumber': _stringOrNull(accountNumber ?? bankNumber),
      'bankNumber': _stringOrNull(bankNumber ?? accountNumber),
      'accountName': _stringOrNull(accountName ?? bankAccountOwnerName),
      'bankAccountOwnerName': _stringOrNull(
        bankAccountOwnerName ?? accountName,
      ),
      'bankAccountOwnerAddress': _stringOrNull(bankAccountOwnerAddress),
      'bankAccountOwnerNationality': _stringOrNull(
        bankAccountOwnerNationality,
      ),
      'bankAccountSwiftCode': _stringOrNull(bankAccountSwiftCode),
      'bankCountry': _stringOrNull(bankCountry),
      'branchBankAddress': _stringOrNull(branchBankAddress),
    }..removeWhere((_, dynamic value) => value == null);
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

class UserWalletWithdrawApplyRequestDto {
  const UserWalletWithdrawApplyRequestDto({
    required this.amount,
    required this.bankId,
    this.bookCrashAddress,
    this.bookDate,
    this.code,
    this.withdrawType = 0,
  });

  final num amount;
  final Object bankId;
  final String? bookCrashAddress;
  final String? bookDate;
  final String? code;
  final int withdrawType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'bankId': bankId,
      'bookCrashAddress': _stringOrNull(bookCrashAddress),
      'bookDate': _stringOrNull(bookDate),
      'code': _stringOrNull(code),
      'withdrawType': withdrawType,
    }..removeWhere((_, dynamic value) => value == null);
  }
}

class UserWalletWithdrawCancelRequestDto {
  const UserWalletWithdrawCancelRequestDto({
    required this.withdrawId,
    this.amount,
    this.bankName,
    this.bankNumber,
    this.bookDate,
    this.branchBankName,
    this.cost,
    this.memberId,
    this.payRemark,
    this.payStatus,
    this.payTime,
    this.withdrawDesc,
    this.withdrawType,
  });

  final Object withdrawId;
  final num? amount;
  final String? bankName;
  final String? bankNumber;
  final String? bookDate;
  final String? branchBankName;
  final num? cost;
  final int? memberId;
  final String? payRemark;
  final int? payStatus;
  final String? payTime;
  final String? withdrawDesc;
  final int? withdrawType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'withdrawId': withdrawId,
      'amount': amount,
      'bankName': _stringOrNull(bankName),
      'bankNumber': _stringOrNull(bankNumber),
      'bookDate': _stringOrNull(bookDate),
      'branchBankName': _stringOrNull(branchBankName),
      'cost': cost,
      'memberId': memberId,
      'payRemark': _stringOrNull(payRemark),
      'payStatus': payStatus,
      'payTime': _stringOrNull(payTime),
      'withdrawDesc': _stringOrNull(withdrawDesc),
      'withdrawType': withdrawType,
    }..removeWhere((_, dynamic value) => value == null);
  }
}

class UserWalletWithdrawRecordDto {
  const UserWalletWithdrawRecordDto({
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

  factory UserWalletWithdrawRecordDto.fromJson(Map<String, dynamic> json) {
    final payStatus = _intOrNull(json['payStatus'] ?? json['status']);
    return UserWalletWithdrawRecordDto(
      withdrawId: _stringOrNull(json['withdrawId'] ?? json['id']),
      memberId: _intOrNull(json['memberId']),
      processId: _stringOrNull(json['processId']),
      amount: _numOrNull(json['amount'] ?? json['applyAmount']),
      cost: _numOrNull(
        json['cost'] ?? json['serviceFee'] ?? json['withdrawCost'],
      ),
      withdrawType: _intOrNull(json['withdrawType']),
      applyTime: _stringOrNull(json['applyTime']),
      bookDate: _stringOrNull(json['bookDate'] ?? json['bookCrashDate']),
      bankNumber: _stringOrNull(json['bankNumber']),
      bankName: _stringOrNull(json['bankName']),
      bankBranch: _stringOrNull(
        json['branchName'] ?? json['bankBranch'] ?? json['branchBankName'],
      ),
      payStatus: payStatus,
      status: payStatus,
      remark: _stringOrNull(json['remark'] ?? json['payRemark']),
      payTime: _stringOrNull(json['payTime'] ?? json['confirmPayTime']),
      updateTime: _stringOrNull(json['updateTime']),
      createTime: _stringOrNull(json['createTime']),
    );
  }

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
