import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_buttons.dart';
import 'ui_tokens.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    required this.title,
    required this.location,
    required this.priceText,
    required this.ratingText,
    super.key,
    this.background,
    this.width = 152,
    this.height = 251,
    this.overlayHeight = 90,
    this.overlayGradientColors,
  });

  final String title;
  final String location;
  final String priceText;
  final String ratingText;
  final Widget? background;
  final double width;
  final double height;
  final double overlayHeight;
  final List<Color>? overlayGradientColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(hotelTheme.cardCornerRadius);

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            background ?? _PlaceholderArtwork(),
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Container(
                  height: overlayHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          overlayGradientColors ??
                          hotelTheme.mediaCardOverlayGradientColors,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hotelTheme.mediaCardTitleStyle,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: colors.onDark.withValues(alpha: 0.95),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: hotelTheme.mediaCardSubtitleStyle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              priceText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hotelTheme.mediaCardPriceStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      _RatingInline(ratingText: ratingText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DealBannerCard extends StatelessWidget {
  const DealBannerCard({
    required this.title,
    required this.location,
    required this.priceText,
    required this.ratingText,
    super.key,
    this.discountText,
    this.background,
    this.height = 213,
    this.overlayGradientColors,
  });

  final String title;
  final String location;
  final String priceText;
  final String ratingText;
  final String? discountText;
  final Widget? background;
  final double height;
  final List<Color>? overlayGradientColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(hotelTheme.cardCornerRadius);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            background ?? _PlaceholderArtwork(),
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          overlayGradientColors ??
                          hotelTheme.dealCardOverlayGradientColors,
                    ),
                  ),
                ),
              ),
            ),
            if (discountText != null)
              Positioned(
                top: 12,
                left: 12,
                child: PillChip(
                  backgroundColor: hotelTheme.discountChipBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Text(
                    discountText!,
                    style: hotelTheme.discountChipTextStyle,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hotelTheme.mediaCardTitleStyle,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: colors.onDark.withValues(alpha: 0.95),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: hotelTheme.mediaCardSubtitleStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _RatingInline(ratingText: ratingText),
                          const SizedBox(height: 6),
                          Text(
                            priceText,
                            style: hotelTheme.mediaCardPriceStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoCountBadge extends StatelessWidget {
  const PhotoCountBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    return PillChip(
      backgroundColor: hotelTheme.photoCountChipBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(label, style: hotelTheme.photoCountChipTextStyle),
    );
  }
}

class SurfacePanelCard extends StatelessWidget {
  const SurfacePanelCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.all(UiTokens.spacing16),
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final isDark = theme.brightness == Brightness.dark;
    final titleStyle = appText.sectionTitle;
    final subtitleStyle = appText.helper.copyWith(color: colors.textSecondary);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(
          alpha: isDark ? 0.94 : 0.97,
        ),
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: hotelTheme.cardTileShadowColor,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null ||
              subtitle != null ||
              leading != null ||
              trailing != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: UiTokens.spacing12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (title != null) Text(title!, style: titleStyle),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: UiTokens.spacing4),
                        Text(subtitle!, style: subtitleStyle),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  const SizedBox(width: UiTokens.spacing8),
                  trailing!,
                ],
              ],
            ),
          if (title != null ||
              subtitle != null ||
              leading != null ||
              trailing != null)
            const SizedBox(height: UiTokens.spacing12),
          child,
        ],
      ),
    );
  }
}

class ListItemCard extends StatelessWidget {
  const ListItemCard({
    super.key,
    required this.title,
    required this.location,
    required this.priceText,
    required this.ratingText,
    this.subtitle,
    this.image,
    this.onTap,
    this.trailing,
    this.showChevron = true,
  });

  final String title;
  final String location;
  final String priceText;
  final String ratingText;
  final String? subtitle;
  final Widget? image;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final isDark = theme.brightness == Brightness.dark;
    final cardRadius = BorderRadius.circular(UiTokens.radius20);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: cardRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(
              alpha: isDark ? 0.94 : 0.98,
            ),
            borderRadius: cardRadius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: hotelTheme.cardTileShadowColor,
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(UiTokens.spacing12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: image ?? _PlaceholderArtwork(),
                  ),
                ),
                const SizedBox(width: UiTokens.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appText.sectionTitle,
                            ),
                          ),
                          const SizedBox(width: UiTokens.spacing8),
                          _InlineRatingPill(ratingText: ratingText),
                        ],
                      ),
                      const SizedBox(height: UiTokens.spacing8),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: hotelTheme.categoryIdleIconColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appText.helper,
                            ),
                          ),
                        ],
                      ),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: UiTokens.spacing4),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appText.helper.copyWith(
                            color: colors.textSecondary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                      const SizedBox(height: UiTokens.spacing8),
                      Row(
                        children: <Widget>[
                          Text(
                            priceText,
                            style: appText.sectionTitle.copyWith(
                              color: hotelTheme.primaryButtonColor,
                            ),
                          ),
                          const Spacer(),
                          trailing ??
                              (showChevron
                                  ? Icon(
                                      Icons.chevron_right_rounded,
                                      color: hotelTheme.categoryIdleIconColor,
                                    )
                                  : const SizedBox.shrink()),
                        ],
                      ),
                    ],
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

class DetailSummaryCard extends StatelessWidget {
  const DetailSummaryCard({
    super.key,
    required this.title,
    required this.priceText,
    required this.location,
    required this.ratingText,
    this.description,
    this.tags = const <String>[],
    this.footer,
  });

  final String title;
  final String priceText;
  final String location;
  final String ratingText;
  final String? description;
  final List<String> tags;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    final hotelTheme = theme.extension<AppFTKTheme>()!;

    return SurfacePanelCard(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: hotelTheme.primaryButtonColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.hotel_class_rounded,
          color: hotelTheme.primaryButtonColor,
          size: 20,
        ),
      ),
      title: title,
      subtitle: location,
      trailing: _InlineRatingPill(ratingText: ratingText),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                priceText,
                style: appText.pageTitle.copyWith(
                  color: hotelTheme.primaryButtonColor,
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
              Text('/night', style: appText.helper),
            ],
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing12),
            Text(description!, style: appText.body),
          ],
          if (tags.isNotEmpty) ...<Widget>[
            const SizedBox(height: UiTokens.spacing12),
            Wrap(
              spacing: UiTokens.spacing8,
              runSpacing: UiTokens.spacing8,
              children: tags
                  .map(
                    (String tag) => PillChip(
                      backgroundColor: hotelTheme.primaryButtonColor.withValues(
                        alpha: 0.10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        tag,
                        style: appText.chip.copyWith(
                          color: hotelTheme.primaryButtonColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (footer != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing12),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _InlineRatingPill extends StatelessWidget {
  const _InlineRatingPill({required this.ratingText});

  final String ratingText;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    return PillChip(
      backgroundColor: hotelTheme.primaryButtonColor.withValues(alpha: 0.10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.star_rounded,
            size: 14,
            color: hotelTheme.ratingAccentColor,
          ),
          const SizedBox(width: 2),
          Text(
            ratingText,
            style: appText.chip.copyWith(color: hotelTheme.primaryButtonColor),
          ),
        ],
      ),
    );
  }
}

class _RatingInline extends StatelessWidget {
  const _RatingInline({required this.ratingText});

  final String ratingText;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.star_rounded, size: 12, color: hotelTheme.ratingAccentColor),
        const SizedBox(width: 2),
        Text(ratingText, style: hotelTheme.mediaCardRatingStyle),
      ],
    );
  }
}

class _PlaceholderArtwork extends StatelessWidget {
  const _PlaceholderArtwork();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).appColors;
    final palette = <Color>[
      appColors.heroStart,
      appColors.heroMiddle,
      appColors.heroEnd,
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            right: -10,
            top: 18,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: appColors.onDark.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: -38,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 170,
                height: 82,
                decoration: BoxDecoration(
                  color: appColors.onDark.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Icon(
              Icons.hotel_rounded,
              size: 24,
              color: appColors.onDark.withValues(alpha: 0.85),
            ),
          ),
          Positioned(
            bottom: 28,
            right: 16,
            child: Icon(
              Icons.waves_rounded,
              size: 34,
              color: appColors.onDark.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}
