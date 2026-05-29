import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class AppLoadingDialogHandle {
  AppLoadingDialogHandle._(this._entry);

  final OverlayEntry _entry;
  Timer? _timer;
  bool _dismissed = false;

  void dismiss() {
    if (_dismissed) {
      return;
    }
    _dismissed = true;
    _timer?.cancel();
    _entry.remove();
  }
}

class AppLoadingDialog {
  const AppLoadingDialog._();

  static AppLoadingDialogHandle show(
    BuildContext context, {
    String? message,
    Duration? timeout = const Duration(seconds: 300), // 5 minutes
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AppLoadingDialogView(message: message),
    );
    overlay.insert(entry);
    final handle = AppLoadingDialogHandle._(entry);
    if (timeout != null) {
      handle._timer = Timer(timeout, handle.dismiss);
    }
    return handle;
  }

  static Future<T> run<T>(
    BuildContext context,
    Future<T> Function() task, {
    String? message,
    Duration? timeout,
  }) async {
    final handle = show(context, message: message, timeout: timeout);
    try {
      return await task();
    } finally {
      handle.dismiss();
    }
  }
}

class _AppLoadingDialogView extends StatelessWidget {
  const _AppLoadingDialogView({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final text = message?.trim() ?? '';
    final barrierAlpha = theme.brightness == Brightness.dark ? 0.58 : 0.28;
    return Positioned.fill(
      child: Material(
        color: colors.scrim.withValues(alpha: barrierAlpha),
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 22, 24, text.isEmpty ? 22 : 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const _AppLoadingSpinner(),
                  if (text.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppLoadingSpinner extends StatefulWidget {
  const _AppLoadingSpinner();

  @override
  State<_AppLoadingSpinner> createState() => _AppLoadingSpinnerState();
}

class _AppLoadingSpinnerState extends State<_AppLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 920),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SizedBox.square(
      dimension: 46,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * math.pi * 2,
            child: child,
          );
        },
        child: CustomPaint(
          painter: _LoadingRingPainter(
            trackColor: colors.borderSoft,
            color: colors.brandPrimary,
          ),
        ),
      ),
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  const _LoadingRingPainter({required this.trackColor, required this.color});

  final Color trackColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.shortestSide * 0.14;
    final rect =
        Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = trackColor.withValues(alpha: 0.55);
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = color;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.42, false, segmentPaint);
  }

  @override
  bool shouldRepaint(covariant _LoadingRingPainter oldDelegate) {
    return oldDelegate.trackColor != trackColor || oldDelegate.color != color;
  }
}
