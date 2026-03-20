import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppUnderlinedTabBarItem<T> {
  const AppUnderlinedTabBarItem({required this.value, required this.label});

  final T value;
  final String label;
}

class AppUnderlinedTabBar<T> extends StatelessWidget {
  const AppUnderlinedTabBar({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.indicatorHeight = 3,
  });

  final List<AppUnderlinedTabBarItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry padding;
  final double indicatorHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: items
            .map(
              (AppUnderlinedTabBarItem<T> item) => Expanded(
                child: _AppUnderlinedTabBarItem<T>(
                  label: item.label,
                  selected: item.value == value,
                  indicatorHeight: indicatorHeight,
                  onTap: () => onChanged(item.value),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _AppUnderlinedTabBarItem<T> extends StatelessWidget {
  const _AppUnderlinedTabBarItem({
    required this.label,
    required this.selected,
    required this.indicatorHeight,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double indicatorHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: appText.bodyStrong.copyWith(
                  color: selected ? colors.primary : colors.textTertiary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: indicatorHeight,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: selected ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
