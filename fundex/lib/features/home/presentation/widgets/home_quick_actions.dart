import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.onFunds,
    required this.onHotels,
  });
  final VoidCallback onFunds;
  final VoidCallback onHotels;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.homeQuickActionsTitle,
        style: context.appTextTheme.bodyStrong,
      ),
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _Action(
              icon: Symbols.monitoring,
              label: context.l10n.homeFindFunds,
              onTap: onFunds,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _Action(
              icon: Symbols.hotel,
              label: context.l10n.homeFindHotels,
              onTap: onHotels,
            ),
          ),
        ],
      ),
    ],
  );
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    padding: const EdgeInsets.all(12),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          Icon(icon, color: context.appColors.primary, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: context.appTextTheme.caption.copyWith(
                color: context.appColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward,
            size: 16,
            color: context.appColors.textSecondary,
          ),
        ],
      ),
    ),
  );
}
