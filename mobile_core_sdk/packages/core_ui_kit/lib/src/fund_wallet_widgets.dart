import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'ui_tokens.dart';

class FundDedicatedDepositAccountCard extends StatelessWidget {
  const FundDedicatedDepositAccountCard({
    super.key,
    required this.title,
    required this.bankNameLabel,
    required this.bankNameValue,
    required this.branchNameLabel,
    required this.branchNameValue,
    required this.accountTypeLabel,
    required this.accountTypeValue,
    required this.accountNumberLabel,
    required this.accountNumberValue,
    required this.accountNumberCopyLabel,
    required this.onTapCopyAccountNumber,
    required this.accountHolderLabel,
    required this.accountHolderValue,
    required this.helperMessage,
  });

  final String title;
  final String bankNameLabel;
  final String bankNameValue;
  final String branchNameLabel;
  final String branchNameValue;
  final String accountTypeLabel;
  final String accountTypeValue;
  final String accountNumberLabel;
  final String accountNumberValue;
  final String accountNumberCopyLabel;
  final VoidCallback onTapCopyAccountNumber;
  final String accountHolderLabel;
  final String accountHolderValue;
  final String helperMessage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _walletCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(UiTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: AppColorTokens.fundexText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: UiTokens.spacing12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColorTokens.fundexBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(UiTokens.spacing12),
                child: Column(
                  children: <Widget>[
                    _FundWalletInfoRow(
                      label: bankNameLabel,
                      value: bankNameValue,
                    ),
                    _FundWalletInfoRow(
                      label: branchNameLabel,
                      value: branchNameValue,
                    ),
                    _FundWalletInfoRow(
                      label: accountTypeLabel,
                      value: accountTypeValue,
                    ),
                    _FundWalletInfoCopyRow(
                      label: accountNumberLabel,
                      value: accountNumberValue,
                      copyLabel: accountNumberCopyLabel,
                      onTapCopy: onTapCopyAccountNumber,
                    ),
                    _FundWalletInfoRow(
                      label: accountHolderLabel,
                      value: accountHolderValue,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UiTokens.spacing12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiTokens.spacing12,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text('💡', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: UiTokens.spacing8),
                    Expanded(
                      child: Text(
                        helperMessage,
                        style: const TextStyle(
                          color: AppColorTokens.fundexAccent,
                          fontSize: 10,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundWalletBalanceEntry {
  const FundWalletBalanceEntry({
    required this.label,
    required this.value,
    this.valueColor = AppColorTokens.fundexSuccess,
  });

  final String label;
  final String value;
  final Color valueColor;
}

class FundWalletStandbyBalanceCard extends StatelessWidget {
  const FundWalletStandbyBalanceCard({
    super.key,
    required this.title,
    required this.entries,
    this.actionLabel,
    this.onTapAction,
  });

  final String title;
  final List<FundWalletBalanceEntry> entries;
  final String? actionLabel;
  final VoidCallback? onTapAction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _walletCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(UiTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColorTokens.fundexText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (actionLabel != null && onTapAction != null)
                  TextButton(
                    onPressed: onTapAction,
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(actionLabel!),
                  ),
              ],
            ),
            const SizedBox(height: UiTokens.spacing12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColorTokens.fundexBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(UiTokens.spacing12),
                child: Column(
                  children: entries
                      .asMap()
                      .entries
                      .map(
                        (entry) => _FundWalletBalanceHistoryRow(
                          label: entry.value.label,
                          value: entry.value.value,
                          valueColor: entry.value.valueColor,
                          isLast: entry.key == entries.length - 1,
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundWalletStandbyBalanceSummaryBox extends StatelessWidget {
  const FundWalletStandbyBalanceSummaryBox({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorTokens.fundexAccent,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: UiTokens.spacing4),
        decoration: BoxDecoration(
          color: AppColorTokens.fundexAccentSuperLight,
          borderRadius: BorderRadius.circular(UiTokens.radius14),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.fundexAccent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColorTokens.fundexText,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundWalletHistoryPreviewCard extends StatelessWidget {
  const FundWalletHistoryPreviewCard({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onTapAction,
    required this.children,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTapAction;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColorTokens.fundexBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          UiTokens.spacing16,
          14,
          UiTokens.spacing16,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColorTokens.fundexText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(onPressed: onTapAction, child: Text(actionLabel)),
              ],
            ),
            const SizedBox(height: UiTokens.spacing8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class FundWalletHistoryListItem extends StatelessWidget {
  const FundWalletHistoryListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final amountColor = isPositive
        ? AppColorTokens.fundexSuccess
        : AppColorTokens.fundexText;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColorTokens.fundexBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiTokens.spacing12,
            vertical: 10,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColorTokens.fundexText,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColorTokens.fundexTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: UiTokens.spacing12),
              Text(
                amount,
                style: TextStyle(
                  color: amountColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FundWalletTransactionCard extends StatelessWidget {
  const FundWalletTransactionCard({
    super.key,
    required this.tradeType,
    required this.remark,
    required this.tradeTime,
    required this.amountText,
    required this.amountColor,
    required this.directionLabel,
    required this.isPending,
    required this.pendingLabel,
  });

  final String tradeType;
  final String remark;
  final String tradeTime;
  final String amountText;
  final Color amountColor;
  final String directionLabel;
  final bool isPending;
  final String pendingLabel;

  @override
  Widget build(BuildContext context) {
    final titleColor = isPending
        ? AppColorTokens.fundexTextTertiary
        : AppColorTokens.fundexText;
    final bodyColor = isPending
        ? AppColorTokens.fundexTextTertiary
        : AppColorTokens.fundexTextSecondary;
    final cardColor = isPending ? const Color(0xFFFAFAFA) : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          border: Border.all(color: AppColorTokens.fundexBorder),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
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
                children: <Widget>[
                  Expanded(
                    child: Text(
                      tradeType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (isPending)
                    _FundWalletStatusChip(
                      label: pendingLabel,
                      backgroundColor: const Color(0xFFF1F5F9),
                      textColor: AppColorTokens.fundexTextSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                remark,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: bodyColor,
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      tradeTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: bodyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _FundWalletStatusChip(
                    label: directionLabel,
                    backgroundColor: amountColor.withValues(alpha: 0.12),
                    textColor: amountColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    amountText,
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FundWalletInfoRow extends StatelessWidget {
  const _FundWalletInfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.fundexTextTertiary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColorTokens.fundexText,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FundWalletInfoCopyRow extends StatelessWidget {
  const _FundWalletInfoCopyRow({
    required this.label,
    required this.value,
    required this.copyLabel,
    required this.onTapCopy,
  });

  final String label;
  final String value;
  final String copyLabel;
  final VoidCallback onTapCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.fundexTextTertiary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          Flexible(
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: <Widget>[
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColorTokens.fundexText,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: onTapCopy,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiTokens.spacing8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      copyLabel,
                      style: const TextStyle(
                        color: AppColorTokens.fundexAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FundWalletBalanceHistoryRow extends StatelessWidget {
  const _FundWalletBalanceHistoryRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.isLast,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.fundexTextTertiary,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FundWalletStatusChip extends StatelessWidget {
  const _FundWalletStatusChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

final BoxDecoration _walletCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(UiTokens.radius16),
  border: Border.all(color: AppColorTokens.fundexBorder),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
);
