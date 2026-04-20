import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class MyPageActiveFundSummaryCardData {
  const MyPageActiveFundSummaryCardData({
    required this.title,
    required this.periodText,
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          data.periodText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appText.meta.copyWith(
                            color: colors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _ActiveFundProgressBar(
                          value: data.progress ?? 0,
                          activeColor: colors.highlightGold,
                          trackColor: colors.border,
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
                        const SizedBox(height: 18),
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

    return ClipRRect(
      borderRadius: cardRadius,
      child: SizedBox(
        width: 40,
        height: 40,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _ActiveFundThumbnailPlaceholder(colors: colors),
              )
            : _ActiveFundThumbnailPlaceholder(colors: colors),
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
      child: Icon(
        Icons.apartment_rounded,
        size: 20,
        color: colors.highlightGold,
      ),
    );
  }
}

class _ActiveFundProgressBar extends StatelessWidget {
  const _ActiveFundProgressBar({
    required this.value,
    required this.activeColor,
    required this.trackColor,
  });

  final double value;
  final Color activeColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 3,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(decoration: BoxDecoration(color: trackColor)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(color: activeColor),
              ),
            ),
          ],
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
