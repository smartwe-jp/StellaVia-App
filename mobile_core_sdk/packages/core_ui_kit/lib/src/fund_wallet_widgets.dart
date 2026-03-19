import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_buttons.dart';
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
    this.expirationMessage,
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
  final String? expirationMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: _walletCardDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(UiTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: appText.cardTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: UiTokens.spacing12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.background,
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
                color: colors.infoSubtle,
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
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: SizedBox.square(
                        dimension: 12,
                        child: FittedBox(child: Text('💡')),
                      ),
                    ),
                    const SizedBox(width: UiTokens.spacing8),
                    Expanded(
                      child: Text(
                        helperMessage,
                        style: appText.meta.copyWith(
                          color: colors.primary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (expirationMessage != null) ...<Widget>[
              const SizedBox(height: UiTokens.spacing8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.warningSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiTokens.spacing12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox.square(
                        dimension: 12,
                        child: FittedBox(child: Text('⏰')),
                      ),
                      const SizedBox(width: UiTokens.spacing8),
                      Expanded(
                        child: Text(
                          expirationMessage!,
                          style: appText.micro.copyWith(
                            color: colors.warning,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FundWalletBankAccountApplyCard extends StatelessWidget {
  const FundWalletBankAccountApplyCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    this.onTapAction,
    this.isApplying = false,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback? onTapAction;
  final bool isApplying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: _walletCardDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(UiTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: appText.cardTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: UiTokens.spacing12),
            Text(description, style: appText.bodyMuted.copyWith(height: 1.6)),
            const SizedBox(height: UiTokens.spacing16),
            PrimaryCtaButton(
              label: actionLabel,
              onPressed: onTapAction,
              isLoading: isApplying,
              fullWidth: false,
              horizontalPadding: 0,
              height: 48,
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
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: _walletCardDecoration(context),
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
                    style: appText.cardTitle.copyWith(
                      color: colors.textPrimary,
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
                color: colors.background,
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
                          valueColor: entry.value.valueColor ?? colors.success,
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: UiTokens.spacing4),
        decoration: BoxDecoration(
          color: colors.primarySubtle,
          borderRadius: BorderRadius.circular(UiTokens.radius14),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: appText.bodyStrong.copyWith(color: colors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: appText.numericHeadline.copyWith(
                color: colors.textPrimary,
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
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
                    style: appText.pageTitle.copyWith(
                      color: colors.textPrimary,
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final amountColor = isPositive ? colors.success : colors.textPrimary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
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
                      style: appText.cardTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appText.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: UiTokens.spacing12),
              Text(
                amount,
                style: appText.bodyStrong.copyWith(color: amountColor),
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final titleColor = isPending ? colors.textTertiary : colors.textPrimary;
    final bodyColor = isPending ? colors.textTertiary : colors.textSecondary;
    final cardColor = isPending ? colors.surfaceAlt : colors.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          border: Border.all(color: colors.border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.03),
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
                      style: appText.cardTitle.copyWith(color: titleColor),
                    ),
                  ),
                  if (isPending)
                    _FundWalletStatusChip(
                      label: pendingLabel,
                      backgroundColor: colors.surfaceAlt,
                      textColor: colors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                remark,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: appText.bodyMuted.copyWith(
                  color: bodyColor,
                  height: 1.5,
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
                      style: appText.inputLabel.copyWith(color: bodyColor),
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
                    style: appText.heroMetricSecondary.copyWith(
                      color: amountColor,
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.caption.copyWith(
                color: colors.textTertiary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: appText.tableValue.copyWith(
                color: colors.textPrimary,
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.caption.copyWith(
                color: colors.textTertiary,
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
                  style: appText.tableValue.copyWith(
                    color: colors.textPrimary,
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
                      color: colors.primarySubtle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      copyLabel,
                      style: appText.meta.copyWith(color: colors.primary),
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.caption.copyWith(color: colors.textTertiary),
            ),
          ),
          Text(value, style: appText.bodyStrong.copyWith(color: valueColor)),
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
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: appText.chip.copyWith(color: textColor)),
    );
  }
}

BoxDecoration _walletCardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.appColors;
  return BoxDecoration(
    color: colors.surface,
    borderRadius: BorderRadius.circular(UiTokens.radius16),
    border: Border.all(color: colors.border),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: colors.scrim.withValues(alpha: 0.06),
        blurRadius: 3,
        offset: const Offset(0, 1),
      ),
      BoxShadow(
        color: colors.scrim.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
