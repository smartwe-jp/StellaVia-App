import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../discussion_board/presentation/providers/discussion_board_providers.dart';
import '../../../discussion_board/presentation/state/discussion_send_queue_state.dart';
import '../providers/main_shell_providers.dart';

class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage>
    with SingleTickerProviderStateMixin {
  static const double _chromeRevealScrollDistance = 96;

  late final AnimationController _chromeSnapController;
  Animation<double>? _chromeSnapAnimation;

  @override
  void initState() {
    super.initState();
    _chromeSnapController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 160),
        )..addListener(() {
          final animation = _chromeSnapAnimation;
          if (animation == null) {
            return;
          }
          _setChromeReveal(animation.value);
        });
  }

  @override
  void dispose() {
    _chromeSnapController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(BuildContext context, int index) {
    _showChrome();
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _setChromeReveal(double reveal) {
    final nextReveal = reveal.clamp(0, 1).toDouble();
    final currentReveal = ref.read(mainShellChromeRevealProvider);
    if ((currentReveal - nextReveal).abs() < 0.001) {
      return;
    }
    ref.read(mainShellChromeRevealProvider.notifier).state = nextReveal;
    ref.read(mainShellChromeVisibleProvider.notifier).state = nextReveal > 0.01;
  }

  void _showChrome() {
    _chromeSnapController.stop();
    _setChromeReveal(1);
  }

  void _snapChromeReveal() {
    final currentReveal = ref.read(mainShellChromeRevealProvider);
    final targetReveal = currentReveal >= 0.5 ? 1.0 : 0.0;
    if ((currentReveal - targetReveal).abs() < 0.001) {
      _setChromeReveal(targetReveal);
      return;
    }
    _chromeSnapAnimation =
        Tween<double>(begin: currentReveal, end: targetReveal).animate(
          CurvedAnimation(
            parent: _chromeSnapController,
            curve: Curves.easeOutCubic,
          ),
        );
    _chromeSnapController.forward(from: 0);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification.metrics.pixels <= notification.metrics.minScrollExtent) {
      _showChrome();
      return false;
    }
    if (notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle) {
      _snapChromeReveal();
      return false;
    }
    if (notification is! ScrollUpdateNotification) {
      return false;
    }

    final delta = notification.scrollDelta ?? 0;
    if (delta == 0) {
      return false;
    }
    _chromeSnapController.stop();
    final currentReveal = ref.read(mainShellChromeRevealProvider);
    final nextReveal = currentReveal - (delta / _chromeRevealScrollDistance);
    _setChromeReveal(nextReveal);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final colorScheme = theme.colorScheme;
    final shellNavigationTheme = theme.extension<AppShellNavigationTheme>()!;
    final sendQueueState = ref.watch(discussionSendQueueProvider);
    final inactiveTabBackgroundColor = Color.alphaBlend(
      colors.highlightGold.withValues(alpha: 0.18),
      colors.surface,
    );
    final currentTabIndex = ref.watch(mainShellCurrentTabIndexProvider);
    final chromeReveal = ref
        .watch(mainShellChromeRevealProvider)
        .clamp(0, 1)
        .toDouble();
    final primaryScrollController = ref
        .watch(mainShellScrollControllerRegistryProvider)
        .controllerFor(currentTabIndex);
    if (currentTabIndex != widget.navigationShell.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        if (ref.read(mainShellCurrentTabIndexProvider) !=
            widget.navigationShell.currentIndex) {
          ref.read(mainShellCurrentTabIndexProvider.notifier).state =
              widget.navigationShell.currentIndex;
          _showChrome();
        }
      });
    }

    return PrimaryScrollController(
      controller: primaryScrollController,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          key: const Key('home_page'),
          body: SafeArea(bottom: false, child: widget.navigationShell),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(color: colors.surface),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _DiscussionSendQueueBar(
                  state: sendQueueState,
                  title: l10n.kizunarkSendingQueueTitle(
                    sendQueueState.pendingCount,
                  ),
                  cancelLabel: l10n.commonCancel,
                  onCancel: () => ref
                      .read(discussionSendQueueProvider.notifier)
                      .cancelAll(),
                ),
                ClipRect(
                  child: Opacity(
                    opacity: chromeReveal,
                    child: Align(
                      heightFactor: chromeReveal,
                      alignment: Alignment.bottomCenter,
                      child: FractionalTranslation(
                        translation: Offset(0, 1 - chromeReveal),
                        child: IgnorePointer(
                          ignoring: chromeReveal <= 0.01,
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
                                              : shellNavigationTheme
                                                    .bottomTabInactiveColor,
                                          onTap: () => _onDestinationSelected(
                                            context,
                                            0,
                                          ),
                                          badge: _MainTabBadge(
                                            backgroundColor:
                                                currentTabIndex == 0
                                                ? colorScheme.primary
                                                : inactiveTabBackgroundColor,
                                            child: Icon(
                                              Icons.home_rounded,
                                              size: 20,
                                              color: currentTabIndex == 0
                                                  ? colors.onDark
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
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
                                              : shellNavigationTheme
                                                    .bottomTabInactiveColor,
                                          onTap: () => _onDestinationSelected(
                                            context,
                                            1,
                                          ),
                                          badge: _MainTabBadge(
                                            backgroundColor:
                                                currentTabIndex == 1
                                                ? colorScheme.primary
                                                : inactiveTabBackgroundColor,
                                            child: Icon(
                                              Icons
                                                  .insert_chart_outlined_outlined,
                                              size: 20,
                                              color: currentTabIndex == 1
                                                  ? colors.onDark
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
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
                                              : shellNavigationTheme
                                                    .bottomTabInactiveColor,
                                          onTap: () => _onDestinationSelected(
                                            context,
                                            2,
                                          ),
                                          badge: _MainTabBadge(
                                            backgroundColor:
                                                currentTabIndex == 2
                                                ? colorScheme.primary
                                                : inactiveTabBackgroundColor,
                                            child: Image.asset(
                                              'assets/images/kizunark.tab.normal.png',
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.contain,
                                              color: currentTabIndex == 2
                                                  ? colors.onDark
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
                                              colorBlendMode: BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: _MainTabItem(
                                          label: l10n.mainTabProfile,
                                          isSelected: currentTabIndex == 3,
                                          labelColor: currentTabIndex == 3
                                              ? colorScheme.primary
                                              : shellNavigationTheme
                                                    .bottomTabInactiveColor,
                                          onTap: () => _onDestinationSelected(
                                            context,
                                            3,
                                          ),
                                          badge: _MainTabBadge(
                                            backgroundColor:
                                                currentTabIndex == 3
                                                ? colorScheme.primary
                                                : inactiveTabBackgroundColor,
                                            child: Icon(
                                              Icons.person_rounded,
                                              size: 20,
                                              color: currentTabIndex == 3
                                                  ? colors.onDark
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscussionSendQueueBar extends StatelessWidget {
  const _DiscussionSendQueueBar({
    required this.state,
    required this.title,
    required this.cancelLabel,
    required this.onCancel,
  });

  final DiscussionSendQueueState state;
  final String title;
  final String cancelLabel;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: state.isActive
          ? ColoredBox(
              key: const ValueKey<String>('discussion-send-queue-bar'),
              color: colors.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 2, 12, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appText.bodyStrong.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 24),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            foregroundColor: colors.primary,
                            textStyle: appText.bodyStrong,
                          ),
                          child: Text(cancelLabel),
                        ),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(
                    value: state.progress.clamp(0, 1).toDouble(),
                    minHeight: 3,
                    backgroundColor: colors.borderSoft,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
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
