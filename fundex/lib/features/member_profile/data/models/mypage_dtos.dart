export 'package:company_api_runtime/company_api_runtime.dart'
    show
        UserInvestmentAccountStatisticDto,
        UserInvestmentApplyRecordDto,
        UserInvestmentInvestorTypeDto,
        UserInvestmentBenefitDetailDto,
        UserInvestmentOrderInquiryApplyResultDto,
        UserInvestmentOrderInquiryRecordDto,
        UserInvestmentPdfDocumentDto,
        UserInvestmentProjectBenefitDto,
        UserInvestmentPdfUrlDto,
        UserInvestmentRecordDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show
        UserInvestmentAccountStatisticDto,
        UserInvestmentApplyRecordDto,
        UserInvestmentInvestorTypeDto,
        UserInvestmentBenefitDetailDto,
        UserInvestmentOrderInquiryApplyResultDto,
        UserInvestmentOrderInquiryRecordDto,
        UserInvestmentPdfDocumentDto,
        UserInvestmentProjectBenefitDto,
        UserInvestmentPdfUrlDto,
        UserInvestmentRecordDto;

import '../../domain/entities/mypage_models.dart';

typedef MyPageAccountStatisticDto = UserInvestmentAccountStatisticDto;
typedef MyPageApplyRecordDto = UserInvestmentApplyRecordDto;
typedef MyPageInvestmentRecordDto = UserInvestmentRecordDto;
typedef MyPageInvestorTypeDto = UserInvestmentInvestorTypeDto;
typedef MyPageBenefitDetailDto = UserInvestmentBenefitDetailDto;
typedef MyPageProjectBenefitDto = UserInvestmentProjectBenefitDto;
typedef MyPageOrderInquiryRecordDto = UserInvestmentOrderInquiryRecordDto;
typedef MyPageOrderInquiryApplyResultDto =
    UserInvestmentOrderInquiryApplyResultDto;
typedef MyPagePdfDocumentDto = UserInvestmentPdfDocumentDto;
typedef MyPagePdfUrlDto = UserInvestmentPdfUrlDto;

extension MyPageAccountStatisticDtoMapper on MyPageAccountStatisticDto {
  MyPageAccountStatistic toEntity() {
    return MyPageAccountStatistic(
      userId: userId,
      total: total,
      crowdfundingTotal: crowdfundingTotal,
      crowdfundingDistributedBenefit: crowdfundingDistributedBenefit,
      financialTotal: financialTotal,
      firstLevelAccountTotal: firstLevelAccountTotal,
      takingAmt: takingAmt,
      takingFee: takingFee,
    );
  }
}

extension MyPageInvestorTypeDtoMapper on MyPageInvestorTypeDto {
  MyPageInvestorType toEntity() {
    return MyPageInvestorType(
      id: id,
      projectId: projectId,
      investorType: investorType,
      investorCode: investorCode,
      earningsType: earningsType,
      earningsRadio: earningsRadio,
      interestRadio: interestRadio,
      remark: remark,
      isOpen: isOpen,
      isOpenType: isOpenType,
      currentAmountApplication: currentAmountApplication,
    );
  }
}

extension MyPagePdfUrlDtoMapper on MyPagePdfUrlDto {
  MyPagePdfUrl toEntity() {
    return MyPagePdfUrl(name: name, url: url, createTime: createTime);
  }
}

extension MyPagePdfDocumentDtoMapper on MyPagePdfDocumentDto {
  MyPagePdfDocument toEntity() {
    return MyPagePdfDocument(
      projectId: projectId,
      type: type,
      description: description,
      urls: urls
          .map((MyPagePdfUrlDto item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

extension MyPageApplyRecordDtoMapper on MyPageApplyRecordDto {
  MyPageApplyRecord toEntity() {
    return MyPageApplyRecord(
      projectId: projectId,
      projectRuleId: projectRuleId,
      secondaryMarketSellId: secondaryMarketSellId,
      fromProcessId: fromProcessId,
      investorCode: investorCode,
      investorType: investorType?.toEntity(),
      projectName: projectName,
      memberId: memberId,
      accountId: accountId,
      memberName: memberName,
      status: status,
      applyNum: applyNum,
      applyMoney: applyMoney,
      feeRatio: feeRatio,
      sellerFeeRatio: sellerFeeRatio,
      applyTime: applyTime,
      passNum: passNum,
      passMoney: passMoney,
      passTime: passTime,
      actualArrivalTime: actualArrivalTime,
      settlementDate: settlementDate,
      paymentExpiryDate: paymentExpiryDate,
      investNum: investNum,
      investMoney: investMoney,
      processId: processId,
      serviceFee: serviceFee,
    );
  }
}

extension MyPageOrderInquiryApplyResultDtoMapper
    on MyPageOrderInquiryApplyResultDto {
  MyPageOrderInquiryApplyResult toEntity() {
    return MyPageOrderInquiryApplyResult(
      processId: processId,
      investorType: investorType,
      memberId: memberId,
      projectId: projectId,
      projectRuleId: projectRuleId,
      serviceFee: serviceFee,
      sellerServiceFee: sellerServiceFee,
      investNum: investNum,
      investMoney: investMoney,
      investNumValid: investNumValid,
      investMoneyValid: investMoneyValid,
      status: status,
      checkTimes: checkTimes,
      createTime: createTime,
      withdrawalTime: withdrawalTime,
    );
  }
}

extension MyPageOrderInquiryRecordDtoMapper on MyPageOrderInquiryRecordDto {
  MyPageOrderInquiryRecord toEntity() {
    return MyPageOrderInquiryRecord(
      id: id,
      memberId: memberId,
      fromProcessId: fromProcessId,
      investorType: investorType?.toEntity(),
      projectId: projectId,
      projectName: projectName,
      sellNum: sellNum,
      soldNum: soldNum,
      price: price,
      status: status,
      createTime: createTime,
      updateTime: updateTime,
      pdfDocuments: pdfDocuments
          .map((MyPagePdfDocumentDto item) => item.toEntity())
          .toList(growable: false),
      applyList: applyList
          .map((MyPageApplyRecordDto item) => item.toEntity())
          .toList(growable: false),
      applyResultList: applyResultList
          .map((MyPageOrderInquiryApplyResultDto item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

extension MyPageInvestmentRecordDtoMapper on MyPageInvestmentRecordDto {
  MyPageInvestmentRecord toEntity() {
    return MyPageInvestmentRecord(
      projectId: projectId,
      projectName: projectName,
      processId: processId,
      investNum: investNum,
      investMoney: investMoney,
      investNumValid: investNumValid,
      investMoneyValid: investMoneyValid,
      investNumRemaining: investNumRemaining,
      status: status,
      projectStatus: projectStatus,
      createTime: createTime,
      withdrawalTime: withdrawalTime,
      investorCode: investorCode,
      earningType: earningType,
      earningRadio: earningRadio,
      remark: remark,
      memberId: memberId,
      accountId: accountId,
      memberName: memberName,
      earnings: earnings,
      checkTimes: checkTimes,
      investorType: investorType?.toEntity(),
    );
  }
}

extension MyPageBenefitDetailDtoMapper on MyPageBenefitDetailDto {
  MyPageBenefitDetail toEntity() {
    return MyPageBenefitDetail(
      id: id,
      projectId: projectId,
      processId: processId,
      projectName: projectName,
      headerId: headerId,
      seq: seq,
      type: type,
      benefit: benefit,
      tax: tax,
      withdrawalTime: withdrawalTime,
      remark: remark,
      createTime: createTime,
      benefitPeriodStartDate: benefitPeriodStartDate,
      benefitPeriodEndDate: benefitPeriodEndDate,
      memberId: memberId,
      investorType: investorType,
    );
  }
}

extension MyPageProjectBenefitDtoMapper on MyPageProjectBenefitDto {
  MyPageProjectBenefit toEntity() {
    return MyPageProjectBenefit(
      projectName: projectName,
      balanceTotal: balanceTotal,
      balanceTotalHistorical: balanceTotalHistorical,
      details: details
          .map((MyPageBenefitDetailDto item) => item.toEntity())
          .toList(growable: false),
    );
  }
}
