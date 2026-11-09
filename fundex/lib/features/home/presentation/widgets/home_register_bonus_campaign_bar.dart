import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HomeRegisterBonusCampaignBar extends StatelessWidget {
  const HomeRegisterBonusCampaignBar({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final locale = Localizations.localeOf(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius8),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(painter: _CampaignBarPainter(colors: colors)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 22,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: AppColorTokens.brandBaseCream),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      body,
                      maxLines: 1,
                      style: appText.caption.copyWith(
                        color: colors.heroStart,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 22,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 6, 48, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      maxLines: 1,
                      style: appText.bodyStrong.copyWith(
                        color: colors.onDark,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _StackedLabel(
                        label: _maxLabel(locale),
                        color: AppColorTokens.brandLilac,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '3,000',
                            maxLines: 1,
                            style: appText.numericDisplay.copyWith(
                              color: AppColorTokens.brandLilac,
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              height: 0.9,
                              letterSpacing: -1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _amountUnit(locale),
                        style: appText.bodyStrong.copyWith(
                          color: colors.onDark,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedLabel extends StatelessWidget {
  const _StackedLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final characters = label.characters.toList(growable: false);
    if (characters.length > 3) {
      return Text(
        label,
        style: appText.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: characters
          .map(
            (String char) => Text(
              char,
              style: appText.micro.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                height: 0.95,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _CampaignBarPainter extends CustomPainter {
  const _CampaignBarPainter({required this.colors});

  final AppSemanticColorTheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = colors.heroStart);

    _drawWindowPanel(canvas, size);
    _drawArc(canvas, size);
    _drawStars(canvas, size);
    _drawCoinStack(canvas, Offset(size.width * 0.05, size.height - 24), 5);
    _drawCoinStack(canvas, Offset(size.width * 0.92, size.height - 24), 6);
    _drawCoin(canvas, Offset(size.width * 0.98, size.height * 0.58), 14);
  }

  void _drawWindowPanel(Canvas canvas, Size size) {
    final panel = Rect.fromLTWH(0, 0, size.width * 0.28, size.height - 22);
    final panelPaint = Paint()..color = colors.onDark.withValues(alpha: 0.08);
    canvas.drawRect(panel, panelPaint);

    final linePaint = Paint()
      ..color = colors.primaryAlt.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (var index = 1; index <= 2; index++) {
      final x = panel.width * index / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, panel.height), linePaint);
    }
    canvas.drawLine(
      Offset(0, panel.height * 0.48),
      Offset(panel.width, panel.height * 0.48),
      linePaint,
    );
  }

  void _drawArc(Canvas canvas, Size size) {
    final arcPaint = Paint()
      ..color = colors.primaryAlt.withValues(alpha: 0.58)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final path = Path()
      ..moveTo(size.width * 0.72, size.height * 0.14)
      ..quadraticBezierTo(
        size.width * 0.82,
        -size.height * 0.08,
        size.width * 0.92,
        size.height * 0.12,
      );
    canvas.drawPath(path, arcPaint);
  }

  void _drawStars(Canvas canvas, Size size) {
    _drawStar(canvas, Offset(size.width * 0.64, size.height * 0.38), 8);
    _drawStar(canvas, Offset(size.width * 0.86, size.height * 0.16), 9);
    _drawStar(canvas, Offset(size.width * 0.52, size.height * 0.27), 5);
  }

  void _drawStar(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppColorTokens.brandLilac
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
    canvas.drawCircle(
      center,
      math.max(1.2, radius * 0.18),
      Paint()..color = colors.onDark.withValues(alpha: 0.92),
    );
  }

  void _drawCoinStack(Canvas canvas, Offset bottomCenter, int count) {
    for (var index = 0; index < count; index++) {
      _drawCoin(
        canvas,
        Offset(bottomCenter.dx, bottomCenter.dy - index * 6.2),
        15,
      );
    }
  }

  void _drawCoin(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final shadowPaint = Paint()
      ..color = colors.heroStart.withValues(alpha: 0.14);
    canvas.drawOval(rect.shift(const Offset(0, 1.5)), shadowPaint);

    final coinPaint = Paint()..color = AppColorTokens.brandLilac;
    canvas.drawOval(rect, coinPaint);

    final borderPaint = Paint()
      ..color = colors.brandPrimary.withValues(alpha: 0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(rect.deflate(2), borderPaint);

    final markStyle = Paint()
      ..color = colors.brandPrimary.withValues(alpha: 0.56)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final markRect = Rect.fromCenter(
      center: center,
      width: radius * 0.64,
      height: radius * 0.72,
    );
    canvas.drawArc(markRect, -math.pi * 0.35, math.pi * 1.25, false, markStyle);
  }

  @override
  bool shouldRepaint(covariant _CampaignBarPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}

String _maxLabel(Locale locale) {
  switch (locale.languageCode.toLowerCase()) {
    case 'en':
      return 'UP';
    case 'zh':
      return '最高';
    default:
      return '最大';
  }
}

String _amountUnit(Locale locale) {
  switch (locale.languageCode.toLowerCase()) {
    case 'en':
      return 'JPY';
    case 'zh':
      return '日元';
    default:
      return '円分';
  }
}
