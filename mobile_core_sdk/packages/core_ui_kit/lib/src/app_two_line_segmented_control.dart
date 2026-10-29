import 'package:flutter/material.dart';
import 'app_dual_segmented_control.dart';

class AppTwoLineSegmentItem<T> {
  const AppTwoLineSegmentItem({
    required this.value,
    required this.label,
    required this.caption,
    this.key,
  });
  final T value;
  final String label, caption;
  final Key? key;
}

/// Two choices with explanatory captions. Values and localized copy belong to callers.
class AppTwoLineSegmentedControl<T> extends StatelessWidget {
  const AppTwoLineSegmentedControl({
    super.key,
    required this.first,
    required this.second,
    required this.value,
    required this.onChanged,
    this.style,
    this.height = 56,
  });
  final AppTwoLineSegmentItem<T> first, second;
  final T value;
  final AppSegmentedControlStyle? style;
  final double height;
  final ValueChanged<T>? onChanged;
  @override
  Widget build(BuildContext context) => AppDualSegmentedControl<T>(
    first: AppDualSegmentItem(
      value: first.value,
      label: first.label,
      caption: first.caption,
      key: first.key,
    ),
    second: AppDualSegmentItem(
      value: second.value,
      label: second.label,
      caption: second.caption,
      key: second.key,
    ),
    style: style,
    value: value,
    onChanged: onChanged,
    height: height * MediaQuery.textScalerOf(context).scale(14) / 14,
  );
}
