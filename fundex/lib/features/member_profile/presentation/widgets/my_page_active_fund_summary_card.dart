import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class MyPageActiveFundSummaryCardData {
  const MyPageActiveFundSummaryCardData({
    required this.title,
    required this.periodText,
    required this.investorCode,
    required this.investorType,
    required this.returnText,
    required this.accumulatedEarningsLabel,
    required this.accumulatedEarningsValue,
    required this.statusLabel,
    required this.statusBackgroundColor,
    required this.statusForegroundColor,
    this.progress,
    this.imageUrls = const <String>[],
    this.onTap,
  });

  final String title;
  final String periodText;
  final String investorCode;
  final String investorType;
  final String returnText;
  final String accumulatedEarningsLabel;
  final String accumulatedEarningsValue;
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
              height: 172,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      width: 72,
                      child: Column(
                        children: <Widget>[
                          _ActiveFundThumbnail(imageUrls: data.imageUrls),
                          const SizedBox(height: 12),
                          _ActiveFundStatusBadge(
                            label: data.statusLabel,
                            backgroundColor: data.statusBackgroundColor,
                            foregroundColor: data.statusForegroundColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
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
                          const Spacer(),
                          _ActiveFundMiddlePanel(
                            investorCode: data.investorCode,
                            returnText: data.returnText,
                            accumulatedEarningsLabel:
                                data.accumulatedEarningsLabel,
                            accumulatedEarningsValue:
                                data.accumulatedEarningsValue,
                          ),
                          const SizedBox(height: 4),
                          Text(
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

class _ActiveFundMiddlePanel extends StatelessWidget {
  const _ActiveFundMiddlePanel({
    required this.investorCode,
    required this.returnText,
    required this.accumulatedEarningsLabel,
    required this.accumulatedEarningsValue,
  });

  final String investorCode;
  final String returnText;
  final String accumulatedEarningsLabel;
  final String accumulatedEarningsValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  investorCode,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appText.micro.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              Text(
                  returnText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: appText.micro.copyWith(
                    color: colors.highlightGold,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              
            ],
          ),
          const SizedBox(height: 5),
          _AccumulatedEarningsPill(
            label: accumulatedEarningsLabel,
            value: accumulatedEarningsValue,
          ),
        ],
      ),
    );
  }
}

class _AccumulatedEarningsPill extends StatelessWidget {
  const _AccumulatedEarningsPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colors.highlightGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appText.micro.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: appText.caption.copyWith(
              color: colors.highlightGold,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
    const size = 64.0;

    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: cardRadius,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? DecoratedBox(
                decoration: BoxDecoration(color: colors.primary),
                child: AppRemoteImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: _ActiveFundThumbnailPlaceholder(colors: colors),
                ),
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
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: appText.micro.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
