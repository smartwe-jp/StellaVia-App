import 'dart:math' as math;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/mypage_chart.dart';
import '../support/mypage_chart_display.dart';

class MyPageSummaryChartPlot extends StatefulWidget {
  const MyPageSummaryChartPlot({
    super.key,
    required this.data,
    required this.kind,
    this.filledMiles = false,
  });
  final MyPageChartData data;
  final MyPageChartKind kind;
  final bool filledMiles;
  @override
  State<MyPageSummaryChartPlot> createState() => _MyPageSummaryChartPlotState();
}

class _MyPageSummaryChartPlotState extends State<MyPageSummaryChartPlot> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    final points = widget.data.points;
    if (points.isEmpty) return const SizedBox.shrink();
    final values = points.map((p) => p.value.toDouble());
    final min = math.min(0.0, values.reduce(math.min));
    final max = math.max(min == 0 ? 1.0 : 0.0, values.reduce(math.max));
    final axis = MyPageChartStyles.axis(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final miles = widget.kind == MyPageChartKind.miles;
    final selectedPoint = selected == null ? null : points[selected!];
    final labelFormat = DateFormat(
      widget.filledMiles
          ? 'yyyy-MM'
          : miles
          ? 'yyyy/MM'
          : 'yyyy-MM-dd',
    );
    return Column(
      children: [
        if (selectedPoint != null)
          Text(
            '${selectedPoint.label}   ${miles ? '' : '¥'}${MyPageChartDisplay.amount(selectedPoint.value, locale)}',
            style: context.appTextTheme.caption,
          ),
        SizedBox(
          height: widget.filledMiles ? 196 : 136,
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i <= 4; i++)
                      FittedBox(
                        child: Text(
                          MyPageChartDisplay.axisValue(
                            max - (max - min) * i / 4,
                            widget.kind,
                            locale,
                          ),
                          style: axis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    void select(double x) {
                      final i = (x / box.maxWidth * (points.length - 1))
                          .round()
                          .clamp(0, points.length - 1);
                      if (i != selected) setState(() => selected = i);
                    }

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (d) => select(d.localPosition.dx),
                      onHorizontalDragUpdate: (d) => select(d.localPosition.dx),
                      child: CustomPaint(
                        size: Size(box.maxWidth, box.maxHeight),
                        painter: _SeriesPainter(
                          points: points,
                          minimum: min,
                          maximum: max,
                          area: !miles || widget.filledMiles,
                          selected: selected,
                          color: context.appColors.brandSecondary,
                          grid: context.appColors.borderSoft,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: LayoutBuilder(
            builder: (context, box) {
              final slots = math.max(1, (box.maxWidth / 66).floor());
              final count = math.min(points.length, slots);
              final labels = List.generate(count, (index) {
                final pointIndex = count == 1
                    ? 0
                    : (index * (points.length - 1) / (count - 1)).round();
                final point = points[pointIndex];
                return miles ? labelFormat.format(point.date) : point.label;
              });
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final label in labels)
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(label, style: axis),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SeriesPainter extends CustomPainter {
  const _SeriesPainter({
    required this.points,
    required this.minimum,
    required this.maximum,
    required this.area,
    required this.selected,
    required this.color,
    required this.grid,
  });
  final List<MyPageChartPoint> points;
  final double minimum, maximum;
  final bool area;
  final int? selected;
  final Color color, grid;
  @override
  void paint(Canvas canvas, Size size) {
    double y(num n) =>
        3 + (size.height - 6) * (maximum - n) / (maximum - minimum);
    double x(int i) => points.length == 1
        ? size.width / 2
        : size.width * i / (points.length - 1);
    for (var i = 0; i <= 4; i++) {
      final h = size.height * i / 4;
      canvas.drawLine(
        Offset(0, h),
        Offset(size.width, h),
        Paint()..color = grid,
      );
    }
    final line = Path()..moveTo(x(0), y(points.first.value));
    for (var i = 1; i < points.length; i++) {
      line.lineTo(x(i), y(points[i].value));
    }
    if (area) {
      final fill = Path.from(line)
        ..lineTo(x(points.length - 1), y(0))
        ..lineTo(x(0), y(0))
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: .28),
              color.withValues(alpha: .02),
            ],
          ).createShader(Offset.zero & size),
      );
    }
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color,
    );
    final index = selected ?? (points.length == 1 ? 0 : null);
    if (index != null) {
      canvas.drawCircle(
        Offset(x(index), y(points[index].value)),
        3,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_SeriesPainter old) =>
      old.points != points ||
      old.area != area ||
      old.selected != selected ||
      old.color != color ||
      old.grid != grid;
}
