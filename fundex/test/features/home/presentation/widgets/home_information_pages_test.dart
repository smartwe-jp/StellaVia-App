import 'package:fundex/features/home/presentation/widgets/home_brand_intro.dart';
import 'package:fundex/features/home/presentation/widgets/home_service_features_card.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fundex/features/home/presentation/widgets/home_service_banners.dart';
import 'package:fundex/features/home/presentation/pages/home_service_detail_page.dart';
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
import 'package:fundex/features/home/presentation/widgets/home_rank_details_section.dart';
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
      path: '/banners',
      builder: (_, _) => const Scaffold(body: HomeServiceBanners()),
    ),
    GoRoute(
      path: '/home/features',
      builder: (_, _) => const HomeServiceDetailPage.features(),
    ),
    GoRoute(
      path: '/home/miles',
      builder: (_, _) => const HomeServiceDetailPage.benefits(),
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
      path: '/guest-guide/register',
      builder: (_, state) => Scaffold(body: Text(state.uri.path)),
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
  testWidgets('two returns panels stack on phones and align on wide screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final router = routerFor('/home/features');
    addTearDown(router.dispose);
    for (final width in [320.0, 1024.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(app(router, scale: 1.3));
      await tester.pumpAndSettle();
      final heading = find.text('TWO RETURNS');
      await tester.scrollUntilVisible(
        heading,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      final future = tester.getTopLeft(find.text('FINANCIAL RETURN').first);
      final now = tester.getTopLeft(find.text('EXPERIENCE RETURN').first);
      if (width == 320) {
        expect(now.dx, future.dx);
        expect(now.dy, greaterThan(future.dy));
      } else {
        expect(now.dy, future.dy);
        expect(now.dx, greaterThan(future.dx));
      }
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('banners advance every ten seconds and wrap to the first card', (
    tester,
  ) async {
    final router = routerFor('/banners');
    addTearDown(router.dispose);
    await tester.pumpWidget(app(router));
    await tester.pumpAndSettle();
    final l = AppLocalizations.of(
      tester.element(find.byType(HomeServiceBanners)),
    );
    await tester.pump(const Duration(seconds: 9));
    expect(find.text(l.bannerFeatures).hitTestable(), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text(l.homeGuestBenefitsTitle).hitTestable(), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(find.text(l.bannerFeatures).hitTestable(), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  for (final member in [false, true]) {
    testWidgets(
      'home banners swipe and open distinct native details member=$member',
      (tester) async {
        final router = routerFor('/banners');
        addTearDown(router.dispose);
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(member ? 320 : 390, 844);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        await tester.pumpWidget(
          app(router, member: member, scale: member ? 1.3 : 1),
        );
        await tester.pumpAndSettle();
        final l = AppLocalizations.of(
          tester.element(find.byType(HomeServiceBanners)),
        );
        expect(
          tester.getSize(find.byType(HomeServiceFeaturesCard).first).height,
          tester.getSize(find.byType(HomeBrandIntro).first).height,
        );
        if (member) {
          await tester.tap(find.text(l.bannerFeatures).hitTestable());
        } else {
          final card = tester.getRect(
            find.byType(HomeServiceFeaturesCard).first,
          );
          await tester.tapAt(card.bottomLeft + const Offset(16, -16));
        }
        await tester.pumpAndSettle();
        expect(find.text(l.featuresDetailTitle), findsOneWidget);
        expect(
          find.widgetWithText(AppBrandHeading, l.homeServiceAboutTitle),
          findsOneWidget,
        );
        expect(
          find.text(member ? l.homeFindFunds : l.homeRegisterFree),
          findsOneWidget,
        );
        final scroll = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.text(l.featuresFaq1Q),
          450,
          scrollable: scroll,
        );
        expect(find.text(l.featuresFaq1A), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text(l.featuresFaq2Q).hitTestable(),
          160,
          scrollable: scroll,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.featuresFaq2Q));
        await tester.pumpAndSettle();
        expect(find.text(l.featuresFaq2A), findsOneWidget);
        expect(find.text(l.featuresFaq1A), findsNothing);
        await tester.tap(find.text(l.featuresFaq2Q));
        await tester.pumpAndSettle();
        expect(find.text(l.featuresFaq2A), findsNothing);
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView),
          Offset(
            -tester.getSize(find.byType(HomeServiceBanners)).width * .8,
            0,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l.homeGuestEyebrow).hitTestable(), findsOneWidget);
        expect(find.text('MASTER').hitTestable(), findsOneWidget);
        await tester.tap(
          find
              .text(
                member
                    ? l.homeFeaturedFundViewDetailAction
                    : l.homeGuestBenefitsTitle,
              )
              .hitTestable(),
        );
        await tester.pumpAndSettle();
        expect(find.text(l.homeServiceTitle), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text(l.benefitsStory2Title),
          450,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(l.benefitsStory2TagAmount), findsOneWidget);
        expect(find.text(l.benefitsStory2RankUp), findsOneWidget);
        expect(find.text(l.benefitsResultRankLabel), findsNWidgets(2));
        expect(find.textContaining('37,650'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();
        expect(find.byType(HomeServiceBanners), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

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
      expect(ranks[1].investmentRange, '123.4567万円以上');
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
      final retry = find.descendant(
        of: find.byType(HomeRankDetailsSection),
        matching: find.text('再試行'),
      );
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
    'service omits rank detail CTA; registration, member CTA and back work',
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
        expect(find.text('ランク制度を詳しく見る'), findsNothing);
        final cta = find.descendant(
          of: find.byType(SafeArea).last,
          matching: find.byType(AppButton),
        );
        await tester.tap(cta);
        await tester.pumpAndSettle();
        expect(
          find.text(member ? 'funds' : '/guest-guide/register'),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox());
        router.dispose();
      }
      for (final path in ['/home/service', '/home/ranks']) {
        final router = routerFor(path);
        await tester.pumpWidget(app(router));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(AppNavigationIconButton));
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
          if (path == '/home/service') {
            final l = AppLocalizations.of(
              tester.element(find.byType(HomeServiceIntroductionPage)),
            );
            expect(find.text('HOST BENEFITS'), findsOneWidget);
            expect(find.text(l.homeServiceBenefitsTitle), findsOneWidget);
            expect(find.text(l.homeServiceBenefitsBody), findsOneWidget);
          }
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
        for (final kind in ['service', 'ranks', 'silver']) {
          tester.view.physicalSize = Size(
            393,
            kind == 'service'
                ? 5400
                : kind == 'silver'
                ? 852
                : 3100,
          );
          final router = routerFor(
            kind == 'silver' ? '/home/service' : '/home/$kind',
          );
          final key = GlobalKey();
          await tester.pumpWidget(
            app(router, capture: key, member: kind == 'silver'),
          );
          await tester.pumpAndSettle();
          if (kind == 'silver') {
            await Scrollable.ensureVisible(
              tester.element(find.byKey(const ValueKey('rank-SILVER'))),
              alignment: 0.04,
            );
            await tester.pumpAndSettle();
            expect(find.text('200万円 ～ 500万円'), findsOneWidget);
          }
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
            final image = await boundary.toImage(
              pixelRatio: kind == 'silver' ? 3 : 1,
            );
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
