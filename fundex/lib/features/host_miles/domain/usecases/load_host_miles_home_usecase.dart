import '../entities/host_miles_models.dart';
import '../repositories/host_miles_repository.dart';

class LoadHostMilesHomeUseCase {
  const LoadHostMilesHomeUseCase(this._repository);
  final HostMilesRepository _repository;
  Future<List<HostMilesExpiry>> loadExpiry() => _repository.fetchExpiryAlerts();
  Future<HostMilesTier> loadTier() => _repository.fetchTier();
  Future<HostMilesAccount> loadAccount() => _repository.fetchAccount();
  Future<List<HostMilesTierRule>> loadRules() => _repository.fetchTierRules();
}
