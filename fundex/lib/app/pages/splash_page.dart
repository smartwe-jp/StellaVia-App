import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations_ext.dart';

const Duration _minimumSplashDuration = Duration(milliseconds: 2500);
const Duration _progressFillDuration = Duration(milliseconds: 2000);
const Duration _logoPulseDuration = Duration(milliseconds: 2000);

String resolveSplashNavigationTarget() {
  return '/home';
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final DateTime _enteredAt;
  late final AnimationController _logoPulseController;
  late final Animation<double> _logoScaleAnimation;
  late final AnimationController _progressController;
  Timer? _deferredNavigationTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _enteredAt = DateTime.now();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNavigation();
    });
  }

  @override
  void dispose() {
    _deferredNavigationTimer?.cancel();
    _logoPulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _scheduleNavigation() {
    if (!mounted || _hasNavigated) {
      return;
    }

    final targetRoute = resolveSplashNavigationTarget();
    final elapsed = DateTime.now().difference(_enteredAt);
    final remaining = _minimumSplashDuration - elapsed;

    _deferredNavigationTimer?.cancel();
    if (remaining <= Duration.zero) {
      _navigate(targetRoute);
      return;
    }

    _deferredNavigationTimer = Timer(remaining, () {
      _navigate(targetRoute);
    });
  }

  void _navigate(String targetRoute) {
    if (!mounted || _hasNavigated) {
      return;
    }
    _hasNavigated = true;
    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    _scheduleNavigation();

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final onDark = colors.onDark;

    return Scaffold(
      key: const Key('splash_page'),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.65, -1),
            end: const Alignment(0.85, 1),
            colors: <Color>[
              colors.heroStart,
              colors.heroMiddle,
              colors.heroEnd,
            ],
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
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          colors.brandPrimary,
                          colors.brandPrimaryBright,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.36),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 44,
                      color: onDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.splashBrandName,
                  style: appText.heroTitle.copyWith(
                    color: onDark,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.splashBrandSlogan,
                  style: appText.bodySemi.copyWith(
                    color: onDark.withValues(alpha: 0.72),
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.splashTagline,
                  style: appText.bodySemi.copyWith(
                    color: onDark.withValues(alpha: 0.42),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
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
                            Container(
                              color: onDark.withValues(alpha: 0.18),
                            ),
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
