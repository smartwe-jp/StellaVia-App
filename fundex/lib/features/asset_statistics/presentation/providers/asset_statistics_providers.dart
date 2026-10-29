import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../domain/repositories/asset_statistics_repository.dart';
import '../../data/datasources/asset_statistics_remote_data_source.dart';
import '../../data/repositories/asset_statistics_repository_impl.dart';

// Dependency wiring only: no requests or account-result caching until consumed.
final assetStatisticsApiClientProvider = Provider<AssetStatisticsApiClient>((
  ref,
) {
  final router = ref.watch(apiClusterRouterProvider);
  return AssetStatisticsApiClient(
    dioForPath: router.dioForPath,
    envelopeCodec: const LegacyEnvelopeCodec(
      profile: CompanyApiResponseProfiles.oa,
    ),
  );
});
final assetStatisticsRepositoryProvider = Provider<AssetStatisticsRepository>((
  ref,
) {
  return AssetStatisticsRepositoryImpl(
    AssetStatisticsRemoteDataSource(
      ref.watch(assetStatisticsApiClientProvider),
    ),
  );
});
