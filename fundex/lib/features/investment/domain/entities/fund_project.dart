import 'package:meta/meta.dart';

@immutable
class FundProject {
  const FundProject({
    required this.id,
    required this.projectName,
    this.expectedDistributionRatioMax,
    this.expectedDistributionRatioMin,
    this.distributionDate,
    this.investmentPeriod,
    this.scheduledStartDate,
    this.scheduledEndDate,
    this.offeringStartDatetime,
    this.offeringEndDatetime,
    this.typeOfOffering,
    this.offeringMethod,
    this.gainType,
    this.investmentUnit,
    this.maximumInvestmentPerPerson,
    this.achievementRate,
    this.amountApplication,
    this.currentlySubscribed,
    this.daysRemaining,
    this.projectStatus,
    this.operatingCompany,
    this.operatingCompanyAccount,
    this.periodType,
    this.times,
    this.accountId,
    this.detailData = const <String, Object?>{},
    this.photos = const <String>[],
    this.investorTypes = const <FundProjectInvestorType>[],
    this.pdfDocuments = const <FundProjectPdfDocument>[],
  });

  final String id;
  final String projectName;
  final double? expectedDistributionRatioMax;
  final double? expectedDistributionRatioMin;
  final String? distributionDate;
  final String? investmentPeriod;
  final String? scheduledStartDate;
  final String? scheduledEndDate;
  final String? offeringStartDatetime;
  final String? offeringEndDatetime;
  final String? typeOfOffering;
  final String? offeringMethod;
  final String? gainType;
  final int? investmentUnit;
  final int? maximumInvestmentPerPerson;
  final double? achievementRate;
  final int? amountApplication;
  final int? currentlySubscribed;
  final int? daysRemaining;
  final int? projectStatus;
  final String? operatingCompany;
  final int? operatingCompanyAccount;
  final String? periodType;
  final int? times;
  final String? accountId;
  final Map<String, Object?> detailData;
  final List<String> photos;
  final List<FundProjectInvestorType> investorTypes;
  final List<FundProjectPdfDocument> pdfDocuments;
}

@immutable
class FundProjectInvestorType {
  const FundProjectInvestorType({
    this.id,
    this.projectId,
    this.investorType,
    this.investorCode,
    this.earningsType,
    this.earningsRadio,
    this.interestRadio,
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
  final bool? isOpen;
  final int? isOpenType;
  final int? currentAmountApplication;
}

@immutable
class FundProjectPdfDocument {
  const FundProjectPdfDocument({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <FundProjectPdfUrl>[],
  });

  final String? projectId;
  final int? type;
  final String? description;
  final List<FundProjectPdfUrl> urls;
}

@immutable
class FundProjectPdfUrl {
  const FundProjectPdfUrl({this.name, this.url, this.createTime});

  final String? name;
  final String? url;
  final String? createTime;
}
