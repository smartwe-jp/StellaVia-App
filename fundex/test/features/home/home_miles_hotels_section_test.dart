import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/home/presentation/providers/home_featured_hotels_provider.dart';
import 'package:fundex/features/home/presentation/widgets/home_miles_hotels_section.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/usecases/search_hotels_usecase.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_detail_route_args.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Search implements SearchHotelsUseCase {
  final pages = <int>[];
  @override
  Future<HotelSearchResult> call({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  }) async {
    expect(criteria.stayBenefit, isTrue);
    expect(criteria.nights, 1);
    pages.add(page);
    HotelSummary hotel(int i) => HotelSummary(
      id: '$i',
      name: 'Hotel $i',
      address: '',
      area: '',
      imageUrl: '',
      latitude: null,
      longitude: null,
      lowestPrice: null,
      beforeDiscountPrice: null,
      discount: null,
      discountName: '',
      bookingType: null,
      buildingCode: 'building-$i',
      bookingTypeLabel: '',
      buildingType: '',
      isBookable: i != 2,
      remainingRooms: i == 3 ? 0 : 1,
      startingPoints: i < 2 ? null : 1200 + i,
      stayBenefitParticipate: i != 7,
      tags: [],
    );
    return HotelSearchResult(
      totalCount: 25,
      hotels: page == 1
          ? [for (var i = 0; i < limit; i++) hotel(i % 5)]
          : [for (var i = 5; i < 10; i++) hotel(i)],
    );
  }
}

void main() {
  testWidgets(
    'fills the preview across pages and opens the selected miles hotel or the miles entry',
    (tester) async {
      final search = _Search();
      HotelDetailRouteArgs? opened;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const Scaffold(body: HomeMilesHotelsSection()),
          ),
          GoRoute(
            path: '/hotel-booking/host-miles',
            builder: (_, __) => const Scaffold(body: Text('Miles entry')),
          ),
          GoRoute(
            path: '/hotel-booking/:id',
            builder: (_, state) {
              opened = state.extra as HotelDetailRouteArgs;
              return Scaffold(
                body: Text('Detail ${state.pathParameters['id']}'),
              );
            },
          ),
        ],
      );
      addTearDown(router.dispose);
      final container = ProviderContainer(
        overrides: [
          searchHotelsUseCaseProvider.overrideWithValue(search),
          hotelLocaleLanguageCodeProvider.overrideWithValue('JP'),
        ],
      );
      addTearDown(container.dispose);
      const locale = Locale('ja');
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(search.pages, [1, 2]);
      expect(
        container
            .read(homeFeaturedHotelsProvider)
            .requireValue
            .hotels
            .map((h) => h.id),
        ['4', '5', '6', '8'],
      );
      final preview = container.read(homeFeaturedHotelsProvider).requireValue;
      expect(find.text('1,204 マイル〜'), findsOneWidget);
      await tester.tap(find.text('Hotel 5'));
      await tester.pumpAndSettle();
      expect(find.text('Detail 5'), findsOneWidget);
      expect(opened?.mode, HotelBookingMode.hostMiles);
      expect(opened?.criteria, same(preview.criteria));
      expect(opened?.buildingCode, 'building-5');
      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('一覧を見る'));
      await tester.pumpAndSettle();
      expect(find.text('Miles entry'), findsOneWidget);
    },
  );
}
