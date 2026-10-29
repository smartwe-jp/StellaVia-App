import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../support/mypage_rank_display.dart';
import '../support/mypage_rank_theme.dart';

class MyPageMembershipCard extends StatelessWidget {
  const MyPageMembershipCard({
    super.key,
    required this.tier,
    required this.account,
    required this.onRankTap,
  });
  final HostMilesTier? tier;
  final HostMilesAccount? account;
  final VoidCallback onRankTap;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rank = MyPageRankDisplay.name(tier);
    final color = MyPageRankTheme.surface(context, rank);
    final progress = MyPageRankDisplay.progress(tier);
    return AppCard(
      variant: AppCardVariant.filled,
      backgroundColor: color,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.homeRankLabel,
                  style: MyPageRankTheme.label(context),
                ),
              ),
              InkWell(
                onTap: onRankTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.myPageRankAbout,
                        style: MyPageRankTheme.label(context),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        'assets/images/mypage-rank-chevron.svg',
                        width: 6,
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(rank, style: MyPageRankTheme.rank(context)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Metric(
                  label: l.myPageChartMiles,
                  value: MyPageRankDisplay.number(
                    account?.availablePoints,
                    locale,
                  ),
                  unit: l.myPageChartMileUnit,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  label: l.myPageRankRate,
                  value: MyPageRankDisplay.rate(tier?.pointRate, locale),
                  unit: '%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppCard(
            variant: AppCardVariant.filled,
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (MyPageRankDisplay.isMax(tier))
                  Text(l.myPageRankMax, style: context.appTextTheme.bodySemi)
                else
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          l.myPageRankGap,
                          style: MyPageRankTheme.gapLabel(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${MyPageRankDisplay.number(tier?.nextTierGap, locale)}${l.myPageChartYenUnit}',
                          textAlign: TextAlign.end,
                          style: MyPageRankTheme.gapValue(context),
                        ),
                      ),
                    ],
                  ),
                if (progress != null) ...[
                  const SizedBox(height: 8),
                  AppProgressBar(value: progress, color: color, height: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.unit});
  final String label, value, unit;
  @override
  Widget build(BuildContext context) => AppCard(
    variant: AppCardVariant.filled,
    backgroundColor: context.appColors.onDark.withValues(alpha: .14),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    borderRadius: BorderRadius.circular(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: MyPageRankTheme.label(context)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(value, style: MyPageRankTheme.metric(context)),
            Text(unit, style: MyPageRankTheme.label(context)),
          ],
        ),
      ],
    ),
  );
}
