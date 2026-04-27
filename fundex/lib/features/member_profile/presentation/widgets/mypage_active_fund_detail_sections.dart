import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class ActiveFundOverviewMetricData {
  const ActiveFundOverviewMetricData({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

class ActiveFundInfoRowData {
  const ActiveFundInfoRowData({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;
}

class ActiveFundOverviewHeroCard extends StatelessWidget {
  const ActiveFundOverviewHeroCard({
    super.key,
    required this.title,
    required this.statusLabel,
    required this.statusBackgroundColor,
    required this.statusForegroundColor,
    required this.totalBenefitLabel,
    required this.totalBenefitValue,
    required this.primaryMetrics,
    required this.secondaryMetrics,
    this.onTitleTap,
    this.titleColor,
  });

  final String title;
  final String statusLabel;
  final Color statusBackgroundColor;
  final Color statusForegroundColor;
  final String totalBenefitLabel;
  final String totalBenefitValue;
  final List<ActiveFundOverviewMetricData> primaryMetrics;
  final List<ActiveFundOverviewMetricData> secondaryMetrics;
  final VoidCallback? onTitleTap;
  final Color? titleColor;

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
            colors.warningSubtle.withValues(alpha: 0.74),
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
            right: -40,
            top: -24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.warning.withValues(alpha: 0.18),
                    colors.warning.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const SizedBox(width: 170, height: 170),
            ),
          ),
          Positioned(
            left: -28,
            bottom: -40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.primary.withValues(alpha: 0.14),
                    colors.primary.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const SizedBox(width: 140, height: 140),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: colors.borderSoft),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 14,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.l10n.myPageActiveFundHeroEyebrow,
                            style: appText.micro.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackgroundColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusLabel,
                        style: appText.chip.copyWith(
                          color: statusForegroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onTitleTap,
                  child: Text(
                    title,
                    style: appText.pageTitle.copyWith(
                      color: titleColor ?? colors.textPrimary,
                      height: 1.24,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ActiveFundBenefitBalanceCard(
                  title: totalBenefitLabel,
                  value: totalBenefitValue,
                ),
                if (primaryMetrics.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    children: primaryMetrics
                        .map(
                          (ActiveFundOverviewMetricData metric) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: metric == primaryMetrics.last ? 0 : 10,
                              ),
                              child: _PrimaryMetricCard(metric: metric),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (secondaryMetrics.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    children: secondaryMetrics
                        .map(
                          (ActiveFundOverviewMetricData metric) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: metric == secondaryMetrics.last ? 0 : 10,
                              ),
                              child: _SecondaryMetricCard(metric: metric),
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

class ActiveFundSectionCard extends StatelessWidget {
  const ActiveFundSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

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
            Text(
              title,
              style: appText.sectionTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class ActiveFundInfoCard extends StatelessWidget {
  const ActiveFundInfoCard({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<ActiveFundInfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return ActiveFundSectionCard(
      title: title,
      child: Column(
        children: rows
            .asMap()
            .entries
            .map(
              (MapEntry<int, ActiveFundInfoRowData> entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == rows.length - 1 ? 0 : 14,
                ),
                child: _InfoRow(row: entry.value),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class ActiveFundBenefitBalanceCard extends StatelessWidget {
  const ActiveFundBenefitBalanceCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.primarySubtle, colors.surface],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: appText.bodyStrong.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: appText.numericHeadline.copyWith(
                color: colors.highlightGold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveFundBenefitHistoryCard extends StatelessWidget {
  const ActiveFundBenefitHistoryCard({
    super.key,
    required this.title,
    required this.benefitLabel,
    required this.benefitValue,
    required this.taxLabel,
    required this.taxValue,
    required this.netLabel,
    required this.netValue,
    this.footnote,
    this.action,
  });

  final String title;
  final String benefitLabel;
  final String benefitValue;
  final String taxLabel;
  final String taxValue;
  final String netLabel;
  final String netValue;
  final String? footnote;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: appText.cardTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: _BenefitMetricTile(
                    label: benefitLabel,
                    value: benefitValue,
                    valueColor: colors.textPrimary,
                    backgroundColor: colors.surfaceAlt,
                    borderColor: colors.borderSoft,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BenefitMetricTile(
                    label: taxLabel,
                    value: taxValue,
                    valueColor: colors.textSecondary,
                    backgroundColor: colors.surfaceAlt,
                    borderColor: colors.borderSoft,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BenefitMetricTile(
                    label: netLabel,
                    value: netValue,
                    valueColor: colors.highlightGold,
                    backgroundColor: colors.primarySubtle,
                    borderColor: colors.borderSoft,
                  ),
                ),
              ],
            ),
            if (footnote != null && footnote!.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                footnote!,
                style: appText.bodyMuted.copyWith(color: colors.textSecondary),
              ),
            ],
            if (action != null) ...<Widget>[
              const SizedBox(height: 14),
              Align(alignment: Alignment.centerRight, child: action!),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrimaryMetricCard extends StatelessWidget {
  const _PrimaryMetricCard({required this.metric});

  final ActiveFundOverviewMetricData metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            metric.label,
            style: appText.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: appText.numericTitle.copyWith(
              color: metric.valueColor ?? colors.textPrimary,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryMetricCard extends StatelessWidget {
  const _SecondaryMetricCard({required this.metric});

  final ActiveFundOverviewMetricData metric;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            metric.label,
            style: appText.micro.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            metric.value,
            style: appText.bodyStrong.copyWith(
              color: metric.valueColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitMetricTile extends StatelessWidget {
  const _BenefitMetricTile({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
            style: appText.micro.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(value, style: appText.bodyStrong.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.row});

  final ActiveFundInfoRowData row;

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
        Flexible(
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
