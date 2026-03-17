class MyPageInvestorType {
  const MyPageInvestorType({
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
  });

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
}

class MyPagePdfUrl {
  const MyPagePdfUrl({this.name, this.url, this.createTime});

  final String? name;
  final String? url;
  final String? createTime;
}

class MyPagePdfDocument {
  const MyPagePdfDocument({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <MyPagePdfUrl>[],
  });

  final String? projectId;
  final int? type;
  final String? description;
  final List<MyPagePdfUrl> urls;
}

class MyPageApplyRecord {
  const MyPageApplyRecord({
    this.projectId,
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
    this.investNum,
    this.investMoney,
    this.processId,
    this.serviceFee,
  });

  final String? projectId;
  final String? secondaryMarketSellId;
  final String? fromProcessId;
  final String? investorCode;
  final MyPageInvestorType? investorType;
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
  final int? investNum;
  final num? investMoney;
  final String? processId;
  final num? serviceFee;
}

class MyPageOrderInquiryRecord {
  const MyPageOrderInquiryRecord({
    this.id,
    this.memberId,
    this.fromProcessId,
    this.investorType,
    required this.projectName,
    this.sellNum,
    this.soldNum,
    this.price,
    this.status,
    this.createTime,
    this.updateTime,
    this.pdfDocuments = const <MyPagePdfDocument>[],
  });

  final String? id;
  final int? memberId;
  final String? fromProcessId;
  final MyPageInvestorType? investorType;
  final String projectName;
  final int? sellNum;
  final int? soldNum;
  final num? price;
  final String? status;
  final String? createTime;
  final String? updateTime;
  final List<MyPagePdfDocument> pdfDocuments;
}

class MyPageInvestmentRecord {
  const MyPageInvestmentRecord({
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
  final MyPageInvestorType? investorType;
}

class MyPageBenefitDetail {
  const MyPageBenefitDetail({
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

class MyPageProjectBenefit {
  const MyPageProjectBenefit({
    this.projectName,
    this.balanceTotal,
    this.details = const <MyPageBenefitDetail>[],
  });

  final String? projectName;
  final num? balanceTotal;
  final List<MyPageBenefitDetail> details;
}

class MyPageAccountStatistic {
  const MyPageAccountStatistic({
    this.userId,
    this.total,
    this.crowdfundingTotal,
    this.financialTotal,
    this.firstLevelAccountTotal,
  });

  final int? userId;
  final num? total;
  final num? crowdfundingTotal;
  final num? financialTotal;
  final num? firstLevelAccountTotal;
}
