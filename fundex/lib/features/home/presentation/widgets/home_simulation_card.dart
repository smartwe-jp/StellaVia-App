import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_text_styles.dart';

class HomeSimulationCard extends StatelessWidget {
  const HomeSimulationCard({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      variant: AppCardVariant.filled,
      backgroundColor: colors.brandPrimaryDark,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.brandPrimaryBright.withValues(alpha: .35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home_simulation_icon.png',
                width: 22,
                height: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeSimulationEyebrow,
                  style: HomeTextStyles.simulationEyebrow(
                    context,
                  ).copyWith(color: colors.onDark),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.homeSimulationTitle,
                  style: HomeTextStyles.entryTitle(
                    context,
                  ).copyWith(color: colors.onDark),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/home_simulation_arrow.png',
            width: 8,
            height: 14,
          ),
        ],
      ),
    );
  }
}
