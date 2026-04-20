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
    this.currentAmountApplication,
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
  final int? currentAmountApplication;
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

  final String? projectId;
  final String? projectRuleId;
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
  final String? settlementDate;
  final String? paymentExpiryDate;
  final int? investNum;
  final num? investMoney;
  final String? processId;
  final num? serviceFee;
}

class MyPageOrderInquiryApplyResult {
  const MyPageOrderInquiryApplyResult({
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

class MyPageOrderInquiryRecord {
  const MyPageOrderInquiryRecord({
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
    this.pdfDocuments = const <MyPagePdfDocument>[],
    this.applyList = const <MyPageApplyRecord>[],
    this.applyResultList = const <MyPageOrderInquiryApplyResult>[],
  });

  final String? id;
  final int? memberId;
  final String? fromProcessId;
  final MyPageInvestorType? investorType;
  final String? projectId;
  final String projectName;
  final int? sellNum;
  final int? soldNum;
  final num? price;
  final String? status;
  final String? createTime;
  final String? updateTime;
  final List<MyPagePdfDocument> pdfDocuments;
  final List<MyPageApplyRecord> applyList;
  final List<MyPageOrderInquiryApplyResult> applyResultList;
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
    this.balanceTotalHistorical,
    this.details = const <MyPageBenefitDetail>[],
  });

  final String? projectName;
  final num? balanceTotal;
  final num? balanceTotalHistorical;
  final List<MyPageBenefitDetail> details;
}

class MyPageAccountStatistic {
  const MyPageAccountStatistic({
    this.userId,
    this.total,
    this.crowdfundingTotal,
    this.crowdfundingDistributedBenefit,
    this.financialTotal,
    this.firstLevelAccountTotal,
    this.takingAmt,
    this.takingFee,
    this.lockedFee,
    this.lockedList = const <MyPageLockedAmount>[],
  });

  final int? userId;
  final num? total;
  final num? crowdfundingTotal;
  final num? crowdfundingDistributedBenefit;
  final num? financialTotal;
  final num? firstLevelAccountTotal;
  final num? takingAmt;
  final num? takingFee;
  final num? lockedFee;
  final List<MyPageLockedAmount> lockedList;

  num? get withdrawableAmount {
    final total = firstLevelAccountTotal;
    if (total == null) {
      return null;
    }
    final locked = lockedFee ?? 0;
    final remaining = total - locked;
    return remaining < 0 ? 0 : remaining;
  }
}

class MyPageAssetTrend {
  const MyPageAssetTrend({
    this.recordDate,
    this.totalAccount,
    this.totalFirstLevelAccount,
    this.totalFundAccount,
  });

  final String? recordDate;
  final num? totalAccount;
  final num? totalFirstLevelAccount;
  final num? totalFundAccount;
}

class MyPageLockedAmount {
  const MyPageLockedAmount({
    this.userId,
    this.lockedAmount,
    this.lockedReason,
    this.startLockedTime,
    this.lockExpireTime,
  });

  final int? userId;
  final num? lockedAmount;
  final String? lockedReason;
  final String? startLockedTime;
  final String? lockExpireTime;
}
