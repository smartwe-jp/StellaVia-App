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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: <Widget>[
        Text(
          title,
          style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColorTokens.fundexText,
          ),
        ),
        const SizedBox(height: 18),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColorTokens.fundexBackground,
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
                              style:
                                  (theme.textTheme.bodySmall ??
                                          const TextStyle())
                                      .copyWith(
                                        fontSize: 13,
                                        color:
                                            AppColorTokens.fundexTextSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              row.value,
                              textAlign: TextAlign.end,
                              style:
                                  (theme.textTheme.bodyMedium ??
                                          const TextStyle())
                                      .copyWith(
                                        fontSize: 14,
                                        color: isHighlighted
                                            ? AppColorTokens.fundexViolet
                                            : AppColorTokens.fundexText,
                                        fontWeight: FontWeight.w800,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < rows.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColorTokens.fundexBorder,
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 240, 189),
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
                      style: (theme.textTheme.bodySmall ?? const TextStyle())
                          .copyWith(
                            fontSize: 12,
                            color: const Color(0xFF92400E),
                            height: 1.6,
                          ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '$noticeTitle\n',
                          style: const TextStyle(fontWeight: FontWeight.w800),
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
              color: AppColorTokens.fundexBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      agreementLabel,
                      style: (theme.textTheme.bodySmall ?? const TextStyle())
                          .copyWith(
                            fontSize: 12,
                            color: AppColorTokens.fundexText,
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
                      color: agreed
                          ? AppColorTokens.fundexAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: agreed
                            ? AppColorTokens.fundexAccent
                            : AppColorTokens.fundexBorder,
                        width: 2,
                      ),
                    ),
                    child: agreed
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: Colors.white,
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
          backgroundColor: AppColorTokens.fundexViolet,
          shadowColor: AppColorTokens.fundexViolet.withValues(alpha: 0.36),
          textStyle: (theme.textTheme.titleMedium ?? const TextStyle())
              .copyWith(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
