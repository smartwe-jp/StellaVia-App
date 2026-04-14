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
    this.liveJapanBank,
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
  final FundProjectLiveJapanBank? liveJapanBank;
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
class FundProjectLiveJapanBank {
  const FundProjectLiveJapanBank({
    this.id,
    this.bankType,
    this.relatedId,
    this.bankAccountOwnerName,
    this.bankAccountOwnerAddress,
    this.bankAccountOwnerNationality,
    this.bankAccountSwiftCode,
    this.bankName,
    this.branchBankName,
    this.branchBankAddress,
    this.bankCountry,
    this.branchBankNumber,
    this.bankNumber,
    this.bankAccountType,
    this.liveType,
  });

  final String? id;
  final int? bankType;
  final String? relatedId;
  final String? bankAccountOwnerName;
  final String? bankAccountOwnerAddress;
  final String? bankAccountOwnerNationality;
  final String? bankAccountSwiftCode;
  final String? bankName;
  final String? branchBankName;
  final String? branchBankAddress;
  final String? bankCountry;
  final String? branchBankNumber;
  final String? bankNumber;
  final String? bankAccountType;
  final int? liveType;
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
