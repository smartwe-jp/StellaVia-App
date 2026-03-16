import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
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
    return Column(
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColorTokens.fundexPrimaryDark,
                    AppColorTokens.fundexPrimaryDarkDradient,
                  ],
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
                              style:
                                  (Theme.of(context).textTheme.titleMedium ??
                                          const TextStyle())
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
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
                            style:
                                (Theme.of(context).textTheme.labelSmall ??
                                        const TextStyle())
                                    .copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.52,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            totalAssetsValue,
                            style:
                                (Theme.of(context).textTheme.headlineMedium ??
                                        const TextStyle())
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            totalAssetsCaption,
                            textAlign: TextAlign.center,
                            style:
                                (Theme.of(context).textTheme.labelSmall ??
                                        const TextStyle())
                                    .copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.42,
                                      ),
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
    const cardRadius = BorderRadius.all(Radius.circular(UiTokens.radius16));
    final borderColor = AppColorTokens.fundexBorder;

    return Padding(
      padding: shadowPadding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accentColor != null
              ? accentColor
              : Colors.transparent,
          borderRadius: cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: cardRadius,
            side: BorderSide(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: cardRadius,
            onTap: onTap,
            child: 
                Container(
                  decoration: BoxDecoration(borderRadius: cardRadius),
                  margin: const EdgeInsets.only(left: 5),
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                              style:
                                  (theme.textTheme.bodyMedium ??
                                          const TextStyle())
                                      .copyWith(
                                        color: AppColorTokens.fundexText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
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
                      for (
                        var index = 0;
                        index < rows.length;
                        index++
                      ) ...<Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                rows[index].label,
                                style:
                                    (theme.textTheme.labelMedium ??
                                            const TextStyle())
                                        .copyWith(
                                          color: AppColorTokens
                                              .fundexTextSecondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                              ),
                            ),
                            const SizedBox(width: UiTokens.spacing8),
                            Text(
                              rows[index].value,
                              style:
                                  (theme.textTheme.bodySmall ??
                                          const TextStyle())
                                      .copyWith(
                                        color:
                                            rows[index].valueColor ??
                                            AppColorTokens.fundexText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
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
                          style:
                              (theme.textTheme.labelSmall ?? const TextStyle())
                                  .copyWith(
                                    color: AppColorTokens.fundexTextTertiary,
                                    fontSize: 11,
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

class _FundMyPageMetricCard extends StatelessWidget {
  const _FundMyPageMetricCard({required this.data});

  final FundMyPageMetricData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColorTokens.fundexBorder),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              children: <Widget>[
                Text(
                  data.label,
                  textAlign: TextAlign.center,
                  style: (theme.textTheme.labelSmall ?? const TextStyle())
                      .copyWith(color: AppColorTokens.fundexTextTertiary),
                ),
                const SizedBox(height: 4),
                Text(
                  data.value,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (theme.textTheme.titleSmall ?? const TextStyle())
                      .copyWith(
                        color: data.valueColor ?? AppColorTokens.fundexText,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: data.onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: data.backgroundColor ?? AppColorTokens.fundexBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: data.borderColor ?? Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  size: 18,
                  color: data.foregroundColor ?? AppColorTokens.fundexText,
                ),
                child: data.icon,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  data.label,
                  overflow: TextOverflow.ellipsis,
                  style: (theme.textTheme.labelLarge ?? const TextStyle())
                      .copyWith(
                        color:
                            data.foregroundColor ?? AppColorTokens.fundexText,
                        fontWeight: FontWeight.w700,
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
