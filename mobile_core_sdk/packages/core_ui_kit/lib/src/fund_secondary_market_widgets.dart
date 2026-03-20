import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class FundSecondaryMarketCardData {
  const FundSecondaryMarketCardData({
    required this.title,
    required this.annualYield,
    required this.investorTypeLabel,
    required this.soldUnitsLabel,
    required this.unitPriceLabel,
    required this.progress,
    this.statusLabel,
    this.statusBackgroundColor,
    this.statusForegroundColor,
    this.onTap,
  });

  final String title;
  final String annualYield;
  final String investorTypeLabel;
  final String soldUnitsLabel;
  final String unitPriceLabel;
  final double progress;
  final String? statusLabel;
  final Color? statusBackgroundColor;
  final Color? statusForegroundColor;
  final VoidCallback? onTap;
}

class FundSecondaryMarketCard extends StatelessWidget {
  const FundSecondaryMarketCard({
    super.key,
    required this.data,
    required this.yieldLabel,
    required this.soldUnitsTitle,
    required this.unitPriceTitle,
    this.width = 280,
    this.fillHeight = false,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final FundSecondaryMarketCardData data;
  final String yieldLabel;
  final String soldUnitsTitle;
  final String unitPriceTitle;
  final double width;
  final bool fillHeight;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final cardRadius = BorderRadius.circular(UiTokens.radius16);

    return SizedBox(
      width: width,
      child: Padding(
        padding: shadowPadding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: cardRadius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.07),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: cardRadius,
              side: BorderSide(color: colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: cardRadius,
              onTap: data.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          colors.primarySubtle,
                          colors.warningSubtle,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (data.statusLabel != null) ...<Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  data.statusBackgroundColor ??
                                  colors.primarySubtle,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              data.statusLabel!,
                              style: appText.micro.copyWith(
                                color:
                                    data.statusForegroundColor ??
                                    colors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: UiTokens.spacing8),
                        ],
                        Text(
                          data.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appText.cardTitle,
                        ),
                      ],
                    ),
                  ),
                  if (fillHeight)
                    Expanded(child: _buildBody(context))
                  else
                    _buildBody(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      yieldLabel,
                      style: appText.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      data.annualYield,
                      style: appText.numericHeadline.copyWith(
                        color: colors.danger,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
              Expanded(
                child: Text(
                  data.investorTypeLabel,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appText.caption.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing12),
          _FundSecondaryMarketInfoRow(
            label: soldUnitsTitle,
            value: data.soldUnitsLabel,
          ),
          const SizedBox(height: UiTokens.spacing4),
          _FundSecondaryMarketInfoRow(
            label: unitPriceTitle,
            value: data.unitPriceLabel,
          ),
          if (fillHeight) const Spacer() else const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: data.progress.clamp(0, 1),
              backgroundColor: colors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _FundSecondaryMarketInfoRow extends StatelessWidget {
  const _FundSecondaryMarketInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: appText.bodyMuted.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(width: UiTokens.spacing8),
        Text(
          value,
          style: appText.bodyStrong.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
