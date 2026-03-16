import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/notifications_local_data_source.dart';
import '../../data/datasources/notifications_remote_data_source.dart';
import '../controllers/notifications_controller.dart';
import '../state/notifications_state.dart';

final noticeApiClientProvider = Provider<NoticeApiClient>((ref) {
  final clusterRouter = ref.watch(apiClusterRouterProvider);
  return NoticeApiClient(
    dioForPath: clusterRouter.dioForPath,
    envelopeCodec: const LegacyEnvelopeCodec(
      profile: CompanyApiResponseProfiles.oa,
    ),
  );
});

final notificationsRemoteDataSourceProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
      return NotificationsRemoteDataSourceImpl(
        ref.watch(noticeApiClientProvider),
      );
    });

final notificationsLocalDataSourceProvider =
    Provider<NotificationsLocalDataSource>((ref) {
      return NotificationsLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
        ref.watch(authLocalDataSourceProvider),
      );
    });

final notificationsControllerProvider =
    StateNotifierProvider.autoDispose<
      NotificationsController,
      NotificationsState
    >((ref) {
      return NotificationsController(
        ref.watch(notificationsRemoteDataSourceProvider),
        ref.watch(notificationsLocalDataSourceProvider),
      );
    });
