import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class SecondaryMarketDetailDocumentItemData {
  const SecondaryMarketDetailDocumentItemData({
    required this.title,
    required this.subtitle,
    required this.available,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool available;
  final VoidCallback? onTap;
}

class SecondaryMarketDetailHeroCard extends StatelessWidget {
  const SecondaryMarketDetailHeroCard({
    super.key,
    required this.marketLabel,
    required this.title,
    required this.statusLabel,
    required this.statusBackgroundColor,
    required this.statusForegroundColor,
    required this.investorTypeLabel,
    required this.unitPriceLabel,
    required this.unitPriceCaption,
    required this.remainingUnitsLabel,
    required this.remainingUnitsCaption,
    required this.listedUnitsLabel,
    required this.soldUnitsLabel,
    required this.completionRateLabel,
    this.orderTimeLabel,
  });

  final String marketLabel;
  final String title;
  final String statusLabel;
  final Color statusBackgroundColor;
  final Color statusForegroundColor;
  final String investorTypeLabel;
  final String unitPriceLabel;
  final String unitPriceCaption;
  final String remainingUnitsLabel;
  final String remainingUnitsCaption;
  final String listedUnitsLabel;
  final String soldUnitsLabel;
  final String completionRateLabel;
  final String? orderTimeLabel;

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
            colors.warningSubtle,
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
            top: -34,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.warning.withValues(alpha: 0.24),
                    colors.warning.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const SizedBox(width: 190, height: 190),
            ),
          ),
          Positioned(
            left: -28,
            bottom: -48,
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
              child: const SizedBox(width: 150, height: 150),
            ),
          ),
          Positioned(
            right: 22,
            top: 82,
            child: Transform.rotate(
              angle: -0.26,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onDark.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox(width: 118, height: 10),
              ),
            ),
          ),
          Positioned(
            left: 40,
            top: 44,
            child: Transform.rotate(
              angle: 0.52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox(width: 78, height: 8),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: colors.borderSoft),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.storefront_rounded,
                            size: 14,
                            color: colors.warningAction,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            marketLabel,
                            style: appText.micro.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _DetailStatusBadge(
                      label: statusLabel,
                      backgroundColor: statusBackgroundColor,
                      foregroundColor: statusForegroundColor,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: appText.pageTitle.copyWith(
                    color: colors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _MetaChip(
                      icon: Icons.badge_outlined,
                      label: investorTypeLabel,
                    ),
                    if (orderTimeLabel != null)
                      _MetaChip(
                        icon: Icons.schedule_rounded,
                        label: orderTimeLabel!,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.90),
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
                      width: 112,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 104),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                remainingUnitsCaption,
                                style: appText.micro.copyWith(
                                  color: colors.onDark.withValues(alpha: 0.78),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                remainingUnitsLabel,
                                style: appText.numericTitle.copyWith(
                                  color: colors.onDark,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.60),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: colors.borderSoft),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _HeroMetricCard(
                          label: listedUnitsLabel,
                          icon: Icons.sell_outlined,
                          backgroundColor: colors.surface,
                          borderColor: colors.borderSoft,
                          accentColor: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HeroMetricCard(
                          label: soldUnitsLabel,
                          icon: Icons.task_alt_rounded,
                          backgroundColor: colors.warningSubtle.withValues(
                            alpha: 0.74,
                          ),
                          borderColor: colors.warningBorder,
                          accentColor: colors.warningAction,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HeroMetricCard(
                          label: completionRateLabel,
                          icon: Icons.insights_rounded,
                          backgroundColor: colors.primarySubtle.withValues(
                            alpha: 0.78,
                          ),
                          borderColor: colors.primary.withValues(alpha: 0.16),
                          accentColor: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryMarketDetailSectionCard extends StatelessWidget {
  const SecondaryMarketDetailSectionCard({
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
            blurRadius: 18,
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
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class SecondaryMarketDetailInfoRow extends StatelessWidget {
  const SecondaryMarketDetailInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: appText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryMarketDetailActivityGrid extends StatelessWidget {
  const SecondaryMarketDetailActivityGrid({
    super.key,
    required this.applicationCount,
    required this.dealCount,
    required this.latestApplication,
    required this.latestDeal,
  });

  final String applicationCount;
  final String dealCount;
  final String latestApplication;
  final String latestDeal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _HighlightMetricTile(
                icon: Icons.inventory_2_outlined,
                label: applicationCount,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HighlightMetricTile(
                icon: Icons.handshake_outlined,
                label: dealCount,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _TimelineInfoTile(
          icon: Icons.schedule_send_rounded,
          value: latestApplication,
        ),
        const SizedBox(height: 8),
        _TimelineInfoTile(icon: Icons.task_alt_rounded, value: latestDeal),
      ],
    );
  }
}

class SecondaryMarketDetailDocumentsList extends StatelessWidget {
  const SecondaryMarketDetailDocumentsList({super.key, required this.items});

  final List<SecondaryMarketDetailDocumentItemData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          _DocumentTile(data: items[index]),
          if (index < items.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class SecondaryMarketMarketplaceStateCard extends StatelessWidget {
  const SecondaryMarketMarketplaceStateCard({
    super.key,
    required this.message,
    this.actionLabel,
    this.onActionTap,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

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
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
            if (actionLabel != null && onActionTap != null) ...<Widget>[
              const SizedBox(height: 14),
              OutlinedButton(onPressed: onActionTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  const _HeroMetricCard({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.accentColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;

    final pieces = label.split('\n');
    final title = pieces.first;
    final value = pieces.length > 1 ? pieces.last : '';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accentColor.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: accentColor),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: appText.numericTitle.copyWith(
                color: accentColor,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: appText.micro.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailStatusBadge extends StatelessWidget {
  const _DetailStatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.18)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: foregroundColor.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: appText.chip.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: colors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: appText.micro.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _HighlightMetricTile extends StatelessWidget {
  const _HighlightMetricTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: appText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineInfoTile extends StatelessWidget {
  const _TimelineInfoTile({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 17, color: colors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: appText.bodyMuted.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.data});

  final SecondaryMarketDetailDocumentItemData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: data.available ? data.onTap : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: data.available ? colors.primarySubtle : colors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 20,
                  color: data.available ? colors.primary : colors.textTertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.title,
                      style: appText.bodyStrong.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle,
                      style: appText.caption.copyWith(
                        color: data.available
                            ? colors.primary
                            : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                data.available
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.schedule_rounded,
                size: data.available ? 14 : 18,
                color: data.available ? colors.primary : colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
