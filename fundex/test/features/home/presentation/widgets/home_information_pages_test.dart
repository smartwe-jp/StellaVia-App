import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';
import 'package:fundex/features/home/presentation/support/home_rank_content.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/home/presentation/pages/home_rank_details_page.dart';
import 'package:fundex/features/home/presentation/pages/home_service_introduction_page.dart';

class RulesRepository implements HostMilesRepository {
  bool fail = false;
  List<HostMilesTierRule> rules = [
    const HostMilesTierRule(
      tierCode: 'REGULAR',
      minAum: 0,
      maxAum: 500000,
      pointRate: .005,
      expireMonths: 13,
      leadTimeMonths: 2,
      maxRooms: 2,
    ),
    const HostMilesTierRule(
      tierCode: 'BRONZE',
      minAum: 500000,
      maxAum: 2000000,
      pointRate: .00525,
      expireMonths: 15,
      leadTimeMonths: 3,
      maxRooms: 3,
    ),
    const HostMilesTierRule(
      tierCode: 'SILVER',
      minAum: 2000000,
      maxAum: 5000000,
      pointRate: .0055,
      expireMonths: 18,
      leadTimeMonths: 4,
      maxRooms: 4,
    ),
    const HostMilesTierRule(
      tierCode: 'GOLD',
      minAum: 5000000,
      maxAum: 10000000,
      pointRate: .00575,
      expireMonths: 21,
      leadTimeMonths: 5,
      maxRooms: 5,
    ),
    const HostMilesTierRule(
      tierCode: 'MASTER',
      minAum: 10000000,
      pointRate: .006,
      expireMonths: 24,
      leadTimeMonths: 6,
      maxRooms: 6,
    ),
  ];
  @override
  Future<List<HostMilesTierRule>> fetchTierRules() async {
    if (fail) throw StateError('fixture error');
    return rules;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GoRouter routerFor(String initial) => GoRouter(
  initialLocation: initial,
  routes: [
    GoRoute(
      path: '/home',
      builder: (_, _) => const Scaffold(body: Text('home')),
    ),
    GoRoute(
      path: '/home/service',
      builder: (_, _) => const HomeServiceIntroductionPage(),
    ),
    GoRoute(
      path: '/home/ranks',
      builder: (_, _) => const HomeRankDetailsPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, state) => Scaffold(
        body: Text('register=${state.uri.queryParameters['openRegister']}'),
      ),
    ),
    GoRoute(
      path: '/funds',
      builder: (_, _) => const Scaffold(body: Text('funds')),
    ),
  ],
);
Widget app(
  GoRouter router, {
  bool member = false,
  Locale locale = const Locale('ja'),
  double scale = 1,
  GlobalKey? capture,
  RulesRepository? repository,
}) => ProviderScope(
  overrides: [
    isAuthenticatedProvider.overrideWithValue(AsyncData(member)),
    hostMilesRepositoryProvider.overrideWithValue(
      repository ?? RulesRepository(),
    ),
  ],
  child: MaterialApp.router(
    routerConfig: router,
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
  ),
);
void main() {
  test(
    'rule mapping uses returned numbers, retains unknowns and sorts thresholds',
    () async {
      final l = await AppLocalizations.delegate.load(const Locale('ja'));
      final ranks = homeRankContent(l, [
        const HostMilesTierRule(
          tierCode: 'CUSTOM',
          minAum: 1234567,
          pointRate: .007125,
          expireMonths: 31,
          leadTimeMonths: 8,
          maxRooms: 9,
        ),
        const HostMilesTierRule(tierCode: 'START', minAum: 0, maxAum: 1234567),
        const HostMilesTierRule(tierCode: 'UNKNOWN'),
      ], 'ja');
      expect(ranks.first.name, 'START');
      expect(ranks[1].rate, '0.7125%');
      expect(ranks[1].investmentRange, '¥1,234,567以上');
      expect(ranks[1].validityMonths, 31);
      expect(ranks[1].advanceMonths, 8);
      expect(ranks[1].rooms, 9);
      expect(ranks.last.investmentRange, '—');
      expect(ranks.last.rate, '—');
      expect(ranks.last.rooms, isNull);
    },
  );
  testWidgets('both pages render changed API rules and recover from failures', (
    tester,
  ) async {
    for (final path in ['/home/service', '/home/ranks']) {
      final repo = RulesRepository()..fail = true;
      final router = routerFor(path);
      await tester.pumpWidget(app(router, repository: repo));
      await tester.pumpAndSettle();
      expect(find.text('MASTER'), findsNothing);
      final retry = find.text('再試行');
      await tester.ensureVisible(retry);
      repo.fail = false;
      repo.rules = [
        const HostMilesTierRule(
          tierCode: 'NEW_RANK',
          minAum: 1500000,
          pointRate: .008,
          expireMonths: 30,
          leadTimeMonths: 9,
          maxRooms: 10,
        ),
      ];
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(find.text('NEW_RANK'), findsOneWidget);
      expect(find.text('0.8%'), findsOneWidget);
      expect(find.text('30ヶ月'), findsOneWidget);
      expect(find.text('MASTER'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      router.dispose();
    }
  });

  testWidgets(
    'service to ranks preserves scroll and back; guest registration and member CTA work',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final member in [false, true]) {
        final router = routerFor('/home');
        await tester.pumpWidget(app(router, member: member));
        router.push('/home/service');
        await tester.pumpAndSettle();
        final details = find.text('ランク制度を詳しく見る');
        await tester.ensureVisible(details);
        await tester.pumpAndSettle();
        final scroll = tester
            .state<ScrollableState>(find.byType(Scrollable).first)
            .position
            .pixels;
        await tester.tap(details);
        await tester.pumpAndSettle();
        expect(find.byType(HomeRankDetailsPage), findsOneWidget);
        expect(find.text('0.525%'), findsOneWidget);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(HomeServiceIntroductionPage), findsOneWidget);
        expect(
          tester
              .state<ScrollableState>(find.byType(Scrollable).first)
              .position
              .pixels,
          closeTo(scroll, 1),
        );
        final cta = find.descendant(
          of: find.byType(SafeArea).last,
          matching: find.byType(AppButton),
        );
        await tester.tap(cta);
        await tester.pumpAndSettle();
        expect(find.text(member ? 'funds' : 'register=1'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
        router.dispose();
      }
      for (final path in ['/home/service', '/home/ranks']) {
        final router = routerFor(path);
        await tester.pumpWidget(app(router));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.text('home'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
        router.dispose();
      }
    },
  );
  testWidgets(
    'information pages render all localized tiers and long content on narrow screens',
    (tester) async {
      final manifest =
          jsonDecode(await rootBundle.loadString('FontManifest.json'))
              as List<dynamic>;
      for (final entry in manifest.cast<Map<String, dynamic>>()) {
        final loader = FontLoader(entry['family'] as String);
        for (final font in entry['fonts'] as List<dynamic>) {
          loader.addFont(rootBundle.load(font['asset'] as String));
        }
        await loader.load();
      }
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final locale in AppLocalizations.supportedLocales) {
        for (final path in ['/home/service', '/home/ranks']) {
          tester.view.physicalSize = const Size(320, 844);
          final router = routerFor(path);
          await tester.pumpWidget(app(router, locale: locale, scale: 1.3));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('MASTER'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$locale $path');
          expect(find.text('0.6%'), findsOneWidget);
          await tester.pumpWidget(const SizedBox());
          router.dispose();
        }
      }
      final output = Platform.environment['HOME_INFO_PREVIEW_DIR'];
      if (output != null) {
        for (final kind in ['service', 'ranks']) {
          tester.view.physicalSize = Size(393, kind == 'service' ? 5400 : 3100);
          final router = routerFor('/home/$kind');
          final key = GlobalKey();
          await tester.pumpWidget(app(router, capture: key));
          await tester.pumpAndSettle();
          if (kind == 'service') {
            await tester.runAsync(
              () => precacheImage(
                const AssetImage('assets/images/home_service_about.png'),
                tester.element(find.byType(HomeServiceIntroductionPage)),
              ),
            );
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await Directory(output).create(recursive: true);
            await File(
              '$output/$kind.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
          await tester.pumpWidget(const SizedBox());
          router.dispose();
        }
      }
    },
  );
}
