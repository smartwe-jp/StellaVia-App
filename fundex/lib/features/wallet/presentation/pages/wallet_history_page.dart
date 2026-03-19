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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.walletHistoryTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: asyncHistory.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(l10n.walletHistoryEmpty, style: appText.bodyMuted),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final amount = item.amount ?? item.money;
              final inOut = item.inOut;
              final isIncome = _parseInflowFlag(inOut);
              final isPending = _isPending(item.businessId);
              return FundWalletTransactionCard(
                tradeType:
                    item.tradeType ??
                    item.typeName ??
                    l10n.walletHistoryUnknownType,
                remark: item.remark ?? '--',
                tradeTime: _formatDateText(item.tradeTime ?? item.createTime),
                amountText: _formatAmountText(
                  amount: amount,
                  isIncome: isIncome,
                  formatter: currency,
                ),
                amountColor: _resolveAmountColor(
                  isIncome: isIncome,
                  colors: colors,
                ),
                directionLabel: _resolveDirectionLabel(
                  isIncome: isIncome,
                  inflowLabel: l10n.walletHistoryInflowLabel,
                  outflowLabel: l10n.walletHistoryOutflowLabel,
                ),
                isPending: isPending,
                pendingLabel: l10n.walletHistoryPendingStatus,
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

bool? _parseInflowFlag(String? inOut) {
  final value = inOut?.trim();
  if (value == null || value.isEmpty) {
    return null;
  }
  final normalized = value.toLowerCase();
  if (value == '收' ||
      value == '収' ||
      normalized == 'in' ||
      normalized == 'income') {
    return true;
  }
  if (value == '支' ||
      value == '出' ||
      normalized == 'out' ||
      normalized == 'expense') {
    return false;
  }
  return null;
}

bool _isPending(String? businessId) {
  return businessId == null || businessId.trim().isEmpty;
}

Color _resolveAmountColor({
  required bool? isIncome,
  required AppSemanticColorTheme colors,
}) {
  if (isIncome == null) {
    return colors.textSecondary;
  }
  return isIncome ? colors.success : colors.danger;
}

String _formatAmountText({
  required num? amount,
  required bool? isIncome,
  required NumberFormat formatter,
}) {
  if (amount == null) {
    return '--';
  }
  final value = amount.abs();
  final sign = isIncome == null ? '' : (isIncome ? '+' : '-');
  return '$sign${formatter.format(value)}';
}

String _resolveDirectionLabel({
  required bool? isIncome,
  required String inflowLabel,
  required String outflowLabel,
}) {
  if (isIncome == null) {
    return '--';
  }
  return isIncome ? inflowLabel : outflowLabel;
}

String _formatDateText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '--';
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return value;
  }
  final y = parsed.year.toString().padLeft(4, '0');
  final m = parsed.month.toString().padLeft(2, '0');
  final d = parsed.day.toString().padLeft(2, '0');
  return '$y/$m/$d';
}
