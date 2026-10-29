import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HomeSimulationCard extends StatelessWidget {
  const HomeSimulationCard({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.brandPrimaryDark,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      style: context.appTextTheme.numericCaption.copyWith(
                        color: colors.onDark,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.homeSimulationTitle,
                      style: context.appTextTheme.bodyStrong.copyWith(
                        color: colors.onDark,
                        fontSize: 15,
                      ),
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
        ),
      ),
    );
  }
}
