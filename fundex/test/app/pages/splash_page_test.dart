import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('resolveSplashNavigationTarget', () {
    test('always routes to home', () {
      final target = resolveSplashNavigationTarget();
      expect(target, '/home');
    });
  });

  testWidgets('splash lifts over a stationary home page', (tester) async {
    const homeKey = Key('home');
    final router = GoRouter(
      initialLocation: '/home/splash',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(key: homeKey),
          routes: [
            GoRoute(
              path: 'splash',
              pageBuilder: (_, state) => buildSplashCurtainPage(
                key: state.pageKey,
                reduceMotion: false,
              ),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        routerConfig: router,
      ),
    );
    await tester.pump();
    final splash = find.byType(SplashPage);
    final height = tester.getSize(splash).height;
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(
      tester.getTopLeft(splash).dy,
      allOf(lessThan(0), greaterThan(-height)),
    );
    expect(tester.getTopLeft(find.byKey(homeKey)), Offset.zero);
    await tester.pumpAndSettle();
    expect(splash, findsNothing);
    expect(router.canPop(), isFalse);
  });
}
