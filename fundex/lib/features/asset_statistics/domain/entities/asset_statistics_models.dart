class AssetInvestment {
  const AssetInvestment({
    this.projectId,
    this.projectName,
    this.projectStatus,
    this.investNumValid,
    this.investMoneyValid,
    this.beginDate,
    this.endDate,
  });
  final String? projectId;
  final String? projectName;
  final int? projectStatus;
  final int? investNumValid;
  final int? investMoneyValid;
  final String? beginDate;
  final String? endDate;
}

class AssetInvestmentChart {
  const AssetInvestmentChart({this.investTotal, this.investList = const []});
  final int? investTotal;
  final List<AssetInvestment> investList;
}

class AssetCumulativeBenefit {
  const AssetCumulativeBenefit({
    this.total,
    this.dates = const [],
    this.values = const [],
  });
  final int? total;
  final List<String> dates;
  final List<int> values;
}

class AssetExpectedBenefit {
  const AssetExpectedBenefit({
    this.yearMonth,
    this.expectBenefit,
    this.floatBenefit,
  });
  final String? yearMonth;
  final int? expectBenefit;
  final bool? floatBenefit;
}

class AssetExpectedPrincipal {
  const AssetExpectedPrincipal({this.yearMonth, this.expectPrincipal});
  final String? yearMonth;
  final int? expectPrincipal;
}

class AssetBenefitForecast {
  const AssetBenefitForecast({
    this.expectBenefitList = const [],
    this.expectPrincipalList = const [],
  });
  final List<AssetExpectedBenefit> expectBenefitList;
  final List<AssetExpectedPrincipal> expectPrincipalList;
}

class AssetYearlyBenefit {
  const AssetYearlyBenefit({
    this.year,
    this.totalBenefit,
    this.totalTax,
    this.actualBenefit,
  });
  final int? year;
  final int? totalBenefit;
  final int? totalTax;
  final int? actualBenefit;
}
