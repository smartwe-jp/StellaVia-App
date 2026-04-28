import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class MyPageActiveFundSummaryCardData {
  const MyPageActiveFundSummaryCardData({
    required this.title,
    required this.periodText,
    required this.yieldLabel,
    required this.annualYield,
    required this.statusLabel,
    required this.statusBackgroundColor,
    required this.statusForegroundColor,
    this.progress,
    this.imageUrls = const <String>[],
    this.onTap,
  });

  final String title;
  final String periodText;
  final String yieldLabel;
  final String annualYield;
  final String statusLabel;
  final Color statusBackgroundColor;
  final Color statusForegroundColor;
  final double? progress;
  final List<String> imageUrls;
  final VoidCallback? onTap;
}

class MyPageActiveFundSummaryCard extends StatelessWidget {
  const MyPageActiveFundSummaryCard({
    super.key,
    required this.data,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final MyPageActiveFundSummaryCardData data;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final cardRadius = BorderRadius.circular(UiTokens.radius12);

    return Padding(
      padding: shadowPadding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.04),
              blurRadius: 10,
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
            child: SizedBox(
              height: 108,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _ActiveFundThumbnail(imageUrls: data.imageUrls),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: appText.cardTitle.copyWith(
                                color: colors.textPrimary,
                                fontSize: 13,
                                height: 1.3,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Text(
                                data.periodText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: appText.cardTitle.copyWith(
                                  color: colors.textSecondary,
                                  fontSize: 12,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 62),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              data.annualYield,
                              textAlign: TextAlign.right,
                              style: appText.numericTitle.copyWith(
                                color: colors.highlightGold,
                                fontSize: 17,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.yieldLabel,
                              textAlign: TextAlign.right,
                              style: appText.micro.copyWith(
                                color: colors.textTertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            _ActiveFundStatusBadge(
                              label: data.statusLabel,
                              backgroundColor: data.statusBackgroundColor,
                              foregroundColor: data.statusForegroundColor,
                            ),
                          ],
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

class _ActiveFundThumbnail extends StatelessWidget {
  const _ActiveFundThumbnail({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final cardRadius = BorderRadius.circular(6);
    final imageUrl = imageUrls.isEmpty ? null : imageUrls.first.trim();

    return SizedBox(
      height: double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: cardRadius,
          child: imageUrl != null && imageUrl.isNotEmpty
              ? DecoratedBox(
                  decoration: BoxDecoration(color: colors.primary),
                  child: AppRemoteImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: _ActiveFundThumbnailPlaceholder(
                      colors: colors,
                    ),
                  ),
                )
              : _ActiveFundThumbnailPlaceholder(colors: colors),
        ),
      ),
    );
  }
}

class _ActiveFundThumbnailPlaceholder extends StatelessWidget {
  const _ActiveFundThumbnailPlaceholder({required this.colors});

  final AppSemanticColorTheme colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.primary),
      child: Center(
        child: Icon(
          Icons.apartment_rounded,
          size: 20,
          color: colors.highlightGold,
        ),
      ),
    );
  }
}

class _ActiveFundStatusBadge extends StatelessWidget {
  const _ActiveFundStatusBadge({
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: appText.micro.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
