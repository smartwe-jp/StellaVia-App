import '../entities/host_miles_models.dart';

abstract class HostMilesRepository {
  Future<HostMilesTier> fetchTier();
  Future<HostMilesAccount> fetchAccount();
  Future<List<HostMilesExpiry>> fetchExpiryAlerts();
  Future<List<HostMilesTierRule>> fetchTierRules();
  Future<List<HostMilesChartEntry>> fetchChart({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<HostMilesCumulativeChart> fetchCumulativeChart({
    required DateTime startMonth,
  });
  Future<HostMilesTransactionPage> fetchTransactions({
    String? bizType,
    int startPage = 1,
    int limit = 20,
  });
}
