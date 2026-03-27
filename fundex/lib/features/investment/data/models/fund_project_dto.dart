export 'package:company_api_runtime/company_api_runtime.dart'
    show
        FundProjectDto,
        FundProjectInvestorTypeDto,
        FundProjectPdfDocumentDto,
        FundProjectPdfUrlDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show
        FundProjectDto,
        FundProjectInvestorTypeDto,
        FundProjectPdfDocumentDto,
        FundProjectPdfUrlDto;

import '../../domain/entities/fund_project.dart';

extension FundProjectDtoMapper on FundProjectDto {
  FundProject toEntity() {
    return FundProject(
      id: id,
      projectName: projectName,
      expectedDistributionRatioMax: expectedDistributionRatioMax,
      expectedDistributionRatioMin: expectedDistributionRatioMin,
      distributionDate: distributionDate,
      investmentPeriod: investmentPeriod,
      scheduledStartDate: scheduledStartDate,
      scheduledEndDate: scheduledEndDate,
      offeringStartDatetime: offeringStartDatetime,
      offeringEndDatetime: offeringEndDatetime,
      typeOfOffering: typeOfOffering,
      offeringMethod: offeringMethod,
      gainType: gainType,
      investmentUnit: investmentUnit,
      maximumInvestmentPerPerson: maximumInvestmentPerPerson,
      achievementRate: achievementRate,
      amountApplication: amountApplication,
      currentlySubscribed: currentlySubscribed,
      daysRemaining: daysRemaining,
      projectStatus: projectStatus,
      operatingCompany: operatingCompany,
      operatingCompanyAccount: operatingCompanyAccount,
      periodType: periodType,
      times: times,
      accountId: accountId,
      detailData: Map<String, Object?>.unmodifiable(detailData),
      photos: List<String>.unmodifiable(photos),
      investorTypes: List<FundProjectInvestorType>.unmodifiable(
        investorTypes.map((item) => item.toEntity()),
      ),
      pdfDocuments: List<FundProjectPdfDocument>.unmodifiable(
        pdfDocuments.map((item) => item.toEntity()),
      ),
    );
  }
}

extension FundProjectInvestorTypeDtoMapper on FundProjectInvestorTypeDto {
  FundProjectInvestorType toEntity() {
    return FundProjectInvestorType(
      id: id,
      projectId: projectId,
      investorType: investorType,
      investorCode: investorCode,
      earningsType: earningsType,
      earningsRadio: earningsRadio,
      interestRadio: interestRadio,
      isOpen: isOpen,
      isOpenType: isOpenType,
      currentAmountApplication: currentAmountApplication,
    );
  }
}

extension FundProjectPdfDocumentDtoMapper on FundProjectPdfDocumentDto {
  FundProjectPdfDocument toEntity() {
    return FundProjectPdfDocument(
      projectId: projectId,
      type: type,
      description: description,
      urls: List<FundProjectPdfUrl>.unmodifiable(
        urls.map((FundProjectPdfUrlDto item) => item.toEntity()),
      ),
    );
  }
}

extension FundProjectPdfUrlDtoMapper on FundProjectPdfUrlDto {
  FundProjectPdfUrl toEntity() {
    return FundProjectPdfUrl(name: name, url: url, createTime: createTime);
  }
}
