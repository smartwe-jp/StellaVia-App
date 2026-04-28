import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplySelectedStep extends StatelessWidget {
  const FundLotteryApplySelectedStep({
    super.key,
    required this.headline,
    required this.body,
    required this.deadlineLabel,
    required this.deadlineValue,
    required this.coolingOffTitle,
    required this.coolingOffBody,
    required this.bankTips,
    required this.depositRows,
    required this.jumpDepositButtonLabel,
    required this.standbyBalanceLabel,
    required this.standbyBalanceValue,
    required this.standbyPurchaseButtonLabel,
    required this.standbyShortageLabel,
    this.standbyShortageValue,
    required this.canPurchaseWithStandbyBalance,
    required this.isPurchasingWithStandbyBalance,
    required this.onPurchaseWithStandbyBalance,
    required this.reportDepositButtonLabel,
    required this.isReportingDeposit,
    this.isReportCompleted = false,
    required this.onReportDeposit,
    required this.onJumpDeposit,
    required this.laterButtonLabel,
    required this.onLaterDeposit,
    this.reportCompletedBackButtonLabel,
    this.onReportCompletedBack,
    required this.copyButtonLabel,
    required this.onCopyValue,
  });

  final String headline;
  final String body;
  final String deadlineLabel;
  final String deadlineValue;
  final String coolingOffTitle;
  final String coolingOffBody;
  final String bankTips;
  final List<FundLotteryDepositRow> depositRows;
  final String jumpDepositButtonLabel;
  final String standbyBalanceLabel;
  final String standbyBalanceValue;
  final String standbyPurchaseButtonLabel;
  final String standbyShortageLabel;
  final String? standbyShortageValue;
  final bool canPurchaseWithStandbyBalance;
  final bool isPurchasingWithStandbyBalance;
  final VoidCallback onPurchaseWithStandbyBalance;
  final String reportDepositButtonLabel;
  final bool isReportingDeposit;
  final bool isReportCompleted;
  final VoidCallback onJumpDeposit;
  final VoidCallback onReportDeposit;
  final String laterButtonLabel;
  final VoidCallback onLaterDeposit;
  final String? reportCompletedBackButtonLabel;
  final VoidCallback? onReportCompletedBack;
  final String copyButtonLabel;
  final ValueChanged<String> onCopyValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
            child: Column(
              children: <Widget>[
                Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: appText.sectionTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: appText.body.copyWith(
                    color: colors.textSecondary,
                    height: 1.7,
                  ),
                ),
                //const SizedBox(height: 12),
                // Container(
                //   width: double.infinity,
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     color: colors.dangerSoft,
                //     border: Border.all(color: colors.dangerBorder),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: <Widget>[
                //         Text(
                //           deadlineLabel,
                //           style: appText.bodyStrong.copyWith(
                //             color: colors.dangerForeground,
                //           ),
                //         ),
                //         const SizedBox(height: 4),
                //         Text(
                //           deadlineValue,
                //           style: appText.numericTitle.copyWith(
                //             color: colors.danger,
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 12),
                // DecoratedBox(
                //   decoration: BoxDecoration(
                //     color: colors.warningSubtle,
                //     border: Border.all(color: colors.warningBorder),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         const SizedBox(width: 8),
                //         Expanded(
                //           child: RichText(
                //             text: TextSpan(
                //               style: appText.caption.copyWith(
                //                 color: colors.warningForeground,
                //                 height: 1.6,
                //               ),
                //               children: <InlineSpan>[
                //                 TextSpan(
                //                   text: '$coolingOffTitle\n',
                //                   style: appText.caption.copyWith(
                //                     color: colors.warningForeground,
                //                     height: 1.6,
                //                   ),
                //                 ),
                //                 TextSpan(text: coolingOffBody),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: List<Widget>.generate(depositRows.length, (
                      int index,
                    ) {
                      final row = depositRows[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    row.label,
                                    style: appText.caption.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  Flexible(
                                    child: Wrap(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          row.value,
                                          textAlign: TextAlign.end,
                                          style: _depositValueStyle(
                                            appText,
                                            row.value,
                                          ).copyWith(color: colors.textPrimary),
                                        ),
                                        if (row.copyable)
                                          _CopyButton(
                                            label: copyButtonLabel,
                                            onTap: () => onCopyValue(row.value),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index < depositRows.length - 1)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: colors.border,
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                FundDetailContentCard(
                  child: Text(
                    bankTips,
                    style: appText.caption.copyWith(
                      color: colors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (isReportCompleted)
                  OutlinedButton(
                    onPressed: onReportCompletedBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(color: colors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      reportCompletedBackButtonLabel ?? laterButtonLabel,
                      style: appText.button.copyWith(color: colors.primary),
                    ),
                  )
                else ...<Widget>[
                  _StandbyBalancePaymentCard(
                    balanceLabel: standbyBalanceLabel,
                    balanceValue: standbyBalanceValue,
                    purchaseButtonLabel: standbyPurchaseButtonLabel,
                    shortageLabel: standbyShortageLabel,
                    shortageValue: standbyShortageValue,
                    canPurchase: canPurchaseWithStandbyBalance,
                    isLoading: isPurchasingWithStandbyBalance,
                    onPurchase: onPurchaseWithStandbyBalance,
                  ),
                  const SizedBox(height: 16),
                  PrimaryCtaButton(
                    label: jumpDepositButtonLabel,
                    onPressed: onJumpDeposit,
                    horizontalPadding: 0,
                  ),
                  const SizedBox(height: 16),
                  PrimaryCtaButton(
                    label: reportDepositButtonLabel,
                    onPressed: onReportDeposit,
                    isLoading: isReportingDeposit,
                    horizontalPadding: 0,
                    backgroundColor: colors.primary,
                    shadowColor: colors.primary.withValues(alpha: 0.34),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: onLaterDeposit,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      laterButtonLabel,
                      style: appText.button.copyWith(color: colors.textPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.primarySubtle,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            style: appText.meta.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _StandbyBalancePaymentCard extends StatelessWidget {
  const _StandbyBalancePaymentCard({
    required this.balanceLabel,
    required this.balanceValue,
    required this.purchaseButtonLabel,
    required this.shortageLabel,
    required this.shortageValue,
    required this.canPurchase,
    required this.isLoading,
    required this.onPurchase,
  });

  final String balanceLabel;
  final String balanceValue;
  final String purchaseButtonLabel;
  final String shortageLabel;
  final String? shortageValue;
  final bool canPurchase;
  final bool isLoading;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final shortageText = shortageValue == null
        ? null
        : '$shortageLabel $shortageValue';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    balanceLabel,
                    style: appText.caption.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (shortageText != null) ...<Widget>[
                  const SizedBox(width: 12),
                  _StandbyShortageBadge(label: shortageText),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              balanceValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appText.numericTitle.copyWith(
                color: colors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            if (canPurchase) ...<Widget>[
              const SizedBox(height: 14),
              PrimaryCtaButton(
                label: purchaseButtonLabel,
                onPressed: isLoading ? null : onPurchase,
                isLoading: isLoading,
                height: 48,
                horizontalPadding: 0,
                backgroundColor: colors.highlightGold,
                shadowColor: colors.highlightGold.withValues(alpha: 0.22),
                textStyle: appText.button.copyWith(color: colors.onDark),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StandbyShortageBadge extends StatelessWidget {
  const _StandbyShortageBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.dangerSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.dangerBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: appText.caption.copyWith(
            color: colors.dangerForeground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

TextStyle _depositValueStyle(AppSemanticTextTheme appText, String value) {
  final trimmed = value.trim();
  final looksNumeric = _looksNumericLikeValue(trimmed);
  return looksNumeric ? appText.numericBody : appText.bodyStrong;
}

bool _looksNumericLikeValue(String value) {
  if (value.isEmpty) {
    return false;
  }

  const symbols = '¥%.,/:- ';
  for (final rune in value.runes) {
    final character = String.fromCharCode(rune);
    final isDigit = rune >= 48 && rune <= 57;
    final isUpper = rune >= 65 && rune <= 90;
    final isLower = rune >= 97 && rune <= 122;
    if (isDigit || isUpper || isLower || symbols.contains(character)) {
      continue;
    }
    return false;
  }
  return true;
}
