import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/repositories/hotel_booking_repository.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_booking_confirm_page.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_booking_result_page.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_management_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_booking_result_route_args.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_booking_extra_sections.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_booking_payment_section.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'hotel_detail_redesign_test.dart' as fixtures;

class _Repository extends Fake implements HotelBookingRepository {
  int quotes = 0;
  final orders = <HotelBookingCreateDraft>[];

  @override
  Future<HotelBookingQuote> quoteBookingPrice(
    HotelBookingQuoteRequest request,
  ) async {
    expect(request.stayBenefit, true);
    expect(request.coupons, isEmpty);
    expect(request.rooms.single.occupancy, 3);
    return fixtures.quote(++quotes == 1 ? null : 8500);
  }

  @override
  Future<String> createBooking(HotelBookingCreateDraft draft) async {
    orders.add(draft);
    if (orders.length == 1) throw StateError('Unavailable');
    return '1232815';
  }
}

void main() {
  testWidgets(
    'miles confirmation retries a missing quote and a failed order, then shows the MrT ID',
    (tester) async {
      final repository = _Repository();
      final seed = HotelBookingConfirmSeed(
        hostMiles: true,
        detail: fixtures.detail(),
        criteria: fixtures.criteria.copyWith(
          stayBenefit: true,
          occupancy: 2,
          kids: 1,
        ),
        selectedRooms: [HotelSelectedRoom(room: fixtures.room(), quantity: 1)],
        assignedPrice: 18000,
        roomTypeCustNums: fixtures.assigned.roomTypeCustNums,
      );
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => HotelBookingConfirmPage(seed: seed),
          ),
          GoRoute(
            path: '/hotel-booking/1/result',
            builder: (_, state) => HotelBookingResultPage(
              args: state.extra! as HotelBookingResultRouteArgs,
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hotelBookingRepositoryProvider.overrideWithValue(repository),
            hotelManagementIdentityProvider.overrideWithValue(null),
            hotelLocaleLanguageCodeProvider.overrideWithValue('EN'),
            currentAuthUserProvider.overrideWith(
              (_) async => const AuthUser(
                username: 'guest',
                firstName: 'Taro',
                lastName: 'Yamada',
                email: 'guest@example.com',
                phone: '12345',
              ),
            ),
            hotelBookingPreparationProvider.overrideWith(
              (_, _) async => const HotelBookingPreparation(
                pageTexts: {},
                countryCodes: [],
                coupons: [],
                couponsAvailableCount: 2,
                contactsCount: 0,
                registeredCardCount: 0,
                quotedPrice: null,
                originalPrice: null,
                roomPriceElements: [],
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            theme: AppThemeFactory.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final bar = find.byType(HotelBookingConfirmBottomBar);
      expect(
        tester.widget<HotelBookingConfirmBottomBar>(bar).onConfirm,
        isNull,
      );
      final l = AppLocalizations.of(tester.element(bar));
      await tester.tap(find.text(l.commonRetry));
      await tester.pumpAndSettle();
      expect(
        tester.widget<HotelBookingConfirmBottomBar>(bar).amount,
        l.hotelMilesReferenceStay('8,500'),
      );
      expect(find.byType(HotelBookingPaymentSection), findsNothing);
      expect(find.byType(HotelBookingCouponRow), findsNothing);
      await tester.tap(find.text(l.hotelBookingConfirmAction));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      expect(repository.orders, hasLength(1));
      expect(bar, findsOneWidget);
      await tester.tap(find.text(l.hotelBookingConfirmAction));
      await tester.pumpAndSettle();
      expect(repository.orders.last.selectedCoupons, isEmpty);
      expect(repository.orders.last.totalAmount, 18000);
      expect(repository.orders.last.roomGuests.single.children, 1);
      expect(find.text('1232815'), findsOneWidget);
      expect(find.text(l.hotelMilesReferenceStay('8,500')), findsOneWidget);
    },
  );
}
