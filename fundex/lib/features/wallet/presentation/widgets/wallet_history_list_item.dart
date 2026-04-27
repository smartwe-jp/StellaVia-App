import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class WalletHistoryListItem extends StatelessWidget {
  const WalletHistoryListItem({
    super.key,
    required this.title,
    required this.dateText,
    required this.amountText,
    required this.amountColor,
    required this.indicatorColor,
  });

  final String title;
  final String dateText;
  final String amountText;
  final Color amountColor;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appText.chip.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dateText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appText.meta.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amountText,
                textAlign: TextAlign.right,
                style: appText.bodyStrong.copyWith(color: amountColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
