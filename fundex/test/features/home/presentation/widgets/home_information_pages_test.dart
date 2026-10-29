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
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/home/presentation/pages/home_rank_details_page.dart';
import 'package:fundex/features/home/presentation/pages/home_service_introduction_page.dart';

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
}) => ProviderScope(
  overrides: [isAuthenticatedProvider.overrideWithValue(AsyncData(member))],
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
