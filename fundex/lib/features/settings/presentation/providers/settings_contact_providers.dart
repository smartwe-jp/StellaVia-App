import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../data/datasources/settings_contact_remote_data_source.dart';

final settingsContactRemoteDataSourceProvider =
    Provider<SettingsContactRemoteDataSource>((ref) {
      return SettingsContactRemoteDataSourceImpl(
        ref.watch(oaCoreHttpClientProvider),
        memberClient: ref.watch(memberCoreHttpClientProvider),
        clusterRouter: ref.watch(apiClusterRouterProvider),
      );
    });
