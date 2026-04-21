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
    final chartValues = _resolveChartValues(records);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.border),
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
              height: 144,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MyPageAssetTrendPainter(
                        values: chartValues,
                        lineColor: colors.highlightGold,
                        fillColor: colors.highlightGold.withValues(alpha: 0.08),
                        guideColor: colors.borderSoft,
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
                color: isSelected ? colors.primary : colors.highlightGold.withValues(alpha: 0.18),
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

List<double> _resolveChartValues(List<MyPageAssetTrend> records) {
  final sorted = [...records]
    ..sort(
      (lhs, rhs) => _parseTrendDate(
        lhs.recordDate,
      ).compareTo(_parseTrendDate(rhs.recordDate)),
    );

  final values = sorted
      .map(_resolveTrendValue)
      .whereType<double>()
      .toList(growable: false);
  return values;
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

class _MyPageAssetTrendPainter extends CustomPainter {
  const _MyPageAssetTrendPainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
    required this.guideColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;
  final Color guideColor;

  @override
  void paint(Canvas canvas, Size size) {
    const horizontalInset = 10.0;
    const topInset = 14.0;
    const bottomInset = 14.0;

    final guidePaint = Paint()
      ..color = guideColor.withValues(alpha: 0.55)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(horizontalInset, size.height - bottomInset),
      Offset(size.width - horizontalInset, size.height - bottomInset),
      guidePaint,
    );

    if (values.length < 2) {
      return;
    }

    final chartWidth = math.max(1.0, size.width - horizontalInset * 2);
    final chartHeight = math.max(1.0, size.height - topInset - bottomInset);
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = maxValue - minValue;
    final paddedRange = range == 0 ? math.max(1.0, maxValue * 0.08) : range;
    final baselineMin = minValue - paddedRange * 0.18;
    final baselineMax = maxValue + paddedRange * 0.18;
    final baselineRange = math.max(1.0, baselineMax - baselineMin);

    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x =
          horizontalInset +
          (chartWidth * index / math.max(1, values.length - 1));
      final normalized = (values[index] - baselineMin) / baselineRange;
      final y = topInset + chartHeight * (1 - normalized);
      points.add(Offset(x, y));
    }

    final linePath = _buildSmoothPath(points);
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height - bottomInset)
      ..lineTo(points.first.dx, size.height - bottomInset)
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
      final control = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      path.quadraticBezierTo(current.dx, current.dy, control.dx, control.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    return path;
  }

  @override
  bool shouldRepaint(covariant _MyPageAssetTrendPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.guideColor != guideColor;
  }
}
