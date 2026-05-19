import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class WalletPendingDepositEmptyCard extends StatelessWidget {
  const WalletPendingDepositEmptyCard({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onActionPressed,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message,
              style: appText.body.copyWith(
                color: colors.textSecondary,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: PrimaryCtaButton(
                  label: actionLabel,
                  onPressed: onActionPressed,
                  height: 52,
                  horizontalPadding: 0,
                  backgroundColor: colors.primary,
                  shadowColor: colors.primary.withValues(alpha: 0.18),
                  textStyle: appText.button.copyWith(color: colors.onDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
