import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../asset_statistics/presentation/providers/asset_statistics_providers.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../../domain/entities/mypage_chart.dart';
import '../../domain/usecases/load_mypage_chart_usecase.dart';
import '../controllers/mypage_chart_controller.dart';
import 'mypage_providers.dart';

final loadMyPageChartProvider = Provider(
  (ref) => LoadMyPageChartUseCase(
    ref.watch(myPageRepositoryProvider),
    ref.watch(assetStatisticsRepositoryProvider),
    ref.watch(hostMilesRepositoryProvider),
  ),
);

final myPageChartProvider = StateNotifierProvider.autoDispose
    .family<MyPageChartController, MyPageChartState, MyPageChartKind>((
      ref,
      kind,
    ) {
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
      // Profile refresh must not reset the selected range or discard cached charts.
      final identity = authenticated
          ? ref.watch(
              currentAuthUserProvider.select((state) {
                final user = state.valueOrNull;
                return user == null
                    ? null
                    : (user.id, user.userId, user.username);
              }),
            )
          : null;
      final useCase = ref.watch(loadMyPageChartProvider);
      final controller = MyPageChartController((years) {
        if (!authenticated || identity == null) {
          return Future.error(StateError('Authenticated user required'));
        }
        return useCase(kind, years, DateTime.now());
      });
      if (authenticated && identity != null) {
        scheduleMicrotask(() {
          if (controller.mounted) unawaited(controller.refresh());
        });
      }
      return controller;
    });
