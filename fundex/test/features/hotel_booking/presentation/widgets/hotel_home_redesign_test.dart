import 'dart:convert';
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
}) => ProviderScope(
  overrides: [
    isAuthenticatedProvider.overrideWithValue(const AsyncData(true)),
    hotelBuildingFiltersProvider.overrideWith((ref) async => []),
    hotelHostMilesProvider.overrideWith((ref) {
      final c = milesController(HotelsFake(), MilesFake());
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
  testWidgets('area and sort apply criteria without legacy benefits', (
    tester,
  ) async {
    final criteria = HotelSearchCriteria.initial(DateTime(2026, 11, 14));
    HotelSearchCriteria? applied;
    await tester.pumpWidget(
      app(
        Scaffold(
          body: HotelHomeFilters(
            criteria: criteria,
            onApply: (value) async {
              applied = value;
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('エリア'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('京都'));
    await tester.pumpAndSettle();
    expect(applied?.area, 'kyoto');
    expect(applied?.stayBenefit, false);
    await tester.tap(find.byType(PopupMenuButton<HotelPriceSort>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuItem<HotelPriceSort>).last);
    await tester.pumpAndSettle();
    expect(applied?.priceSort, HotelPriceSort.descending);
  });
  testWidgets('localized live miles home fits narrow screens and cannot book', (
    tester,
  ) async {
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
      await tester.scrollUntilVisible(
        find.byWidgetPredicate((w) => w is AppButton && w.onPressed == null),
        300,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<AppButton>(
              find.byWidgetPredicate(
                (w) => w is AppButton && w.onPressed == null,
              ),
            )
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
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
