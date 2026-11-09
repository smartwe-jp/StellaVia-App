import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/mypage_membership_providers.dart';
import '../support/host_fund_management.dart';
import '../widgets/host_fund_applications.dart';
import '../widgets/host_fund_holdings.dart';
import '../widgets/host_fund_returns.dart';

class HostFundManagementPage extends ConsumerWidget {
  const HostFundManagementPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppNavigationBar(
      title: context.l10n.myPageShortcutFunds,
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.textPrimary,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        backgroundColor: context.appColors.surface,
        foregroundColor: context.appColors.textPrimary,
        onTap: () => context.pop(),
      ),
    ),
    body: SafeArea(
      top: false,
      child: _FundSections(
        key: ValueKey(ref.watch(myPageMembershipIdentityProvider)),
      ),
    ),
  );
}

class _FundSections extends StatefulWidget {
  const _FundSections({super.key});
  @override
  State<_FundSections> createState() => _FundSectionsState();
}

class _FundSectionsState extends State<_FundSections> {
  HostFundTab tab = HostFundTab.applying;
  final ranges = <HostFundTab, int>{};
  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppFilterBar<HostFundTab>(
        value: tab,
        height: 54,
        backgroundColor: context.appColors.surface,
        items: [
          for (final t in HostFundTab.values)
            AppFilterBarItem(value: t, label: t.label(context.l10n)),
        ],
        onChanged: (value) => setState(() => tab = value),
      ),
      Expanded(
        child: ListView(
          key: ValueKey(tab),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            switch (tab) {
              HostFundTab.applying ||
              HostFundTab.pending => HostFundApplications(
                key: ValueKey(tab),
                pending: tab == HostFundTab.pending,
              ),
              HostFundTab.running => const HostFundHoldings(),
              HostFundTab.forecast || HostFundTab.dividends => HostFundReturns(
                key: ValueKey(tab),
                forecast: tab == HostFundTab.forecast,
                years: ranges[tab] ?? 1,
                onYearsChanged: (value) => setState(() => ranges[tab] = value),
              ),
            },
          ],
        ),
      ),
    ],
  );
}
