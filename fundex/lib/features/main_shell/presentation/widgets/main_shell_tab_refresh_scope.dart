import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_connectivity_providers.dart';
import '../providers/main_shell_providers.dart';

class MainShellTabRefreshScope extends ConsumerStatefulWidget {
  const MainShellTabRefreshScope({
    super.key,
    required this.tabIndex,
    required this.child,
    required this.onRefresh,
  });

  final int tabIndex;
  final Widget child;
  final FutureOr<void> Function(WidgetRef ref) onRefresh;

  @override
  ConsumerState<MainShellTabRefreshScope> createState() =>
      _MainShellTabRefreshScopeState();
}

class _MainShellTabRefreshScopeState
    extends ConsumerState<MainShellTabRefreshScope> {
  bool _didInitialize = false;
  bool _wasActive = false;
  bool _refreshQueued = false;

  void _scheduleRefresh() {
    if (_refreshQueued || !mounted) {
      return;
    }
    if (shouldSkipAppNetworkRefresh(ref)) {
      return;
    }
    _refreshQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshQueued = false;
      if (!mounted) {
        return;
      }
      if (shouldSkipAppNetworkRefresh(ref)) {
        return;
      }
      unawaited(
        Future<void>.microtask(() async {
          await widget.onRefresh(ref);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTabIndex = ref.watch(mainShellCurrentTabIndexProvider);
    final isActive = currentTabIndex == widget.tabIndex;

    if (!_didInitialize) {
      _didInitialize = true;
      _wasActive = isActive;
    } else if (isActive && !_wasActive) {
      _wasActive = true;
      _scheduleRefresh();
    } else if (!isActive && _wasActive) {
      _wasActive = false;
    }

    return widget.child;
  }
}
