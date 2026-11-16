import '../entities/asset_statistics_models.dart';

abstract class AssetStatisticsRepository {
  Future<AssetInvestmentChart> fetchInvestments({required List<int> status});
  Future<AssetCumulativeBenefit> fetchCumulativeBenefit({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<AssetBenefitForecast> fetchForecast({required DateTime endYearMonth});
  Future<List<AssetYearlyBenefit>> fetchYearlyBenefits({
    required int startYear,
  });
}
