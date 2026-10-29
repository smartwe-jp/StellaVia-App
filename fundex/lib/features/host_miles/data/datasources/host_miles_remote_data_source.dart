import 'package:company_api_runtime/company_api_runtime.dart';

class HostMilesRemoteDataSource {
  const HostMilesRemoteDataSource(this._api);
  final HostMilesApiClient _api;
  Future<HostMilesTierDto> fetchTier() => _api.fetchTier();
  Future<HostMilesAccountDto> fetchAccount() => _api.fetchAccount();
  Future<List<HostMilesExpiryDto>> fetchExpiryAlerts() =>
      _api.fetchExpiryAlerts();
  Future<List<HostMilesTierRuleDto>> fetchTierRules() => _api.fetchTierRules();
  Future<List<HostMilesChartEntryDto>> fetchChart({
    required DateTime startDate,
    required DateTime endDate,
  }) => _api.fetchChart(startDate: startDate, endDate: endDate);
  Future<HostMilesCumulativeChartDto> fetchCumulativeChart({
    required DateTime startMonth,
  }) => _api.fetchCumulativeChart(startMonth: startMonth);
  Future<HostMilesTransactionPageDto> fetchTransactions({
    String? bizType,
    int startPage = 1,
    int limit = 20,
  }) => _api.fetchTransactions(
    bizType: bizType,
    startPage: startPage,
    limit: limit,
  );
}
