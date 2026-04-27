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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    colors.highlightGold.withValues(alpha: 0.9),
                    const Color(0xFFFFE8A7),
                    colors.highlightGold.withValues(alpha: 0.86),
                  ],
                ),
              ),
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
                        shadows: _softTextShadows,
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
                        color: colors.highlightGold,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '3,000',
                            maxLines: 1,
                            style: appText.numericDisplay.copyWith(
                              color: const Color(0xFFFFE7A1),
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              height: 0.9,
                              letterSpacing: -1.6,
                              shadows: _goldTextShadows,
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
                          shadows: _softTextShadows,
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
                shadows: _goldTextShadows,
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
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[colors.heroStart, colors.heroMiddle, colors.primaryAlt],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    _drawWindowPanel(canvas, size);
    _drawArc(canvas, size);
    _drawStars(canvas, size);
    _drawCoinStack(canvas, Offset(size.width * 0.05, size.height - 24), 5);
    _drawCoinStack(canvas, Offset(size.width * 0.92, size.height - 24), 6);
    _drawCoin(canvas, Offset(size.width * 0.98, size.height * 0.58), 14);
  }

  void _drawWindowPanel(Canvas canvas, Size size) {
    final panel = Rect.fromLTWH(0, 0, size.width * 0.28, size.height - 22);
    final panelPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.white.withValues(alpha: 0.16),
          Colors.white.withValues(alpha: 0.03),
        ],
      ).createShader(panel);
    canvas.drawRect(panel, panelPaint);

    final linePaint = Paint()
      ..color = colors.highlightGold.withValues(alpha: 0.18)
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
      ..color = colors.highlightGold.withValues(alpha: 0.58)
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
      ..color = const Color(0xFFFFF2B8)
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
      Paint()..color = Colors.white.withValues(alpha: 0.92),
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
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.14);
    canvas.drawOval(rect.shift(const Offset(0, 1.5)), shadowPaint);

    final coinPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFFFFF0A8),
          Color(0xFFC79837),
          Color(0xFFFFD978),
        ],
      ).createShader(rect);
    canvas.drawOval(rect, coinPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF8F6824).withValues(alpha: 0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(rect.deflate(2), borderPaint);

    final markStyle = Paint()
      ..color = const Color(0xFF8F6824).withValues(alpha: 0.56)
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

const _softTextShadows = <Shadow>[
  Shadow(color: Color(0x99000000), blurRadius: 4, offset: Offset(0, 1)),
];

const _goldTextShadows = <Shadow>[
  Shadow(color: Color(0x88000000), blurRadius: 5, offset: Offset(0, 1.5)),
  Shadow(color: Color(0x66FFFFFF), blurRadius: 4, offset: Offset(0, -1)),
];
