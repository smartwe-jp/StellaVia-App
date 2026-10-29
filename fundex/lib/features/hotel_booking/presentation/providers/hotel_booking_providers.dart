import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/hotel_credit_card_token_remote_data_source.dart';
import '../../data/datasources/hotel_booking_remote_data_source.dart';
import '../../data/repositories/hotel_credit_card_token_repository_impl.dart';
import '../../data/repositories/hotel_booking_repository_impl.dart';
import '../../domain/entities/hotel_models.dart';
import '../../domain/repositories/hotel_credit_card_token_repository.dart';
import '../../domain/repositories/hotel_booking_repository.dart';
import '../../domain/usecases/assign_hotel_occupancy_usecase.dart';
import '../../domain/usecases/cancel_hotel_order_usecase.dart';
import '../../domain/usecases/check_in_hotel_order_customer_usecase.dart';
import '../../domain/usecases/create_hotel_alipay_payment_usecase.dart';
import '../../domain/usecases/create_hotel_credit_card_token_usecase.dart';
import '../../domain/usecases/create_hotel_booking_usecase.dart';
import '../../domain/usecases/delete_hotel_member_contact_usecase.dart';
import '../../domain/usecases/fetch_hotel_building_filters_usecase.dart';
import '../../domain/usecases/fetch_hotel_booking_preparation_usecase.dart';
import '../../domain/usecases/fetch_hotel_country_codes_usecase.dart';
import '../../domain/usecases/fetch_hotel_coupons_usecase.dart';
import '../../domain/usecases/fetch_hotel_credit_cards_usecase.dart';
import '../../domain/usecases/fetch_hotel_detail_usecase.dart';
import '../../domain/usecases/fetch_hotel_member_contacts_usecase.dart';
import '../../domain/usecases/fetch_hotel_member_profile_usecase.dart';
import '../../domain/usecases/fetch_hotel_order_cancel_rule_usecase.dart';
import '../../domain/usecases/fetch_hotel_order_detail_usecase.dart';
import '../../domain/usecases/fetch_hotel_order_list_usecase.dart';
import '../../domain/usecases/fetch_hotel_price_discount_usecase.dart';
import '../../domain/usecases/fetch_hotel_stay_benefit_periods_usecase.dart';
import '../../domain/usecases/fetch_hotel_today_checkins_usecase.dart';
import '../../domain/usecases/pay_hotel_order_usecase.dart';
import '../../domain/usecases/pay_hotel_order_with_registered_card_usecase.dart';
import '../../domain/usecases/pay_hotel_order_with_credit_card_token_usecase.dart';
import '../../domain/usecases/quote_hotel_booking_price_usecase.dart';
import '../../domain/usecases/register_hotel_credit_card_usecase.dart';
import '../../domain/usecases/request_hotel_order_invoice_usecase.dart';
import '../../domain/usecases/save_hotel_member_contact_usecase.dart';
import '../../domain/usecases/search_hotels_usecase.dart';
import '../../domain/usecases/set_hotel_user_language_usecase.dart';
import '../../domain/usecases/sync_hotel_optimism_payment_usecase.dart';
import '../../domain/usecases/unregister_hotel_credit_card_usecase.dart';
import '../../domain/usecases/update_hotel_member_profile_usecase.dart';
import '../controllers/hotel_booking_controller.dart';
import '../controllers/hotel_order_list_controller.dart';
import '../controllers/hotel_today_checkin_controller.dart';
import '../support/hotel_native_payment_service.dart';
import '../support/hotel_native_payment_settings.dart';

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

final hotelNativePaymentServiceProvider = Provider<HotelNativePaymentService>((
  ref,
) {
  return HotelNativePaymentService(
    settings: ref.watch(hotelNativePaymentSettingsProvider),
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

final fetchHotelPriceDiscountUseCaseProvider =
    Provider<FetchHotelPriceDiscountUseCase>((ref) {
      return FetchHotelPriceDiscountUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
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

final fetchHotelCouponsUseCaseProvider = Provider<FetchHotelCouponsUseCase>((
  ref,
) {
  return FetchHotelCouponsUseCase(ref.watch(hotelBookingRepositoryProvider));
});

final fetchHotelMemberContactsUseCaseProvider =
    Provider<FetchHotelMemberContactsUseCase>((ref) {
      return FetchHotelMemberContactsUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final fetchHotelCountryCodesUseCaseProvider =
    Provider<FetchHotelCountryCodesUseCase>((ref) {
      return FetchHotelCountryCodesUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final saveHotelMemberContactUseCaseProvider =
    Provider<SaveHotelMemberContactUseCase>((ref) {
      return SaveHotelMemberContactUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final deleteHotelMemberContactUseCaseProvider =
    Provider<DeleteHotelMemberContactUseCase>((ref) {
      return DeleteHotelMemberContactUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final fetchHotelStayBenefitPeriodsUseCaseProvider =
    Provider<FetchHotelStayBenefitPeriodsUseCase>((ref) {
      return FetchHotelStayBenefitPeriodsUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final quoteHotelBookingPriceUseCaseProvider =
    Provider<QuoteHotelBookingPriceUseCase>((ref) {
      return QuoteHotelBookingPriceUseCase(
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

final payHotelOrderWithCreditCardTokenUseCaseProvider =
    Provider<PayHotelOrderWithCreditCardTokenUseCase>((ref) {
      return PayHotelOrderWithCreditCardTokenUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final payHotelOrderUseCaseProvider = Provider<PayHotelOrderUseCase>((ref) {
  return PayHotelOrderUseCase(ref.watch(hotelBookingRepositoryProvider));
});

final createHotelAlipayPaymentUseCaseProvider =
    Provider<CreateHotelAlipayPaymentUseCase>((ref) {
      return CreateHotelAlipayPaymentUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final syncHotelOptimismPaymentUseCaseProvider =
    Provider<SyncHotelOptimismPaymentUseCase>((ref) {
      return SyncHotelOptimismPaymentUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final unregisterHotelCreditCardUseCaseProvider =
    Provider<UnregisterHotelCreditCardUseCase>((ref) {
      return UnregisterHotelCreditCardUseCase(
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

final fetchHotelTodayCheckInsUseCaseProvider =
    Provider<FetchHotelTodayCheckInsUseCase>((ref) {
      return FetchHotelTodayCheckInsUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

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

final checkInHotelOrderCustomerUseCaseProvider =
    Provider<CheckInHotelOrderCustomerUseCase>((ref) {
      return CheckInHotelOrderCustomerUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final requestHotelOrderInvoiceUseCaseProvider =
    Provider<RequestHotelOrderInvoiceUseCase>((ref) {
      return RequestHotelOrderInvoiceUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
    });

final setHotelUserLanguageUseCaseProvider =
    Provider<SetHotelUserLanguageUseCase>((ref) {
      return SetHotelUserLanguageUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
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

final hotelUserLanguageSyncBootstrapProvider = Provider<void>((ref) {
  String? lastSyncedLanguageCode;
  Future<void>? inFlightSync;
  var disposed = false;
  ref.onDispose(() {
    disposed = true;
  });

  Future<void> sync(String languageCode) async {
    final isAuthenticated =
        ref.read(isAuthenticatedProvider).asData?.value ?? false;
    if (!isAuthenticated) {
      return;
    }
    if (lastSyncedLanguageCode == languageCode) {
      return;
    }
    final existingSync = inFlightSync;
    if (existingSync != null) {
      try {
        await existingSync;
      } catch (_) {
        // The caller below intentionally swallows sync failures.
      }
      if (lastSyncedLanguageCode == languageCode) {
        return;
      }
    }
    final syncFuture = ref
        .read(setHotelUserLanguageUseCaseProvider)
        .call(languageCode: languageCode)
        .then((_) {
          lastSyncedLanguageCode = languageCode;
        })
        .whenComplete(() {
          inFlightSync = null;
        });
    inFlightSync = syncFuture;
    try {
      await syncFuture;
    } catch (_) {
      // This backend setting only controls localized hotel messages. Do not
      // block app startup or language switching when it is temporarily failing.
    }
  }

  Future<void> syncCurrentLanguageIfAuthenticated() async {
    await ref.read(appLanguageProvider.notifier).ready;
    if (disposed) {
      return;
    }
    await sync(ref.read(hotelLocaleLanguageCodeProvider));
  }

  unawaited(syncCurrentLanguageIfAuthenticated());
  ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
    final wasAuthenticated = previous?.asData?.value ?? false;
    final isAuthenticated = next.asData?.value ?? false;
    if (wasAuthenticated == isAuthenticated) {
      return;
    }
    if (!isAuthenticated) {
      lastSyncedLanguageCode = null;
      return;
    }
    unawaited(syncCurrentLanguageIfAuthenticated());
  });
  ref.listen<String>(hotelLocaleLanguageCodeProvider, (previous, next) {
    if (previous == next) {
      return;
    }
    unawaited(sync(next));
  });
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

final hotelStayBenefitSearchProvider = FutureProvider.autoDispose
    .family<HotelSearchResult, HotelSearchCriteria>((ref, criteria) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(searchHotelsUseCaseProvider)(
        criteria: criteria.copyWith(stayBenefit: true),
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

final hotelPriceDiscountProvider = FutureProvider.autoDispose
    .family<HotelPriceDiscount, HotelPriceDiscountQuery>((ref, query) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelPriceDiscountUseCaseProvider)(
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

final hotelCouponsProvider = FutureProvider.autoDispose<HotelCouponListResult>((
  ref,
) {
  final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
  return ref.watch(fetchHotelCouponsUseCaseProvider)(
    languageCode: languageCode,
  );
});

final hotelFundBenefitTicketsProvider =
    FutureProvider.autoDispose<List<HotelFundBenefitTicket>>((ref) {
      return const <HotelFundBenefitTicket>[];
    });

final hotelMemberContactsProvider =
    FutureProvider.autoDispose<List<HotelMemberContact>>((ref) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelMemberContactsUseCaseProvider)(
        languageCode: languageCode,
      );
    });

final hotelCountryCodesProvider =
    FutureProvider.autoDispose<List<HotelCountryCode>>((ref) {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      return ref.watch(fetchHotelCountryCodesUseCaseProvider)(
        languageCode: languageCode,
      );
    });

final hotelMaxFundBenefitTicketAmountProvider =
    FutureProvider.autoDispose<int?>((ref) {
      return null;
    });

final hotelStayBenefitPeriodsProvider =
    FutureProvider.autoDispose<List<HotelStayBenefitPeriod>>((ref) {
      return ref.watch(fetchHotelStayBenefitPeriodsUseCaseProvider)();
    });

final hotelStayBenefitPeriodsForHotelProvider = FutureProvider.autoDispose
    .family<List<HotelStayBenefitPeriod>, String>((ref, hotelId) {
      return ref
          .watch(fetchHotelStayBenefitPeriodsUseCaseProvider)
          .forHotel(hotelId: hotelId);
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
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
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
      return HotelOrderListController(
        canLoad: authenticated && identity != null,
        fetchOrderList: ref.watch(fetchHotelOrderListUseCaseProvider),
        languageCode: ref.watch(hotelLocaleLanguageCodeProvider),
      );
    });

final hotelTodayCheckInControllerProvider =
    StateNotifierProvider.autoDispose<
      HotelTodayCheckInController,
      HotelTodayCheckInState
    >((ref) {
      return HotelTodayCheckInController(
        fetchTodayCheckIns: ref.watch(fetchHotelTodayCheckInsUseCaseProvider),
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

class HotelPriceDiscountQuery {
  const HotelPriceDiscountQuery({
    required this.hotelId,
    required this.criteria,
  });

  final String hotelId;
  final HotelSearchCriteria criteria;

  @override
  bool operator ==(Object other) {
    return other is HotelPriceDiscountQuery &&
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
