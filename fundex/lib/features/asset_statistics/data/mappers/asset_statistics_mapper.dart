import 'package:company_api_runtime/company_api_runtime.dart';
import '../../domain/entities/asset_statistics_models.dart';

extension AssetInvestmentMapping on AssetInvestmentDto {
  AssetInvestment toEntity() {
    return AssetInvestment(
      projectId: projectId,
      projectName: projectName,
      projectStatus: projectStatus,
      investNumValid: investNumValid,
      investMoneyValid: investMoneyValid,
      beginDate: beginDate,
      endDate: endDate,
    );
  }
}

extension AssetInvestmentChartMapping on AssetInvestmentChartDto {
  AssetInvestmentChart toEntity() {
    return AssetInvestmentChart(
      investTotal: investTotal,
      investList: List.unmodifiable(investList.map((item) => item.toEntity())),
    );
  }
}

extension AssetCumulativeBenefitMapping on AssetCumulativeBenefitDto {
  AssetCumulativeBenefit toEntity() {
    if (dates.length != values.length) {
      throw const FormatException('Chart axes have different lengths.');
    }
    return AssetCumulativeBenefit(
      total: total,
      dates: List.unmodifiable(dates),
      values: List.unmodifiable(values),
    );
  }
}

extension AssetExpectedBenefitMapping on AssetExpectedBenefitDto {
  AssetExpectedBenefit toEntity() {
    return AssetExpectedBenefit(
      yearMonth: yearMonth,
      expectBenefit: expectBenefit,
      floatBenefit: floatBenefit,
    );
  }
}

extension AssetExpectedPrincipalMapping on AssetExpectedPrincipalDto {
  AssetExpectedPrincipal toEntity() {
    return AssetExpectedPrincipal(
      yearMonth: yearMonth,
      expectPrincipal: expectPrincipal,
    );
  }
}

extension AssetBenefitForecastMapping on AssetBenefitForecastDto {
  AssetBenefitForecast toEntity() {
    return AssetBenefitForecast(
      expectBenefitList: List.unmodifiable(
        expectBenefitList.map((item) => item.toEntity()),
      ),
      expectPrincipalList: List.unmodifiable(
        expectPrincipalList.map((item) => item.toEntity()),
      ),
    );
  }
}

extension AssetYearlyBenefitMapping on AssetYearlyBenefitDto {
  AssetYearlyBenefit toEntity() {
    return AssetYearlyBenefit(
      year: year,
      totalBenefit: totalBenefit,
      totalTax: totalTax,
      actualBenefit: actualBenefit,
    );
  }
}
