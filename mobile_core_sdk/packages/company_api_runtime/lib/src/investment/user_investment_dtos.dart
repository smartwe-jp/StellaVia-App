class UserInvestmentAccountStatisticDto {
  const UserInvestmentAccountStatisticDto({
    this.userId,
    this.total,
    this.crowdfundingTotal,
    this.financialTotal,
    this.firstLevelAccountTotal,
  });

  factory UserInvestmentAccountStatisticDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserInvestmentAccountStatisticDto(
      userId: _intOrNull(json['userId']),
      total: _numOrNull(json['total']),
      crowdfundingTotal: _numOrNull(json['crowdfundingTotal']),
      financialTotal: _numOrNull(json['financialTotal']),
      firstLevelAccountTotal: _numOrNull(json['firstLevelAccountTotal']),
    );
  }

  final int? userId;
  final num? total;
  final num? crowdfundingTotal;
  final num? financialTotal;
  final num? firstLevelAccountTotal;
}

class UserInvestmentInvestorTypeDto {
  const UserInvestmentInvestorTypeDto({
    this.id,
    this.projectId,
    this.investorType,
    this.investorCode,
    this.earningsType,
    this.earningsRadio,
    this.interestRadio,
    this.remark,
    this.isOpen,
    this.isOpenType,
    this.currentAmountApplication,
  });

  factory UserInvestmentInvestorTypeDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentInvestorTypeDto(
      id: _stringOrNull(json['id']),
      projectId: _stringOrNull(json['projectId']),
      investorType: _stringOrNull(json['investorType']),
      investorCode: _stringOrNull(json['investorCode']),
      earningsType: _stringOrNull(json['earningsType']),
      earningsRadio: _doubleOrNull(json['earningsRadio']),
      interestRadio: _doubleOrNull(json['interestRadio']),
      remark: _stringOrNull(json['remark']),
      isOpen: _boolOrNull(json['isOpen']),
      isOpenType: _intOrNull(json['isOpenType']),
      currentAmountApplication: _intOrNull(json['currentAmountApplication']),
    );
  }

  final String? id;
  final String? projectId;
  final String? investorType;
  final String? investorCode;
  final String? earningsType;
  final double? earningsRadio;
  final double? interestRadio;
  final String? remark;
  final bool? isOpen;
  final int? isOpenType;
  final int? currentAmountApplication;
}

class UserInvestmentPdfUrlDto {
  const UserInvestmentPdfUrlDto({this.name, this.url, this.createTime});

  factory UserInvestmentPdfUrlDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentPdfUrlDto(
      name: _stringOrNull(json['name']),
      url: _stringOrNull(json['url']),
      createTime: _stringOrNull(json['createTime']),
    );
  }

  final String? name;
  final String? url;
  final String? createTime;
}

class UserInvestmentPdfDocumentDto {
  const UserInvestmentPdfDocumentDto({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <UserInvestmentPdfUrlDto>[],
  });

  factory UserInvestmentPdfDocumentDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentPdfDocumentDto(
      projectId: _stringOrNull(json['projectId']),
      type: _intOrNull(json['type']),
      description: _stringOrNull(json['desc']),
      urls: _toList(json['urls'])
          .map((dynamic item) {
            if (item is String) {
              return UserInvestmentPdfUrlDto(url: item);
            }
            return UserInvestmentPdfUrlDto.fromJson(_toJsonMap(item));
          })
          .toList(growable: false),
    );
  }

  final String? projectId;
  final int? type;
  final String? description;
  final List<UserInvestmentPdfUrlDto> urls;
}

class UserInvestmentApplyRecordDto {
  const UserInvestmentApplyRecordDto({
    this.projectId,
    this.projectRuleId,
    this.secondaryMarketSellId,
    this.fromProcessId,
    this.investorCode,
    this.investorType,
    required this.projectName,
    this.memberId,
    this.accountId,
    this.memberName,
    this.status,
    this.applyNum,
    this.applyMoney,
    this.feeRatio,
    this.sellerFeeRatio,
    this.applyTime,
    this.passNum,
    this.passMoney,
    this.passTime,
    this.actualArrivalTime,
    this.settlementDate,
    this.paymentExpiryDate,
    this.investNum,
    this.investMoney,
    this.processId,
    this.serviceFee,
  });

  factory UserInvestmentApplyRecordDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentApplyRecordDto(
      projectId:
          _stringOrNull(json['projectId']) ?? _stringOrNull(json['projecId']),
      projectRuleId: _stringOrNull(json['projectRuleId']),
      secondaryMarketSellId: _stringOrNull(json['secondaryMarketSellId']),
      fromProcessId: _stringOrNull(json['fromProcessId']),
      investorCode: _stringOrNull(json['investorCode']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : UserInvestmentInvestorTypeDto.fromJson(
              _toJsonMap(json['investorType']),
            ),
      projectName: _stringOrNull(json['projectName']) ?? '',
      memberId: _intOrNull(json['memberId']),
      accountId: _stringOrNull(json['accountId']),
      memberName: _stringOrNull(json['memberName']),
      status: _intOrNull(json['status']),
      applyNum: _intOrNull(json['applyNum']),
      applyMoney: _numOrNull(json['applyMoney']),
      feeRatio: _doubleOrNull(json['feeRatio']),
      sellerFeeRatio: _doubleOrNull(json['sellerFeeRatio']),
      applyTime: _dateTimeOrNull(json['applyTime']),
      passNum: _intOrNull(json['passNum']),
      passMoney: _numOrNull(json['passMoney']),
      passTime: _dateTimeOrNull(json['passTime']),
      actualArrivalTime: _dateTimeOrNull(json['actualArrivalTime']),
      settlementDate: _dateTimeOrNull(json['settlementDate']),
      paymentExpiryDate: _dateTimeOrNull(json['paymentExpiryDate']),
      investNum: _intOrNull(json['investNum']),
      investMoney: _numOrNull(json['investMoney']),
      processId: _stringOrNull(json['processId']),
      serviceFee: _numOrNull(json['serviceFee']),
    );
  }

  final String? projectId;
  final String? projectRuleId;
  final String? secondaryMarketSellId;
  final String? fromProcessId;
  final String? investorCode;
  final UserInvestmentInvestorTypeDto? investorType;
  final String projectName;
  final int? memberId;
  final String? accountId;
  final String? memberName;
  final int? status;
  final int? applyNum;
  final num? applyMoney;
  final double? feeRatio;
  final double? sellerFeeRatio;
  final String? applyTime;
  final int? passNum;
  final num? passMoney;
  final String? passTime;
  final String? actualArrivalTime;
  final String? settlementDate;
  final String? paymentExpiryDate;
  final int? investNum;
  final num? investMoney;
  final String? processId;
  final num? serviceFee;
}

class UserInvestmentOrderInquiryApplyResultDto {
  const UserInvestmentOrderInquiryApplyResultDto({
    this.processId,
    this.investorType,
    this.memberId,
    this.projectId,
    this.projectRuleId,
    this.serviceFee,
    this.sellerServiceFee,
    this.investNum,
    this.investMoney,
    this.investNumValid,
    this.investMoneyValid,
    this.status,
    this.checkTimes,
    this.createTime,
    this.withdrawalTime,
  });

  factory UserInvestmentOrderInquiryApplyResultDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserInvestmentOrderInquiryApplyResultDto(
      processId: _stringOrNull(json['processId']),
      investorType: _stringOrNull(json['investorType']),
      memberId: _intOrNull(json['memberId']),
      projectId: _stringOrNull(json['projectId']),
      projectRuleId: _stringOrNull(json['projectRuleId']),
      serviceFee: _numOrNull(json['serviceFee']),
      sellerServiceFee: _numOrNull(json['sellerServiceFee']),
      investNum: _intOrNull(json['investNum']),
      investMoney: _numOrNull(json['investMoney']),
      investNumValid: _intOrNull(json['investNumValid']),
      investMoneyValid: _numOrNull(json['investMoneyValid']),
      status: _intOrNull(json['status']),
      checkTimes: _intOrNull(json['checkTimes']),
      createTime: _dateTimeOrNull(json['createTime']),
      withdrawalTime: _dateTimeOrNull(json['withdrawalTime']),
    );
  }

  final String? processId;
  final String? investorType;
  final int? memberId;
  final String? projectId;
  final String? projectRuleId;
  final num? serviceFee;
  final num? sellerServiceFee;
  final int? investNum;
  final num? investMoney;
  final int? investNumValid;
  final num? investMoneyValid;
  final int? status;
  final int? checkTimes;
  final String? createTime;
  final String? withdrawalTime;
}

class UserInvestmentOrderInquiryRecordDto {
  const UserInvestmentOrderInquiryRecordDto({
    this.id,
    this.memberId,
    this.fromProcessId,
    this.investorType,
    this.projectId,
    required this.projectName,
    this.sellNum,
    this.soldNum,
    this.price,
    this.status,
    this.createTime,
    this.updateTime,
    this.pdfDocuments = const <UserInvestmentPdfDocumentDto>[],
    this.applyList = const <UserInvestmentApplyRecordDto>[],
    this.applyResultList = const <UserInvestmentOrderInquiryApplyResultDto>[],
  });

  factory UserInvestmentOrderInquiryRecordDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserInvestmentOrderInquiryRecordDto(
      id: _stringOrNull(json['id']),
      memberId: _intOrNull(json['memberId']),
      fromProcessId: _stringOrNull(json['fromProcessId']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : UserInvestmentInvestorTypeDto.fromJson(
              _toJsonMap(json['investorType']),
            ),
      projectId: _stringOrNull(json['projectId']),
      projectName: _stringOrNull(json['projectName']) ?? '',
      sellNum: _intOrNull(json['sellNum']),
      soldNum: _intOrNull(json['soldNum']),
      price: _numOrNull(json['price']),
      status: _stringOrNull(json['status']),
      createTime: _dateTimeOrNull(json['createTime']),
      updateTime: _dateTimeOrNull(json['updateTime']),
      pdfDocuments: _toList(json['pdfs'])
          .map(
            (dynamic item) =>
                UserInvestmentPdfDocumentDto.fromJson(_toJsonMap(item)),
          )
          .toList(growable: false),
      applyList: _toList(json['applyList'])
          .map(
            (dynamic item) =>
                UserInvestmentApplyRecordDto.fromJson(_toJsonMap(item)),
          )
          .toList(growable: false),
      applyResultList: _toList(json['applyResultList'])
          .map(
            (dynamic item) => UserInvestmentOrderInquiryApplyResultDto.fromJson(
              _toJsonMap(item),
            ),
          )
          .toList(growable: false),
    );
  }

  final String? id;
  final int? memberId;
  final String? fromProcessId;
  final UserInvestmentInvestorTypeDto? investorType;
  final String? projectId;
  final String projectName;
  final int? sellNum;
  final int? soldNum;
  final num? price;
  final String? status;
  final String? createTime;
  final String? updateTime;
  final List<UserInvestmentPdfDocumentDto> pdfDocuments;
  final List<UserInvestmentApplyRecordDto> applyList;
  final List<UserInvestmentOrderInquiryApplyResultDto> applyResultList;
}

class UserInvestmentRecordDto {
  const UserInvestmentRecordDto({
    required this.projectId,
    required this.projectName,
    this.processId,
    this.investNum,
    this.investMoney,
    this.investNumValid,
    this.investMoneyValid,
    this.investNumRemaining,
    this.status,
    this.projectStatus,
    this.createTime,
    this.withdrawalTime,
    this.investorCode,
    this.earningType,
    this.earningRadio,
    this.remark,
    this.memberId,
    this.accountId,
    this.memberName,
    this.earnings,
    this.checkTimes,
    this.investorType,
  });

  factory UserInvestmentRecordDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentRecordDto(
      projectId: _stringOrNull(json['projectId']) ?? '',
      projectName: _stringOrNull(json['projectName']) ?? '',
      processId: _stringOrNull(json['processId']),
      investNum: _intOrNull(json['investNum']),
      investMoney: _numOrNull(json['investMoney']),
      investNumValid: _intOrNull(json['investNumValid']),
      investMoneyValid: _numOrNull(json['investMoneyValid']),
      investNumRemaining: _intOrNull(json['investNumRemaining']),
      status: _intOrNull(json['status']),
      projectStatus: _intOrNull(json['projectStatus']),
      createTime: _stringOrNull(json['createTime']),
      withdrawalTime: _stringOrNull(json['withdrawalTime']),
      investorCode: _stringOrNull(json['investorCode']),
      earningType: _stringOrNull(json['earningType']),
      earningRadio: _doubleOrNull(json['earningRadio']),
      remark: _stringOrNull(json['remark']),
      memberId: _intOrNull(json['memberId']),
      accountId: _stringOrNull(json['accountId']),
      memberName: _stringOrNull(json['memberName']),
      earnings: _numOrNull(json['earnings']),
      checkTimes: _intOrNull(json['checkTimes']),
      investorType: _toNullableJsonMap(json['investorType']) == null
          ? null
          : UserInvestmentInvestorTypeDto.fromJson(
              _toJsonMap(json['investorType']),
            ),
    );
  }

  final String projectId;
  final String projectName;
  final String? processId;
  final int? investNum;
  final num? investMoney;
  final int? investNumValid;
  final num? investMoneyValid;
  final int? investNumRemaining;
  final int? status;
  final int? projectStatus;
  final String? createTime;
  final String? withdrawalTime;
  final String? investorCode;
  final String? earningType;
  final double? earningRadio;
  final String? remark;
  final int? memberId;
  final String? accountId;
  final String? memberName;
  final num? earnings;
  final int? checkTimes;
  final UserInvestmentInvestorTypeDto? investorType;
}

class UserInvestmentBenefitDetailDto {
  const UserInvestmentBenefitDetailDto({
    this.id,
    this.projectId,
    this.processId,
    this.projectName,
    this.headerId,
    this.seq,
    this.type,
    this.benefit,
    this.tax,
    this.withdrawalTime,
    this.remark,
    this.createTime,
    this.benefitPeriodStartDate,
    this.benefitPeriodEndDate,
    this.memberId,
    this.investorType,
  });

  factory UserInvestmentBenefitDetailDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentBenefitDetailDto(
      id: _stringOrNull(json['id']),
      projectId: _stringOrNull(json['projectId']),
      processId: _stringOrNull(json['processId']),
      projectName: _stringOrNull(json['projectName']),
      headerId: _stringOrNull(json['headerId']),
      seq: _intOrNull(json['seq']),
      type: _intOrNull(json['type']),
      benefit: _numOrNull(json['benefit']),
      tax: _numOrNull(json['tax']),
      withdrawalTime: _stringOrNull(json['withdrawalTime']),
      remark: _stringOrNull(json['remark']),
      createTime: _stringOrNull(json['createTime']),
      benefitPeriodStartDate: _stringOrNull(json['benefitPeriodStartDate']),
      benefitPeriodEndDate: _stringOrNull(json['benefitPeriodEndDate']),
      memberId: _intOrNull(json['memberId']),
      investorType: _stringOrNull(json['investorType']),
    );
  }

  final String? id;
  final String? projectId;
  final String? processId;
  final String? projectName;
  final String? headerId;
  final int? seq;
  final int? type;
  final num? benefit;
  final num? tax;
  final String? withdrawalTime;
  final String? remark;
  final String? createTime;
  final String? benefitPeriodStartDate;
  final String? benefitPeriodEndDate;
  final int? memberId;
  final String? investorType;
}

class UserInvestmentProjectBenefitDto {
  const UserInvestmentProjectBenefitDto({
    this.projectName,
    this.balanceTotal,
    this.details = const <UserInvestmentBenefitDetailDto>[],
  });

  factory UserInvestmentProjectBenefitDto.fromJson(Map<String, dynamic> json) {
    return UserInvestmentProjectBenefitDto(
      projectName: _stringOrNull(json['projectName']),
      balanceTotal: _numOrNull(json['balanceTotal']),
      details: _toList(json['details'])
          .map(
            (dynamic item) =>
                UserInvestmentBenefitDetailDto.fromJson(_toJsonMap(item)),
          )
          .toList(growable: false),
    );
  }

  final String? projectName;
  final num? balanceTotal;
  final List<UserInvestmentBenefitDetailDto> details;
}

Map<String, dynamic> _toJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  return <String, dynamic>{};
}

Map<String, dynamic>? _toNullableJsonMap(dynamic data) {
  final map = _toJsonMap(data);
  return map.isEmpty ? null : map;
}

List<dynamic> _toList(dynamic data) {
  if (data is List) {
    return data;
  }
  return const <dynamic>[];
}

String? _stringOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _intOrNull(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}

double? _doubleOrNull(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value == null) {
    return null;
  }
  return double.tryParse(value.toString());
}

num? _numOrNull(Object? value) {
  if (value is num) {
    return value;
  }
  if (value == null) {
    return null;
  }
  return num.tryParse(value.toString());
}

bool? _boolOrNull(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value == null) {
    return null;
  }
  final text = value.toString().toLowerCase();
  if (text == 'true') {
    return true;
  }
  if (text == 'false') {
    return false;
  }
  return null;
}

String? _dateTimeOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    final absolute = value.abs();
    final milliseconds = absolute < 100000000000
        ? value.toInt() * 1000
        : value.toInt();
    return _formatApiDateTime(
      DateTime.fromMillisecondsSinceEpoch(milliseconds),
    );
  }

  final map = _toNullableJsonMap(value);
  if (map != null) {
    final year = _intOrNull(map['year']);
    final month =
        _intOrNull(map['monthValue']) ??
        _monthNameToNumber(_stringOrNull(map['month']));
    final day = _intOrNull(map['dayOfMonth']);
    if (year != null && month != null && day != null) {
      final dateTime = DateTime(
        year,
        month,
        day,
        _intOrNull(map['hour']) ?? 0,
        _intOrNull(map['minute']) ?? 0,
        _intOrNull(map['second']) ?? 0,
      );
      return _formatApiDateTime(dateTime);
    }
    return null;
  }

  return _stringOrNull(value);
}

int? _monthNameToNumber(String? value) {
  switch (value?.trim().toUpperCase()) {
    case 'JANUARY':
      return 1;
    case 'FEBRUARY':
      return 2;
    case 'MARCH':
      return 3;
    case 'APRIL':
      return 4;
    case 'MAY':
      return 5;
    case 'JUNE':
      return 6;
    case 'JULY':
      return 7;
    case 'AUGUST':
      return 8;
    case 'SEPTEMBER':
      return 9;
    case 'OCTOBER':
      return 10;
    case 'NOVEMBER':
      return 11;
    case 'DECEMBER':
      return 12;
  }
  return null;
}

String _formatApiDateTime(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  final second = value.second.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute:$second';
}
