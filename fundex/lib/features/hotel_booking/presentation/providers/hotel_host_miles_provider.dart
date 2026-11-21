import 'dart:async';
import '../../domain/entities/hotel_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../controllers/hotel_host_miles_controller.dart';
import 'hotel_booking_providers.dart';

final hotelHostMilesProvider = StateNotifierProvider.autoDispose
    .family<
      HotelHostMilesController,
      HotelHostMilesState,
      HotelSearchCriteria?
    >((ref, initialCriteria) {
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
      // Recreate on account changes; dispose rejects late responses from the old account.
      final user = authenticated ? ref.watch(currentAuthUserProvider) : null;
      final controller = HotelHostMilesController(
        initialCriteria: initialCriteria,
        search: ref.watch(searchHotelsUseCaseProvider),
        membership: LoadHostMilesHomeUseCase(
          ref.watch(hostMilesRepositoryProvider),
        ),
        languageCode: ref.watch(hotelLocaleLanguageCodeProvider),
        canLoadMembership: authenticated && user != null && !user.isLoading,
      );
      scheduleMicrotask(() {
        if (controller.mounted &&
            !(initialCriteria != null && user?.isLoading == true)) {
          unawaited(controller.initialize());
        }
      });
      return controller;
    });
