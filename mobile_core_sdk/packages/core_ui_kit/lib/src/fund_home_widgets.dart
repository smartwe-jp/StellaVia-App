import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'fund_detail_widgets.dart';
import 'ui_tokens.dart';

class FundHomeHeroSummary extends StatelessWidget {
  const FundHomeHeroSummary({
    super.key,
    required this.greeting,
    required this.totalAssetsLabel,
    required this.totalAssetsValue,
    this.totalAssetsDelta,
    required this.activeInvestmentLabel,
    required this.activeInvestmentValue,
    required this.totalDividendsLabel,
    required this.totalDividendsValue,
    this.onNotificationTap,
    this.showNotificationDot = false,
  });

  final String greeting;
  final String totalAssetsLabel;
  final String totalAssetsValue;
  final String? totalAssetsDelta;
  final String activeInvestmentLabel;
  final String activeInvestmentValue;
  final String totalDividendsLabel;
  final String totalDividendsValue;
  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final foregroundColor = colors.onDark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -40,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      colors.primary.withValues(alpha: 0.2),
                      colors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        greeting,
                        style: appText.heroSubtitle.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                    ),
                    _FundHeroNotificationButton(
                      showDot: showNotificationDot,
                      onTap: onNotificationTap,
                    ),
                  ],
                ),
                const SizedBox(height: UiTokens.spacing16),
                _FundHeroMetricCard(
                  label: totalAssetsLabel,
                  value: totalAssetsValue,
                  subtitle: totalAssetsDelta,
                  isPrimary: true,
                ),
                const SizedBox(height: UiTokens.spacing8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _FundHeroMetricCard(
                        label: activeInvestmentLabel,
                        value: activeInvestmentValue,
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: UiTokens.spacing8),
                    Expanded(
                      child: _FundHeroMetricCard(
                        label: totalDividendsLabel,
                        value: totalDividendsValue,
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FundGuestBrowsingBar extends StatelessWidget {
  const FundGuestBrowsingBar({
    super.key,
    required this.title,
    required this.message,
    required this.loginLabel,
    required this.registerLabel,
    this.onLoginTap,
    this.onRegisterTap,
  });

  final String title;
  final String message;
  final String loginLabel;
  final String registerLabel;
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final ftkTheme = theme.extension<AppFTKTheme>()!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: appText.bodyStrong.copyWith(color: colors.onDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: appText.caption.copyWith(
                      color: colors.onDark.withValues(alpha: 0.72),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: UiTokens.spacing12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _FundGuestActionButton(
                  label: loginLabel,
                  onTap: onLoginTap,
                  backgroundColor: colors.onDark.withValues(alpha: 0.15),
                  foregroundColor: colors.onDark,
                ),
                const SizedBox(width: UiTokens.spacing8),
                _FundGuestActionButton(
                  label: registerLabel,
                  onTap: onRegisterTap,
                  backgroundColor: ftkTheme.primaryButtonColor,
                  foregroundColor: colors.onDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FundGuestActionButton extends StatelessWidget {
  const _FundGuestActionButton({
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: appText.button.copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}

class _FundHeroNotificationButton extends StatelessWidget {
  const _FundHeroNotificationButton({
    required this.showDot,
    required this.onTap,
  });

  final bool showDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: colors.onDark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: onTap,
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: colors.onDark,
                ),
              ),
            ),
          ),
          if (showDot)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.heroStart, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FundHeroMetricCard extends StatelessWidget {
  const _FundHeroMetricCard({
    required this.label,
    required this.value,
    required this.isPrimary,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final valueStyle = isPrimary
        ? appText.heroMetricPrimary
        : appText.heroMetricSecondary;
    final backgroundGradient = isPrimary
        ? (isDark
              ? <Color>[
                  colors.heroMiddle.withValues(alpha: 0.82),
                  colors.primary.withValues(alpha: 0.30),
                ]
              : <Color>[
                  colors.heroMiddle.withValues(alpha: 0.72),
                  colors.brandPrimaryBright.withValues(alpha: 0.24),
                ])
        : <Color>[
            colors.heroEnd.withValues(alpha: 0.30),
            colors.brandWhite.withValues(alpha: 0.10),
          ];
    final borderColor = isPrimary
        ? (isDark
              ? colors.primary.withValues(alpha: 0.22)
              : colors.brandPrimaryBright.withValues(alpha: 0.20))
        : colors.brandWhite.withValues(alpha: 0.1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: backgroundGradient,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: appText.caption.copyWith(
              color: colors.onDark.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: valueStyle.copyWith(color: colors.onDark)),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: appText.chip.copyWith(color: colors.success),
            ),
          ],
        ],
      ),
    );
  }
}

enum FundReminderTone { danger, warning, info }

class FundReminderData {
  const FundReminderData({
    required this.leading,
    required this.title,
    required this.message,
    this.tone = FundReminderTone.warning,
    this.badgeLabel,
    this.progress,
    this.segmentCount,
    this.completedSegmentCount,
    this.actionLabel,
    this.onActionTap,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String message;
  final FundReminderTone tone;
  final String? badgeLabel;
  final double? progress;
  final int? segmentCount;
  final int? completedSegmentCount;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;
}

class FundReminderFeed extends StatelessWidget {
  const FundReminderFeed({super.key, required this.items, this.spacing = 12});

  final List<FundReminderData> items;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          FundReminderCard(data: items[index]),
          if (index < items.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

class FundReminderCard extends StatelessWidget {
  const FundReminderCard({super.key, required this.data});

  final FundReminderData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final palette = _paletteFor(context, data.tone);
    final cardRadius = BorderRadius.circular(UiTokens.radius16);
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.backgroundGradientColors,
        ),
        borderRadius: cardRadius,
        border: Border.all(color: palette.borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: palette.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              data.leading,
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.title,
                  style: appText.cardTitle.copyWith(color: palette.titleColor),
                ),
              ),
              if (data.badgeLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: palette.badgeBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.badgeLabel!,
                    style: appText.chip.copyWith(
                      color: palette.badgeForegroundColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              data.message,
              style: appText.bodyMuted.copyWith(
                color: palette.messageColor,
                height: 1.6,
              ),
            ),
          ),
          if (data.segmentCount != null &&
              data.completedSegmentCount != null) ...<Widget>[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: FundSegmentedProgressBar(
                segmentCount: data.segmentCount!,
                completedSegmentCount: data.completedSegmentCount!,
                activeColor: palette.progressFillColor,
                inactiveColor: palette.progressTrackColor,
              ),
            ),
          ] else if (data.progress != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: data.progress!.clamp(0, 1),
                  minHeight: 4,
                  backgroundColor: palette.progressTrackColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    palette.progressFillColor,
                  ),
                ),
              ),
            ),
          ],
          if (data.actionLabel != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: OutlinedButton(
                onPressed: data.onActionTap,
                style: OutlinedButton.styleFrom(
                  visualDensity: const VisualDensity(
                    horizontal: -2,
                    vertical: -2,
                  ),
                  foregroundColor: palette.actionTextColor,
                  side: BorderSide(
                    color: palette.actionBorderColor,
                    width: 1.5,
                  ),
                  backgroundColor: colors.surface,
                  minimumSize: const Size(0, 30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(data.actionLabel!, style: appText.chip),
              ),
            ),
          ],
        ],
      ),
    );

    if (data.onTap == null) {
      return card;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(borderRadius: cardRadius, onTap: data.onTap, child: card),
    );
  }
}

class FundSegmentedProgressBar extends StatelessWidget {
  const FundSegmentedProgressBar({
    super.key,
    required this.segmentCount,
    required this.completedSegmentCount,
    required this.activeColor,
    required this.inactiveColor,
    this.spacing = 8,
    this.height = 6,
  });

  final int segmentCount;
  final int completedSegmentCount;
  final Color activeColor;
  final Color inactiveColor;
  final double spacing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final safeSegmentCount = segmentCount <= 0 ? 1 : segmentCount;
    final safeCompletedCount = completedSegmentCount.clamp(0, safeSegmentCount);

    return Row(
      children: <Widget>[
        for (var index = 0; index < safeSegmentCount; index++) ...<Widget>[
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: index < safeCompletedCount ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
          if (index < safeSegmentCount - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}

class _FundGradientProgressBar extends StatelessWidget {
  const _FundGradientProgressBar({
    required this.value,
    required this.minHeight,
    required this.trackColor,
    required this.gradientColors,
    required this.borderRadius,
  });

  final double value;
  final double minHeight;
  final Color trackColor;
  final List<Color> gradientColors;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = value.clamp(0, 1).toDouble();
    final startColor = gradientColors.isNotEmpty
        ? gradientColors.first
        : trackColor;
    final endColor = gradientColors.length > 1
        ? gradientColors.last
        : startColor;
    final blueShift = _resolveBlueShift(normalizedValue);
    final visibility =
        0.32 + (0.68 * Curves.easeOutCubic.transform(normalizedValue));
    final shiftedGradientColors = <Color>[
      Color.lerp(startColor, endColor, blueShift * 0.58) ?? startColor,
      Color.lerp(startColor, endColor, blueShift) ?? endColor,
    ];
    final effectiveGradientColors = shiftedGradientColors
        .map(
          (Color color) => Color.lerp(trackColor, color, visibility) ?? color,
        )
        .toList(growable: false);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: minHeight,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ColoredBox(color: trackColor),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: normalizedValue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: effectiveGradientColors),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _resolveBlueShift(double normalizedValue) {
    if (normalizedValue <= 0.20) {
      return 0.00;
    }
    if (normalizedValue <= 0.40) {
      return _lerpWindow(normalizedValue, 0.20, 0.40, 0.00, 0.22);
    }
    if (normalizedValue <= 0.60) {
      return _lerpWindow(normalizedValue, 0.40, 0.60, 0.22, 0.46);
    }
    if (normalizedValue <= 0.80) {
      return _lerpWindow(normalizedValue, 0.60, 0.80, 0.46, 0.72);
    }
    return _lerpWindow(normalizedValue, 0.80, 1.00, 0.72, 0.96);
  }

  double _lerpWindow(
    double value,
    double start,
    double end,
    double startOutput,
    double endOutput,
  ) {
    final t = ((value - start) / (end - start)).clamp(0, 1).toDouble();
    return startOutput + ((endOutput - startOutput) * t);
  }
}

class _FundReminderPalette {
  const _FundReminderPalette({
    required this.backgroundGradientColors,
    required this.borderColor,
    required this.titleColor,
    required this.messageColor,
    required this.dotColor,
    required this.badgeBackgroundColor,
    required this.badgeForegroundColor,
    required this.progressTrackColor,
    required this.progressFillColor,
    required this.actionTextColor,
    required this.actionBorderColor,
  });

  final List<Color> backgroundGradientColors;
  final Color borderColor;
  final Color titleColor;
  final Color messageColor;
  final Color dotColor;
  final Color badgeBackgroundColor;
  final Color badgeForegroundColor;
  final Color progressTrackColor;
  final Color progressFillColor;
  final Color actionTextColor;
  final Color actionBorderColor;
}

_FundReminderPalette _paletteFor(BuildContext context, FundReminderTone tone) {
  final colors = Theme.of(context).appColors;

  switch (tone) {
    case FundReminderTone.danger:
      return _FundReminderPalette(
        backgroundGradientColors: <Color>[
          colors.dangerSubtle,
          colors.dangerSoft,
        ],
        borderColor: colors.dangerBorder,
        titleColor: colors.danger,
        messageColor: colors.dangerForeground,
        dotColor: colors.danger,
        badgeBackgroundColor: colors.danger,
        badgeForegroundColor: colors.onDark,
        progressTrackColor: colors.dangerSubtle,
        progressFillColor: colors.danger,
        actionTextColor: colors.dangerForeground,
        actionBorderColor: colors.dangerBorder,
      );
    case FundReminderTone.warning:
      return _FundReminderPalette(
        backgroundGradientColors: <Color>[
          colors.warningSubtle,
          colors.warningSoft,
        ],
        borderColor: colors.warningBorder,
        titleColor: colors.warning,
        messageColor: colors.warningForeground,
        dotColor: colors.warning,
        badgeBackgroundColor: colors.warning,
        badgeForegroundColor: colors.onDark,
        progressTrackColor: colors.warningSubtle,
        progressFillColor: colors.warning,
        actionTextColor: colors.warningAction,
        actionBorderColor: colors.warningBorder,
      );
    case FundReminderTone.info:
      return _FundReminderPalette(
        backgroundGradientColors: <Color>[colors.infoSubtle, colors.infoSoft],
        borderColor: colors.infoBorder,
        titleColor: colors.info,
        messageColor: colors.infoForeground,
        dotColor: colors.info,
        badgeBackgroundColor: colors.info,
        badgeForegroundColor: colors.onDark,
        progressTrackColor: colors.infoSubtle,
        progressFillColor: colors.info,
        actionTextColor: colors.infoForeground,
        actionBorderColor: colors.infoBorder,
      );
  }
}

class FundSectionHeader extends StatelessWidget {
  const FundSectionHeader({
    super.key,
    required this.title,
    this.leading,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              if (leading != null) ...<Widget>[
                leading!,
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(title, style: appText.heroMetricSecondary)),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            child: Text(
              actionLabel ?? '',
              style: appText.bodyStrong.copyWith(color: colors.primary),
            ),
          ),
      ],
    );
  }
}

class FundFeaturedFundTagData {
  const FundFeaturedFundTagData({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
}

class FundFeaturedFundCardData {
  const FundFeaturedFundCardData({
    required this.title,
    required this.annualYield,
    required this.metadata,
    required this.progress,
    this.progressLabel,
    this.tags = const <FundFeaturedFundTagData>[],
    this.artworkGradientColors = const <Color>[],
    this.imageUrls = const <String>[],
    this.onTap,
  });

  final String title;
  final String annualYield;
  final String metadata;
  final double progress;
  final String? progressLabel;
  final List<FundFeaturedFundTagData> tags;
  final List<Color> artworkGradientColors;
  final List<String> imageUrls;
  final VoidCallback? onTap;
}

class FundFeaturedFundCarousel extends StatelessWidget {
  const FundFeaturedFundCarousel({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.actionLabel,
    this.onActionTap,
    this.height = 260,
    this.itemSpacing = 12,
    this.headerSpacing = 0,
  });

  final String title;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final List<Widget> children;
  final double height;
  final double itemSpacing;
  final double headerSpacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: UiTokens.spacing16),
          child: FundSectionHeader(
            title: title,
            leading: leading,
            actionLabel: actionLabel,
            onActionTap: onActionTap,
          ),
        ),
        SizedBox(height: headerSpacing),
        SizedBox(
          height: height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (
                  var index = 0;
                  index < children.length;
                  index++
                ) ...<Widget>[
                  children[index],
                  if (index < children.length - 1) SizedBox(width: itemSpacing),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FundFeaturedFundCard extends StatelessWidget {
  const FundFeaturedFundCard({
    super.key,
    required this.data,
    required this.yieldLabel,
    this.width = 280,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final FundFeaturedFundCardData data;
  final String yieldLabel;
  final double width;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final borderColor = colors.border;
    final shadowColor = colors.scrim;
    final cardRadius = BorderRadius.circular(UiTokens.radius16);
    final artworkGradientColors = data.artworkGradientColors.isEmpty
        ? <Color>[colors.heroStart, colors.heroMiddle, colors.heroEnd]
        : data.artworkGradientColors;

    return SizedBox(
      width: width,
      height: double.infinity,
      child: Padding(
        padding: shadowPadding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: cardRadius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.07),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: cardRadius,
              side: BorderSide(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: cardRadius,
              onTap: data.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 130,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        FundHeroMediaBackground(
                          gradientColors: artworkGradientColors,
                          imageUrls: data.imageUrls,
                        ),
                        if (data.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: data.tags
                                  .map(
                                    (FundFeaturedFundTagData tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tag.backgroundColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tag.label,
                                        style: appText.micro.copyWith(
                                          color: tag.foregroundColor,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appText.cardTitle,
                          ),

                          const SizedBox(height: UiTokens.spacing8),

                          Text(
                            yieldLabel,
                            style: appText.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          //const SizedBox(height: 2),
                          Text(
                            data.annualYield,
                            style: appText.numericHeadline.copyWith(
                              color: colors.success,
                              height: 1.0,
                            ),
                          ),

                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              data.metadata,
                              textAlign: TextAlign.end,
                              style: appText.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                                 
                          const SizedBox(height: UiTokens.spacing4),
                          _FundGradientProgressBar(
                            value: data.progress,
                            minHeight: 5,
                            trackColor: colors.border,
                            gradientColors: <Color>[
                              colors.success,
                              colors.primary,
                            ],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FundLabeledValue {
  const FundLabeledValue({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

class FundActiveFundCardData {
  const FundActiveFundCardData({
    required this.title,
    required this.annualYield,
    required this.rows,
    this.progress,
    this.progressColor,
    this.onTap,
  });

  final String title;
  final String annualYield;
  final List<FundLabeledValue> rows;
  final double? progress;
  final Color? progressColor;
  final VoidCallback? onTap;
}

class FundSectionList extends StatefulWidget {
  const FundSectionList({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.actionLabel,
    this.onActionTap,
    this.showMoreLabel,
    this.showLessLabel,
    this.initialVisibleCount = 3,
    this.itemSpacing = 4,
    this.headerSpacing = UiTokens.spacing8,
  });

  final String title;
  final List<Widget> children;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final String? showMoreLabel;
  final String? showLessLabel;
  final int initialVisibleCount;
  final double itemSpacing;
  final double headerSpacing;

  @override
  State<FundSectionList> createState() => _FundSectionListState();
}

class _FundSectionListState extends State<FundSectionList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final shouldShowMoreAction =
        widget.showMoreLabel != null &&
        widget.showLessLabel != null &&
        widget.children.length > widget.initialVisibleCount;
    final visibleItems = _expanded
        ? widget.children
        : widget.children.take(widget.initialVisibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FundSectionHeader(
          title: widget.title,
          leading: widget.leading,
          actionLabel: widget.actionLabel,
          onActionTap: widget.onActionTap,
        ),
        SizedBox(height: widget.headerSpacing),
        for (var index = 0; index < visibleItems.length; index++) ...<Widget>[
          visibleItems[index],
          if (index < visibleItems.length - 1)
            SizedBox(height: widget.itemSpacing),
        ],
        if (shouldShowMoreAction) ...<Widget>[
          const SizedBox(height: UiTokens.spacing8),
          TextButton(
            onPressed: widget.onActionTap,
            child: Text(
              _expanded ? widget.showLessLabel! : widget.showMoreLabel!,
            ),
          ),
        ],
      ],
    );
  }
}

class FundActiveFundCard extends StatelessWidget {
  const FundActiveFundCard({
    super.key,
    required this.data,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final FundActiveFundCardData data;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final cardRadius = BorderRadius.circular(UiTokens.radius16);
    final borderColor = colors.border;
    final shadowColor = colors.scrim;

    return Padding(
      padding: shadowPadding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.065),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: cardRadius,
            side: BorderSide(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: cardRadius,
            onTap: data.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(data.title, style: appText.cardTitle),
                      ),
                      const SizedBox(width: UiTokens.spacing8),
                      Text(
                        data.annualYield,
                        style: appText.numericTitle.copyWith(
                          color: colors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UiTokens.spacing8),
                  for (final row in data.rows) ...<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            row.label,
                            style: appText.bodyMuted.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: UiTokens.spacing8),
                        Text(
                          row.value,
                          style: appText.bodyStrong.copyWith(
                            color: row.valueColor ?? colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    if (row != data.rows.last) const SizedBox(height: 4),
                  ],
                  if (data.progress != null) ...<Widget>[
                    const SizedBox(height: UiTokens.spacing8),
                    _FundGradientProgressBar(
                      value: data.progress!,
                      minHeight: 5,
                      trackColor: colors.border,
                      gradientColors: <Color>[
                        data.progressColor ?? colors.success,
                        colors.primary,
                      ],
                      borderRadius: BorderRadius.circular(2),
                    ),
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
