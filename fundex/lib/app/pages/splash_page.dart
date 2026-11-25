import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Duration _minimumSplashDuration = Duration(milliseconds: 2500);
const Duration _progressFillDuration = Duration(milliseconds: 2000);
const Duration _logoPulseDuration = Duration(milliseconds: 2000);
const String _brandLockupAssetPath =
    'assets/images/stellavia.logoAndText.light.png';

CustomTransitionPage<void> buildSplashCurtainPage({
  required LocalKey key,
  required bool reduceMotion,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 900),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
        child: child,
      );
    },
  );
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.destination});
  final String? destination;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoPulseController;
  late final Animation<double> _logoScaleAnimation;
  late final AnimationController _progressController;
  Timer? _deferredNavigationTimer;
  bool _minimumElapsed = false;

  @override
  void initState() {
    super.initState();

    _logoPulseController = AnimationController(
      vsync: this,
      duration: _logoPulseDuration,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: _progressFillDuration,
    )..forward();

    _deferredNavigationTimer = Timer(_minimumSplashDuration, () {
      _minimumElapsed = true;
      _finishIfReady();
    });
  }

  @override
  void didUpdateWidget(SplashPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_minimumElapsed && oldWidget.destination != widget.destination) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _finishIfReady());
    }
  }

  void _finishIfReady() {
    if (!mounted || ModalRoute.of(context)?.isActive != true) return;
    final destination = widget.destination;
    if (destination != null) context.go(destination);
  }

  @override
  void dispose() {
    _deferredNavigationTimer?.cancel();
    _logoPulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final onDark = colors.onDark;
    final isDark = theme.brightness == Brightness.dark;
    final splashGradientColors = isDark
        ? <Color>[
            Color.alphaBlend(
              colors.brandPrimaryDark.withValues(alpha: 0.96),
              colors.background,
            ),
            Color.alphaBlend(
              colors.heroStart.withValues(alpha: 0.94),
              colors.brandPrimaryDark,
            ),
            Color.alphaBlend(
              colors.heroEnd.withValues(alpha: 0.96),
              colors.background,
            ),
          ]
        : <Color>[
            Color.alphaBlend(
              colors.brandPrimaryDark.withValues(alpha: 0.12),
              colors.heroStart,
            ),
            Color.alphaBlend(
              colors.brandPrimaryDark.withValues(alpha: 0.08),
              colors.heroMiddle,
            ),
            Color.alphaBlend(
              colors.brandPrimaryDark.withValues(alpha: 0.12),
              colors.heroEnd,
            ),
          ];

    return Scaffold(
      key: const Key('splash_page'),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.65, -1),
            end: const Alignment(0.85, 1),
            colors: splashGradientColors,
            stops: const <double>[0, 0.5, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: onDark.withValues(alpha: 0.12),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      _brandLockupAssetPath,
                      width: 154,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 120,
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (BuildContext context, Widget? child) {
                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(color: onDark.withValues(alpha: 0.18)),
                            FractionallySizedBox(
                              widthFactor: _progressController.value,
                              alignment: Alignment.centerLeft,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      colors.brandPrimaryBright.withValues(
                                        alpha: 0.92,
                                      ),
                                      onDark.withValues(alpha: 0.92),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
