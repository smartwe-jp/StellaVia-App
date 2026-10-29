import '../../domain/entities/host_miles_models.dart';
import '../../domain/repositories/host_miles_repository.dart';
import '../datasources/host_miles_remote_data_source.dart';
import '../mappers/host_miles_mapper.dart';

class HostMilesRepositoryImpl implements HostMilesRepository {
  const HostMilesRepositoryImpl(this._remote);
  final HostMilesRemoteDataSource _remote;
  @override
  Future<HostMilesTier> fetchTier() async {
    final result = await _remote.fetchTier();
    return result.toEntity();
  }

  @override
  Future<HostMilesAccount> fetchAccount() async {
    final result = await _remote.fetchAccount();
    return result.toEntity();
  }

  @override
  Future<List<HostMilesExpiry>> fetchExpiryAlerts() async {
    final result = await _remote.fetchExpiryAlerts();
    return List.unmodifiable(result.map((item) => item.toEntity()));
  }

  @override
  Future<List<HostMilesTierRule>> fetchTierRules() async {
    final result = await _remote.fetchTierRules();
    return List.unmodifiable(result.map((item) => item.toEntity()));
  }

  @override
  Future<List<HostMilesChartEntry>> fetchChart({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await _remote.fetchChart(
      startDate: startDate,
      endDate: endDate,
    );
    return List.unmodifiable(result.map((item) => item.toEntity()));
  }

  @override
  Future<HostMilesCumulativeChart> fetchCumulativeChart({
    required DateTime startMonth,
  }) async {
    final result = await _remote.fetchCumulativeChart(startMonth: startMonth);
    return result.toEntity();
  }

  @override
  Future<HostMilesTransactionPage> fetchTransactions({
    String? bizType,
    int startPage = 1,
    int limit = 20,
  }) async {
    final result = await _remote.fetchTransactions(
      bizType: bizType,
      startPage: startPage,
      limit: limit,
    );
    return result.toEntity();
  }
}
