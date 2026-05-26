import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/status_bar/app_status_bar_providers.dart';

class HotelStatusBarPreferenceScope extends ConsumerStatefulWidget {
  const HotelStatusBarPreferenceScope({
    super.key,
    required this.immersive,
    required this.child,
    this.immersiveOnPop = false,
  });

  final bool immersive;
  final bool immersiveOnPop;
  final Widget child;

  @override
  ConsumerState<HotelStatusBarPreferenceScope> createState() =>
      _HotelStatusBarPreferenceScopeState();
}

class _HotelStatusBarPreferenceScopeState
    extends ConsumerState<HotelStatusBarPreferenceScope> {
  @override
  void initState() {
    super.initState();
    _apply(widget.immersive);
  }

  @override
  void didUpdateWidget(covariant HotelStatusBarPreferenceScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.immersive != widget.immersive) {
      _apply(widget.immersive);
    }
  }

  void _apply(bool immersive) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(appImmersiveHotelStatusBarHintProvider.notifier).state =
          immersive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      onPopInvokedWithResult: (bool didPop, void result) {
        if (didPop && widget.immersiveOnPop) {
          _apply(true);
        }
      },
      child: widget.child,
    );
  }
}
