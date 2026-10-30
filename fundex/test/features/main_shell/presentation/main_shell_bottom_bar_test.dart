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
import 'package:fundex/app/router/app_router.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/main_shell/presentation/widgets/main_shell_bottom_bar.dart';
import 'package:fundex/features/main_shell/presentation/providers/main_shell_providers.dart';

void main() {
  test('real router branch order and legacy order aliases', () {
    final c = ProviderContainer(
      overrides: [
        isAuthenticatedProvider.overrideWithValue(const AsyncData(true)),
      ],
    );
    addTearDown(c.dispose);
    final router = c.read(appRouterProvider);
    final shell = router.configuration.routes
        .whereType<StatefulShellRoute>()
        .single;
    expect(shell.branches.map((b) => (b.routes.first as GoRoute).path), [
      '/home',
      '/funds',
      '/hotel-booking',
      '/bookings',
      '/profile',
      '/discussion-board',
    ]);
    expect(
      router.configuration
          .findMatch(Uri.parse('/hotel-booking/orders'))
          .last
          .route
          .path,
      'orders',
    );
    expect(
      router.configuration
          .findMatch(Uri.parse('/hotel-booking/orders/42'))
          .last
          .route
          .path,
      'orders/:orderId',
    );
    expect(
      router.configuration
          .findMatch(Uri.parse('/bookings/history'))
          .last
          .route
          .path,
      'history',
    );
    expect(
      router.configuration.findMatch(Uri.parse('/bookings/42')).last.route.path,
      ':orderId',
    );
  });
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final e in manifest) {
      final loader = FontLoader(e['family'] as String);
      for (final f in e['fonts']) {
        loader.addFont(rootBundle.load(f['asset'] as String));
      }
      await loader.load();
    }
  });
  Widget app(
    Locale locale, {
    double scale = 1,
    GlobalKey? capture,
    ValueChanged<int>? onTap,
    int selected = 0,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: locale.languageCode == 'en'
        ? AppThemeFactory.dark(locale: locale)
        : AppThemeFactory.light(locale: locale),
    builder: (c, child) => MediaQuery(
      data: MediaQuery.of(c).copyWith(
        padding: const EdgeInsets.only(bottom: 34),
        textScaler: TextScaler.linear(scale),
      ),
      child: RepaintBoundary(key: capture, child: child!),
    ),
    home: Scaffold(
      bottomNavigationBar: MainShellBottomBar(
        currentTabIndex: selected,
        onSelected: onTap ?? (_) {},
      ),
    ),
  );
  testWidgets(
    'five equal tabs map callbacks, preserve safe area, and support narrow layouts',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 220);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      for (final locale in AppLocalizations.supportedLocales) {
        final taps = <int>[];
        await tester.pumpWidget(app(locale, scale: 1.3, onTap: taps.add));
        await tester.pumpAndSettle();
        final bar = tester.widget<AppBottomTabBar>(
          find.byType(AppBottomTabBar),
        );
        expect(bar.items.length, 5);
        for (final item in bar.items) {
          await tester.tap(find.text(item.label));
        }
        expect(taps, [0, 1, 2, 3, 4]);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
      await tester.pumpWidget(
        app(const Locale('ja'), selected: MainShellTab.kizunark.index),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<AppBottomTabBar>(find.byType(AppBottomTabBar))
            .selectedIndex,
        isNull,
      );
    },
  );
  testWidgets('capture tab bar', (tester) async {
    if (Platform.environment['TAB_CAPTURE'] != '1') return;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 140);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final key = GlobalKey();
    await tester.pumpWidget(app(const Locale('ja'), capture: key));
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final img = await boundary.toImage();
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      await File(
        '/tmp/stellavia-tabbar.png',
      ).writeAsBytes(data!.buffer.asUint8List());
      img.dispose();
    });
  });
}
