import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_design_theme.dart';
import '../support/home_rank_content.dart';

class HomeRankDetailCard extends StatelessWidget {
  const HomeRankDetailCard({
    super.key,
    required this.rank,
    required this.index,
  });
  final HomeRankContent rank;
  final int index;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = context.appTextTheme;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: HomeDesignTheme.detailRankHeaders[index],
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.homeRankProvisionalLabel,
                  style: text.caption.copyWith(
                    color: context.appColors.onDark.withValues(alpha: .8),
                    fontSize: 11,
                    letterSpacing: 1.32,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rank.name,
                  style: text.numericTitle.copyWith(
                    color: context.appColors.onDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                _Metric(
                  label: l.homeRankInvestmentLabel,
                  value: rank.investmentRange,
                ),
                _GroupHeading(label: l.homeHostMiles),
                _Metric(
                  label: l.homeRankRateLabel,
                  value: rank.rate,
                  prominent: true,
                ),
                _Metric(
                  label: l.homeRankValidityLabel,
                  value: l.homeRankMonths(rank.validityMonths),
                ),
                _GroupHeading(label: l.homeRankBookingLabel),
                _Metric(
                  label: l.homeRankAdvanceLabel,
                  value: l.homeRankAdvanceMonths(rank.advanceMonths),
                ),
                _Metric(
                  label: l.homeRankRoomsLabel,
                  value: l.homeRankRooms(rank.rooms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.prominent = false,
  });
  final String label, value;
  final bool prominent;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: context.appTextTheme.caption.copyWith(fontSize: 12, height: 1.2),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: prominent
            ? context.appTextTheme.numericTitle.copyWith(
                fontSize: 32,
                height: 1,
                fontWeight: FontWeight.w700,
              )
            : context.appTextTheme.bodyStrong.copyWith(
                fontSize: 14,
                height: 1.2,
              ),
      ),
    ],
  );
}

class _GroupHeading extends StatelessWidget {
  const _GroupHeading({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: context.appColors.textPrimary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: context.appTextTheme.bodyStrong.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Divider(height: 1, color: context.appColors.border),
      ],
    ),
  );
}
