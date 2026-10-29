import 'package:company_api_runtime/company_api_runtime.dart';

class AssetStatisticsRemoteDataSource {
  const AssetStatisticsRemoteDataSource(this._api);
  final AssetStatisticsApiClient _api;
  Future<AssetInvestmentChartDto> fetchInvestments() => _api.fetchInvestments();
  Future<AssetCumulativeBenefitDto> fetchCumulativeBenefit({
    required DateTime startDate,
    required DateTime endDate,
  }) => _api.fetchCumulativeBenefit(startDate: startDate, endDate: endDate);
  Future<AssetBenefitForecastDto> fetchForecast({
    required DateTime endYearMonth,
  }) => _api.fetchForecast(endYearMonth: endYearMonth);
  Future<List<AssetYearlyBenefitDto>> fetchYearlyBenefits({
    required int startYear,
  }) => _api.fetchYearlyBenefits(startYear: startYear);
}
