import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_detail_route_args.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_home_card.dart';
import '../../hotel_host_miles_fakes.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_host_miles_provider.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_host_miles_page.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_home_search.dart';

Widget app(
  Widget child, {
  Locale locale = const Locale('ja'),
  double scale = 1,
  GlobalKey? capture,
  bool eligible = false,
}) => ProviderScope(
  overrides: [
    isAuthenticatedProvider.overrideWithValue(const AsyncData(true)),
    hotelBuildingFiltersProvider.overrideWith((ref) async => []),
    hotelHostMilesProvider.overrideWith((ref) {
      final c = milesController(HotelsFake(eligible: eligible), MilesFake());
      Future.microtask(c.refresh);
      return c;
    }),
  ],
  child: MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppThemeFactory.light(locale: locale),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: RepaintBoundary(key: capture, child: child!),
    ),
    home: child,
  ),
);
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List<dynamic>;
    for (final entry in manifest) {
      final loader = FontLoader(entry['family'] as String);
      for (final font in entry['fonts'] as List<dynamic>) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });
  testWidgets(
    'host miles notices appear above the search fields only in the sheet',
    (tester) async {
      await tester.pumpWidget(app(const HotelHostMilesPage()));
      await tester.pumpAndSettle();
      final trigger = find.byKey(const Key('hotel_home_search'));
      final l = AppLocalizations.of(tester.element(trigger));
      expect(
        find.descendant(
          of: trigger,
          matching: find.textContaining(l.hotelSearchGuestCounts(1, 0)),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: trigger,
          matching: find.textContaining(l.hotelGuestDetailedSummary(1, 0, 1)),
        ),
        findsNothing,
      );
      final advance = l.hotelMilesAdvanceMonths(5);
      expect(find.text(advance), findsNothing);
      expect(find.text(l.hotelMilesBookingPending), findsNothing);
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(find.text(advance), findsOneWidget);
      expect(find.text(l.hotelMilesBookingPending), findsOneWidget);
      expect(
        tester.getBottomLeft(find.text(l.hotelSearchConditionsTitle)).dy,
        lessThan(tester.getTopLeft(find.text(advance)).dy),
      );
      expect(
        tester.getBottomLeft(find.text(l.hotelMilesBookingPending)).dy,
        lessThan(tester.getTopLeft(find.text(l.hotelDestinationLabel)).dy),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('area and sort apply criteria without legacy benefits', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var criteria = HotelSearchCriteria.initial(DateTime(2026, 11, 14));
    HotelSearchCriteria? applied;
    await tester.pumpWidget(
      app(
        Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => HotelHomeFilters(
              criteria: criteria,
              onApply: (value) async {
                applied = value;
                setState(() => criteria = value);
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('エリア'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('京都'));
    await tester.pumpAndSettle();
    expect(applied?.area, 'kyoto');
    expect(find.text('京都'), findsOneWidget);
    expect(find.text('エリア'), findsNothing);
    expect(applied?.stayBenefit, false);
    await tester.tap(find.byType(PopupMenuButton<HotelPriceSort>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuItem<HotelPriceSort>).last);
    await tester.pumpAndSettle();
    expect(applied?.priceSort, HotelPriceSort.descending);
    final l = AppLocalizations.of(
      tester.element(find.byType(HotelHomeFilters)),
    );
    expect(find.text(l.hotelSortPriceDescending), findsOneWidget);
    expect(find.text(l.hotelToolbarSort), findsNothing);
    expect(applied?.area, 'kyoto');
    await tester.tap(find.byType(PopupMenuButton<HotelPriceSort>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuItem<HotelPriceSort>).at(1));
    await tester.pumpAndSettle();
    expect(find.text(l.hotelSortPriceAscending), findsOneWidget);
    expect(find.text(l.hotelSortPriceDescending), findsNothing);
    await tester.tap(find.byType(PopupMenuButton<HotelPriceSort>));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<PopupMenuItem<HotelPriceSort>>(
            find.byType(PopupMenuItem<HotelPriceSort>).first,
          )
          .value,
      HotelPriceSort.none,
    );
    await tester.tap(find.text(l.hotelSortNone));
    await tester.pumpAndSettle();
    expect(applied?.priceSort, HotelPriceSort.none);
    expect(applied?.area, 'kyoto');
    expect(find.text(l.hotelToolbarSort), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'ineligible miles cards have a translucent overlay and cannot open details on narrow screens',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 844);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          app(const HotelHostMilesPage(), locale: locale, scale: 1.3),
        );
        await tester.pumpAndSettle();
        expect(find.text('GOLD'), findsOneWidget);
        expect(find.text('23,456'), findsOneWidget);
        await tester.scrollUntilVisible(find.byType(HotelHomeCard).first, 300);
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<AppCard>(
                find.descendant(
                  of: find.byType(HotelHomeCard).first,
                  matching: find.byType(AppCard),
                ),
              )
              .onTap,
          isNull,
        );
        final l = AppLocalizations.of(
          tester.element(find.byType(HotelHomeCard).first),
        );
        final card = find.byType(HotelHomeCard).first;
        expect(
          find.descendant(
            of: card,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.position == DecorationPosition.foreground &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).color ==
                      tester
                          .element(card)
                          .appColors
                          .surface
                          .withValues(alpha: 0.32),
            ),
          ),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('API Hotel').first);
        await tester.tap(find.text('API Hotel').first);
        await tester.pumpAndSettle();
        expect(find.text(l.hotelMilesDateIneligible), findsWidgets);
        expect(find.text(l.hotelMilesDateEligible), findsNothing);
        expect(
          find.text(l.hotelMilesReferenceStayFrom('12,800')),
          findsWidgets,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    },
  );
  testWidgets('miles hotel entry passes explicit mode and current criteria', (
    tester,
  ) async {
    HotelDetailRouteArgs? args;
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HotelHostMilesPage()),
        GoRoute(
          path: '/hotel-booking/:id',
          builder: (_, state) {
            args = state.extra as HotelDetailRouteArgs;
            return const Scaffold(body: Text('detail destination'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      app(
        MaterialApp.router(
          routerConfig: router,
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('ja')),
        ),
        eligible: true,
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(HotelHomeCard).first, 300);
    await tester.ensureVisible(find.text('API Hotel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('API Hotel'));
    await tester.pumpAndSettle();
    expect(args?.mode, HotelBookingMode.hostMiles);
    expect(args?.buildingCode, liveHotel(eligible: true).buildingCode);
    expect(args?.criteria.stayBenefit, true);
    expect(find.text('detail destination'), findsOneWidget);
  });
  testWidgets('capture miles preview', (tester) async {
    if (Platform.environment['HOTEL_CAPTURE'] != '1') return;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1100);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(app(const HotelHostMilesPage(), capture: key));
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final img = await boundary.toImage();
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      await File(
        '/tmp/hotel-miles-live.png',
      ).writeAsBytes(data!.buffer.asUint8List());
      img.dispose();
    });
  });
}
