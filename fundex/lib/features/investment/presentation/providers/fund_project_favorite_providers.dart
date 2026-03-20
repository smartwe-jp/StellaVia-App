import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/fund_project_favorites_local_data_source.dart';
import '../controllers/fund_project_favorites_controller.dart';

final fundProjectFavoritesLocalDataSourceProvider =
    Provider<FundProjectFavoritesLocalDataSource>((ref) {
      return FundProjectFavoritesLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
        ref.watch(authLocalDataSourceProvider),
      );
    });

final fundProjectFavoritesControllerProvider =
    StateNotifierProvider<FundProjectFavoritesController, Set<String>>((ref) {
      ref.watch(currentAuthUserProvider);
      return FundProjectFavoritesController(
        ref.watch(fundProjectFavoritesLocalDataSourceProvider),
      );
    });

final isFundProjectFavoriteProvider = Provider.family<bool, String>((
  ref,
  String projectId,
) {
  return ref
      .watch(fundProjectFavoritesControllerProvider)
      .contains(projectId.trim());
});
