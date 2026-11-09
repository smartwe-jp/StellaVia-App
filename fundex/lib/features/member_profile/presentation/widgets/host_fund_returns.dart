import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../asset_statistics/domain/entities/asset_statistics_models.dart';
import '../providers/host_fund_management_providers.dart';
import '../support/host_fund_management.dart';
import 'host_fund_content.dart';
import 'host_fund_return_chart.dart';

class HostFundReturns extends ConsumerWidget {
  const HostFundReturns({
    super.key,
    required this.forecast,
    required this.years,
    required this.onYearsChanged,
  });
  final bool forecast;
  final int years;
  final ValueChanged<int> onYearsChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final forecastProvider = hostFundForecastProvider(years);
    final dividends = hostFundDividendsProvider(years);
    final futureLabels = [
      l.hostManageFundExpectRange1y,
      l.hostManageFundExpectRange3y,
      l.hostManageFundExpectRange5y,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: AppDropdownSelector<int>(
            tooltip: l.myPageChartRange,
            value: years,
            onChanged: onYearsChanged,
            options: [
              for (final (i, y) in [1, 3, 5].indexed)
                AppDropdownOption(
                  value: y,
                  label: forecast ? futureLabels[i] : l.myPageChartYears(y),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (forecast)
          HostFundContent(
            state: ref.watch(forecastProvider),
            retry: () => ref.invalidate(forecastProvider),
            builder: (months) => _Forecast(months),
          )
        else
          HostFundContent(
            state: ref.watch(dividends),
            retry: () => ref.invalidate(dividends),
            builder: (data) => _Dividends(data.chart, data.years),
          ),
      ],
    );
  }
}

class _Forecast extends StatelessWidget {
  const _Forecast(this.months);
  final List<FundForecastMonth> months;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        locale = Localizations.localeOf(context).toLanguageTag();
    final labels = months
        .map((m) => DateFormat('yyyy.MM').format(m.month))
        .toList();
    String yen(int amount) =>
        '${fundMoney(amount, locale)} ${l.myPageChartYenUnit}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        for (final (i, m) in months.take(2).indexed)
          FundMyPageProjectCard(
            title:
                '${labels[i]}（${i == 0 ? l.hostManageFundThisMonth : l.hostManageFundNextMonth}）',
            accentColor: context.appColors.primary,
            rows: [
              FundLabeledValue(
                label: l.hostManageFundExpectTotal,
                value: yen(m.benefit + m.principal),
              ),
              FundLabeledValue(
                label: l.hostManageFundExpectPrincipal,
                value: yen(m.principal),
              ),
              FundLabeledValue(
                label: l.hostManageFundExpectBenefit,
                value: yen(m.benefit),
              ),
            ],
            footnote: i == 1 ? l.hostManageFundExpectDisclaimer : null,
          ),
        for (final principal in [false, true])
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Text(
                  principal
                      ? l.hostManageFundExpectPrincipal
                      : l.hostManageFundExpectBenefit,
                  style: context.appTextTheme.cardTitle,
                ),
                Text(
                  principal
                      ? l.hostManageFundExpectPrincipalUnit
                      : l.myPageChartDividendUnit,
                  style: context.appTextTheme.caption,
                ),
                HostFundReturnChart(
                  key: ValueKey((principal, labels.length)),
                  labels: labels,
                  amounts: [
                    for (final m in months) principal ? m.principal : m.benefit,
                  ],
                  unitScale: principal ? 10000 : 1000,
                  color: principal
                      ? context.appColors.brandPrimaryBright
                      : context.appColors.brandPrimary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Dividends extends StatelessWidget {
  const _Dividends(this.chart, this.years);
  final AssetCumulativeBenefit chart;
  final List<AssetYearlyBenefit> years;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Text(
                l.myPageChartDividends,
                style: context.appTextTheme.cardTitle,
              ),
              Text(
                '${fundMoney(chart.total, locale)} ${l.myPageChartYenUnit}',
                style: context.appTextTheme.numericTitle,
              ),
              Text(
                l.myPageChartDividendUnit,
                style: context.appTextTheme.caption,
              ),
              HostFundReturnChart(
                key: ObjectKey(chart),
                labels: [
                  for (final d in chart.dates)
                    d.length >= 7 ? d.substring(0, 7).replaceAll('-', '.') : d,
                ],
                amounts: [
                  for (var i = 0; i < chart.dates.length; i++)
                    i < chart.values.length ? chart.values[i] : 0,
                ],
                area: true,
                unitScale: 1,
                color: context.appColors.brandPrimaryBright,
              ),
            ],
          ),
        ),
        AppCard(
          child: years.isEmpty
              ? Text(l.hostManageFundEmptyDividend)
              : Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Text(l.hostManageFundDividendDate),
                        Text(
                          l.hostManageFundDividendAmount,
                          textAlign: TextAlign.end,
                        ),
                        Tooltip(
                          message: l.hostManageFundDividendReceivedHint,
                          triggerMode: TooltipTriggerMode.tap,
                          child: Text(
                            '${l.hostManageFundDividendReceived} ⓘ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    for (final row in years)
                      TableRow(
                        children: [
                          for (final text in [
                            '${row.year}',
                            '${fundMoney(row.totalBenefit ?? 0, locale)} ${l.myPageChartYenUnit}',
                            '${fundMoney(row.actualBenefit ?? 0, locale)} ${l.myPageChartYenUnit}',
                          ].indexed)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                text.$2,
                                textAlign: text.$1 == 0
                                    ? TextAlign.start
                                    : TextAlign.end,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
