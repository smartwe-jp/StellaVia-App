import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FundLotteryApplyAmountStep extends StatelessWidget {
  const FundLotteryApplyAmountStep({
    super.key,
    required this.title,
    required this.balanceLabel,
    required this.balanceValue,
    required this.depositActionLabel,
    required this.investmentAmountLabel,
    required this.amountController,
    required this.quickAmounts,
    required this.selectedAmount,
    required this.onQuickAmountTap,
    required this.onDepositTap,
    required this.estimatedDistributionLabel,
    required this.estimatedDistributionAmount,
    required this.estimatedDistributionSuffix,
    required this.nextButtonLabel,
    required this.onNext,
    this.showBalanceWarning = false,
    this.balanceWarningTitle,
    this.balanceWarningBody,
    this.balanceWarningActionLabel,
    this.onBalanceWarningActionTap,
  });

  final String title;
  final String balanceLabel;
  final String balanceValue;
  final String depositActionLabel;
  final String investmentAmountLabel;
  final TextEditingController amountController;
  final List<int> quickAmounts;
  final int selectedAmount;
  final ValueChanged<int> onQuickAmountTap;
  final VoidCallback onDepositTap;
  final String estimatedDistributionLabel;
  final String estimatedDistributionAmount;
  final String estimatedDistributionSuffix;
  final String nextButtonLabel;
  final VoidCallback? onNext;
  final bool showBalanceWarning;
  final String? balanceWarningTitle;
  final String? balanceWarningBody;
  final String? balanceWarningActionLabel;
  final VoidCallback? onBalanceWarningActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: <Widget>[
        Text(
          title,
          style: appText.sectionTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 18),
        _BalanceCard(
          label: balanceLabel,
          value: balanceValue,
          actionLabel: depositActionLabel,
          onTap: onDepositTap,
        ),
        const SizedBox(height: 18),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  investmentAmountLabel,
                  style: appText.inputLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                //const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '¥',
                      style: appText.numericTitle.copyWith(
                        fontSize: 24,
                        color: colors.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //const Spacer(),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        style: appText.numericHeadline.copyWith(
                          fontSize: 34,
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    //const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickAmounts
              .map(
                (int amount) => _QuickAmountChip(
                  label: _formatQuickAmount(amount),
                  selected: selectedAmount == amount,
                  onTap: () => onQuickAmountTap(amount),
                ),
              )
              .toList(growable: false),
        ),
        if (showBalanceWarning) ...<Widget>[
          const SizedBox(height: 14),
          _BalanceWarningCard(
            title: balanceWarningTitle ?? '',
            body: balanceWarningBody ?? '',
            actionLabel: balanceWarningActionLabel,
            onActionTap: onBalanceWarningActionTap,
          ),
        ],
        const SizedBox(height: 18),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[colors.successSubtle, colors.successSoft],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.successBorder, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 22, 14, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  estimatedDistributionLabel,
                  style: appText.meta.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: appText.numericHeadline.copyWith(
                      color: colors.success,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: estimatedDistributionAmount),
                      TextSpan(
                        text: ' $estimatedDistributionSuffix',
                        style: appText.numericBody.copyWith(
                          color: colors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        PrimaryCtaButton(
          label: nextButtonLabel,
          onPressed: onNext,
          horizontalPadding: 0,
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.label,
    required this.value,
    required this.actionLabel,
    required this.onTap,
  });

  final String label;
  final String value;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: appText.meta.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: appText.numericTitle.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: colors.primarySubtle,
                foregroundColor: colors.primary,
                minimumSize: const Size(74, 30),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                actionLabel,
                style: appText.chip.copyWith(color: colors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? colors.primarySubtle : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1.5,
            color: selected ? colors.primary : colors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            label,
            style: appText.chip.copyWith(
              color: selected ? colors.primary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceWarningCard extends StatelessWidget {
  const _BalanceWarningCard({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.dangerSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.dangerBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('⚠️'),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: appText.caption.copyWith(
                        color: colors.dangerForeground,
                        height: 1.6,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '$title\n',
                          style: appText.caption.copyWith(
                            color: colors.dangerForeground,
                            height: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: body),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if ((actionLabel?.isNotEmpty ?? false) &&
                onActionTap != null) ...<Widget>[
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  foregroundColor: colors.dangerForeground,
                  backgroundColor: colors.surface,
                  side: BorderSide(color: colors.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: appText.button.copyWith(
                    color: colors.dangerForeground,
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

String _formatQuickAmount(int amount) {
  if (amount % 10000 == 0) {
    return '${amount ~/ 10000}万';
  }
  return amount.toString();
}
