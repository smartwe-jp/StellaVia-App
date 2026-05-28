import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../data/datasources/hotel_credit_card_token_remote_data_source.dart';
import '../../data/datasources/hotel_booking_remote_data_source.dart';
import '../../data/repositories/hotel_credit_card_token_repository_impl.dart';
import '../../data/repositories/hotel_booking_repository_impl.dart';
import '../../domain/entities/hotel_models.dart';
import '../../domain/repositories/hotel_credit_card_token_repository.dart';
import '../../domain/repositories/hotel_booking_repository.dart';
import '../../domain/usecases/assign_hotel_occupancy_usecase.dart';
import '../../domain/usecases/cancel_hotel_order_usecase.dart';
import '../../domain/usecases/create_hotel_credit_card_token_usecase.dart';
import '../../domain/usecases/create_hotel_booking_usecase.dart';
import '../../domain/usecases/fetch_hotel_building_filters_usecase.dart';
import '../../domain/usecases/fetch_hotel_booking_preparation_usecase.dart';
import '../../domain/usecases/fetch_hotel_credit_cards_usecase.dart';
import '../../domain/usecases/fetch_hotel_detail_usecase.dart';
import '../../domain/usecases/fetch_hotel_member_profile_usecase.dart';
import '../../domain/usecases/fetch_hotel_order_cancel_rule_usecase.dart';
import '../../domain/usecases/fetch_hotel_order_detail_usecase.dart';
import '../../domain/usecases/fetch_hotel_order_list_usecase.dart';
import '../../domain/usecases/pay_hotel_order_with_registered_card_usecase.dart';
import '../../domain/usecases/register_hotel_credit_card_usecase.dart';
import '../../domain/usecases/search_hotels_usecase.dart';
import '../../domain/usecases/update_hotel_member_profile_usecase.dart';
import '../controllers/hotel_booking_controller.dart';
import '../controllers/hotel_order_list_controller.dart';

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

final hotelCreditCardTokenRemoteDataSourceProvider =
    Provider<HotelCreditCardTokenRemoteDataSource>((ref) {
      return HotelCreditCardTokenRemoteDataSourceImpl(
        Dio(BaseOptions(baseUrl: ref.watch(veritransTokenApiBaseUrlProvider))),
      );
    });

final hotelCreditCardTokenRepositoryProvider =
    Provider<HotelCreditCardTokenRepository>((ref) {
      return HotelCreditCardTokenRepositoryImpl(
        remote: ref.watch(hotelCreditCardTokenRemoteDataSourceProvider),
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

final fetchHotelDetailUseCaseProvider = Provider<FetchHotelDetailUseCase>((
  ref,
) {
  return FetchHotelDetailUseCase(ref.watch(hotelBookingRepositoryProvider));
});

final assignHotelOccupancyUseCaseProvider =
    Provider<AssignHotelOccupancyUseCase>((ref) {
      return AssignHotelOccupancyUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final fetchHotelBookingPreparationUseCaseProvider =
    Provider<FetchHotelBookingPreparationUseCase>((ref) {
      return FetchHotelBookingPreparationUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final createHotelBookingUseCaseProvider = Provider<CreateHotelBookingUseCase>((
  ref,
) {
  return CreateHotelBookingUseCase(ref.watch(hotelBookingRepositoryProvider));
});

final fetchHotelCreditCardsUseCaseProvider =
    Provider<FetchHotelCreditCardsUseCase>((ref) {
      return FetchHotelCreditCardsUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final createHotelCreditCardTokenUseCaseProvider =
    Provider<CreateHotelCreditCardTokenUseCase>((ref) {
      return CreateHotelCreditCardTokenUseCase(
        ref.watch(hotelCreditCardTokenRepositoryProvider),
      );
    });

final registerHotelCreditCardUseCaseProvider =
    Provider<RegisterHotelCreditCardUseCase>((ref) {
      return RegisterHotelCreditCardUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final payHotelOrderWithRegisteredCardUseCaseProvider =
    Provider<PayHotelOrderWithRegisteredCardUseCase>((ref) {
      return PayHotelOrderWithRegisteredCardUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final fetchHotelOrderListUseCaseProvider = Provider<FetchHotelOrderListUseCase>(
  (ref) {
    return FetchHotelOrderListUseCase(
      ref.watch(hotelBookingRepositoryProvider),
    );
  },
);

final fetchHotelOrderDetailUseCaseProvider =
    Provider<FetchHotelOrderDetailUseCase>((ref) {
      return FetchHotelOrderDetailUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final fetchHotelOrderCancelRuleUseCaseProvider =
    Provider<FetchHotelOrderCancelRuleUseCase>((ref) {
      return FetchHotelOrderCancelRuleUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final cancelHotelOrderUseCaseProvider = Provider<CancelHotelOrderUseCase>((
  ref,
) {
  return CancelHotelOrderUseCase(ref.watch(hotelBookingRepositoryProvider));
});

final fetchHotelMemberProfileUseCaseProvider =
    Provider<FetchHotelMemberProfileUseCase>((ref) {
      return FetchHotelMemberProfileUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final updateHotelMemberProfileUseCaseProvider =
    Provider<UpdateHotelMemberProfileUseCase>((ref) {
      return UpdateHotelMemberProfileUseCase(
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

final hotelMapSearchProvider = FutureProvider.autoDispose
    .family<HotelSearchResult, HotelSearchCriteria>((ref, criteria) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(searchHotelsUseCaseProvider)(
        criteria: criteria,
        languageCode: languageCode,
        limit: 100,
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

final hotelDetailProvider = FutureProvider.autoDispose
    .family<HotelDetail, HotelDetailQuery>((ref, query) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelDetailUseCaseProvider)(
        hotelId: query.hotelId,
        criteria: query.criteria,
        languageCode: languageCode,
      );
    });

final hotelBookingPreparationProvider = FutureProvider.autoDispose
    .family<HotelBookingPreparation, HotelBookingConfirmSeed>((ref, seed) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelBookingPreparationUseCaseProvider)(
        seed: seed,
        languageCode: languageCode,
      );
    });

final hotelMemberProfileProvider =
    FutureProvider.autoDispose<HotelMemberProfile>((ref) {
      return ref.watch(fetchHotelMemberProfileUseCaseProvider)();
    });

final hotelCreditCardsProvider =
    FutureProvider.autoDispose<List<HotelCreditCard>>((ref) {
      return ref.watch(fetchHotelCreditCardsUseCaseProvider)();
    });

final hotelOrderListControllerProvider =
    StateNotifierProvider.autoDispose<
      HotelOrderListController,
      HotelOrderListState
    >((ref) {
      return HotelOrderListController(
        fetchOrderList: ref.watch(fetchHotelOrderListUseCaseProvider),
        languageCode: ref.watch(hotelLocaleLanguageCodeProvider),
      );
    });

final hotelOrderDetailProvider = FutureProvider.autoDispose
    .family<HotelOrderDetail, String>((ref, orderId) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelOrderDetailUseCaseProvider)(
        languageCode: languageCode,
        orderId: orderId,
      );
    });

class HotelDetailQuery {
  const HotelDetailQuery({required this.hotelId, required this.criteria});

  final String hotelId;
  final HotelSearchCriteria criteria;

  @override
  bool operator ==(Object other) {
    return other is HotelDetailQuery &&
        other.hotelId == hotelId &&
        other.criteria.checkInDate == criteria.checkInDate &&
        other.criteria.checkOutDate == criteria.checkOutDate &&
        other.criteria.occupancy == criteria.occupancy &&
        other.criteria.kids == criteria.kids &&
        other.criteria.roomCount == criteria.roomCount;
  }

  @override
  int get hashCode => Object.hash(
    hotelId,
    criteria.checkInDate,
    criteria.checkOutDate,
    criteria.occupancy,
    criteria.kids,
    criteria.roomCount,
  );
}

String resolveHotelApiLanguageCode(Locale locale) {
  return switch (locale.languageCode.toLowerCase()) {
    'ja' => 'JP',
    'en' => 'EN',
    'zh' => 'CH',
    _ => 'EN',
  };
}
