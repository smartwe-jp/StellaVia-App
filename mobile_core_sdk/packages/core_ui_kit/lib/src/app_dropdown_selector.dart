import 'package:flutter/material.dart';
import 'app_theme_extensions.dart';

class AppDropdownOption<T> {
  const AppDropdownOption({required this.value, required this.label});
  final T value;
  final String label;
}

/// Compact outlined selection trigger with a native anchored popup menu.
/// The caller owns values, localization and selection state.
class AppDropdownSelector<T> extends StatefulWidget {
  const AppDropdownSelector({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.tooltip,
    this.textStyle,
    this.icon,
    this.iconGap = 6,
    this.borderWidth = 1,
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.fromLTRB(12, 6, 8, 6),
  });
  final T value;
  final List<AppDropdownOption<T>> options;
  final ValueChanged<T>? onChanged;
  final String tooltip;
  final TextStyle? textStyle;
  final Widget? icon;
  final double iconGap;
  final double borderWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  State<AppDropdownSelector<T>> createState() => _AppDropdownSelectorState<T>();
}

class _AppDropdownSelectorState<T> extends State<AppDropdownSelector<T>> {
  final menuKey = GlobalKey<PopupMenuButtonState<T>>();
  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final options = widget.options;
    final onChanged = widget.onChanged;
    final tooltip = widget.tooltip;
    final textStyle = widget.textStyle;
    final icon = widget.icon;
    final iconGap = widget.iconGap;
    final borderWidth = widget.borderWidth;
    final backgroundColor = widget.backgroundColor;
    final borderColor = widget.borderColor;
    final foregroundColor = widget.foregroundColor;
    final borderRadius = widget.borderRadius;
    final padding = widget.padding;
    final colors = context.appColors;
    final label =
        options.where((item) => item.value == value).firstOrNull?.label ?? '';
    final foreground = foregroundColor ?? colors.textPrimary;
    final enabled = onChanged != null && options.isNotEmpty;
    // Keep the generous hit target outside the clipped ink surface.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: enabled ? () => menuKey.currentState?.showButtonMenu() : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Material(
            color: backgroundColor ?? colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide(
                color: borderColor ?? colors.border,
                width: borderWidth,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: PopupMenuButton<T>(
              key: menuKey,
              borderRadius: borderRadius,
              enabled: onChanged != null && options.isNotEmpty,
              tooltip: tooltip,
              initialValue: value,
              position: PopupMenuPosition.under,
              color: backgroundColor ?? colors.surface,
              onSelected: onChanged,
              itemBuilder: (context) => [
                for (final option in options)
                  PopupMenuItem<T>(
                    value: option.value,
                    child: Text(option.label),
                  ),
              ],
              child: Padding(
                // Match the former decorated box's border-inclusive dimensions.
                padding: padding.add(EdgeInsets.all(borderWidth)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style:
                            textStyle ??
                            context.appTextTheme.caption.copyWith(
                              color: foreground,
                              fontSize: 12,
                              height: 1,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    SizedBox(width: iconGap),
                    icon ??
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 12,
                          color: foreground,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
