import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';

final hotelManagementIdentityProvider = Provider((ref) {
  if (ref.watch(isAuthenticatedProvider).asData?.value != true) return null;
  return ref.watch(
    currentAuthUserProvider.select((state) {
      final user = state.valueOrNull;
      return user == null ? null : (user.id, user.userId, user.username);
    }),
  );
});
// Account-specific family prevents a previous user's room counts being reused.
final hotelManagementTierResourceProvider = FutureProvider.autoDispose
    .family<HostMilesTier, Object>((ref, identity) {
      return LoadHostMilesHomeUseCase(
        ref.watch(hostMilesRepositoryProvider),
      ).loadTier();
    });
final hotelManagementTierProvider =
    Provider.autoDispose<AsyncValue<HostMilesTier>>((ref) {
      final identity = ref.watch(hotelManagementIdentityProvider);
      if (identity == null) return const AsyncLoading();
      return ref.watch(hotelManagementTierResourceProvider(identity));
    });
Future<void> refreshHotelManagementTier(WidgetRef ref) async {
  final identity = ref.read(hotelManagementIdentityProvider);
  if (identity == null) return;
  try {
    ref.invalidate(hotelManagementTierResourceProvider(identity));
    await ref.read(hotelManagementTierResourceProvider(identity).future);
  } catch (_) {
    // The resource exposes the failure while retaining cached content.
  }
}
