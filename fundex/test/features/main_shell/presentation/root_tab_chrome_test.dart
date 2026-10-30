import 'package:fundex/features/main_shell/presentation/pages/main_shell_page.dart';
import 'package:fundex/features/home/presentation/providers/home_miles_providers.dart';
import 'package:fundex/features/home/presentation/controllers/home_resource_controller.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/app/network/app_network_connectivity_providers.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/home/presentation/pages/home_overview_tab_page.dart';
import 'package:fundex/features/home/presentation/providers/home_featured_hotels_provider.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/usecases/search_hotels_usecase.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_booking_controller.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_booking_tab_page.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_management_page.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_management_providers.dart';
import 'package:fundex/features/main_shell/presentation/providers/main_shell_providers.dart';
import '../../hotel_booking/hotel_host_miles_fakes.dart';

void main() {
  setUpAll(() => initializeDateFormatting());
  for (final entry in <(String, Widget, double)>[
    ('home', const HomeOverviewTabPage(), 56),
    ('hotel', const HotelBookingTabPage(), 57),
    ('management', const HotelManagementPage(), 65),
  ]) {
    testWidgets('${entry.$1} observes shell reveal without shrinking navigation', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 600);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      final container = ProviderContainer(
        overrides: [
          homeMilesRulesProvider.overrideWith(
            (ref) => HomeResourceController(() async => []),
          ),
          isAuthenticatedProvider.overrideWithValue(const AsyncData(false)),
          appNetworkAvailabilityProvider.overrideWith(
            (ref) => Stream.value(AppNetworkAvailability.online),
          ),
          fundProjectListProvider.overrideWith((ref) async => []),
          homeFeaturedHotelsProvider.overrideWith(
            (ref) async => HomeFeaturedHotels(
              criteria: HotelSearchCriteria.initial(DateTime(2026, 10, 30)),
              hotels: [],
            ),
          ),
          hotelManagementIdentityProvider.overrideWith((ref) => null),
          hotelBuildingFiltersProvider.overrideWith((ref) async => []),
          hotelBookingControllerProvider.overrideWith(
            (ref) => HotelBookingController(
              searchHotels: SearchHotelsUseCase(HotelsFake()),
              languageCode: 'JP',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final events = <String>[];
      final router = GoRouter(
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, __, shell) => MainShellPage(navigationShell: shell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n.metrics.axis == Axis.vertical) {
                          events.add(
                            '${n.runtimeType} px=${n.metrics.pixels} after=${n.metrics.extentAfter} delta=${n is ScrollUpdateNotification ? n.scrollDelta : null}',
                          );
                        }
                        return false;
                      },
                      child: entry.$2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('ja'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppThemeFactory.light(locale: const Locale('ja')),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final bar = find.byType(AppScrollNavigationBar);
      expect(bar, findsOneWidget);
      for (final value in [1.0, .99, .5, 0.0, .4, 1.0]) {
        container.read(mainShellChromeRevealProvider.notifier).state = value;
        await tester.pump();
        final widget = tester.widget<AppScrollNavigationBar>(bar);
        expect(widget.reveal, value);
        expect(
          tester.getSize(find.byWidget(widget.navigationBar)).height,
          entry.$3,
        );
        expect(tester.getSize(bar).height, closeTo(47 + entry.$3 * value, .01));
        expect(tester.takeException(), isNull);
      }
      if (entry.$1 == 'home') {
        await tester.drag(
          find.byKey(const Key('home_tab_content')),
          const Offset(0, -180),
        );
        await tester.pumpAndSettle();
        expect(
          container.read(mainShellChromeRevealProvider),
          lessThan(1),
          reason: events.join("\n"),
        );
        await tester.drag(
          find.byKey(const Key('home_tab_content')),
          const Offset(0, 40),
        );
        await tester.pumpAndSettle();
        expect(container.read(mainShellChromeRevealProvider), 1);
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }
}
