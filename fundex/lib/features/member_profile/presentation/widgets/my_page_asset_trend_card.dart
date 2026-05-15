import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/mypage_models.dart';

enum MyPageAssetTrendRange {
  oneMonth,
  threeMonths,
  oneYear;

  String get label {
    return switch (this) {
      MyPageAssetTrendRange.oneMonth => '1M',
      MyPageAssetTrendRange.threeMonths => '3M',
      MyPageAssetTrendRange.oneYear => '1Y',
    };
  }

  DateTime resolveStart(DateTime end) {
    return switch (this) {
      MyPageAssetTrendRange.oneMonth => DateTime(
        end.year,
        end.month - 1,
        end.day,
      ),
      MyPageAssetTrendRange.threeMonths => DateTime(
        end.year,
        end.month - 3,
        end.day,
      ),
      MyPageAssetTrendRange.oneYear => DateTime(
        end.year - 1,
        end.month,
        end.day,
      ),
    };
  }
}

class MyPageAssetTrendCard extends StatelessWidget {
  const MyPageAssetTrendCard({
    super.key,
    required this.title,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.records,
    this.isLoading = false,
  });

  final String title;
  final MyPageAssetTrendRange selectedRange;
  final ValueChanged<MyPageAssetTrendRange> onRangeChanged;
  final List<MyPageAssetTrend> records;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final chartPoints = _resolveChartPoints(records);
    final chartValues = chartPoints
        .map((point) => point.value)
        .toList(growable: false);
    final yAxisScale = _resolveYAxisScale(chartValues);
    final xAxisLabels = _resolveXAxisLabels(chartPoints);
    final yAxisLabels = _resolveYAxisLabels(yAxisScale);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        //border: Border.all(color: colors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: appText.pageTitle.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _TrendRangeSelector(
                  selectedRange: selectedRange,
                  onChanged: onRangeChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 178,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: _MyPageAssetTrendChart(
                      values: chartValues,
                      yAxisScale: yAxisScale,
                      xAxisLabels: xAxisLabels,
                      yAxisLabels: yAxisLabels,
                      lineColor: colors.highlightGold,
                      fillColor: colors.highlightGold.withValues(alpha: 0.08),
                      guideColor: colors.borderSoft,
                      labelStyle: appText.micro.copyWith(
                        color: colors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface.withValues(alpha: 0.42),
                            borderRadius: BorderRadius.circular(
                              UiTokens.radius12,
                            ),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendRangeSelector extends StatelessWidget {
  const _TrendRangeSelector({
    required this.selectedRange,
    required this.onChanged,
  });

  final MyPageAssetTrendRange selectedRange;
  final ValueChanged<MyPageAssetTrendRange> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: MyPageAssetTrendRange.values
          .map((range) {
            final isSelected = range == selectedRange;
            return Padding(
              padding: EdgeInsets.only(
                left: range == MyPageAssetTrendRange.oneMonth ? 0 : 8,
              ),
              child: Material(
                color: isSelected
                    ? colors.primary
                    : colors.highlightGold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(UiTokens.radius8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(UiTokens.radius8),
                  onTap: () => onChanged(range),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    child: Text(
                      range.label,
                      textAlign: TextAlign.center,
                      style: appText.button.copyWith(
                        color: isSelected
                            ? colors.onDark
                            : colors.textSecondary.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

List<_AssetTrendChartPoint> _resolveChartPoints(
  List<MyPageAssetTrend> records,
) {
  final sorted = [...records]
    ..sort(
      (lhs, rhs) => _parseTrendDate(
        lhs.recordDate,
      ).compareTo(_parseTrendDate(rhs.recordDate)),
    );

  final points = <_AssetTrendChartPoint>[];
  for (final record in sorted) {
    final value = _resolveTrendValue(record);
    if (value == null) {
      continue;
    }
    points.add(
      _AssetTrendChartPoint(
        date: _parseTrendDate(record.recordDate),
        value: value,
      ),
    );
  }
  return points;
}

double? _resolveTrendValue(MyPageAssetTrend record) {
  final total = record.totalAccount;
  if (total != null) {
    return total.toDouble();
  }

  final standby = record.totalFirstLevelAccount ?? 0;
  final fund = record.totalFundAccount ?? 0;
  final combined = standby + fund;
  return combined == 0 ? null : combined.toDouble();
}

DateTime _parseTrendDate(String? raw) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.tryParse(trimmed) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

class _AssetTrendChartPoint {
  const _AssetTrendChartPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

class _AssetTrendChartScale {
  const _AssetTrendChartScale({required this.min, required this.max});

  final double min;
  final double max;

  double get range => math.max(1.0, max - min);
  double get middle => min + range / 2;
}

class _MyPageAssetTrendChart extends StatelessWidget {
  const _MyPageAssetTrendChart({
    required this.values,
    required this.yAxisScale,
    required this.xAxisLabels,
    required this.yAxisLabels,
    required this.lineColor,
    required this.fillColor,
    required this.guideColor,
    required this.labelStyle,
  });

  final List<double> values;
  final _AssetTrendChartScale yAxisScale;
  final List<String> xAxisLabels;
  final List<String> yAxisLabels;
  final Color lineColor;
  final Color fillColor;
  final Color guideColor;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    const leftAxisWidth = 42.0;
    const bottomAxisHeight = 24.0;

    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: leftAxisWidth,
                child: _AxisLabelColumn(labels: yAxisLabels, style: labelStyle),
              ),
              Expanded(
                // CustomPaint has a zero preferred size without a child.
                // Force it to fill the Row's cross-axis height.
                child: SizedBox.expand(
                  child: CustomPaint(
                    painter: _MyPageAssetTrendPainter(
                      values: values,
                      yAxisScale: yAxisScale,
                      lineColor: lineColor,
                      fillColor: fillColor,
                      guideColor: guideColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: bottomAxisHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: leftAxisWidth),
            child: _AxisLabelRow(labels: xAxisLabels, style: labelStyle),
          ),
        ),
      ],
    );
  }
}

class _AxisLabelColumn extends StatelessWidget {
  const _AxisLabelColumn({required this.labels, required this.style});

  final List<String> labels;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: labels
          .map(
            (label) => Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: style,
            ),
          )
          .toList(growable: false),
    );
  }
}

class _AxisLabelRow extends StatelessWidget {
  const _AxisLabelRow({required this.labels, required this.style});

  final List<String> labels;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map(
            (label) => Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          )
          .toList(growable: false),
    );
  }
}

List<String> _resolveXAxisLabels(List<_AssetTrendChartPoint> points) {
  if (points.isEmpty) {
    return const <String>['--', '--', '--'];
  }
  final middleIndex = (points.length - 1) ~/ 2;
  return <String>[
    _formatAxisDate(points.first.date),
    _formatAxisDate(points[middleIndex].date),
    _formatAxisDate(points.last.date),
  ];
}

_AssetTrendChartScale _resolveYAxisScale(List<double> values) {
  if (values.isEmpty) {
    return const _AssetTrendChartScale(min: 0, max: 1);
  }

  final maxValue = values.reduce(math.max);
  return _AssetTrendChartScale(min: 0, max: math.max(1.0, maxValue));
}

List<String> _resolveYAxisLabels(_AssetTrendChartScale scale) {
  return <String>[
    _formatAxisAmount(scale.max),
    _formatAxisAmount(scale.middle),
    _formatAxisAmount(scale.min),
  ];
}

String _formatAxisDate(DateTime value) {
  return '${value.year}-${value.month}/${value.day}';
}

String _formatAxisAmount(double value) {
  if (value >= 100000000) {
    return '${(value / 100000000).toStringAsFixed(1)}億';
  }
  if (value >= 10000) {
    return '${(value / 10000).toStringAsFixed(0)}万';
  }
  return '${value.round()}';
}

class _MyPageAssetTrendPainter extends CustomPainter {
  const _MyPageAssetTrendPainter({
    required this.values,
    required this.yAxisScale,
    required this.lineColor,
    required this.fillColor,
    required this.guideColor,
  });

  final List<double> values;
  final _AssetTrendChartScale yAxisScale;
  final Color lineColor;
  final Color fillColor;
  final Color guideColor;

  @override
  void paint(Canvas canvas, Size size) {
    const horizontalInset = 10.0;
    const topInset = 14.0;
    const bottomInset = 14.0;
    final chartWidth = math.max(1.0, size.width - horizontalInset * 2);
    final chartHeight = math.max(1.0, size.height - topInset - bottomInset);
    final middleY = topInset + chartHeight / 2;
    final bottomY = topInset + chartHeight;

    final guidePaint = Paint()
      ..color = guideColor.withValues(alpha: 0.55)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(
        const Offset(horizontalInset, topInset),
        Offset(size.width - horizontalInset, topInset),
        guidePaint,
      )
      ..drawLine(
        Offset(horizontalInset, middleY),
        Offset(size.width - horizontalInset, middleY),
        guidePaint,
      )
      ..drawLine(
        Offset(horizontalInset, bottomY),
        Offset(size.width - horizontalInset, bottomY),
        guidePaint,
      );

    if (values.length < 2) {
      return;
    }

    final baselineRange = yAxisScale.range;

    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x =
          horizontalInset +
          (chartWidth * index / math.max(1, values.length - 1));
      final normalized = (values[index] - yAxisScale.min) / baselineRange;
      final y = topInset + chartHeight * (1 - normalized);
      points.add(Offset(x, y));
    }

    final linePath = _buildSmoothPath(points);
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, bottomY)
      ..lineTo(points.first.dx, bottomY)
      ..close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);
  }

  Path _buildSmoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    if (points.length == 2) {
      path.lineTo(points.last.dx, points.last.dy);
      return path;
    }

    for (var index = 0; index < points.length - 1; index++) {
      final current = points[index];
      final next = points[index + 1];
      final controlDistance = (next.dx - current.dx) * 0.42;
      path.cubicTo(
        current.dx + controlDistance,
        current.dy,
        next.dx - controlDistance,
        next.dy,
        next.dx,
        next.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _MyPageAssetTrendPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.yAxisScale.min != yAxisScale.min ||
        oldDelegate.yAxisScale.max != yAxisScale.max ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.guideColor != guideColor;
  }
}
