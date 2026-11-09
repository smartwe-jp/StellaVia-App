import 'dart:math' as math;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/host_fund_management.dart';
import '../support/mypage_chart_display.dart';
import '../../domain/entities/mypage_chart.dart';

/// The website uses logarithmic axes with a minimum of one displayed unit.
class HostFundReturnChart extends StatefulWidget {
  const HostFundReturnChart({
    super.key,
    required this.labels,
    required this.amounts,
    required this.unitScale,
    required this.color,
    this.area = false,
  });
  final List<String> labels;
  final List<int> amounts;
  final int unitScale;
  final Color color;
  final bool area;
  @override
  State<HostFundReturnChart> createState() => _ChartState();
}

class _ChartState extends State<HostFundReturnChart> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    final values = widget.amounts, n = values.length;
    if (n == 0) return Text(context.l10n.myPageChartEmpty);
    final maximum = values.reduce(math.max);
    final exponent = math.max(
      1,
      (math.log(math.max(1, maximum / widget.unitScale)) / math.ln10).ceil(),
    );
    final ink = context.appTextTheme.micro;
    final index = selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (index != null && index < n)
          Text(
            '${widget.labels[index]}   ¥${fundMoney(values[index], Localizations.localeOf(context).toLanguageTag())}',
            style: ink,
          ),
        SizedBox(
          height: 140,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var e = exponent; e >= 0; e--)
                    Text(
                      widget.area
                          ? MyPageChartDisplay.axisValue(
                              math.pow(10, e).toDouble(),
                              MyPageChartKind.dividends,
                              Localizations.localeOf(context).toLanguageTag(),
                            )
                          : fundMoney(
                              math.pow(10, e),
                              Localizations.localeOf(context).toLanguageTag(),
                            ),
                      style: ink,
                    ),
                ],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    void select(double x) {
                      final i = widget.area
                          ? (x / box.maxWidth * (n - 1)).round()
                          : (x / box.maxWidth * n).floor();
                      setState(() => selected = i.clamp(0, n - 1));
                    }

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (d) => select(d.localPosition.dx),
                      onHorizontalDragUpdate: (d) => select(d.localPosition.dx),
                      child: CustomPaint(
                        size: Size(box.maxWidth, box.maxHeight),
                        painter: _ReturnPainter(
                          values,
                          widget.unitScale,
                          exponent,
                          widget.color,
                          context.appColors.borderSoft,
                          widget.area,
                          selected,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final i in {0, (n - 1) ~/ 2, n - 1})
              Flexible(child: Text(widget.labels[i], style: ink, maxLines: 1)),
          ],
        ),
      ],
    );
  }
}

class _ReturnPainter extends CustomPainter {
  const _ReturnPainter(
    this.values,
    this.unitScale,
    this.exponent,
    this.color,
    this.grid,
    this.area,
    this.selected,
  );
  final List<int> values;
  final int unitScale, exponent;
  final Color color, grid;
  final bool area;
  final int? selected;
  @override
  void paint(Canvas canvas, Size s) {
    for (var i = 0; i <= exponent; i++) {
      final y = s.height * i / exponent;
      canvas.drawLine(Offset(0, y), Offset(s.width, y), Paint()..color = grid);
    }
    final slot = s.width / values.length;
    final paint = Paint()..color = color;
    Offset? previous;
    for (var i = 0; i < values.length; i++) {
      final v = values[i] / unitScale;
      if (v <= 0) {
        previous = null;
        continue;
      }
      final y =
          s.height * (1 - (math.log(v) / math.ln10 / exponent).clamp(0, 1));
      final pt = Offset(
        area && values.length > 1
            ? s.width * i / (values.length - 1)
            : slot * (i + .5),
        y,
      );
      if (area) {
        if (previous != null) {
          final path = Path()
            ..moveTo(previous.dx, s.height)
            ..lineTo(previous.dx, previous.dy)
            ..lineTo(pt.dx, pt.dy)
            ..lineTo(pt.dx, s.height)
            ..close();
          canvas.drawPath(path, Paint()..color = color.withValues(alpha: .18));
          canvas.drawLine(
            previous,
            pt,
            Paint()
              ..color = color
              ..strokeWidth = 2,
          );
        }
        if (selected == i || values.length == 1) {
          canvas.drawCircle(pt, 3, paint);
        }
        previous = pt;
      } else {
        final half = math.min(slot * .33, 12.0);
        canvas.drawRect(
          Rect.fromLTRB(pt.dx - half, y, pt.dx + half, s.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ReturnPainter old) =>
      old.values != values ||
      old.selected != selected ||
      old.color != color ||
      old.grid != grid ||
      old.area != area ||
      old.unitScale != unitScale;
}
