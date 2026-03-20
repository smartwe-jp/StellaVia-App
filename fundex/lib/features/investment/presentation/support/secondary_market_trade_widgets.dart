import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

enum SecondaryMarketTradeStep { order, confirm }

class SecondaryMarketSegmentHeader extends StatelessWidget {
  const SecondaryMarketSegmentHeader({
    super.key,
    required this.current,
    required this.orderLabel,
    required this.confirmLabel,
  });

  final SecondaryMarketTradeStep current;
  final String orderLabel;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _SecondaryMarketSegmentChip(
          label: orderLabel,
          selected: current == SecondaryMarketTradeStep.order,
        ),
        const SizedBox(width: 8),
        _SecondaryMarketSegmentChip(
          label: confirmLabel,
          selected: current == SecondaryMarketTradeStep.confirm,
        ),
      ],
    );
  }
}

class _SecondaryMarketSegmentChip extends StatelessWidget {
  const _SecondaryMarketSegmentChip({
    required this.label,
    required this.selected,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? colors.infoSubtle : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: appText.chip.copyWith(
          color: selected ? colors.primary : colors.textSecondary,
        ),
      ),
    );
  }
}

class SecondaryMarketTableRow extends StatelessWidget {
  const SecondaryMarketTableRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: colors.border),
          right: BorderSide(color: colors.border),
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 120,
              padding: const EdgeInsets.all(12),
              color: colors.surfaceAlt,
              alignment: Alignment.centerLeft,
              child: Text(label, style: appText.bodyStrong),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Align(alignment: Alignment.centerLeft, child: value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryMarketUnitInputField extends StatelessWidget {
  const SecondaryMarketUnitInputField({
    super.key,
    required this.controller,
    required this.unitLabel,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String unitLabel;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          unitLabel,
          style: appText.bodyMuted.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class SecondaryMarketPreviewCard extends StatelessWidget {
  const SecondaryMarketPreviewCard({
    super.key,
    required this.totalLabel,
    required this.feeLabel,
    required this.netLabel,
    required this.totalValue,
    required this.feeValue,
    required this.netValue,
    this.highlightColor,
  });

  final String totalLabel;
  final String feeLabel;
  final String netLabel;
  final String totalValue;
  final String feeValue;
  final String netValue;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.infoSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.infoBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            _PreviewRow(label: totalLabel, value: totalValue),
            const SizedBox(height: 6),
            _PreviewRow(label: feeLabel, value: feeValue),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _PreviewRow(
              label: netLabel,
              value: netValue,
              valueStyle: appText.numericTitle.copyWith(
                color: highlightColor ?? colors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: appText.bodyMuted.copyWith(color: colors.textSecondary),
          ),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}

String buildSecondaryMarketInvestorTypeText({
  required String? investorCode,
  required double? earningRatio,
  required String Function(String ratio) fallbackBuilder,
  required String Function(String ratio) fixedYieldBuilder,
}) {
  final code = investorCode?.trim();
  final ratio = earningRatio == null
      ? '--'
      : '${(earningRatio * 100).toStringAsFixed(2)}%';
  if (code == null || code.isEmpty) {
    return fallbackBuilder(ratio);
  }
  return '$code\n${fixedYieldBuilder(ratio)}';
}
