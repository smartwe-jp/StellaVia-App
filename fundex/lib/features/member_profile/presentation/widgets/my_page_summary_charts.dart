import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../providers/mypage_membership_providers.dart';
import '../providers/mypage_providers.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/mypage_chart_providers.dart';
import '../support/mypage_chart_display.dart';
import 'my_page_summary_chart_plot.dart';
import 'my_page_balance_ring.dart';

class MyPageSummaryCharts extends StatelessWidget {
  const MyPageSummaryCharts({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final kind in const [
          MyPageChartKind.miles,
          MyPageChartKind.operating,
          MyPageChartKind.dividends,
          MyPageChartKind.available,
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MyPageSummaryChartCard(kind: kind),
          ),
      ],
    ),
  );
}

class MyPageSummaryChartCard extends ConsumerWidget {
  const MyPageSummaryChartCard({super.key, required this.kind});
  final MyPageChartKind kind;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPageChartProvider(kind));
    final controller = ref.read(myPageChartProvider(kind).notifier);
    final data = state.data.valueOrNull;
    final l = context.l10n;
    final title = MyPageChartDisplay.title(l, kind);
    final headerTotal = switch (kind) {
      MyPageChartKind.miles =>
        ref.watch(myPageTierProvider).asData?.value.pointsBalance ??
            data?.total,
      MyPageChartKind.operating =>
        data?.total ??
            ref
                .watch(myPageAccountStatisticProvider)
                .asData
                ?.value
                ?.crowdfundingTotal,
      MyPageChartKind.available =>
        ref
            .watch(myPageAccountStatisticProvider)
            .asData
            ?.value
            ?.firstLevelAccountTotal,
      MyPageChartKind.dividends => data?.total,
    };
    final value = MyPageChartDisplay.amount(
      headerTotal,
      Localizations.localeOf(context).toLanguageTag(),
    );
    final unit = kind == MyPageChartKind.miles
        ? l.myPageChartMileUnit
        : l.myPageChartYenUnit;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      borderColor: context.appColors.borderSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(title, style: MyPageChartStyles.title(context)),
              Semantics(
                label: '$title $value $unit',
                excludeSemantics: true,
                child: Text.rich(
                  TextSpan(
                    text: value,
                    children: [
                      TextSpan(
                        text: ' $unit',
                        style: MyPageChartStyles.unit(context),
                      ),
                    ],
                  ),
                  style: MyPageChartStyles.amount(context),
                ),
              ),
            ],
          ),
          if (kind == MyPageChartKind.miles)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/profile/miles-history'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.myPageMilesHistoryLink),
                    const Icon(Icons.chevron_right_rounded, size: 16),
                  ],
                ),
              ),
            ),
          if (kind == MyPageChartKind.available) ...[
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.push('/wallet/withdraw'),
                  child: Text(l.walletWithdrawTitle),
                ),
                TextButton(
                  onPressed: () => context.push('/wallet/history'),
                  child: Text(l.walletTransactionHistoryTitle),
                ),
              ],
            ),
            Text(l.myPageChartCashHint, style: context.appTextTheme.caption),
          ],
          if (kind == MyPageChartKind.dividends)
            Text(
              l.myPageChartDividendUnit,
              style: context.appTextTheme.caption,
            ),
          if (kind != MyPageChartKind.operating)
            Align(
              alignment: Alignment.centerRight,
              child: AppDropdownSelector<int>(
                tooltip: l.myPageChartRange,
                textStyle: MyPageChartStyles.range(context),
                icon: SizedBox(
                  width: 6,
                  height: 3,
                  child: OverflowBox(
                    maxWidth: 7,
                    maxHeight: 4,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: SvgPicture.asset(
                        'assets/images/mypage-range-chevron.svg',
                        width: 4,
                        height: 7,
                        colorFilter: ColorFilter.mode(
                          context.appColors.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                value: state.years,
                onChanged: controller.selectYears,
                options: [
                  for (final y in [1, 3, 5])
                    AppDropdownOption(value: y, label: l.myPageChartYears(y)),
                ],
              ),
            ),
          const SizedBox(height: 10),
          if (state.data.isLoading && data == null)
            const SizedBox(
              height: 88,
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (data == null ||
              (kind == MyPageChartKind.operating
                  ? data.holdings.isEmpty
                  : data.points.isEmpty))
            SizedBox(
              height: 88,
              child: Center(
                child: Text(
                  state.data.hasError
                      ? l.myPageChartLoadFailed
                      : l.myPageChartEmpty,
                  style: context.appTextTheme.caption,
                ),
              ),
            )
          else if (kind == MyPageChartKind.operating)
            MyPageBalanceRing(
              value: MyPageChartDisplay.amount(
                data.total ??
                    data.holdings.fold<int>(
                      0,
                      (total, h) => total + (h.investMoneyValid ?? 0),
                    ),
                Localizations.localeOf(context).toLanguageTag(),
              ),
              unit: unit,
              label: title,
              holdings: data.holdings,
              key: ObjectKey(data),
            )
          else
            MyPageSummaryChartPlot(
              data: data,
              key: ObjectKey(data),
              kind: kind,
            ),
          if (state.data.isLoading && data != null)
            const LinearProgressIndicator(minHeight: 2),
          if (state.data.hasError)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.myPageChartLoadFailed,
                    style: context.appTextTheme.caption,
                  ),
                ),
                TextButton(
                  onPressed: controller.refresh,
                  child: Text(l.commonRetry),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
