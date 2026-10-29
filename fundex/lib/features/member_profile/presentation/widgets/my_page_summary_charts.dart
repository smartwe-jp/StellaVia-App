import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/mypage_chart_providers.dart';
import '../support/mypage_chart_display.dart';
import 'my_page_summary_chart_plot.dart';

class MyPageSummaryCharts extends StatelessWidget {
  const MyPageSummaryCharts({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.myPageChartAssets,
          style: context.appTextTheme.sectionTitle,
        ),
        const SizedBox(height: 12),
        for (final kind in MyPageChartKind.values)
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
    final value = MyPageChartDisplay.amount(
      data?.total,
      Localizations.localeOf(context).toLanguageTag(),
    );
    final unit = kind == MyPageChartKind.miles
        ? l.myPageChartMileUnit
        : l.myPageChartYenUnit;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      borderColor: context.appColors.borderSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: MyPageChartStyles.title(context)),
              ),
              PopupMenuButton<int>(
                tooltip: l.myPageChartRange,
                initialValue: state.years,
                onSelected: controller.selectYears,
                itemBuilder: (c) => [
                  for (final y in [1, 3, 5])
                    PopupMenuItem(value: y, child: Text(l.myPageChartYears(y))),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.myPageChartYears(state.years),
                        style: MyPageChartStyles.range(context),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/images/mypage-chart-chevron.svg',
                        width: 8,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          context.appColors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Semantics(
            label: '$title $value $unit',
            excludeSemantics: true,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                Text(value, style: MyPageChartStyles.amount(context)),
                Text(unit, style: MyPageChartStyles.unit(context)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (state.data.isLoading && data == null)
            const SizedBox(
              height: 88,
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (data == null || data.points.isEmpty)
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
          else
            MyPageSummaryChartPlot(
              data: data,
              years: state.years,
              bars: kind == MyPageChartKind.dividends,
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
