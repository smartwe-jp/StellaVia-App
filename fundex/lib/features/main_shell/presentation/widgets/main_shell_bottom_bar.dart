import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/main_shell_providers.dart';

class MainShellBottomBar extends StatelessWidget {
  const MainShellBottomBar({
    super.key,
    required this.currentTabIndex,
    required this.onSelected,
  });
  final int currentTabIndex;
  final ValueChanged<int> onSelected;
  static const tabs = [
    MainShellTab.home,
    MainShellTab.investment,
    MainShellTab.hotel,
    MainShellTab.bookings,
    MainShellTab.profile,
  ];
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = [
      l.mainTabHome,
      l.mainTabInvestment,
      l.mainTabHotel,
      l.mainTabBookings,
      l.mainTabProfile,
    ];
    const assets = ['home', 'funds', 'hotel', 'bookings', 'profile'];
    final selected = tabs.indexWhere((tab) => tab.index == currentTabIndex);
    return AppBottomTabBar(
      key: const Key('main_tab_bar'),
      selectedIndex: selected < 0 ? null : selected,
      onSelected: (index) => onSelected(tabs[index].index),
      items: [
        for (var i = 0; i < tabs.length; i++)
          AppBottomTabItem(
            label: labels[i],
            iconBuilder: (color) => SvgPicture.asset(
              'assets/images/tab-${assets[i]}.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
      ],
    );
  }
}
