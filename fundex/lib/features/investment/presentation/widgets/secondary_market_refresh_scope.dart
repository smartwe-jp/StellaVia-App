import 'package:flutter/material.dart';
import '../../../../app/navigation/app_route_observers.dart';

/// Refresh retained trading pages on navigation return and foregrounding.
class SecondaryMarketRefreshScope extends StatefulWidget {
  const SecondaryMarketRefreshScope({
    super.key,
    required this.onRefresh,
    required this.child,
  });
  final VoidCallback onRefresh;
  final Widget child;
  @override
  State<SecondaryMarketRefreshScope> createState() =>
      _SecondaryMarketRefreshScopeState();
}

class _SecondaryMarketRefreshScopeState
    extends State<SecondaryMarketRefreshScope>
    with WidgetsBindingObserver, RouteAware {
  ModalRoute<dynamic>? _route;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route == _route) return;
    appRootRouteObserver.unsubscribe(this);
    _route = route;
    if (route != null) appRootRouteObserver.subscribe(this, route);
  }

  @override
  void didPopNext() => _refresh();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onRefresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appRootRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
