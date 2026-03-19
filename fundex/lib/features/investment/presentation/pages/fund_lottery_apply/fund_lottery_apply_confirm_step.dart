import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplyConfirmStep extends StatelessWidget {
  const FundLotteryApplyConfirmStep({
    super.key,
    required this.title,
    required this.rows,
    required this.noticeTitle,
    required this.noticeBody,
    required this.agreementLabel,
    required this.agreed,
    required this.onAgreementChanged,
    required this.applyButtonLabel,
    required this.onApply,
    this.highlightValue,
    this.isSubmitting = false,
  });

  final String title;
  final List<FundLotterySummaryRow> rows;
  final String noticeTitle;
  final String noticeBody;
  final String agreementLabel;
  final bool agreed;
  final ValueChanged<bool> onAgreementChanged;
  final String applyButtonLabel;
  final VoidCallback? onApply;
  final String? highlightValue;
  final bool isSubmitting;

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
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List<Widget>.generate(rows.length, (int index) {
              final row = rows[index];
              final isHighlighted =
                  highlightValue != null &&
                  row.value.trim() == highlightValue!.trim();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              row.label,
                              style: appText.caption.copyWith(
                                fontSize: 13,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              row.value,
                              textAlign: TextAlign.end,
                              style:
                                  _summaryValueStyle(
                                    appText,
                                    value: row.value,
                                    defaultColor: colors.textPrimary,
                                    highlightColor: colors.communitySecondary,
                                  ).copyWith(
                                    fontSize: 14,
                                    color: isHighlighted
                                        ? colors.communitySecondary
                                        : colors.textPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < rows.length - 1)
                      Divider(height: 1, thickness: 1, color: colors.border),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.warningSubtle,
            border: Border.all(color: colors.warningBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('⚠️'),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: appText.caption.copyWith(
                        fontSize: 12,
                        color: colors.warningForeground,
                        height: 1.6,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '$noticeTitle\n',
                          style: appText.caption.copyWith(
                            fontSize: 12,
                            color: colors.warningForeground,
                            height: 1.6,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(text: noticeBody),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () => onAgreementChanged(!agreed),
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      agreementLabel,
                      style: appText.bodyStrong.copyWith(
                        fontSize: 12,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: agreed ? colors.primary : colors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: agreed ? colors.primary : colors.border,
                        width: 2,
                      ),
                    ),
                    child: agreed
                        ? Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: colors.brandWhite,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        PrimaryCtaButton(
          label: applyButtonLabel,
          onPressed: onApply,
          isLoading: isSubmitting,
          horizontalPadding: 0,
          backgroundColor: colors.communitySecondary,
          shadowColor: colors.communitySecondary.withValues(alpha: 0.36),
          textStyle: appText.button.copyWith(
            color: colors.brandWhite,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

TextStyle _summaryValueStyle(
  AppSemanticTextTheme appText, {
  required String value,
  required Color defaultColor,
  Color? highlightColor,
}) {
  final trimmed = value.trim();
  final looksNumeric = _looksNumericLikeValue(trimmed);
  final baseStyle = looksNumeric ? appText.numericBody : appText.bodyStrong;

  return baseStyle.copyWith(
    color: highlightColor ?? defaultColor,
    fontWeight: FontWeight.w800,
  );
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
