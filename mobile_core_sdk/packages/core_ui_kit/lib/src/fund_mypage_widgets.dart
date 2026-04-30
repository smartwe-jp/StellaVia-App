import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'fund_home_widgets.dart';
import 'ui_tokens.dart';

class FundMyPageMetricData {
  const FundMyPageMetricData({
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;
}

class FundMyPageQuickActionData {
  const FundMyPageQuickActionData({
    required this.label,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
}

class FundMyPageVerificationBadgeData {
  const FundMyPageVerificationBadgeData({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final IconData? icon;
}

class FundMyPageAssetOverview extends StatelessWidget {
  const FundMyPageAssetOverview({
    super.key,
    required this.brandLabel,
    required this.welcomeLabel,
    required this.displayName,
    required this.totalAssetsLabel,
    required this.totalAssetsValue,
    required this.totalAssetsCaption,
    required this.metrics,
    required this.quickActions,
    this.verificationBadge,
    this.headerActions = const <Widget>[],
  });

  final String brandLabel;
  final String welcomeLabel;
  final String displayName;
  final String totalAssetsLabel;
  final String totalAssetsValue;
  final String totalAssetsCaption;
  final List<FundMyPageMetricData> metrics;
  final List<FundMyPageQuickActionData> quickActions;
  final FundMyPageVerificationBadgeData? verificationBadge;
  final List<Widget> headerActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.heroStart),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, topInset + 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    brandLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appText.cardTitle.copyWith(
                      color: colors.highlightGold,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                if (headerActions.isNotEmpty) ...<Widget>[
                  for (
                    var index = 0;
                    index < headerActions.length;
                    index++
                  ) ...<Widget>[
                    headerActions[index],
                    if (index < headerActions.length - 1)
                      const SizedBox(width: 12),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 30),
            Text(
              welcomeLabel,
              style: appText.body.copyWith(
                color: colors.onDark.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: appText.pageTitle.copyWith(
                      color: colors.onDark,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ),
                if (verificationBadge != null) ...<Widget>[
                  const SizedBox(width: 8),
                  _FundMyPageVerificationBadge(data: verificationBadge!),
                ],
              ],
            ),
            const SizedBox(height: 22),
            Text(
              totalAssetsLabel,
              style: appText.caption.copyWith(
                color: colors.highlightGold,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              totalAssetsValue,
              style: appText.heroMetricPrimary.copyWith(
                color: colors.onDark,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              totalAssetsCaption,
              style: appText.body.copyWith(
                color: colors.onDark.withValues(alpha: 0.62),
                height: 1.35,
              ),
            ),
            if (metrics.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (
                    var index = 0;
                    index < metrics.length;
                    index++
                  ) ...<Widget>[
                    Expanded(
                      child: _FundMyPageMetricCard(data: metrics[index]),
                    ),
                    if (index < metrics.length - 1)
                      const SizedBox(width: UiTokens.spacing8),
                  ],
                ],
              ),
            ],
            if (quickActions.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  for (
                    var index = 0;
                    index < quickActions.length;
                    index++
                  ) ...<Widget>[
                    Expanded(
                      child: _FundMyPageQuickActionButton(
                        data: quickActions[index],
                      ),
                    ),
                    if (index < quickActions.length - 1)
                      const SizedBox(width: 10),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FundMyPageVerificationBadge extends StatelessWidget {
  const _FundMyPageVerificationBadge({required this.data});

  final FundMyPageVerificationBadgeData data;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: data.borderColor == null
            ? null
            : Border.all(color: data.borderColor!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (data.icon != null) ...<Widget>[
              Icon(data.icon, size: 12, color: data.foregroundColor),
              const SizedBox(width: 4),
            ],
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appText.meta.copyWith(
                color: data.foregroundColor,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundMyPageProjectCard extends StatelessWidget {
  const FundMyPageProjectCard({
    super.key,
    required this.title,
    required this.rows,
    this.trailing,
    this.accentColor,
    this.detail,
    this.footnote,
    this.footer,
    this.onTap,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final String title;
  final List<FundLabeledValue> rows;
  final Widget? trailing;
  final Color? accentColor;
  final Widget? detail;
  final String? footnote;
  final Widget? footer;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    const cardRadius = BorderRadius.all(Radius.circular(UiTokens.radius16));
    const innerCardRadius = BorderRadius.all(
      Radius.circular(UiTokens.radius14),
    );
    final borderColor = colors.border;
    final hasAccent = accentColor != null;
    final leftInset = hasAccent ? 3.0 : 0.0;

    return Padding(
      padding: shadowPadding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accentColor ?? colors.surface,
          borderRadius: cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.06),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: colors.surface.withValues(alpha: 0),
          borderRadius: cardRadius,
          //clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: cardRadius,
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(left: leftInset),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: hasAccent ? innerCardRadius : cardRadius,
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appText.cardTitle.copyWith(
                            color: colors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (trailing != null) ...<Widget>[
                        const SizedBox(width: UiTokens.spacing8),
                        trailing!,
                      ],
                    ],
                  ),
                  if (rows.isNotEmpty) const SizedBox(height: 8),
                  for (var index = 0; index < rows.length; index++) ...<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            rows[index].label,
                            style: appText.tableLabel.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: UiTokens.spacing8),
                        Text(
                          rows[index].value,
                          style: appText.tableValue.copyWith(
                            color: rows[index].valueColor ?? colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    if (index < rows.length - 1) const SizedBox(height: 4),
                  ],
                  if (detail != null) ...<Widget>[
                    const SizedBox(height: 8),
                    detail!,
                  ],
                  if (footnote != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      footnote!,
                      style: appText.meta.copyWith(
                        color: colors.textTertiary,
                        height: 1.5,
                      ),
                    ),
                  ],
                  if (footer != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: footer),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FundMyPageMetricCard extends StatefulWidget {
  const _FundMyPageMetricCard({required this.data});

  final FundMyPageMetricData data;

  @override
  State<_FundMyPageMetricCard> createState() => _FundMyPageMetricCardState();
}

class _FundMyPageMetricCardState extends State<_FundMyPageMetricCard> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final enabled = widget.data.onTap != null;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.data.onTap,
        onTapDown: enabled
            ? (_) {
                if (_pressed) {
                  return;
                }
                setState(() {
                  _pressed = true;
                });
              }
            : null,
        onTapUp: enabled
            ? (_) {
                if (!_pressed) {
                  return;
                }
                setState(() {
                  _pressed = false;
                });
              }
            : null,
        onTapCancel: enabled
            ? () {
                if (!_pressed) {
                  return;
                }
                setState(() {
                  _pressed = false;
                });
              }
            : null,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.primaryAlt.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(UiTokens.radius12),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.data.label,
                      textAlign: TextAlign.center,
                      style: appText.meta.copyWith(
                        color: colors.onDark.withValues(alpha: 0.58),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appText.heroMetricSecondary.copyWith(
                        color: widget.data.valueColor ?? colors.onDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FundMyPageQuickActionButton extends StatelessWidget {
  const _FundMyPageQuickActionButton({required this.data});

  final FundMyPageQuickActionData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final borderColor = data.borderColor ?? colors.surface.withValues(alpha: 0);
    final foregroundColor = data.foregroundColor ?? colors.textPrimary;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        onTap: data.onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: data.backgroundColor ?? colors.background,
            borderRadius: BorderRadius.circular(UiTokens.radius12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (data.icon != null) ...<Widget>[
                IconTheme(
                  data: IconThemeData(size: 18, color: foregroundColor),
                  child: data.icon!,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  data.label,
                  overflow: TextOverflow.ellipsis,
                  style: appText.button.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
