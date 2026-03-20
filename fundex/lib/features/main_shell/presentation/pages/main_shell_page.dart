import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/main_shell_providers.dart';

class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shellNavigationTheme = theme.extension<AppShellNavigationTheme>()!;
    final currentTabIndex = ref.watch(mainShellCurrentTabIndexProvider);
    if (currentTabIndex != navigationShell.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        if (ref.read(mainShellCurrentTabIndexProvider) !=
            navigationShell.currentIndex) {
          ref.read(mainShellCurrentTabIndexProvider.notifier).state =
              navigationShell.currentIndex;
        }
      });
    }

    return Scaffold(
      key: const Key('home_page'),
      body: SafeArea(bottom: false, child: navigationShell),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
            Set<WidgetState> states,
          ) {
            return IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? colorScheme.primary
                  : shellNavigationTheme.bottomTabInactiveColor,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
            Set<WidgetState> states,
          ) {
            final base = theme.textTheme.labelMedium;
            return base?.copyWith(
              color: states.contains(WidgetState.selected)
                  ? colorScheme.primary
                  : shellNavigationTheme.bottomTabInactiveColor,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            );
          }),
        ),
        child: NavigationBar(
          key: const Key('main_tab_bar'),
          height: 60,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_rounded),
              selectedIcon: const Icon(Icons.home_rounded),
              label: l10n.mainTabHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.show_chart_rounded),
              selectedIcon: const Icon(Icons.show_chart_rounded),
              label: l10n.mainTabInvestment,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite),
              selectedIcon: const Icon(Icons.favorite),
              label: l10n.mainTabKizunark,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: l10n.mainTabProfile,
            ),
          ],
        ),
      ),
    );
  }
}
