import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondaryMarketTradeMetricItemData {
  const SecondaryMarketTradeMetricItemData({
    required this.icon,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.borderColor,
    this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? accentColor;
}

class SecondaryMarketTradeInfoRowData {
  const SecondaryMarketTradeInfoRowData({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;
}

class SecondaryMarketTradeFlowHeader extends StatelessWidget {
  const SecondaryMarketTradeFlowHeader({
    super.key,
    required this.currentStep,
    required this.title,
    required this.orderLabel,
    required this.confirmLabel,
  });

  final int currentStep;
  final String title;
  final String orderLabel;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _StepLabel(
                label: orderLabel,
                selected: currentStep == 0,
                completed: currentStep > 0,
              ),
            ),
            Expanded(
              child: _StepLabel(
                label: confirmLabel,
                selected: currentStep == 1,
                completed: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppStepProgressBar(
          stepCount: 2,
          currentStep: currentStep,
          padding: EdgeInsets.zero,
          height: 3,
          spacing: 8,
          completedColor: colors.primary,
          currentColor: colors.primary,
          pendingColor: colors.borderSoft,
          enablePulse: false,
        ),
        const SizedBox(height: 20),
        Text(title, style: context.appTextTheme.pageTitle),
      ],
    );
  }
}

class SecondaryMarketTradePinnedTitleBar extends StatelessWidget {
  const SecondaryMarketTradePinnedTitleBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.borderSoft)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: appText.pageTitle.copyWith(
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryMarketTradeTitleCard extends StatelessWidget {
  const SecondaryMarketTradeTitleCard({
    super.key,
    required this.marketLabel,
    required this.orderMethodLabel,
    required this.title,
    required this.investorTypeLabel,
    required this.unitPriceLabel,
    required this.unitPriceCaption,
    required this.availableUnitsLabel,
    required this.availableUnitsCaption,
  });

  final String marketLabel;
  final String orderMethodLabel;
  final String title;
  final String investorTypeLabel;
  final String unitPriceLabel;
  final String unitPriceCaption;
  final String availableUnitsLabel;
  final String availableUnitsCaption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _HeroChip(
                  icon: Icons.storefront_rounded,
                  label: marketLabel,
                  backgroundColor: colors.primarySubtle.withValues(alpha: 0.7),
                  foregroundColor: colors.infoForeground,
                  textColor: colors.infoForeground,
                ),
                const SizedBox(width: 8),
                _HeroChip(
                  icon: Icons.shopping_bag_outlined,
                  label: orderMethodLabel,
                  backgroundColor: colors.primarySubtle.withValues(alpha: 0.78),
                  foregroundColor: colors.primary,
                  textColor: colors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: appText.pageTitle.copyWith(
                color: colors.textPrimary,
                height: 1.24,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderSoft),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.badge_outlined,
                    size: 18,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      investorTypeLabel,
                      style: appText.body.copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: _CompactHighlightMetric(
                    label: unitPriceCaption,
                    value: unitPriceLabel,
                    backgroundColor: colors.primarySubtle.withValues(
                      alpha: 0.62,
                    ),
                    borderColor: colors.primary.withValues(alpha: 0.14),
                    valueColor: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CompactHighlightMetric(
                    label: availableUnitsCaption,
                    value: availableUnitsLabel,
                    backgroundColor: colors.primarySubtle.withValues(
                      alpha: 0.72,
                    ),
                    borderColor: colors.infoBorder,
                    valueColor: colors.infoForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryMarketTradeHeroCard extends StatelessWidget {
  const SecondaryMarketTradeHeroCard({
    super.key,
    required this.marketLabel,
    required this.orderMethodLabel,
    required this.title,
    required this.investorTypeLabel,
    required this.unitPriceLabel,
    required this.unitPriceCaption,
    required this.highlightLabel,
    required this.highlightValue,
    required this.metrics,
  });

  final String marketLabel;
  final String orderMethodLabel;
  final String title;
  final String investorTypeLabel;
  final String unitPriceLabel;
  final String unitPriceCaption;
  final String highlightLabel;
  final String highlightValue;
  final List<SecondaryMarketTradeMetricItemData> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.primarySubtle,
            colors.surface,
            colors.primarySubtle.withValues(alpha: 0.78),
          ],
        ),
        border: Border.all(color: colors.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -42,
            top: -30,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.primary.withValues(alpha: 0.18),
                    colors.primary.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const SizedBox(width: 180, height: 180),
            ),
          ),
          Positioned(
            left: -32,
            bottom: -52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.primary.withValues(alpha: 0.16),
                    colors.primary.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const SizedBox(width: 160, height: 160),
            ),
          ),
          Positioned(
            right: 18,
            top: 84,
            child: Transform.rotate(
              angle: -0.28,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onDark.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox(width: 120, height: 10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _HeroChip(
                      icon: Icons.storefront_rounded,
                      label: marketLabel,
                      backgroundColor: colors.surface.withValues(alpha: 0.9),
                      foregroundColor: colors.infoForeground,
                      textColor: colors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    _HeroChip(
                      icon: Icons.shopping_bag_outlined,
                      label: orderMethodLabel,
                      backgroundColor: colors.primarySubtle.withValues(
                        alpha: 0.82,
                      ),
                      foregroundColor: colors.primary,
                      textColor: colors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: appText.pageTitle.copyWith(
                    color: colors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.borderSoft),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.badge_outlined,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          investorTypeLabel,
                          style: appText.bodyMuted.copyWith(
                            color: colors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.borderSoft),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              unitPriceCaption,
                              style: appText.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              unitPriceLabel,
                              style: appText.numericHeadline.copyWith(
                                color: colors.textPrimary,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 116,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              highlightLabel,
                              style: appText.micro.copyWith(
                                color: colors.onDark.withValues(alpha: 0.78),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              highlightValue,
                              style: appText.numericTitle.copyWith(
                                color: colors.onDark,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (metrics.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  Row(
                    children: metrics
                        .map(
                          (SecondaryMarketTradeMetricItemData metric) =>
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: metric == metrics.last ? 0 : 10,
                                  ),
                                  child: _MetricCard(metric: metric),
                                ),
                              ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryMarketTradePanelCard extends StatelessWidget {
  const SecondaryMarketTradePanelCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(height: 1, color: context.appColors.borderSoft),
        const SizedBox(height: 16),
        Text(title, style: context.appTextTheme.sectionTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: context.appTextTheme.caption),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class SecondaryMarketTradeOrderForm extends StatelessWidget {
  const SecondaryMarketTradeOrderForm({
    super.key,
    required this.title,
    required this.availabilityLabel,
    required this.formulaLabel,
    required this.formulaValue,
    required this.paymentLabel,
    required this.paymentValue,
    required this.controller,
    required this.selectedUnits,
    required this.availableUnits,
    required this.unitLabel,
    required this.maxChipLabel,
    required this.onChanged,
    required this.onDecrease,
    required this.onIncrease,
    required this.onSelectPreset,
    this.enabled = true,
  });

  final String title;
  final String availabilityLabel;
  final String formulaLabel;
  final String formulaValue;
  final String paymentLabel;
  final String paymentValue;
  final TextEditingController controller;
  final int selectedUnits;
  final int availableUnits;
  final String unitLabel;
  final String maxChipLabel;
  final ValueChanged<String> onChanged;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final ValueChanged<int> onSelectPreset;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final presets = <int>{
      1,
      5,
      10,
      availableUnits,
    }.where((n) => n > 0 && n <= availableUnits);
    return SecondaryMarketTradePanelCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$availabilityLabel  $availableUnits$unitLabel',
            style: context.appTextTheme.caption,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _QuantityAdjustButton(
                icon: Icons.remove_rounded,
                onTap: enabled ? onDecrease : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SecondaryMarketOrderNumberField(
                  label: title,
                  controller: controller,
                  unit: unitLabel,
                  enabled: enabled,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              _QuantityAdjustButton(
                icon: Icons.add_rounded,
                onTap: enabled ? onIncrease : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final n in presets)
                _QuickSelectChip(
                  label: n == availableUnits ? maxChipLabel : '$n$unitLabel',
                  selected: selectedUnits == n,
                  onTap: enabled ? () => onSelectPreset(n) : null,
                ),
            ],
          ),
          const SizedBox(height: 24),
          SecondaryMarketTradeSummaryCard(
            title: formulaLabel,
            formula: formulaValue,
            highlightLabel: paymentLabel,
            highlightValue: paymentValue,
          ),
        ],
      ),
    );
  }
}

class SecondaryMarketOrderNumberField extends StatelessWidget {
  const SecondaryMarketOrderNumberField({
    super.key,
    required this.label,
    required this.unit,
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });
  final String label, unit;
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      style: context.appTextTheme.numericTitle,
      decoration: InputDecoration(suffixText: unit, hintText: '0'),
    ),
  );
}

class SecondaryMarketTradeSummaryCard extends StatelessWidget {
  const SecondaryMarketTradeSummaryCard({
    super.key,
    required this.title,
    this.rows = const [],
    required this.highlightLabel,
    required this.highlightValue,
    this.formula,
  });

  final String title;
  final List<SecondaryMarketTradeInfoRowData> rows;
  final String highlightLabel;
  final String highlightValue;
  final String? formula;

  @override
  Widget build(BuildContext context) {
    return SecondaryMarketTradePanelCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (formula != null) ...[
            Text(formula!, style: context.appTextTheme.numericTitle),
            const SizedBox(height: 12),
          ],
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _InfoRow(row: row),
            ),
          Divider(color: context.appColors.borderSoft),
          _InfoRow(
            row: SecondaryMarketTradeInfoRowData(
              label: highlightLabel,
              value: highlightValue,
              emphasized: true,
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryMarketTradeAgreementCard extends StatelessWidget {
  const SecondaryMarketTradeAgreementCard({
    super.key,
    required this.title,
    required this.body,
    required this.agreed,
    required this.onChanged,
    required this.documentLabel,
    required this.documentActionLabel,
    required this.documentAvailable,
    this.onOpenDocument,
  });

  final String title;
  final String body;
  final bool agreed;
  final ValueChanged<bool> onChanged;
  final String documentLabel;
  final String documentActionLabel;
  final bool documentAvailable;
  final VoidCallback? onOpenDocument;

  @override
  Widget build(BuildContext context) {
    return SecondaryMarketTradePanelCard(
      title: title,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.description_outlined,
              color: context.appColors.primary,
            ),
            title: Text(documentLabel, style: context.appTextTheme.bodyStrong),
            subtitle: Text(documentActionLabel),
            trailing: Icon(
              documentAvailable
                  ? Icons.chevron_right_rounded
                  : Icons.schedule_rounded,
            ),
            enabled: documentAvailable,
            onTap: documentAvailable ? onOpenDocument : null,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: agreed,
            onChanged: (value) => onChanged(value ?? false),
            title: Text(body, style: context.appTextTheme.body),
          ),
        ],
      ),
    );
  }
}

class SecondaryMarketTradeFinalNoticeCard extends StatelessWidget {
  const SecondaryMarketTradeFinalNoticeCard({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 20,
          color: context.appColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.appTextTheme.bodyStrong),
              Text(body, style: context.appTextTheme.caption),
            ],
          ),
        ),
      ],
    );
  }
}

class SecondaryMarketTradeReviewCard extends StatelessWidget {
  const SecondaryMarketTradeReviewCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.rows,
  });

  final String title;
  final String? subtitle;
  final List<SecondaryMarketTradeInfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return SecondaryMarketTradePanelCard(
      title: title,
      subtitle: subtitle,
      child: Column(
        children: rows
            .asMap()
            .entries
            .map((MapEntry<int, SecondaryMarketTradeInfoRowData> entry) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == rows.length - 1 ? 0 : 14,
                ),
                child: _InfoRow(row: entry.value),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class SecondaryMarketTradeStickyActionBar extends StatelessWidget {
  const SecondaryMarketTradeStickyActionBar({
    super.key,
    required this.amountLabel,
    required this.amountValue,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.helperText,
    this.isLoading = false,
  });

  final String amountLabel;
  final String amountValue;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String? helperText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(top: BorderSide(color: context.appColors.borderSoft)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (helperText != null) ...[
                Text(helperText!, style: context.appTextTheme.caption),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(amountLabel, style: context.appTextTheme.caption),
                        Text(
                          amountValue,
                          style: context.appTextTheme.numericTitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: AppButton(
                      label: primaryLabel,
                      onPressed: onPrimaryPressed,
                      isLoading: isLoading,
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

class _StepLabel extends StatelessWidget {
  const _StepLabel({
    required this.label,
    required this.selected,
    required this.completed,
  });

  final String label;
  final bool selected;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    final foregroundColor = selected || completed
        ? colors.textPrimary
        : colors.textSecondary;
    final iconColor = completed
        ? colors.primary
        : selected
        ? colors.infoForeground
        : colors.textSecondary.withValues(alpha: 0.5);

    return Row(
      children: <Widget>[
        Icon(
          completed ? Icons.check_circle_rounded : Icons.circle,
          size: 14,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: appText.caption.copyWith(color: foregroundColor),
          ),
        ),
      ],
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 6),
          Text(label, style: appText.micro.copyWith(color: textColor)),
        ],
      ),
    );
  }
}

class _CompactHighlightMetric extends StatelessWidget {
  const _CompactHighlightMetric({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.borderColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color backgroundColor;
  final Color borderColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: appText.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: appText.numericTitle.copyWith(
              color: valueColor,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final SecondaryMarketTradeMetricItemData metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final accentColor = metric.accentColor ?? colors.textPrimary;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: metric.backgroundColor ?? colors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: metric.borderColor ?? colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(metric.icon, size: 18, color: accentColor),
          const SizedBox(height: 10),
          Text(
            metric.value,
            style: appText.bodyStrong.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            metric.label,
            style: appText.micro.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _QuantityAdjustButton extends StatelessWidget {
  const _QuantityAdjustButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return Material(
      color: onTap == null ? colors.surfaceAlt : colors.primarySubtle,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            icon,
            color: onTap == null ? colors.textSecondary : colors.primary,
          ),
        ),
      ),
    );
  }
}

class _QuickSelectChip extends StatelessWidget {
  const _QuickSelectChip({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Material(
      color: selected ? colors.primarySubtle : colors.surfaceAlt,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.row});

  final SecondaryMarketTradeInfoRowData row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            row.label,
            style: appText.bodyMuted.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            row.value,
            textAlign: TextAlign.end,
            style: (row.emphasized ? appText.bodyStrong : appText.body)
                .copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}
