import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../data/datasources/hotel_booking_remote_data_source.dart';
import '../../data/repositories/hotel_booking_repository_impl.dart';
import '../../domain/entities/hotel_models.dart';
import '../../domain/repositories/hotel_booking_repository.dart';
import '../../domain/usecases/fetch_hotel_building_filters_usecase.dart';
import '../../domain/usecases/search_hotels_usecase.dart';
import '../controllers/hotel_booking_controller.dart';

final hotelApiClientProvider = Provider<HotelApiClient>((ref) {
  return HotelApiClient(ref.watch(hotelCoreHttpClientProvider));
});

final hotelBookingRemoteDataSourceProvider =
    Provider<HotelBookingRemoteDataSource>((ref) {
      return HotelBookingRemoteDataSourceImpl(
        ref.watch(hotelApiClientProvider),
      );
    });

final hotelBookingRepositoryProvider = Provider<HotelBookingRepository>((ref) {
  return HotelBookingRepositoryImpl(
    remote: ref.watch(hotelBookingRemoteDataSourceProvider),
  );
});

final searchHotelsUseCaseProvider = Provider<SearchHotelsUseCase>((ref) {
  return SearchHotelsUseCase(ref.watch(hotelBookingRepositoryProvider));
});

final fetchHotelBuildingFiltersUseCaseProvider =
    Provider<FetchHotelBuildingFiltersUseCase>((ref) {
      return FetchHotelBuildingFiltersUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final hotelLocaleLanguageCodeProvider = Provider<String>((ref) {
  return resolveHotelApiLanguageCode(ref.watch(appEffectiveLocaleProvider));
});

final hotelBuildingFiltersProvider =
    FutureProvider.autoDispose<List<HotelBuildingFilter>>((ref) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelBuildingFiltersUseCaseProvider)(
        languageCode: languageCode,
      );
    });

final hotelBookingControllerProvider =
    StateNotifierProvider.autoDispose<
      HotelBookingController,
      HotelBookingState
    >((ref) {
      return HotelBookingController(
        searchHotels: ref.watch(searchHotelsUseCaseProvider),
        languageCode: ref.watch(hotelLocaleLanguageCodeProvider),
      );
    });

String resolveHotelApiLanguageCode(Locale locale) {
  return switch (locale.languageCode.toLowerCase()) {
    'ja' => 'JP',
    'en' => 'EN',
    'zh' => 'CH',
    _ => 'EN',
  };
}
