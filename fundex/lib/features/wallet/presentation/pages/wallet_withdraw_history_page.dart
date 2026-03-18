import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_withdraw_record_list_item.dart';

class WalletWithdrawHistoryPage extends ConsumerWidget {
  const WalletWithdrawHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );

    final asyncRecords = ref.watch(walletWithdrawHistoryProvider);
    return Scaffold(
      backgroundColor: AppColorTokens.fundexBackground,
      appBar: AppNavigationBar(
        title: l10n.walletWithdrawHistoryPageTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: asyncRecords.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Text(
                l10n.walletWithdrawRecordEmpty,
                style: const TextStyle(
                  color: AppColorTokens.fundexTextSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(walletWithdrawHistoryProvider);
              await ref.read(walletWithdrawHistoryProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemBuilder: (BuildContext context, int index) {
                final record = records[index];
                return WalletWithdrawRecordListItem(
                  record: record,
                  formatter: formatter,
                  showPaidTime: true,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: records.length,
            ),
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
    );
  }
}
