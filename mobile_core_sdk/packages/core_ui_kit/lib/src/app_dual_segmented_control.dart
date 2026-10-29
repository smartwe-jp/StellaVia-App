import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'app_control_styles.dart';

/// Optional visual overrides. Null fields retain the existing control defaults.
class AppSegmentedControlStyle {
  const AppSegmentedControlStyle({
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.border,
    this.shadows,
    this.padding,
    this.itemPadding,
    this.radius,
    this.selectedRadius,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.captionStyle,
  });
  final Color? backgroundColor, selectedBackgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding, itemPadding;
  final double? radius, selectedRadius;
  final TextStyle? selectedTextStyle, unselectedTextStyle, captionStyle;
}

class AppDualSegmentItem<T> {
  const AppDualSegmentItem({
    required this.value,
    required this.label,
    this.icon,
    this.caption,
    this.key,
  });

  final T value;
  final String label;
  final IconData? icon;
  final String? caption;
  final Key? key;
}

class AppDualSegmentedControl<T> extends StatelessWidget {
  const AppDualSegmentedControl({
    super.key,
    required this.first,
    required this.second,
    required this.value,
    required this.onChanged,
    this.height = 56,
    this.radius = 18,
    this.style,
  });

  final AppDualSegmentItem<T> first;
  final AppDualSegmentItem<T> second;
  final T value;
  final ValueChanged<T>? onChanged;
  final double height;
  final double radius;
  final AppSegmentedControlStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(style?.radius ?? this.radius);
    final selectedBackgroundColor =
        style?.selectedBackgroundColor ??
        (isDark
            ? Color.alphaBlend(
                colors.highlightGold.withValues(alpha: 0.20),
                colors.surfaceAlt,
              )
            : Color.alphaBlend(
                colors.highlightGold.withValues(alpha: 0.28),
                colors.surface,
              ));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: style?.padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: style?.backgroundColor ?? colors.surfaceAlt,
        borderRadius: radius,
        border:
            style?.border ??
            Border.all(
              color: isDark
                  ? colors.border
                  : colors.textPrimary.withValues(alpha: 0.12),
            ),
        boxShadow:
            style?.shadows ??
            (isDark
                ? const <BoxShadow>[]
                : <BoxShadow>[
                    BoxShadow(
                      color: colors.scrim.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]),
      ),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedAlign(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: value == first.value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: selectedBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      style?.selectedRadius ??
                          (style?.radius ?? this.radius) - 4,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _AppDualSegmentButton<T>(
                    style: style,
                    item: first,
                    selected: value == first.value,
                    onTap: onChanged == null
                        ? null
                        : () => onChanged!(first.value),
                  ),
                ),
                Expanded(
                  child: _AppDualSegmentButton<T>(
                    style: style,
                    item: second,
                    selected: value == second.value,
                    onTap: onChanged == null
                        ? null
                        : () => onChanged!(second.value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDualSegmentButton<T> extends StatelessWidget {
  const _AppDualSegmentButton({
    this.style,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppSegmentedControlStyle? style;
  final AppDualSegmentItem<T> item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final selectedForegroundColor = isDark ? colors.onDark : colors.primary;
    final idleForegroundColor = isDark
        ? colors.textSecondary
        : colors.textSecondary.withValues(alpha: 0.94);
    final foregroundColor = selected
        ? selectedForegroundColor
        : idleForegroundColor;

    return Semantics(
      selected: selected,
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        key: item.key,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          padding:
              style?.itemPadding ??
              EdgeInsets.symmetric(
                vertical: item.caption == null ? 10 : 7,
                horizontal: 10,
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (item.icon != null) ...<Widget>[
                Icon(item.icon, size: 17, color: foregroundColor),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  style:
                      (selected
                          ? style?.selectedTextStyle
                          : style?.unselectedTextStyle) ??
                      (theme.textTheme.labelLarge ?? const TextStyle())
                          .copyWith(
                            color: foregroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.caption != null)
                        Text(
                          item.caption!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              style?.captionStyle ??
                              AppControlStyles.segmentCaption(context),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
