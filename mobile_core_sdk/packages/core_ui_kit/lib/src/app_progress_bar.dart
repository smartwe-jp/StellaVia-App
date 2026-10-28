import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

/// Normalized visual progress. Thresholds and status-dependent colors belong
/// to the feature; values above 1 fill the bar without changing supplied text.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.height = UiTokens.progressHeight,
    this.color,
    this.trackColor,
    this.semanticLabel,
    this.semanticValue,
  });
  final double? value;
  final double height;
  final Color? color, trackColor;
  final String? semanticLabel, semanticValue;

  @override
  Widget build(BuildContext context) {
    final indicator = LinearProgressIndicator(
      value: value == null
          ? null
          : (value!.isFinite ? value!.clamp(0, 1).toDouble() : 0),
      minHeight: height,
      borderRadius: BorderRadius.circular(UiTokens.circle),
      color: color ?? context.appColors.primaryAlt,
      backgroundColor: trackColor ?? context.appColors.surfaceAlt,
      semanticsLabel: semanticLabel,
      stopIndicatorRadius: 0,
      trackGap: 0,
    );
    if (semanticValue == null) return indicator;
    // Domain values may exceed 100% or contain localized units. Keep them out
    // of the native progressBar numeric range (0..100) semantics role.
    return Semantics(
      label: semanticLabel,
      value: semanticValue,
      child: ExcludeSemantics(child: indicator),
    );
  }
}
