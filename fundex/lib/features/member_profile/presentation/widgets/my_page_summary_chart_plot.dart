import 'dart:math' as math;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/mypage_chart.dart';
import '../support/mypage_chart_display.dart';

class MyPageSummaryChartPlot extends StatelessWidget {
  const MyPageSummaryChartPlot({
    super.key,
    required this.data,
    required this.years,
    required this.bars,
  });
  final MyPageChartData data;
  final int years;
  final bool bars;
  @override
  Widget build(BuildContext context) {
    final points = bars ? MyPageChartDisplay.bars(data, years) : data.points;
    return Column(
      children: [
        SizedBox(
          height: 64,
          width: double.infinity,
          child: CustomPaint(
            painter: _SummaryPainter(
              points: points,
              start: data.start,
              end: DateTime(data.end.year, 12, 31),
              bars: bars,
              line: context.appColors.brandSecondary,
              primary: context.appColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 9),
        LayoutBuilder(
          builder: (context, constraints) {
            final labels = MyPageChartDisplay.labels(data, years);
            return SizedBox(
              height: 18 * MediaQuery.textScalerOf(context).scale(1),
              child: Stack(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Positioned(
                      left:
                          constraints.maxWidth *
                              (years == 1
                                  ? (int.parse(labels[i]) - .5) / 12
                                  : (i + .5) / labels.length) -
                          18,
                      width: 36,
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: MyPageChartStyles.axis(context),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SummaryPainter extends CustomPainter {
  const _SummaryPainter({
    required this.points,
    required this.start,
    required this.end,
    required this.bars,
    required this.line,
    required this.primary,
  });
  final List<MyPageChartPoint> points;
  final DateTime start, end;
  final bool bars;
  final Color line, primary;
  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final minimum = math.min(
      0.0,
      points.map((p) => p.value.toDouble()).reduce(math.min),
    );
    final maximum = math.max(
      1.0,
      points.map((p) => p.value.toDouble()).reduce(math.max),
    );
    final span = maximum - minimum;
    double y(num v) => 3 + (size.height - 6) * (1 - (v - minimum) / span);
    double x(DateTime d) =>
        3 +
        (size.width - 6) *
            d.difference(start).inMilliseconds /
            math.max(1, end.difference(start).inMilliseconds);
    if (bars) {
      final months = start.year == end.year;
      final count = months ? 12 : end.year - start.year + 1;
      final slot = size.width / count;
      for (var i = 0; i < points.length; i++) {
        final p = points[i];
        final index = months ? p.date.month - 1 : p.date.year - start.year;
        final top = math.min(y(p.value), y(0));
        final height = math.max(1.0, (y(p.value) - y(0)).abs());
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(index * slot + slot * .22, top, slot * .56, height),
            const Radius.circular(2),
          ),
          Paint()
            ..color = i == points.length - 1
                ? primary
                : line.withValues(alpha: .32),
        );
      }
      return;
    }
    final path = Path()..moveTo(x(points.first.date), y(points.first.value));
    for (final p in points.skip(1)) {
      path.lineTo(x(p.date), y(p.value));
    }
    final fill = Path.from(path)
      ..lineTo(x(points.last.date), y(0))
      ..lineTo(x(points.first.date), y(0))
      ..close();
    canvas.drawPath(fill, Paint()..color = line.withValues(alpha: .12));
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(
      Offset(x(points.last.date), y(points.last.value)),
      2.5,
      Paint()..color = line,
    );
  }

  @override
  bool shouldRepaint(covariant _SummaryPainter old) =>
      old.points != points ||
      old.start != start ||
      old.end != end ||
      old.bars != bars ||
      old.line != line ||
      old.primary != primary;
}
