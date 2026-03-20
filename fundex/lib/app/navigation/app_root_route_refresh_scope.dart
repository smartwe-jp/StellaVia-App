import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_route_observers.dart';

class AppRootRouteRefreshScope extends ConsumerStatefulWidget {
  const AppRootRouteRefreshScope({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final FutureOr<void> Function(WidgetRef ref) onRefresh;

  @override
  ConsumerState<AppRootRouteRefreshScope> createState() =>
      _AppRootRouteRefreshScopeState();
}

class _AppRootRouteRefreshScopeState
    extends ConsumerState<AppRootRouteRefreshScope>
    with RouteAware {
  ModalRoute<dynamic>? _route;
  bool _refreshQueued = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextRoute = ModalRoute.of(context);
    if (nextRoute == null || identical(nextRoute, _route)) {
      return;
    }

    if (_route != null) {
      appRootRouteObserver.unsubscribe(this);
    }
    _route = nextRoute;
    appRootRouteObserver.subscribe(this, nextRoute);
  }

  @override
  void dispose() {
    if (_route != null) {
      appRootRouteObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    _scheduleRefresh();
  }

  void _scheduleRefresh() {
    if (_refreshQueued || !mounted) {
      return;
    }
    _refreshQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshQueued = false;
      if (!mounted) {
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
    return widget.child;
  }
}
