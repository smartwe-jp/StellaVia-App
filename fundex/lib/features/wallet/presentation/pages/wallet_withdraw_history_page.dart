import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../domain/entities/wallet_withdraw_record.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_withdraw_record_list_item.dart';

class WalletWithdrawHistoryPage extends ConsumerStatefulWidget {
  const WalletWithdrawHistoryPage({super.key});

  @override
  ConsumerState<WalletWithdrawHistoryPage> createState() =>
      _WalletWithdrawHistoryPageState();
}

class _WalletWithdrawHistoryPageState
    extends ConsumerState<WalletWithdrawHistoryPage> {
  _WalletWithdrawHistoryFilter _filter = _WalletWithdrawHistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );

    final asyncRecords = ref.watch(walletWithdrawHistoryProvider);
    return AppRootRouteRefreshScope(
      onRefresh: (WidgetRef ref) async {
        ref.invalidate(walletWithdrawHistoryProvider);
        await ref.refresh(walletWithdrawHistoryProvider.future).then((_) {});
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppNavigationBar(
          title: l10n.walletWithdrawHistoryPageTitle,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),
        body: asyncRecords.when(
          data: (records) {
            final filteredRecords = records
                .where(
                  (WalletWithdrawRecord record) => switch (_filter) {
                    _WalletWithdrawHistoryFilter.all => true,
                    _WalletWithdrawHistoryFilter.status0 => record.status == 0,
                    _WalletWithdrawHistoryFilter.status1 => record.status == 1,
                    _WalletWithdrawHistoryFilter.status2 => record.status == 2,
                    _WalletWithdrawHistoryFilter.status3 => record.status == 3,
                    _WalletWithdrawHistoryFilter.status4 => record.status == 4,
                  },
                )
                .toList(growable: false);
            if (records.isEmpty) {
              return Center(
                child: Text(
                  l10n.walletWithdrawRecordEmpty,
                  style: appText.bodyMuted,
                ),
              );
            }

            return Column(
              children: <Widget>[
                AppFilterBar<_WalletWithdrawHistoryFilter>(
                  backgroundColor: colors.surface,
                  height: 56,
                  showBottomDivider: true,
                  value: _filter,
                  onChanged: (_WalletWithdrawHistoryFilter value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                  items: <AppFilterBarItem<_WalletWithdrawHistoryFilter>>[
                    AppFilterBarItem<_WalletWithdrawHistoryFilter>(
                      value: _WalletWithdrawHistoryFilter.all,
                      label: l10n.walletWithdrawHistoryFilterAll,
                    ),
                    AppFilterBarItem<_WalletWithdrawHistoryFilter>(
                      value: _WalletWithdrawHistoryFilter.status0,
                      label: l10n.walletWithdrawRecordStatusUnpaid,
                    ),
                    AppFilterBarItem<_WalletWithdrawHistoryFilter>(
                      value: _WalletWithdrawHistoryFilter.status1,
                      label: l10n.walletWithdrawRecordStatusPaid,
                    ),
                    AppFilterBarItem<_WalletWithdrawHistoryFilter>(
                      value: _WalletWithdrawHistoryFilter.status2,
                      label: l10n.walletWithdrawRecordStatusFailedUnconfirmed,
                    ),
                    AppFilterBarItem<_WalletWithdrawHistoryFilter>(
                      value: _WalletWithdrawHistoryFilter.status3,
                      label: l10n.walletWithdrawRecordStatusFailedConfirmed,
                    ),
                    AppFilterBarItem<_WalletWithdrawHistoryFilter>(
                      value: _WalletWithdrawHistoryFilter.status4,
                      label: l10n.walletWithdrawRecordStatusRevoked,
                    ),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(walletWithdrawHistoryProvider);
                      await ref.read(walletWithdrawHistoryProvider.future);
                    },
                    child: filteredRecords.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                            children: <Widget>[
                              Center(
                                child: Text(
                                  l10n.walletWithdrawRecordEmpty,
                                  style: appText.bodyMuted,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            itemBuilder: (BuildContext context, int index) {
                              final record = filteredRecords[index];
                              return WalletWithdrawRecordListItem(
                                record: record,
                                formatter: formatter,
                                showPaidTime: true,
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemCount: filteredRecords.length,
                          ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: TextButton(
              onPressed: () => ref.invalidate(walletWithdrawHistoryProvider),
              child: Text(l10n.fundListRetry),
            ),
          ),
        ),
      ),
    );
  }
}

enum _WalletWithdrawHistoryFilter {
  all,
  status0,
  status1,
  status2,
  status3,
  status4,
}
