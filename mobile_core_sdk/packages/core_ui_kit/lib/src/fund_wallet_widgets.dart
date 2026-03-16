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
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: UiTokens.spacing12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColorTokens.fundexBackground,
                borderRadius: BorderRadius.circular(UiTokens.radius12),
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
                borderRadius: BorderRadius.circular(UiTokens.radius12),
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
  });

  final String title;
  final List<FundWalletBalanceEntry> entries;

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
                borderRadius: BorderRadius.circular(UiTokens.radius12),
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
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(UiTokens.radius16),
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColorTokens.fundexAccent, width: 4),
          ),
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
                fontSize: 22,
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
      padding: EdgeInsets.only(bottom: isLast ? 0 : UiTokens.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.fundexTextSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColorTokens.fundexText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.only(bottom: UiTokens.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColorTokens.fundexTextSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: <Widget>[
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColorTokens.fundexText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
                        fontWeight: FontWeight.w700,
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
      padding: EdgeInsets.only(bottom: isLast ? 0 : UiTokens.spacing8),
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

final BoxDecoration _walletCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(UiTokens.radius16),
  border: Border.all(color: AppColorTokens.fundexBorder),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ],
);
