import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../controllers/mypage_membership_controller.dart';

final myPageMembershipIdentityProvider = Provider((ref) {
  final authenticated =
      ref.watch(isAuthenticatedProvider).asData?.value == true;
  if (!authenticated) return null;
  return ref.watch(
    currentAuthUserProvider.select((state) {
      final user = state.valueOrNull;
      return user == null ? null : (user.id, user.userId, user.username);
    }),
  );
});
final myPageMembershipUseCaseProvider = Provider(
  (ref) => LoadHostMilesHomeUseCase(ref.watch(hostMilesRepositoryProvider)),
);

MyPageMembershipController<T> _resource<T>(
  bool ready,
  Future<T> Function() load,
) {
  final controller = MyPageMembershipController<T>(() async {
    if (!ready) throw StateError('Authenticated user required');
    return load();
  });
  if (ready) {
    scheduleMicrotask(() {
      if (controller.mounted) unawaited(controller.refresh());
    });
  }
  return controller;
}

final myPageTierProvider =
    StateNotifierProvider.autoDispose<
      MyPageMembershipController<HostMilesTier>,
      AsyncValue<HostMilesTier>
    >(
      (ref) => _resource(
        ref.watch(myPageMembershipIdentityProvider) != null,
        ref.watch(myPageMembershipUseCaseProvider).loadTier,
      ),
    );
final myPageMilesAccountProvider =
    StateNotifierProvider.autoDispose<
      MyPageMembershipController<HostMilesAccount>,
      AsyncValue<HostMilesAccount>
    >(
      (ref) => _resource(
        ref.watch(myPageMembershipIdentityProvider) != null,
        ref.watch(myPageMembershipUseCaseProvider).loadAccount,
      ),
    );
final myPageMilesExpiryProvider =
    FutureProvider.autoDispose<List<HostMilesExpiry>>((ref) {
      if (ref.watch(myPageMembershipIdentityProvider) == null) {
        return const <HostMilesExpiry>[];
      }
      return ref.watch(myPageMembershipUseCaseProvider).loadExpiry();
    });
