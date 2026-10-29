import '../statistics/statistics_wire_values.dart';

class AssetInvestmentDto {
  const AssetInvestmentDto({
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
  factory AssetInvestmentDto.fromJson(Map<String, dynamic> json) =>
      AssetInvestmentDto(
        projectId: readString(json['projectId']),
        projectName: readString(json['projectName']),
        projectStatus: readInteger(json['projectStatus']),
        investNumValid: readInteger(json['investNumValid']),
        investMoneyValid: readInteger(json['investMoneyValid']),
        beginDate: readString(json['beginDate']),
        endDate: readString(json['endDate']),
      );
}

class AssetInvestmentChartDto {
  const AssetInvestmentChartDto({this.investTotal, this.investList = const []});
  final int? investTotal;
  final List<AssetInvestmentDto> investList;
  factory AssetInvestmentChartDto.fromJson(Map<String, dynamic> json) =>
      AssetInvestmentChartDto(
        investTotal: readInteger(json['investTotal']),
        investList: readList(
          json['investList'],
          (value) => readObject(value, AssetInvestmentDto.fromJson),
        ),
      );
}

class AssetCumulativeBenefitDto {
  const AssetCumulativeBenefitDto({
    this.total,
    this.dates = const [],
    this.values = const [],
  });
  final int? total;
  final List<String> dates;
  final List<int> values;
  factory AssetCumulativeBenefitDto.fromJson(Map<String, dynamic> json) =>
      AssetCumulativeBenefitDto(
        total: readInteger(json['total']),
        dates: readList(json['dates'], readString),
        values: readList(json['values'], readInteger),
      );
}

class AssetExpectedBenefitDto {
  const AssetExpectedBenefitDto({
    this.yearMonth,
    this.expectBenefit,
    this.floatBenefit,
  });
  final String? yearMonth;
  final int? expectBenefit;
  final bool? floatBenefit;
  factory AssetExpectedBenefitDto.fromJson(Map<String, dynamic> json) =>
      AssetExpectedBenefitDto(
        yearMonth: readYearMonth(json['yearMonth']),
        expectBenefit: readInteger(json['expectBenefit']),
        floatBenefit: readBoolean(json['floatBenefit']),
      );
}

class AssetExpectedPrincipalDto {
  const AssetExpectedPrincipalDto({this.yearMonth, this.expectPrincipal});
  final String? yearMonth;
  final int? expectPrincipal;
  factory AssetExpectedPrincipalDto.fromJson(Map<String, dynamic> json) =>
      AssetExpectedPrincipalDto(
        yearMonth: readYearMonth(json['yearMonth']),
        expectPrincipal: readInteger(json['expectPrincipal']),
      );
}

class AssetBenefitForecastDto {
  const AssetBenefitForecastDto({
    this.expectBenefitList = const [],
    this.expectPrincipalList = const [],
  });
  final List<AssetExpectedBenefitDto> expectBenefitList;
  final List<AssetExpectedPrincipalDto> expectPrincipalList;
  factory AssetBenefitForecastDto.fromJson(Map<String, dynamic> json) =>
      AssetBenefitForecastDto(
        expectBenefitList: readList(
          json['expectBenefitList'],
          (value) => readObject(value, AssetExpectedBenefitDto.fromJson),
        ),
        expectPrincipalList: readList(
          json['expectPrincipalList'],
          (value) => readObject(value, AssetExpectedPrincipalDto.fromJson),
        ),
      );
}

class AssetYearlyBenefitDto {
  const AssetYearlyBenefitDto({
    this.year,
    this.totalBenefit,
    this.totalTax,
    this.actualBenefit,
  });
  final int? year;
  final int? totalBenefit;
  final int? totalTax;
  final int? actualBenefit;
  factory AssetYearlyBenefitDto.fromJson(Map<String, dynamic> json) =>
      AssetYearlyBenefitDto(
        year: readInteger(json['year']),
        totalBenefit: readInteger(json['totalBenefit']),
        totalTax: readInteger(json['totalTax']),
        actualBenefit: readInteger(json['actualBenefit']),
      );
}
