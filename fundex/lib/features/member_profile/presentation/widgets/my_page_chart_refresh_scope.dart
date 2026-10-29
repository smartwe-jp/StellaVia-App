import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/mypage_chart_providers.dart';
import '../providers/mypage_membership_providers.dart';

/// The root tab keeps chart state. Refresh it on foreground and detail return.
class MyPageChartRefreshScope extends ConsumerStatefulWidget {
  const MyPageChartRefreshScope({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<MyPageChartRefreshScope> createState() =>
      _MyPageChartRefreshScopeState();
}

class _MyPageChartRefreshScopeState
    extends ConsumerState<MyPageChartRefreshScope>
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
    final router = GoRouter.maybeOf(context);
    if (identical(router, _router)) return;
    _router?.routerDelegate.removeListener(_routeChanged);
    _router = router;
    _lastPath = router?.routerDelegate.state.uri.path;
    router?.routerDelegate.addListener(_routeChanged);
  }

  void _routeChanged() {
    final path = _router?.routerDelegate.state.uri.path;
    final returned =
        path == '/profile' && _lastPath != null && _lastPath != '/profile';
    _lastPath = path;
    if (returned) _refresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _lastPath == '/profile') {
      _refresh();
    }
  }

  void _refresh() {
    if (_queued) return;
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (!mounted || shouldSkipAppNetworkRefresh(ref)) return;
      unawaited(ref.read(myPageTierProvider.notifier).refresh());
      unawaited(ref.read(myPageMilesAccountProvider.notifier).refresh());
      for (final kind in MyPageChartKind.values) {
        unawaited(ref.read(myPageChartProvider(kind).notifier).refresh());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router?.routerDelegate.removeListener(_routeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
