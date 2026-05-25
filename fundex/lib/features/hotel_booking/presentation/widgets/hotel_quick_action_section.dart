import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HotelQuickActionSection extends StatelessWidget {
  const HotelQuickActionSection({
    super.key,
    required this.userInfoLabel,
    required this.ordersLabel,
    required this.couponsLabel,
    required this.contactLabel,
    required this.onUserInfoTap,
    required this.onOrdersTap,
    required this.onCouponsTap,
    required this.onContactTap,
  });

  final String userInfoLabel;
  final String ordersLabel;
  final String couponsLabel;
  final String contactLabel;
  final VoidCallback onUserInfoTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onCouponsTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _HotelQuickActionItem(
              icon: Icons.account_circle_outlined,
              label: userInfoLabel,
              onTap: onUserInfoTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _HotelQuickActionItem(
              icon: Icons.receipt_long_outlined,
              label: ordersLabel,
              onTap: onOrdersTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _HotelQuickActionItem(
              icon: Icons.confirmation_num_outlined,
              label: couponsLabel,
              onTap: onCouponsTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _HotelQuickActionItem(
              icon: Icons.call_outlined,
              label: contactLabel,
              onTap: onContactTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelQuickActionItem extends StatelessWidget {
  const _HotelQuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: colors.brandPrimaryDark,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    return Semantics(
      button: true,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(UiTokens.radius20),
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.brandWhite.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(UiTokens.radius20),
                  border: Border.all(
                    color: colors.brandWhite.withValues(alpha: 0.64),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.scrim.withValues(alpha: 0.08),
                      blurRadius: 18,
                      spreadRadius: -3,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 62,
                  height: 62,
                  child: Icon(icon, color: colors.brandPrimary, size: 34),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
