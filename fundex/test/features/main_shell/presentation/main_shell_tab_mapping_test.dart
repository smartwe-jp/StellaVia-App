import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/main_shell/presentation/providers/main_shell_providers.dart';
import 'package:fundex/features/main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';

void main() {
  test('main shell tab order matches the router branch order', () {
    expect(MainShellTab.home.index, 0);
    expect(MainShellTab.hotel.index, 2);
    expect(MainShellTab.investment.index, 1);
    expect(MainShellTab.bookings.index, 3);
    expect(MainShellTab.profile.index, 4);
    expect(MainShellTab.kizunark.index, 5);
  });

  testWidgets('tab refresh scope refreshes only when its tab becomes active', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    var refreshCount = 0;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: MainShellTabRefreshScope(
            tabIndex: MainShellTab.investment.index,
            onRefresh: (_) async {
              refreshCount++;
            },
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );

    expect(refreshCount, 0);

    container.read(mainShellCurrentTabIndexProvider.notifier).state =
        MainShellTab.hotel.index;
    await tester.pump();
    expect(refreshCount, 0);

    container.read(mainShellCurrentTabIndexProvider.notifier).state =
        MainShellTab.investment.index;
    await tester.pump();
    await tester.pump();
    expect(refreshCount, 1);

    container.read(mainShellCurrentTabIndexProvider.notifier).state =
        MainShellTab.profile.index;
    await tester.pump();
    container.read(mainShellCurrentTabIndexProvider.notifier).state =
        MainShellTab.investment.index;
    await tester.pump();
    await tester.pump();
    expect(refreshCount, 2);
  });
}
