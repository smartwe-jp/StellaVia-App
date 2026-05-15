import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundProjectDetailYieldHighlightCard extends StatelessWidget {
  const FundProjectDetailYieldHighlightCard({
    super.key,
    required this.label,
    required this.value,
    required this.disclaimer,
  });

  final String label;
  final String value;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final backgroundStart = Color.alphaBlend(
      colors.highlightGold.withValues(alpha: isDark ? 0.18 : 0.08),
      colors.surfaceAlt,
    );
    final backgroundEnd = Color.alphaBlend(
      colors.highlightGold.withValues(alpha: isDark ? 0.28 : 0.16),
      colors.surface,
    );
    final borderColor = colors.highlightGold.withValues(
      alpha: isDark ? 0.52 : 0.58,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[backgroundStart, backgroundEnd],
        ),
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(UiTokens.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            textAlign: TextAlign.center,
            style: appText.cardTitle.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _YieldValueText(value: value),
          const SizedBox(height: 6),
          // Text(
          //   disclaimer,
          //   textAlign: TextAlign.center,
          //   style: appText.meta.copyWith(
          //     color: colors.textTertiary,
          //     height: 1.4,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _YieldValueText extends StatelessWidget {
  const _YieldValueText({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final parsed = _parseYield(value);
    final numberStyle = appText.numericDisplay.copyWith(
      color: colors.highlightGold,
      fontSize: 58,
      height: 0.95,
      letterSpacing: -1.2,
    );
    final suffixStyle = appText.numericTitle.copyWith(
      color: colors.highlightGold,
      fontSize: 24,
      fontWeight: FontWeight.w900,
      height: 1.1,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(parsed.number, style: numberStyle),
          if (parsed.suffix.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(parsed.suffix, style: suffixStyle),
            ),
        ],
      ),
    );
  }
}

({String number, String suffix}) _parseYield(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return (number: '--', suffix: '');
  }
  final normalized = trimmed.endsWith('%')
      ? trimmed.substring(0, trimmed.length - 1).trim()
      : trimmed;
  final isNumeric = double.tryParse(normalized) != null;
  if (!isNumeric) {
    return (number: trimmed, suffix: '');
  }
  return (number: normalized, suffix: trimmed.endsWith('%') ? '%' : '');
}
