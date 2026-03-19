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
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.walletWithdrawHistoryPageTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: asyncRecords.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Text(
                l10n.walletWithdrawRecordEmpty,
                style: appText.bodyMuted,
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
