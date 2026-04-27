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
    required this.unitPriceLabel,
    required this.unitPriceValue,
    required this.unitCountLabel,
    required this.unitCountController,
    required this.onDecreaseUnits,
    required this.onIncreaseUnits,
    required this.unitSuffix,
    required this.totalAmountLabel,
    required this.totalAmountValue,
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
    this.showEstimatedDistribution = false,
  });

  final String title;
  final String balanceLabel;
  final String balanceValue;
  final String depositActionLabel;
  final String investmentAmountLabel;
  final String unitPriceLabel;
  final String unitPriceValue;
  final String unitCountLabel;
  final TextEditingController unitCountController;
  final VoidCallback? onDecreaseUnits;
  final VoidCallback? onIncreaseUnits;
  final String unitSuffix;
  final String totalAmountLabel;
  final String totalAmountValue;
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
  final bool showEstimatedDistribution;

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
        // const SizedBox(height: 18),
        // _BalanceCard(
        //   label: balanceLabel,
        //   value: balanceValue,
        //   actionLabel: depositActionLabel,
        //   onTap: onDepositTap,
        // ),
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
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Text(
                      unitPriceLabel,
                      style: appText.meta.copyWith(color: colors.textSecondary),
                    ),
                    const Spacer(),
                    Text(
                      unitPriceValue,
                      style: appText.numericBody.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _UnitAdjustButton(
                      icon: Icons.remove_rounded,
                      onTap: onDecreaseUnits,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                unitCountLabel,
                                style: appText.meta.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: unitCountController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: appText.numericHeadline.copyWith(
                                        fontSize: 28,
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
                                  const SizedBox(width: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      unitSuffix,
                                      style: appText.numericBody.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _UnitAdjustButton(
                      icon: Icons.add_rounded,
                      onTap: onIncreaseUnits,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: colors.borderSoft, height: 1),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Text(
                      totalAmountLabel,
                      style: appText.bodyMuted.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      totalAmountValue,
                      style: appText.numericTitle.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        if (showEstimatedDistribution) ...<Widget>[
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[colors.primarySubtle, colors.surface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.18),
                width: 1.5,
              ),
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
                        color: colors.highlightGold,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                      children: <InlineSpan>[
                        TextSpan(text: estimatedDistributionAmount),
                        TextSpan(
                          text: ' $estimatedDistributionSuffix',
                          style: appText.numericBody.copyWith(
                            color: colors.highlightGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

class _UnitAdjustButton extends StatelessWidget {
  const _UnitAdjustButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return SizedBox.square(
      dimension: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Icon(icon, size: 22),
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
