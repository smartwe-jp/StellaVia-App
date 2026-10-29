import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/home/presentation/widgets/home_miles_refresh_scope.dart';

void main() {
  testWidgets(
    'returning home and foreground trigger refresh, disposal stops listener',
    (tester) async {
      var refreshes = 0;
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => HomeMilesRefreshScope(
              onRefresh: () async {
                refreshes++;
              },
              child: const Scaffold(body: Text('home')),
            ),
          ),
          GoRoute(
            path: '/detail',
            builder: (context, state) => const Scaffold(body: Text('detail')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(refreshes, 0);
      router.push('/detail');
      await tester.pumpAndSettle();
      expect(refreshes, 0);
      router.pop();
      await tester.pumpAndSettle();
      expect(refreshes, 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(refreshes, 2);
      await tester.pumpWidget(const SizedBox());
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(refreshes, 2);
    },
  );
}
