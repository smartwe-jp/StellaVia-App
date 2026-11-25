import 'dart:io';
import 'package:fundex/features/home/presentation/providers/simulation_hotels_provider.dart';
import 'package:fundex/features/home/presentation/widgets/simulation_hotel_results.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_detail_route_args.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/home/domain/entities/home_simulation.dart';
import 'package:fundex/features/home/presentation/pages/home_simulation_page.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';

const rules = [
  HostMilesTierRule(
    tierCode: 'REGULAR',
    minAum: 0,
    maxAum: 500000,
    pointRate: .005,
  ),
  HostMilesTierRule(
    tierCode: 'BRONZE',
    minAum: 500000,
    maxAum: 2000000,
    pointRate: .00525,
  ),
  HostMilesTierRule(tierCode: 'MASTER', minAum: 10000000, pointRate: .006),
];

class FakeRules implements HostMilesRepository {
  @override
  Future<List<HostMilesTierRule>> fetchTierRules() async => rules;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('web example, rank thresholds, missing rules and rounding', () {
    const calculate = CalculateHomeSimulation();
    final result = calculate(const HomeSimulationInput(), rules);
    expect(result.monthlyDividend, 5000);
    expect(result.termDividend, 60000);
    expect(result.totalReceived, 1060000);
    expect(result.miles, 63000);
    expect(result.monthlyMiles, 5250);
    expect(result.monthlyPointRate, .00525);
    expect(result.tierCode, 'BRONZE');
    final fractional = calculate(
      const HomeSimulationInput(units: 1, annualRateTenths: 31, months: 7),
      [const HostMilesTierRule(tierCode: 'TEST', minAum: 0, pointRate: .00525)],
    );
    expect(fractional.monthlyDividend, 25);
    expect(fractional.termDividend, 180);
    expect(fractional.monthlyMiles, 52);
    expect(fractional.miles, 367); // 52.5 * 7, not 52 * 7.

    expect(
      calculate(const HomeSimulationInput(units: 49), rules).tierCode,
      'REGULAR',
    );
    expect(
      calculate(const HomeSimulationInput(units: 50), rules).tierCode,
      'BRONZE',
    );
    expect(
      calculate(const HomeSimulationInput(units: 200), rules).tierCode,
      'BRONZE',
    );
    expect(
      calculate(const HomeSimulationInput(units: 1000), rules).tierCode,
      'MASTER',
    );
    expect(calculate(const HomeSimulationInput(), []).miles, isNull);
    expect(
      calculate(
        const HomeSimulationInput(units: 1, annualRateTenths: 30, months: 1),
        rules,
      ).termDividend,
      25,
    );
    expect(
      calculate(
        const HomeSimulationInput(
          units: 5000,
          annualRateTenths: 100,
          months: 36,
        ),
        rules,
      ).totalReceived,
      65000000,
    );
    expect(
      () => calculate(const HomeSimulationInput(months: 0), rules),
      throwsArgumentError,
    );
  });
  testWidgets(
    'a failed hotel lookup offers retry and never supplies sample hotels',
    (tester) async {
      var requests = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            simulationHotelsProvider.overrideWith((ref, points) async {
              expect(points, 63000);
              if (++requests == 1) throw StateError('offline');
              return [];
            }),
          ],
          child: MaterialApp(
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            locale: const Locale('ja'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: SimulationHotelResults(points: 63000)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(SimulationHotelResults)),
      );
      expect(find.text(l.homeDataLoadError), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      await tester.tap(find.text(l.commonRetry));
      await tester.pumpAndSettle();
      expect(find.text(l.simPointsHotelsEmpty), findsOneWidget);
      expect(requests, 2);
    },
  );
  testWidgets(
    'interactive inputs, payout type, navigation and narrow localized layout',
    (tester) async {
      final font = FontLoader('Jost')
        ..addFont(rootBundle.load('assets/fonts/Jost.ttf'));
      await font.load();
      final ja = FontLoader('Zen Kaku Gothic Antique')
        ..addFont(
          rootBundle.load('assets/fonts/ZenKakuGothicAntique-Regular.ttf'),
        );
      await ja.load();
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      for (final locale in AppLocalizations.supportedLocales) {
        for (final member in [false, true]) {
          tester.platformDispatcher.textScaleFactorTestValue = 1;
          tester.view.physicalSize = const Size(393, 852);
          final router = GoRouter(
            initialLocation: '/home/simulation',
            routes: [
              GoRoute(
                path: '/home/simulation',
                builder: (_, __) => const HomeSimulationPage(),
              ),
              GoRoute(
                path: '/home',
                builder: (_, __) => const Scaffold(body: Text('home')),
              ),
              GoRoute(
                path: '/guest-guide/register',
                builder: (_, state) => Scaffold(body: Text(state.uri.path)),
              ),
              GoRoute(
                path: '/hotel-booking/:id',
                builder: (_, state) {
                  final args = state.extra! as HotelDetailRouteArgs;
                  expect(args.mode, HotelBookingMode.hostMiles);
                  expect(args.criteria.checkInDate, DateTime(2026, 11, 22));
                  expect(args.criteria.checkOutDate, DateTime(2026, 11, 23));
                  return const Scaffold(body: Text('Hotel detail'));
                },
              ),
              GoRoute(
                path: '/funds',
                builder: (_, __) => const Scaffold(body: Text('funds')),
              ),
            ],
          );
          final capture = GlobalKey();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                simulationHotelsProvider.overrideWith(
                  (ref, points) async => [
                    for (var i = 0; i < 8; i++)
                      PointsHotel(
                        id: (42 + i).toString(),
                        name: i == 0 ? 'Kyoto Test' : 'Hotel $i',
                        buildingCode: '01',
                        nightlyPoints: 15400,
                        referenceCheckIn: DateTime(2026, 11, 22),
                        referenceCheckOut: DateTime(2026, 11, 23),
                      ),
                  ],
                ),
                isAuthenticatedProvider.overrideWithValue(AsyncData(member)),
                hostMilesRepositoryProvider.overrideWithValue(FakeRules()),
              ],
              child: MaterialApp.router(
                routerConfig: router,
                locale: locale,
                theme: AppThemeFactory.light(locale: locale),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) =>
                    RepaintBoundary(key: capture, child: child!),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text('¥5,000'), findsOneWidget);
          expect(find.text('¥1,060,000'), findsOneWidget);
          expect(find.text('FINANCIAL RETURN'), findsOneWidget);
          expect(find.text('EXPERIENCE RETURN'), findsOneWidget);
          expect(find.text('BRONZE'), findsOneWidget);
          if (locale.languageCode == 'ja' && !member) {
            await tester.runAsync(
              () => precacheImage(
                const AssetImage('assets/images/simulation_back.png'),
                tester.element(find.byType(HomeSimulationPage)),
              ),
            );
            await tester.pumpAndSettle();
            final boundary =
                capture.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            await tester.runAsync(() async {
              final image = await boundary.toImage();
              final bytes = await image.toByteData(
                format: ui.ImageByteFormat.png,
              );
              await File(
                '/tmp/stellavia-simulation.png',
              ).writeAsBytes(bytes!.buffer.asUint8List());
              image.dispose();
            });
            final l = AppLocalizations.of(
              tester.element(find.byType(HomeSimulationPage)),
            );
            await tester.ensureVisible(find.text(l.simEarnedMiles));
            await tester.pumpAndSettle();
            await tester.runAsync(() async {
              final image = await boundary.toImage();
              final bytes = await image.toByteData(
                format: ui.ImageByteFormat.png,
              );
              await File(
                '/tmp/stellavia-simulation-results.png',
              ).writeAsBytes(bytes!.buffer.asUint8List());
              image.dispose();
            });
            await tester.ensureVisible(
              find.byKey(const ValueKey('simulation-capital')),
            );
            await tester.pumpAndSettle();
          }
          final strings = AppLocalizations.of(
            tester.element(find.byType(HomeSimulationPage)),
          );
          final run = find.text(strings.simRunAction);
          await tester.ensureVisible(run);
          await tester.tap(run);
          await tester.pumpAndSettle();
          expect(find.text('Kyoto Test'), findsOneWidget);
          final rail = find.descendant(
            of: find.byType(SimulationHotelResults),
            matching: find.byType(SingleChildScrollView),
          );
          final viewport = tester.getRect(rail);
          final page = tester.getRect(find.byType(HomeSimulationPage));
          expect(viewport.left, page.left);
          expect(viewport.right, page.right);
          expect(
            tester.widget<SingleChildScrollView>(rail).padding,
            const EdgeInsets.symmetric(horizontal: UiTokens.spacing20),
          );
          expect(
            find.text(strings.simPointsHotelStay('15,400', 4)),
            findsNWidgets(6),
          );
          await tester.ensureVisible(find.text('Kyoto Test'));
          await tester.tap(find.text('Kyoto Test'));
          await tester.pumpAndSettle();
          expect(find.text('Hotel detail'), findsOneWidget);
          router.pop();
          await tester.pumpAndSettle();
          expect(find.text('Hotel 6'), findsNothing);
          final more = find.text(strings.homeShowMoreAction);
          await tester.ensureVisible(more);
          await tester.tap(more);
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.text('Hotel 7'),
            350,
            scrollable: find.byType(Scrollable).last,
          );
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Hotel 7'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Hotel 7'));
          await tester.pumpAndSettle();
          expect(find.text('Hotel detail'), findsOneWidget);
          router.pop();
          await tester.pumpAndSettle();
          expect(find.text('Hotel 7'), findsOneWidget);
          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();
          final rate = find.descendant(
            of: find.byKey(const ValueKey('simulation-rate-input')),
            matching: find.byType(TextField),
          );
          await tester.ensureVisible(rate);
          await tester.enterText(rate, '6.5');
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<Slider>(find.byKey(const ValueKey('simulation-rate')))
                .value,
            65,
          );
          await tester.enterText(rate, '6');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();
          final amount = find.descendant(
            of: find.byKey(const ValueKey('simulation-amount-input')),
            matching: find.byType(TextField),
          );
          await tester.ensureVisible(amount);
          await tester.enterText(amount, '200');
          await tester.pumpAndSettle();
          final amountSlider = find.byKey(const ValueKey('simulation-amount'));
          expect(tester.widget<Slider>(amountSlider).value, 200);
          tester.widget<Slider>(amountSlider).onChanged!(100);
          await tester.pumpAndSettle();
          expect(tester.widget<TextField>(amount).controller!.text, '100');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.ensureVisible(
            find.byKey(const ValueKey('simulation-capital')),
          );
          await tester.pumpAndSettle();
          final slider = tester.widget<Slider>(
            find.byKey(const ValueKey('simulation-months')),
          );
          slider.onChanged!(24);
          await tester.pumpAndSettle();
          expect(find.text('¥1,120,000'), findsOneWidget);
          expect(find.text('¥120,000'), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('simulation-capital')));
          await tester.pumpAndSettle();
          expect(find.text('¥120,000'), findsNWidgets(2));
          tester.view.physicalSize = const Size(320, 852);
          tester.platformDispatcher.textScaleFactorTestValue = 1.3;
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final l = AppLocalizations.of(
            tester.element(find.byType(HomeSimulationPage)),
          );
          final action = find.text(member ? l.homeFindFunds : l.simRegister);
          expect(
            find.ancestor(
              of: action,
              matching: find.byType(SingleChildScrollView),
            ),
            member ? findsWidgets : findsNothing,
          );
          if (member) await tester.ensureVisible(action);
          await tester.pumpAndSettle();
          await tester.tap(action);
          await tester.pumpAndSettle();
          expect(
            find.text(member ? 'funds' : '/guest-guide/register'),
            findsOneWidget,
          );
          await tester.pumpWidget(const SizedBox());
          router.dispose();
        }
      }
    },
  );
}
