import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class WalletWithdrawRecordDetailRow {
  const WalletWithdrawRecordDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

class WalletWithdrawRecordCard extends StatelessWidget {
  const WalletWithdrawRecordCard({
    super.key,
    required this.typeLabel,
    required this.statusLabel,
    required this.statusBackgroundColor,
    required this.statusForegroundColor,
    required this.amountText,
    required this.details,
    this.note,
  });

  final String typeLabel;
  final String statusLabel;
  final Color statusBackgroundColor;
  final Color statusForegroundColor;
  final String amountText;
  final List<WalletWithdrawRecordDetailRow> details;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColorTokens.fundexBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    typeLabel,
                    style: const TextStyle(
                      color: AppColorTokens.fundexText,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusForegroundColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amountText,
              style: const TextStyle(
                color: AppColorTokens.fundexDanger,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (details.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              for (var index = 0; index < details.length; index++) ...<Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        details[index].label,
                        style: const TextStyle(
                          color: AppColorTokens.fundexTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        details[index].value,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color:
                              details[index].valueColor ??
                              AppColorTokens.fundexText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (index < details.length - 1) const SizedBox(height: 4),
              ],
            ],
            if (note != null && note!.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                note!,
                style: const TextStyle(
                  color: AppColorTokens.fundexTextTertiary,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
