import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundLotteryApplyCompletedStep extends StatelessWidget {
  const FundLotteryApplyCompletedStep({
    super.key,
    required this.headline,
    required this.body,
    required this.receiptLabel,
    required this.receiptValue,
    required this.backHomeLabel,
    required this.onBackHome,
  });

  final String headline;
  final String body;
  final String receiptLabel;
  final String receiptValue;
  final String backHomeLabel;
  final VoidCallback onBackHome;

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
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.successSubtle,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.check_rounded,
                      color: colors.success,
                      size: 38,
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
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Text.rich(
                      TextSpan(
                        style: appText.body.copyWith(color: colors.textPrimary),
                        children: <InlineSpan>[
                          TextSpan(text: '$receiptLabel '),
                          TextSpan(
                            text: receiptValue,
                            style: appText.bodyStrong.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryCtaButton(
                  label: backHomeLabel,
                  onPressed: onBackHome,
                  horizontalPadding: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
