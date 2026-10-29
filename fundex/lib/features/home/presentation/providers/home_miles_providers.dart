import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../controllers/home_resource_controller.dart';

final loadHostMilesHomeUseCaseProvider = Provider<LoadHostMilesHomeUseCase>(
  (ref) => LoadHostMilesHomeUseCase(ref.watch(hostMilesRepositoryProvider)),
);

final homeMilesAccountProvider =
    StateNotifierProvider.autoDispose<
      HomeResourceController<HostMilesAccount>,
      HomeResourceState<HostMilesAccount>
    >((ref) {
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
      // Recreate on identity changes: never retain another member's balance.
      final userState = authenticated
          ? ref.watch(currentAuthUserProvider)
          : null;
      final identityReady = userState != null && !userState.isLoading;
      final useCase = ref.watch(loadHostMilesHomeUseCaseProvider);
      final controller = HomeResourceController<HostMilesAccount>(() async {
        if (!authenticated || !identityReady) {
          throw StateError('No authenticated user.');
        }
        return useCase.loadAccount();
      });
      if (authenticated && identityReady) {
        scheduleMicrotask(() {
          if (controller.mounted) unawaited(controller.refresh());
        });
      }
      return controller;
    });

final homeMilesRulesProvider =
    StateNotifierProvider.autoDispose<
      HomeResourceController<List<HostMilesTierRule>>,
      HomeResourceState<List<HostMilesTierRule>>
    >((ref) {
      final controller = HomeResourceController(
        ref.watch(loadHostMilesHomeUseCaseProvider).loadRules,
      );
      scheduleMicrotask(() {
        if (controller.mounted) unawaited(controller.refresh());
      });
      return controller;
    });

// Information pages have their own lifetime; an open root tab must not pin their cache.
final homeRankDetailsRulesProvider =
    StateNotifierProvider.autoDispose<
      HomeResourceController<List<HostMilesTierRule>>,
      HomeResourceState<List<HostMilesTierRule>>
    >((ref) {
      final controller = HomeResourceController(
        ref.watch(loadHostMilesHomeUseCaseProvider).loadRules,
      );
      scheduleMicrotask(() {
        if (controller.mounted) unawaited(controller.refresh());
      });
      return controller;
    });
