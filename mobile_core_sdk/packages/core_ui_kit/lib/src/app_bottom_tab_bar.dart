import 'package:flutter/material.dart';
import 'app_theme_extensions.dart';

class AppBottomTabItem {
  const AppBottomTabItem({required this.label, required this.iconBuilder});
  final String label;
  final Widget Function(Color color) iconBuilder;
}

/// Equal-width bottom navigation primitive; route and icon ownership stays in App.
class AppBottomTabBar extends StatelessWidget {
  const AppBottomTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<AppBottomTabItem> items;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final inactive = theme
        .extension<AppShellNavigationTheme>()!
        .bottomTabInactiveColor;
    final labelStyle = context.appTextTheme.meta.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );
    final scaledLabel = MediaQuery.textScalerOf(context).scale(10);
    final height = 40 + scaledLabel * 1.4 * (scaledLabel > 10 ? 2 : 1);
    return Material(
      color: colors.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.borderSoft)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: Semantics(
                      selected: i == selectedIndex,
                      excludeSemantics: true,
                      onTap: () => onSelected(i),
                      button: true,
                      label: items[i].label,
                      child: InkWell(
                        onTap: () => onSelected(i),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
                          child: Column(
                            children: [
                              ExcludeSemantics(
                                child: SizedBox.square(
                                  dimension: 24,
                                  child: items[i].iconBuilder(
                                    i == selectedIndex
                                        ? colors.primary
                                        : inactive,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  items[i].label,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: labelStyle.copyWith(
                                    color: i == selectedIndex
                                        ? colors.primary
                                        : inactive,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
