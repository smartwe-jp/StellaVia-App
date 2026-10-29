import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Refresh account/catalog on foreground and when a pushed page returns home.
/// Tab reselection and pull-to-refresh are handled by the existing home scope.
class HomeMilesRefreshScope extends StatefulWidget {
  const HomeMilesRefreshScope({
    super.key,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final Future<void> Function() onRefresh;
  @override
  State<HomeMilesRefreshScope> createState() => _HomeMilesRefreshScopeState();
}

class _HomeMilesRefreshScopeState extends State<HomeMilesRefreshScope>
    with WidgetsBindingObserver {
  GoRouter? _router;
  String? _lastPath;
  bool _queued = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (identical(router, _router)) return;
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _router = router;
    _lastPath = router.routerDelegate.state.uri.path;
    router.routerDelegate.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    final path = _router?.routerDelegate.state.uri.path;
    final returnedHome = path == '/home' && _lastPath != '/home';
    _lastPath = path;
    if (returnedHome) _scheduleRefresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _scheduleRefresh();
  }

  void _scheduleRefresh() {
    if (_queued) return;
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (mounted) unawaited(widget.onRefresh());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
