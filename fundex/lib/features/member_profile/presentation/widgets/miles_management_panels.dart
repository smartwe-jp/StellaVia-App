import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/miles_management_providers.dart';
import '../support/mypage_chart_display.dart';
import 'my_page_summary_chart_plot.dart';

class MonthlyMilesCard extends ConsumerWidget {
  const MonthlyMilesCard({
    super.key,
    required this.month,
    required this.offset,
  });
  final DateTime month;
  final int offset;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateTime(month.year, month.month + offset);
    final provider = monthlyMilesProvider((month: date, expected: offset == 1));
    final value = ref.watch(provider);
    final l = context.l10n, ym = DateFormat('yyyy.MM').format(date);
    final label = switch (offset) {
      -1 => l.manageMilesPrevMonth(ym),
      0 => l.manageMilesThisMonth(ym),
      _ => l.manageMilesNextMonth(ym),
    };
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: context.appColors.background,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(label, style: context.appTextTheme.bodyStrong),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    offset == 1
                        ? l.manageMilesEarnedPlan
                        : l.manageMilesEarnedDone,
                    style: context.appTextTheme.caption,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: value.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => TextButton(
                        onPressed: () => ref.invalidate(provider),
                        child: Text(l.commonRetry),
                      ),
                      data: (amount) => Text(
                        '${MyPageChartDisplay.amount(amount, Localizations.localeOf(context).toLanguageTag())} ${l.myPageChartMileUnit}',
                        style: context.appTextTheme.numericBody,
                      ),
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

class CumulativeMilesCard extends StatelessWidget {
  const CumulativeMilesCard({
    super.key,
    required this.state,
    required this.total,
    required this.years,
    required this.onYears,
    required this.onRetry,
  });
  final AsyncValue<MyPageChartData> state;
  final num? total;
  final int years;
  final ValueChanged<int> onYears;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            children: [
              Text(
                l.manageMilesCumulative,
                style: MyPageChartStyles.title(context),
              ),
              Text.rich(
                TextSpan(
                  text: MyPageChartDisplay.amount(
                    total,
                    Localizations.localeOf(context).toLanguageTag(),
                  ),
                  children: [
                    TextSpan(
                      text: ' ${l.myPageChartMileUnit}',
                      style: context.appTextTheme.caption,
                    ),
                  ],
                ),
                style: MyPageChartStyles.amount(context),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppDropdownSelector<int>(
              tooltip: l.myPageChartRange,
              value: years,
              onChanged: onYears,
              options: [
                for (final y in [1, 3, 5])
                  AppDropdownOption(value: y, label: l.myPageChartYears(y)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          state.when(
            skipLoadingOnReload: false,
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (_, __) =>
                TextButton(onPressed: onRetry, child: Text(l.commonRetry)),
            data: (data) => data.points.isEmpty
                ? Text(l.myPageChartEmpty)
                : MyPageSummaryChartPlot(
                    key: ObjectKey(data),
                    data: data,
                    kind: MyPageChartKind.miles,
                    filledMiles: true,
                  ),
          ),
        ],
      ),
    );
  }
}
