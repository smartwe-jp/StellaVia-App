import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/main_shell_providers.dart';

class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(BuildContext context, WidgetRef ref, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final colorScheme = theme.colorScheme;
    final shellNavigationTheme = theme.extension<AppShellNavigationTheme>()!;
    final inactiveTabBackgroundColor = Color.alphaBlend(
      colors.highlightGold.withValues(alpha: 0.18),
      colors.surface,
    );
    final currentTabIndex = ref.watch(mainShellCurrentTabIndexProvider);
    final primaryScrollController = ref
        .watch(mainShellScrollControllerRegistryProvider)
        .controllerFor(currentTabIndex);
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

    return PrimaryScrollController(
      controller: primaryScrollController,
      child: Scaffold(
        key: const Key('home_page'),
        body: SafeArea(bottom: false, child: navigationShell),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(color: colors.surface),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 1,
                width: double.infinity,
                color: colors.border,
              ),
              SafeArea(
                top: false,
                child: SizedBox(
                  key: const Key('main_tab_bar'),
                  height: 68,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _MainTabItem(
                          label: l10n.mainTabHome,
                          isSelected: currentTabIndex == 0,
                          labelColor: currentTabIndex == 0
                              ? colorScheme.primary
                              : shellNavigationTheme.bottomTabInactiveColor,
                          onTap: () => _onDestinationSelected(context, ref, 0),
                          badge: _MainTabBadge(
                            backgroundColor: currentTabIndex == 0
                                ? colorScheme.primary
                                : inactiveTabBackgroundColor,
                            child: Icon(
                              Icons.home_rounded,
                              size: 20,
                              color: currentTabIndex == 0
                                  ? colors.onDark
                                  : shellNavigationTheme.bottomTabInactiveColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _MainTabItem(
                          label: l10n.mainTabInvestment,
                          isSelected: currentTabIndex == 1,
                          labelColor: currentTabIndex == 1
                              ? colorScheme.primary
                              : shellNavigationTheme.bottomTabInactiveColor,
                          onTap: () => _onDestinationSelected(context, ref, 1),
                          badge: _MainTabBadge(
                            backgroundColor: currentTabIndex == 1
                                ? colorScheme.primary
                                : inactiveTabBackgroundColor,
                            child: Icon(
                              Icons.insert_chart_outlined_outlined,
                              size: 20,
                              color: currentTabIndex == 1
                                  ? colors.onDark
                                  : shellNavigationTheme.bottomTabInactiveColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _MainTabItem(
                          label: l10n.mainTabKizunark,
                          isSelected: currentTabIndex == 2,
                          labelColor: currentTabIndex == 2
                              ? colorScheme.primary
                              : shellNavigationTheme.bottomTabInactiveColor,
                          onTap: () => _onDestinationSelected(context, ref, 2),
                          badge: _MainTabBadge(
                            backgroundColor: currentTabIndex == 2
                                ? colorScheme.primary
                                : inactiveTabBackgroundColor,
                            child: Image.asset(
                              'assets/images/kizunark.tab.normal.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: currentTabIndex == 2
                                  ? colors.onDark
                                  : shellNavigationTheme.bottomTabInactiveColor,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _MainTabItem(
                          label: l10n.mainTabHotel,
                          isSelected: currentTabIndex == 3,
                          labelColor: currentTabIndex == 3
                              ? colorScheme.primary
                              : shellNavigationTheme.bottomTabInactiveColor,
                          onTap: () => _onDestinationSelected(context, ref, 3),
                          badge: _MainTabBadge(
                            backgroundColor: currentTabIndex == 3
                                ? colorScheme.primary
                                : inactiveTabBackgroundColor,
                            child: Icon(
                              Icons.hotel_rounded,
                              size: 20,
                              color: currentTabIndex == 3
                                  ? colors.onDark
                                  : shellNavigationTheme.bottomTabInactiveColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _MainTabItem(
                          label: l10n.mainTabProfile,
                          isSelected: currentTabIndex == 4,
                          labelColor: currentTabIndex == 4
                              ? colorScheme.primary
                              : shellNavigationTheme.bottomTabInactiveColor,
                          onTap: () => _onDestinationSelected(context, ref, 4),
                          badge: _MainTabBadge(
                            backgroundColor: currentTabIndex == 4
                                ? colorScheme.primary
                                : inactiveTabBackgroundColor,
                            child: Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: currentTabIndex == 4
                                  ? colors.onDark
                                  : shellNavigationTheme.bottomTabInactiveColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainTabItem extends StatelessWidget {
  const _MainTabItem({
    required this.label,
    required this.isSelected,
    required this.labelColor,
    required this.onTap,
    required this.badge,
  });

  final String label;
  final bool isSelected;
  final Color labelColor;
  final VoidCallback onTap;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          badge,
          const SizedBox(height: 4),
          Text(
            label,
            style: labelStyle?.copyWith(
              color: labelColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainTabBadge extends StatelessWidget {
  const _MainTabBadge({required this.backgroundColor, required this.child});

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: SizedBox(width: 32, height: 32, child: Center(child: child)),
    );
  }
}
