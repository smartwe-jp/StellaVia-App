import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../controllers/hotel_host_miles_controller.dart';
import 'hotel_booking_providers.dart';

final hotelHostMilesProvider =
    StateNotifierProvider.autoDispose<
      HotelHostMilesController,
      HotelHostMilesState
    >((ref) {
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
      // Recreate on account changes; dispose rejects late responses from the old account.
      final user = authenticated ? ref.watch(currentAuthUserProvider) : null;
      final controller = HotelHostMilesController(
        search: ref.watch(searchHotelsUseCaseProvider),
        membership: LoadHostMilesHomeUseCase(
          ref.watch(hostMilesRepositoryProvider),
        ),
        languageCode: ref.watch(hotelLocaleLanguageCodeProvider),
        canLoadMembership: authenticated && user != null && !user.isLoading,
      );
      scheduleMicrotask(() {
        if (controller.mounted) unawaited(controller.refresh());
      });
      return controller;
    });
