import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import 'app_realtime_refresh.dart';

class AppLifecycleRefreshScope extends ConsumerStatefulWidget {
  const AppLifecycleRefreshScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLifecycleRefreshScope> createState() =>
      _AppLifecycleRefreshScopeState();
}

class _AppLifecycleRefreshScopeState
    extends ConsumerState<AppLifecycleRefreshScope>
    with WidgetsBindingObserver {
  DateTime? _lastResumeRefreshAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    final isAuthenticated =
        ref.read(isAuthenticatedProvider).asData?.value == true;
    if (!isAuthenticated) {
      return;
    }

    final now = DateTime.now();
    final lastRefreshAt = _lastResumeRefreshAt;
    if (lastRefreshAt != null &&
        now.difference(lastRefreshAt) < const Duration(seconds: 1)) {
      return;
    }
    _lastResumeRefreshAt = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(
        Future<void>.microtask(() {
          invalidateAuthenticatedRealtimeProviders(ref);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
