import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Shared scroll behavior used by the app shell and full-screen detail pages.
/// Each route owns its controller; scrolling a pushed page never changes tabs.
class AppScrollChromeController extends ChangeNotifier {
  AppScrollChromeController({
    required TickerProvider vsync,
    double initialReveal = 1,
  }) {
    _value = initialReveal.clamp(0, 1).toDouble();
    _snapController =
        AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 160),
        )..addListener(() {
          final animation = _snapAnimation;
          if (animation != null) _setReveal(animation.value);
        });
  }
  static const double revealDistance = 96;
  static const double activationDistance = 18;
  late final AnimationController _snapController;
  Animation<double>? _snapAnimation;
  double _pendingDistance = 0;
  ScrollDirection _userDirection = ScrollDirection.idle;
  double _value = 1;
  double get value => _value;
  bool _disposed = false;
  bool _notificationScheduled = false;

  void _setReveal(double reveal) {
    final next = reveal.clamp(0, 1).toDouble();
    if ((_value - next).abs() < .001) return;
    _value = next;
    // Resizing scroll viewports can dispatch notifications during layout.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationScheduled) return;
      _notificationScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _notificationScheduled = false;
        if (!_disposed) notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  void show() {
    _snapController.stop();
    _pendingDistance = 0;
    _setReveal(1);
  }

  @override
  void dispose() {
    _disposed = true;
    _snapController.dispose();
    super.dispose();
  }

  void _snap(ScrollMetrics metrics) {
    _pendingDistance = 0;
    final currentReveal = value;
    final isAtBottom = metrics.extentAfter <= 1;
    if (isAtBottom && currentReveal > 0.01) {
      return;
    }
    final targetReveal = currentReveal >= 0.5 ? 1.0 : 0.0;
    if ((currentReveal - targetReveal).abs() < 0.001) {
      _setReveal(targetReveal);
      return;
    }
    _snapAnimation = Tween<double>(begin: currentReveal, end: targetReveal)
        .animate(
          CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
        );
    _snapController.forward(from: 0);
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification is UserScrollNotification &&
        notification.direction != ScrollDirection.idle) {
      _userDirection = notification.direction;
    }
    if (notification.metrics.pixels <= notification.metrics.minScrollExtent) {
      // Hiding bars can make a short list fit and correct its offset to zero.
      // That is not a user's reverse gesture; keep the bars hidden until one.
      if (_userDirection != ScrollDirection.reverse ||
          notification.metrics.maxScrollExtent >
              notification.metrics.minScrollExtent) {
        show();
      }
      return false;
    }
    if (notification.metrics.outOfRange) {
      return false;
    }
    if (notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle) {
      _snap(notification.metrics);
      return false;
    }
    if (notification is! ScrollUpdateNotification) {
      return false;
    }

    final delta = notification.scrollDelta ?? 0;
    if (delta == 0) {
      return false;
    }
    // Viewport expansion can animate a correction back from the old bottom.
    // Do not interpret that correction as the user reversing their scroll.
    if (delta < 0 &&
        notification.dragDetails == null &&
        _userDirection == ScrollDirection.reverse) {
      return false;
    }
    _snapController.stop();
    final currentReveal = value;
    if (delta > 0 &&
        currentReveal > 0.01 &&
        notification.metrics.extentAfter <= 1 &&
        notification.dragDetails == null) {
      return false;
    }
    var effectiveDelta = delta;
    if (delta < 0 && currentReveal <= 0.01) {
      _pendingDistance += -delta;
      if (_pendingDistance < activationDistance) {
        return false;
      }
      effectiveDelta = -(_pendingDistance - activationDistance);
      _pendingDistance = activationDistance;
    } else if (delta > 0 || currentReveal > 0.01) {
      _pendingDistance = 0;
    }
    final nextReveal = currentReveal - (effectiveDelta / revealDistance);
    _setReveal(nextReveal);
    return false;
  }
}

/// Presentation only: same slide/fade/collapse geometry for either edge.
class AppScrollChromeVisibility extends StatelessWidget {
  const AppScrollChromeVisibility({
    super.key,
    required this.reveal,
    required this.child,
    this.bottom = false,
  });
  final double reveal;
  final Widget child;
  final bool bottom;
  @override
  Widget build(BuildContext context) {
    final value = reveal.clamp(0.0, 1.0);
    return ClipRect(
      child: Opacity(
        opacity: value,
        child: Align(
          heightFactor: value,
          alignment: bottom ? Alignment.bottomCenter : Alignment.topCenter,
          child: FractionalTranslation(
            translation: Offset(0, bottom ? 1 - value : value - 1),
            child: IgnorePointer(
              ignoring: value <= .01,
              child: ExcludeSemantics(excluding: value <= .01, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Optional scope for bars nested below a page's state/async content.
class AppScrollChromeScope
    extends InheritedNotifier<AppScrollChromeController> {
  const AppScrollChromeScope({
    super.key,
    required AppScrollChromeController controller,
    required super.child,
  }) : super(notifier: controller);
  static double revealOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AppScrollChromeScope>()
          ?.notifier
          ?.value ??
      1;
}

/// Collapses only the app-bar viewport. The toolbar itself always receives its
/// full height, and moves as a rigid surface below the stationary status inset.
class AppScrollNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AppScrollNavigationBar({
    super.key,
    required this.navigationBar,
    required this.reveal,
    this.backgroundColor,
  });
  final PreferredSizeWidget navigationBar;
  final double reveal;
  final Color? backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(
    navigationBar.preferredSize.height * reveal.clamp(0.0, 1.0),
  );

  @override
  Widget build(BuildContext context) {
    final value = reveal.clamp(0.0, 1.0);
    final height = navigationBar.preferredSize.height;
    return ColoredBox(
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height * value,
          width: double.infinity,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minHeight: height,
              maxHeight: height,
              child: Transform.translate(
                offset: Offset(0, -height * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: IgnorePointer(
                    ignoring: value <= .01,
                    child: ExcludeSemantics(
                      excluding: value <= .01,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: SizedBox(height: height, child: navigationBar),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
