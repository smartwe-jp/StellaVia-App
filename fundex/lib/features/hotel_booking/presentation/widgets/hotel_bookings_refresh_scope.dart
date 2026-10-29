import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HotelBookingsRefreshScope extends StatefulWidget {
  const HotelBookingsRefreshScope({
    super.key,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final Future<void> Function() onRefresh;
  @override
  State<HotelBookingsRefreshScope> createState() =>
      _HotelBookingsRefreshScopeState();
}

class _HotelBookingsRefreshScopeState extends State<HotelBookingsRefreshScope>
    with WidgetsBindingObserver {
  GoRouter? _router;
  String? _path;
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
    _router?.routerDelegate.removeListener(_changed);
    _router = router;
    _path = router?.routerDelegate.state.uri.path;
    router?.routerDelegate.addListener(_changed);
  }

  void _changed() {
    final path = _router?.routerDelegate.state.uri.path;
    final returned =
        path == '/bookings' && _path != null && _path!.startsWith('/bookings/');
    _path = path;
    if (returned) _refresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _path == '/bookings') _refresh();
  }

  void _refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(widget.onRefresh());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router?.routerDelegate.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
