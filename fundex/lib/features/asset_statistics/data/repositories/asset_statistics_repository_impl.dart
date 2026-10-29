import '../../domain/entities/asset_statistics_models.dart';
import '../../domain/repositories/asset_statistics_repository.dart';
import '../datasources/asset_statistics_remote_data_source.dart';
import '../mappers/asset_statistics_mapper.dart';

class AssetStatisticsRepositoryImpl implements AssetStatisticsRepository {
  const AssetStatisticsRepositoryImpl(this._remote);
  final AssetStatisticsRemoteDataSource _remote;
  @override
  Future<AssetInvestmentChart> fetchInvestments() async {
    final result = await _remote.fetchInvestments();
    return result.toEntity();
  }

  @override
  Future<AssetCumulativeBenefit> fetchCumulativeBenefit({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await _remote.fetchCumulativeBenefit(
      startDate: startDate,
      endDate: endDate,
    );
    return result.toEntity();
  }

  @override
  Future<AssetBenefitForecast> fetchForecast({
    required DateTime endYearMonth,
  }) async {
    final result = await _remote.fetchForecast(endYearMonth: endYearMonth);
    return result.toEntity();
  }

  @override
  Future<List<AssetYearlyBenefit>> fetchYearlyBenefits({
    required int startYear,
  }) async {
    final result = await _remote.fetchYearlyBenefits(startYear: startYear);
    return List.unmodifiable(result.map((item) => item.toEntity()));
  }
}
