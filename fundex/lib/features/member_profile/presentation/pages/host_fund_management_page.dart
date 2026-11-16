import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/host_fund_management_providers.dart';
import '../providers/mypage_membership_providers.dart';
import '../support/host_fund_management.dart';
import '../widgets/host_fund_applications.dart';
import '../widgets/host_fund_holdings.dart';
import '../widgets/host_fund_returns.dart';
import 'my_page_section_list_page.dart';

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

class _FundSections extends ConsumerStatefulWidget {
  const _FundSections({super.key});
  @override
  ConsumerState<_FundSections> createState() => _FundSectionsState();
}

class _FundSectionsState extends ConsumerState<_FundSections> {
  Future<void> refreshHoldings(HostFundTab selected) async {
    try {
      final request = ref.refresh(hostFundHoldingsProvider(selected).future);
      await request;
    } catch (_) {
      // HostFundHoldings displays the provider error and retry action.
    }
  }

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
        child: tab == HostFundTab.running
            ? MyPageSectionListPage.operating(
                header: HostFundHoldings(tab: tab),
                onRefreshHeader: () => refreshHoldings(HostFundTab.running),
              )
            : tab == HostFundTab.beforeOperation
            ? RefreshIndicator(
                onRefresh: () => refreshHoldings(HostFundTab.beforeOperation),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [HostFundHoldings(tab: tab)],
                ),
              )
            : ListView(
                key: ValueKey(tab),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  if (tab == HostFundTab.applying || tab == HostFundTab.pending)
                    HostFundApplications(
                      key: ValueKey(tab),
                      pending: tab == HostFundTab.pending,
                    )
                  else
                    HostFundReturns(
                      key: ValueKey(tab),
                      forecast: tab == HostFundTab.forecast,
                      years: ranges[tab] ?? 1,
                      onYearsChanged: (value) =>
                          setState(() => ranges[tab] = value),
                    ),
                ],
              ),
      ),
    ],
  );
}
