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
    required this.icon,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
}

class FundMyPageAssetOverview extends StatelessWidget {
  const FundMyPageAssetOverview({
    super.key,
    required this.totalAssetsLabel,
    required this.totalAssetsValue,
    required this.totalAssetsCaption,
    required this.metrics,
    required this.quickActions,
    this.title,
    this.leading,
    this.trailing,
  });

  final String totalAssetsLabel;
  final String totalAssetsValue;
  final String totalAssetsCaption;
  final List<FundMyPageMetricData> metrics;
  final List<FundMyPageQuickActionData> quickActions;
  final String? title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Column(
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[colors.heroStart, colors.heroMiddle],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (leading != null) leading!,
                        if (leading != null && title != null)
                          const SizedBox(width: 12),
                        if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              style: appText.pageTitle.copyWith(
                                color: colors.onDark,
                              ),
                            ),
                          )
                        else
                          const Spacer(),
                        if (trailing != null) ...<Widget>[
                          if (title != null) const SizedBox(width: 12),
                          trailing!,
                        ],
                      ],
                    ),
                    const SizedBox(height: UiTokens.spacing16),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            totalAssetsLabel,
                            style: appText.caption.copyWith(
                              color: colors.onDark.withValues(alpha: 0.52),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            totalAssetsValue,
                            style: appText.heroMetricPrimary.copyWith(
                              color: colors.onDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            totalAssetsCaption,
                            textAlign: TextAlign.center,
                            style: appText.micro.copyWith(
                              color: colors.onDark.withValues(alpha: 0.42),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (metrics.isNotEmpty)
              Positioned(
                left: UiTokens.spacing16,
                right: UiTokens.spacing16,
                bottom: -36,
                child: Row(
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
              ),
          ],
        ),
        SizedBox(height: metrics.isEmpty ? UiTokens.spacing16 : 52),
        if (quickActions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
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
          ),
      ],
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
    this.footnote,
    this.footer,
    this.onTap,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final String title;
  final List<FundLabeledValue> rows;
  final Widget? trailing;
  final Color? accentColor;
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
          clipBehavior: Clip.antiAlias,
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
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.scrim.withValues(alpha: _pressed ? 0.03 : 0.05),
                  blurRadius: _pressed ? 6 : 10,
                  offset: Offset(0, _pressed ? 2 : 4),
                ),
              ],
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
                      style: appText.meta.copyWith(color: colors.textTertiary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appText.heroMetricSecondary.copyWith(
                        color: widget.data.valueColor ?? colors.textPrimary,
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

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: data.onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: data.backgroundColor ?? colors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: data.borderColor ?? colors.surface.withValues(alpha: 0),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  size: 18,
                  color: data.foregroundColor ?? colors.textPrimary,
                ),
                child: data.icon,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  data.label,
                  overflow: TextOverflow.ellipsis,
                  style: appText.button.copyWith(
                    color: data.foregroundColor ?? colors.textPrimary,
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
