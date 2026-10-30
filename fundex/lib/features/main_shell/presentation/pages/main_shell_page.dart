import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../discussion_board/presentation/providers/discussion_board_providers.dart';
import '../../../discussion_board/presentation/state/discussion_send_queue_state.dart';
import '../providers/main_shell_providers.dart';
import '../widgets/main_shell_bottom_bar.dart';

class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage>
    with SingleTickerProviderStateMixin {
  late final AppScrollChromeController _chrome;

  @override
  void initState() {
    super.initState();
    _chrome = AppScrollChromeController(
      vsync: this,
      initialReveal: ref.read(mainShellChromeRevealProvider),
    )..addListener(_syncChrome);
  }

  void _syncChrome() {
    ref.read(mainShellChromeRevealProvider.notifier).state = _chrome.value;
    ref.read(mainShellChromeVisibleProvider.notifier).state =
        _chrome.value > .01;
  }

  @override
  void dispose() {
    _chrome.dispose();
    super.dispose();
  }

  void _onDestinationSelected(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _showChrome() {
    _chrome.show();
    _syncChrome();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final sendQueueState = ref.watch(discussionSendQueueProvider);
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
        onNotification: _chrome.handleScrollNotification,
        child: Scaffold(
          key: const Key('home_page'),
          body: SafeArea(
            top: false,
            bottom: false,
            child: widget.navigationShell,
          ),
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
                  clipBehavior: Clip.none,
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
                              MainShellBottomBar(
                                currentTabIndex: currentTabIndex,
                                onSelected: (index) =>
                                    _onDestinationSelected(context, index),
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
