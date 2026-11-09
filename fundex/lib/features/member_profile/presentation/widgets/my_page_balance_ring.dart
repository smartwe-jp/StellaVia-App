import 'dart:math' as math;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../asset_statistics/domain/entities/asset_statistics_models.dart';
import '../support/mypage_chart_display.dart';

class MyPageBalanceRing extends StatefulWidget {
  const MyPageBalanceRing({
    super.key,
    required this.value,
    required this.unit,
    required this.label,
    required this.holdings,
  });
  final String value, unit, label;
  final List<AssetInvestment> holdings;
  @override
  State<MyPageBalanceRing> createState() => _MyPageBalanceRingState();
}

class _MyPageBalanceRingState extends State<MyPageBalanceRing> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    final items = widget.holdings;
    final amounts = [
      for (final item in items) math.max(0, item.investMoneyValid ?? 0),
    ];
    final sum = amounts.fold<int>(0, (a, b) => a + b);
    final item = selected == null ? null : items[selected!];
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 228),
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, box) {
                final radius = box.maxWidth / 2;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (tap) {
                    final offset = tap.localPosition - Offset(radius, radius);
                    int? hit;
                    if (sum > 0 &&
                        offset.distance >= radius * .60 &&
                        offset.distance <= radius * .93) {
                      final angle =
                          (math.atan2(offset.dy, offset.dx) + math.pi / 2) %
                          (2 * math.pi);
                      final target = angle / (2 * math.pi) * sum;
                      var running = 0;
                      for (var i = 0; i < amounts.length; i++) {
                        running += amounts[i];
                        if (target < running) {
                          hit = i;
                          break;
                        }
                      }
                    }
                    setState(() => selected = hit);
                  },
                  child: CustomPaint(
                    painter: _HoldingsPainter(
                      amounts,
                      sum,
                      selected,
                      context.appColors.primarySoft,
                    ),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: .58,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.label,
                              style: context.appTextTheme.caption,
                            ),
                            FittedBox(
                              child: Text(
                                '${widget.value} ${widget.unit}',
                                style: context.appTextTheme.numericTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (item != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${item.projectName?.isNotEmpty == true ? item.projectName : item.projectId ?? '—'}\n${item.beginDate ?? '—'} ～ ${item.endDate ?? '—'}\n${MyPageChartDisplay.amount(item.investMoneyValid ?? 0, Localizations.localeOf(context).toLanguageTag())} ${widget.unit}',
              textAlign: TextAlign.center,
              style: context.appTextTheme.caption,
            ),
          ),
      ],
    );
  }
}

class _HoldingsPainter extends CustomPainter {
  const _HoldingsPainter(this.amounts, this.sum, this.selected, this.track);
  final List<int> amounts;
  final int sum;
  final int? selected;
  final Color track;
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: r * .75,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * .30
      ..color = track;
    canvas.drawOval(rect, paint);
    if (sum == 0) return;
    var start = -math.pi / 2;
    for (var i = 0; i < amounts.length; i++) {
      final sweep = amounts[i] / sum * 2 * math.pi;
      paint
        ..color = MyPageChartDisplay
            .ringColors[i % MyPageChartDisplay.ringColors.length]
        ..strokeWidth = r * (i == selected ? .35 : .30);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_HoldingsPainter old) =>
      old.amounts != amounts || old.selected != selected || old.track != track;
}
