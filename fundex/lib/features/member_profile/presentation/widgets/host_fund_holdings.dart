import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/host_fund_management_providers.dart';
import '../support/host_fund_management.dart';
import 'host_fund_content.dart';
import 'my_page_balance_ring.dart';

class HostFundHoldings extends ConsumerWidget {
  const HostFundHoldings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n,
        locale = Localizations.localeOf(context).toLanguageTag();
    return HostFundContent(
      state: ref.watch(hostFundHoldingsProvider),
      retry: () => ref.invalidate(hostFundHoldingsProvider),
      builder: (data) {
        final items = data.investList;
        if (items.isEmpty) return const SizedBox.shrink();
        final total = data.investTotal == null || data.investTotal == 0
            ? items.fold(0, (n, i) => n + (i.investMoneyValid ?? 0))
            : data.investTotal;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.myPageChartOperating,
                style: context.appTextTheme.sectionTitle,
              ),
              MyPageBalanceRing(
                key: ObjectKey(data),
                value: fundMoney(total, locale),
                unit: l.myPageChartYenUnit,
                label: l.hostManageFundExpectTotal,
                holdings: items,
              ),
            ],
          ),
        );
      },
    );
  }
}
