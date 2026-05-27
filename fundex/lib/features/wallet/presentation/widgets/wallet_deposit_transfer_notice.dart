import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletDepositTransferNotice extends StatelessWidget {
  const WalletDepositTransferNotice({
    super.key,
    required this.message,
    required this.transferName,
    required this.copyButtonLabel,
    required this.copyDoneMessage,
  });

  final String message;
  final String transferName;
  final String copyButtonLabel;
  final String copyDoneMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final normalizedTransferName = transferName.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.highlightGold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.highlightGold),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: colors.highlightGold,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: appText.caption.copyWith(
                      color: colors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (normalizedTransferName.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              AppCopyButton(
                label: copyButtonLabel,
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: normalizedTransferName),
                  );
                  if (context.mounted) {
                    AppNotice.show(context, message: copyDoneMessage);
                  }
                },
                backgroundColor: colors.highlightGold.withValues(alpha: 0.10),
                foregroundColor: colors.highlightGold,
                borderColor: colors.highlightGold.withValues(alpha: 0.28),
                textStyle: appText.caption.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
