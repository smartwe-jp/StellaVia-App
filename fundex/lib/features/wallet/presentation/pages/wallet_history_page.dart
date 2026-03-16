import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/wallet_providers.dart';

class WalletHistoryPage extends ConsumerWidget {
  const WalletHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.compactCurrency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 1,
    );

    final asyncHistory = ref.watch(walletHistoryProvider);

    return Scaffold(
      backgroundColor: AppColorTokens.fundexBackground,
      appBar: AppNavigationBar(
        title: l10n.walletHistoryTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: asyncHistory.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                l10n.walletHistoryEmpty,
                style: const TextStyle(
                  color: AppColorTokens.fundexTextSecondary,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final amount = item.money ?? 0;
              final isPositive = amount >= 0;
              final signedValue = isPositive
                  ? '+${currency.format(amount)}'
                  : '-${currency.format(amount.abs())}';
              return FundWalletHistoryListItem(
                title: item.typeName ?? l10n.walletHistoryUnknownType,
                subtitle: item.createTime ?? '--',
                amount: signedValue,
                isPositive: isPositive,
              );
            },
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
    );
  }
}
