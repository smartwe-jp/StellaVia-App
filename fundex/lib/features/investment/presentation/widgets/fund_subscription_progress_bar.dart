import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundSubscriptionProgressBar extends StatelessWidget {
  const FundSubscriptionProgressBar({
    super.key,
    required this.label,
    required this.ratio,
  });

  final String label;
  final double? ratio;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = context.appTextTheme.button;
    final value = ratio;
    final fraction = value != null && value.isFinite
        ? value.clamp(0.0, 1.0).toDouble()
        : 0.0;
    final shape = StadiumBorder(side: BorderSide(color: colors.border));
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: colors.surface,
        ),
        foregroundDecoration: ShapeDecoration(shape: shape),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: fraction,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      AppColorTokens.brandLilac,
                      colors.brandPrimary,
                      fraction,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Stack(
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeJoin = StrokeJoin.round
                        ..strokeWidth = 2
                        ..color = colors.scrim.withValues(alpha: 1),
                    ),
                  ),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: style.copyWith(color: colors.brandWhite),
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
