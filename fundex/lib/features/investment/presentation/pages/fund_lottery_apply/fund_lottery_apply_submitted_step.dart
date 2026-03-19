import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplySubmittedStep extends StatelessWidget {
  const FundLotteryApplySubmittedStep({
    super.key,
    required this.headline,
    required this.body,
    required this.announcementLabel,
    required this.announcementValue,
    required this.rows,
    required this.hintBody,
    required this.backHomeLabel,
    required this.onBackHome,
    required this.demoResultLabel,
    required this.onDemoCheckResult,
  });

  final String headline;
  final String body;
  final String announcementLabel;
  final String announcementValue;
  final List<FundLotterySummaryRow> rows;
  final String hintBody;
  final String backHomeLabel;
  final VoidCallback onBackHome;
  final String demoResultLabel;
  final VoidCallback onDemoCheckResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 32),
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
            child: Column(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.communitySecondary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(1),
                    child: Text(
                      '📩',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
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
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.communitySecondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.communitySecondary),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          announcementLabel,
                          style: appText.bodyStrong.copyWith(
                            color: colors.communitySecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          announcementValue,
                          style: appText.numericTitle.copyWith(
                            color: colors.communitySecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: List<Widget>.generate(rows.length, (int index) {
                      final row = rows[index];
                      Color rightValueColor = colors.textPrimary;
                      if (index == rows.length - 1) {
                        rightValueColor = colors.communitySecondary;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      row.label,
                                      style: appText.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    row.value,
                                    style: _submittedValueStyle(
                                      appText,
                                      row.value,
                                    ).copyWith(color: rightValueColor),
                                  ),
                                ],
                              ),
                            ),
                            if (index < rows.length - 1)
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
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('💡'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hintBody,
                            style: appText.caption.copyWith(
                              color: colors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryCtaButton(
                  label: backHomeLabel,
                  onPressed: onBackHome,
                  horizontalPadding: 0,
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: onDemoCheckResult,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: colors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    demoResultLabel,
                    style: appText.button.copyWith(color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

TextStyle _submittedValueStyle(AppSemanticTextTheme appText, String value) {
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
