import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../domain/repositories/host_miles_repository.dart';
import '../../data/datasources/host_miles_remote_data_source.dart';
import '../../data/repositories/host_miles_repository_impl.dart';

// Dependency wiring only: no requests or account-result caching until consumed.
final hostMilesApiClientProvider = Provider<HostMilesApiClient>((ref) {
  final router = ref.watch(apiClusterRouterProvider);
  return HostMilesApiClient(
    dioForPath: router.dioForPath,
    envelopeCodec: const LegacyEnvelopeCodec(
      profile: CompanyApiResponseProfiles.oa,
    ),
  );
});
final hostMilesRepositoryProvider = Provider<HostMilesRepository>((ref) {
  return HostMilesRepositoryImpl(
    HostMilesRemoteDataSource(ref.watch(hostMilesApiClientProvider)),
  );
});
