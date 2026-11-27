import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_text_styles.dart';
import 'home_action_icon.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.onFunds,
    required this.onHotels,
    required this.onReservations,
    required this.onHeldFunds,
  });
  final VoidCallback onFunds;
  final VoidCallback onHotels;
  final VoidCallback onReservations;
  final VoidCallback onHeldFunds;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ActionRow(
        left: _Action(
          icon: Symbols.monitoring,
          label: context.l10n.homeFindFunds,
          onTap: onFunds,
        ),
        right: _Action(
          icon: Symbols.hotel,
          label: context.l10n.homeFindHotels,
          onTap: onHotels,
        ),
      ),
      const SizedBox(height: 12),
      _ActionRow(
        left: _Action(
          icon: Icons.event_available_outlined,
          label: context.l10n.homeViewReservations,
          onTap: onReservations,
        ),
        right: _Action(
          icon: Icons.account_balance_wallet_outlined,
          label: context.l10n.homeViewHeldFunds,
          onTap: onHeldFunds,
        ),
      ),
    ],
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.left, required this.right});
  final Widget left, right;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    ),
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          HomeActionIcon(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: HomeTextStyles.caption(
                context,
              ).copyWith(color: context.appColors.textPrimary),
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
