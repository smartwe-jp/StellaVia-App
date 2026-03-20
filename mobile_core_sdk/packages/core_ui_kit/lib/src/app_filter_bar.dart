import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

enum AppFilterBarItemStyle { primary, accent }

class AppFilterBarItem<T> {
  const AppFilterBarItem({
    required this.value,
    required this.label,
    this.style = AppFilterBarItemStyle.primary,
    this.leadingIcon,
  });

  final T value;
  final String label;
  final AppFilterBarItemStyle style;
  final IconData? leadingIcon;
}

class AppFilterBar<T> extends StatelessWidget {
  const AppFilterBar({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.backgroundColor,
    this.borderRadius = BorderRadius.zero,
    this.height,
    this.showBottomDivider = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.spacing = 8,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.unselectedBackgroundColor,
    this.unselectedForegroundColor,
    this.borderColor,
  });

  final List<AppFilterBarItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final double? height;
  final bool showBottomDivider;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color? unselectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    final content = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: items
                    .asMap()
                    .entries
                    .map((entry) {
                      final item = entry.value;
                      final selected = item.value == value;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: entry.key == items.length - 1 ? 0 : spacing,
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () => onChanged(item.value),
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _resolveBackgroundColor(
                                  item,
                                  selected: selected,
                                  colors: colors,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _resolveBorderColor(
                                    item,
                                    selected: selected,
                                    colors: colors,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (item.leadingIcon != null) ...<Widget>[
                                    Icon(
                                      item.leadingIcon,
                                      size: 14,
                                      color: _resolveForegroundColor(
                                        item,
                                        selected: selected,
                                        colors: colors,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    item.label,
                                    style: appText.chip.copyWith(
                                      color: _resolveForegroundColor(
                                        item,
                                        selected: selected,
                                        colors: colors,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
            ),
          ),
        );
      },
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: borderRadius,
          border: showBottomDivider
              ? Border(bottom: BorderSide(color: colors.border))
              : null,
        ),
        child: SizedBox(width: double.infinity, height: height, child: content),
      ),
    );
  }

  Color _resolveBorderColor(
    AppFilterBarItem<T> item, {
    required bool selected,
    required AppSemanticColorTheme colors,
  }) {
    switch (item.style) {
      case AppFilterBarItemStyle.accent:
        return colors.warning;
      case AppFilterBarItemStyle.primary:
        return selected
            ? (selectedBackgroundColor ?? colors.primary)
            : (borderColor ?? colors.border);
    }
  }

  Color _resolveBackgroundColor(
    AppFilterBarItem<T> item, {
    required bool selected,
    required AppSemanticColorTheme colors,
  }) {
    switch (item.style) {
      case AppFilterBarItemStyle.accent:
        return selected ? colors.warningSubtle : colors.surface;
      case AppFilterBarItemStyle.primary:
        return selected
            ? (selectedBackgroundColor ?? colors.primary)
            : (unselectedBackgroundColor ?? colors.surface);
    }
  }

  Color _resolveForegroundColor(
    AppFilterBarItem<T> item, {
    required bool selected,
    required AppSemanticColorTheme colors,
  }) {
    switch (item.style) {
      case AppFilterBarItemStyle.accent:
        return selected ? colors.warningAction : colors.warning;
      case AppFilterBarItemStyle.primary:
        return selected
            ? (selectedForegroundColor ?? colors.onDark)
            : (unselectedForegroundColor ?? colors.textSecondary);
    }
  }
}
