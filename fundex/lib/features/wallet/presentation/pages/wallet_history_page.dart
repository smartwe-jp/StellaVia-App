import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/wallet_account_history.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_history_view_support.dart';
import '../widgets/wallet_history_list_item.dart';

class WalletHistoryPage extends ConsumerStatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  ConsumerState<WalletHistoryPage> createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends ConsumerState<WalletHistoryPage> {
  _WalletHistoryFilter _filter = _WalletHistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );

    final asyncHistory = ref.watch(walletHistoryProvider);

    return AppRootRouteRefreshScope(
      onRefresh: (WidgetRef ref) async {
        ref.invalidate(walletHistoryProvider);
        await ref.refresh(walletHistoryProvider.future).then((_) {});
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppNavigationBar(
          title: l10n.walletTransactionHistoryTitle,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),
        body: asyncHistory.when(
          data: (items) {
            final filteredItems = items
                .where((WalletAccountHistory item) {
                  switch (_filter) {
                    case _WalletHistoryFilter.all:
                      return true;
                    case _WalletHistoryFilter.deposit:
                      return parseWalletHistoryInflowFlag(item.inOut) == true;
                    case _WalletHistoryFilter.withdraw:
                      return parseWalletHistoryInflowFlag(item.inOut) == false;
                  }
                })
                .toList(growable: false);

            return Column(
              children: <Widget>[
                AppFilterBar<_WalletHistoryFilter>(
                  height: 60,
                  showBottomDivider: true,
                  backgroundColor: colors.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  value: _filter,
                  onChanged: (_WalletHistoryFilter value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                  items: <AppFilterBarItem<_WalletHistoryFilter>>[
                    AppFilterBarItem<_WalletHistoryFilter>(
                      value: _WalletHistoryFilter.all,
                      label: l10n.walletHistoryFilterAll,
                    ),
                    AppFilterBarItem<_WalletHistoryFilter>(
                      value: _WalletHistoryFilter.deposit,
                      label: l10n.walletHistoryFilterDeposit,
                    ),
                    AppFilterBarItem<_WalletHistoryFilter>(
                      value: _WalletHistoryFilter.withdraw,
                      label: l10n.walletHistoryFilterWithdraw,
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: <Widget>[
                      if (filteredItems.isEmpty)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colors.border),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 24,
                            ),
                            child: Text(
                              l10n.walletHistoryEmpty,
                              textAlign: TextAlign.center,
                              style: appText.bodyMuted.copyWith(height: 1.6),
                            ),
                          ),
                        )
                      else
                        for (
                          var index = 0;
                          index < filteredItems.length;
                          index++
                        ) ...<Widget>[
                          _buildHistoryCard(
                            context,
                            filteredItems[index],
                            l10n: l10n,
                            formatter: currency,
                          ),
                          if (index < filteredItems.length - 1)
                            const SizedBox(height: 12),
                        ],
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: TextButton(
              onPressed: () => ref.invalidate(walletHistoryProvider),
              child: Text(l10n.fundListRetry),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    WalletAccountHistory item, {
    required AppLocalizations l10n,
    required NumberFormat formatter,
  }) {
    return WalletHistoryListItem(
      title: resolveWalletHistoryDisplayTitle(l10n, item),
      dateText: formatWalletHistoryDateText(item.tradeTime ?? item.createTime),
      amountText: formatWalletHistoryAmountText(
        item: item,
        formatter: formatter,
      ),
      amountColor: resolveWalletHistoryAmountColor(context, item),
      indicatorColor: resolveWalletHistoryIndicatorColor(context, item),
    );
  }
}

enum _WalletHistoryFilter { all, deposit, withdraw }
