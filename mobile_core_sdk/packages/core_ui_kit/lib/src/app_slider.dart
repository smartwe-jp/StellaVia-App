import 'package:flutter/material.dart';
import 'app_theme_extensions.dart';

/// Brand slider with native keyboard, focus and accessibility behavior.
class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    this.sliderKey,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.semanticFormatterCallback,
  });
  final Key? sliderKey;
  final double value, min, max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final SemanticFormatterCallback? semanticFormatterCallback;
  @override
  Widget build(BuildContext context) => SliderTheme(
    data: SliderTheme.of(context).copyWith(
      trackHeight: 6,
      activeTrackColor: context.appColors.brandPrimaryBright,
      inactiveTrackColor: context.appColors.surfaceAlt,
      thumbColor: context.appColors.surface,
      overlayColor: context.appColors.brandPrimaryBright.withValues(alpha: .15),
      activeTickMarkColor: context.appColors.brandPrimaryBright,
      inactiveTickMarkColor: context.appColors.surfaceAlt,
      thumbShape: _OutlinedThumb(context.appColors.brandPrimaryBright),
      trackShape: const RoundedRectSliderTrackShape(),
    ),
    child: SizedBox(
      height: 24,
      child: Slider(
        key: sliderKey,
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
        semanticFormatterCallback: semanticFormatterCallback,
      ),
    ),
  );
}

class _OutlinedThumb extends SliderComponentShape {
  const _OutlinedThumb(this.border);
  final Color border;
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    context.canvas.drawCircle(
      center,
      9,
      Paint()..color = sliderTheme.thumbColor!,
    );
    context.canvas.drawCircle(
      center,
      9,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }
}
