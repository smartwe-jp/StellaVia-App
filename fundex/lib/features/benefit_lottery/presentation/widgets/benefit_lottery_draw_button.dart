import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class BenefitLotteryDrawButton extends StatelessWidget {
  const BenefitLotteryDrawButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onDark,
          disabledBackgroundColor: colors.primary.withValues(alpha: 0.48),
          disabledForegroundColor: colors.onDark.withValues(alpha: 0.72),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiTokens.radius12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isLoading) ...<Widget>[
              SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.onDark,
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
            ],
            Text(
              label,
              style: appText.button.copyWith(
                color: colors.onDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
