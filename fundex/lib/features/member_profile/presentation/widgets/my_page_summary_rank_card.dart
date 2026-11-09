import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../../host_miles/presentation/support/host_miles_rank_theme.dart';
import '../support/mypage_rank_display.dart';

class MyPageSummaryRankCard extends StatelessWidget {
  const MyPageSummaryRankCard({
    super.key,
    required this.tier,
    required this.account,
    required this.onRankTap,
    required this.onExpiryTap,
    this.management = false,
    this.cumulativeMiles,
    this.expiringMiles,
  });
  final HostMilesTier? tier;
  final HostMilesAccount? account;
  final VoidCallback onRankTap, onExpiryTap;
  final bool management;
  final num? cumulativeMiles, expiringMiles;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rank = MyPageRankDisplay.name(tier);
    final palette = HostMilesRankTheme.of(rank);
    final ink = palette.headerInk;
    final displayedRank = management && palette != HostMilesRankTheme.unknown
        ? palette.name.toUpperCase()
        : rank;
    final colors = context.appColors;
    final text = context.appTextTheme;
    return AppCard(
      backgroundColor: palette.header,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.homeRankLabel, style: text.caption.copyWith(color: ink)),
          const SizedBox(height: 8),
          Text(
            displayedRank,
            style: text.numericTitle.copyWith(
              fontSize: 28,
              height: 1,
              letterSpacing: 1.12,
              fontWeight: FontWeight.w500,
              color: ink,
            ),
          ),
          const SizedBox(height: 24),
          _RankRow(
            label: l.myPageRankRate,
            value: management
                ? MyPageRankDisplay.managementRate(tier?.pointRate, locale)
                : MyPageRankDisplay.rate(tier?.pointRate, locale),
            unit: '%',
            ink: ink,
          ),
          const SizedBox(height: 24),
          if (management) ...[
            _RankRow(
              label: l.manageTierCumulativeMiles,
              value: MyPageRankDisplay.number(cumulativeMiles, locale),
              unit: l.myPageChartMileUnit,
              ink: ink,
            ),
            const SizedBox(height: 12),
          ],
          _RankRow(
            label: l.homeRankRoomsLabel,
            value: MyPageRankDisplay.number(tier?.maxRooms, locale),
            unit: l.myPageRankRoomUnit,
            ink: ink,
          ),
          const SizedBox(height: 6),
          _RankRow(
            label: l.myPageRankBooked,
            value: MyPageRankDisplay.number(tier?.currentBookingRooms, locale),
            unit: l.myPageRankRoomUnit,
            ink: ink,
          ),
          if (management) ...[
            const SizedBox(height: 8),
            Text(l.manageTierRoomsHint, style: text.meta.copyWith(color: ink)),
          ],
          const SizedBox(height: 20),
          AppCard(
            backgroundColor: colors.background,
            variant: AppCardVariant.filled,
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            onTap: onExpiryTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 33),
              child: Row(
                children: [
                  Expanded(
                    child: _RankRow(
                      label: l.myPageRankExpiring,
                      value: MyPageRankDisplay.number(
                        management
                            ? expiringMiles
                            : account?.expiringSoonPoints,
                        locale,
                      ),
                      unit: l.myPageChartMileUnit,
                      ink: colors.textPrimary,
                      compact: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colors.infoForeground,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            backgroundColor: colors.background,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  MyPageRankDisplay.isMax(tier)
                      ? l.myPageRankMax
                      : l.myPageNextRankTitle,
                  style: text.caption.copyWith(color: colors.textSecondary),
                ),
                if (management && MyPageRankDisplay.isMax(tier)) ...[
                  const SizedBox(height: 8),
                  AppProgressBar(value: 1, color: palette.marker, height: 6),
                ],
                if (!MyPageRankDisplay.isMax(tier)) ...[
                  const SizedBox(height: 8),
                  _RankRow(
                    label: l.myPageNextRankBalance,
                    value: MyPageRankDisplay.number(tier?.nextTierGap, locale),
                    unit: l.myPageChartYenUnit,
                    ink: colors.textPrimary,
                    compact: true,
                  ),
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onRankTap,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.primaryAlt,
                      minimumSize: const Size(0, 32),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            l.myPageRankAbout,
                            style: text.caption.copyWith(
                              color: colors.primaryAlt,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          'assets/images/mypage-rank-chevron.svg',
                          width: 4,
                          height: 8,
                          colorFilter: ColorFilter.mode(
                            colors.primaryAlt,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
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

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.ink,
    this.compact = false,
  });
  final String label, value, unit;
  final Color ink;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final text = context.appTextTheme;
    final caption = text.caption.copyWith(
      color: ink,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: caption)),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: value,
              children: [TextSpan(text: ' $unit', style: caption)],
            ),
            textAlign: TextAlign.end,
            style: text.numericBody.copyWith(
              color: ink,
              fontSize: compact ? 16 : 20,
              height: 1.1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
