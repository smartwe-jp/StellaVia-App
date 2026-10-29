import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../support/mypage_rank_display.dart';
import '../support/mypage_rank_theme.dart';

class MyPageMembershipRooms extends StatelessWidget {
  const MyPageMembershipRooms({
    super.key,
    required this.tier,
    required this.account,
    required this.onExpiryTap,
  });
  final HostMilesTier? tier;
  final HostMilesAccount? account;
  final VoidCallback onExpiryTap;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return AppCard(
      padding: EdgeInsets.zero,
      borderColor: context.appColors.borderSoft,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 10,
              child: _Item(
                label: l.homeRankRoomsLabel,
                value: MyPageRankDisplay.number(tier?.maxRooms, locale),
                unit: l.myPageRankRoomUnit,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.appColors.borderSoft,
            ),
            Expanded(
              flex: 10,
              child: _Item(
                label: l.myPageRankBooked,
                value: MyPageRankDisplay.number(
                  tier?.currentBookingRooms,
                  locale,
                ),
                unit: l.myPageRankRoomUnit,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.appColors.borderSoft,
            ),
            Expanded(
              flex: 12,
              child: _Item(
                label: l.myPageRankExpiring,
                value: MyPageRankDisplay.number(
                  account?.expiringSoonPoints,
                  locale,
                ),
                unit: l.myPageChartMileUnit,
                accent: true,
                onTap: onExpiryTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.value,
    required this.unit,
    this.accent = false,
    this.onTap,
  });
  final String label, value, unit;
  final bool accent;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: accent ? context.appColors.primarySubtle : context.appColors.surface,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: MyPageRankTheme.small(context).copyWith(
                color: accent
                    ? context.appColors.primary
                    : context.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 2,
                    children: [
                      Text(
                        value,
                        style: MyPageRankTheme.room(context).copyWith(
                          color: accent
                              ? context.appColors.primary
                              : context.appColors.textPrimary,
                        ),
                      ),
                      Text(
                        unit,
                        style: MyPageRankTheme.small(context).copyWith(
                          color: accent
                              ? context.appColors.primary
                              : context.appColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (accent) ...[
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/images/mypage-expiry-chevron.svg',
                    width: 8,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      context.appColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
