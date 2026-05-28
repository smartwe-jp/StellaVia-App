import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class WalletPaymentConfirmationNotice extends StatelessWidget {
  const WalletPaymentConfirmationNotice({
    super.key,
    required this.message,
    required this.timeLabel,
    required this.createTime,
  });

  final String message;
  final String timeLabel;
  final String createTime;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.warningBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: colors.warningForeground,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message,
                    style: appText.chip.copyWith(
                      color: colors.warningForeground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$timeLabel $createTime',
                    style: appText.chip.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
