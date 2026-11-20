import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppDashedBorderPainter extends CustomPainter {
  const AppDashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Path source = Path()..addRRect(rrect);
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double segmentLength = math.min(dash, metric.length - distance);
        canvas.drawPath(
          metric.extractPath(distance, distance + segmentLength),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant AppDashedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth ||
        dash != oldDelegate.dash ||
        gap != oldDelegate.gap;
  }
}
