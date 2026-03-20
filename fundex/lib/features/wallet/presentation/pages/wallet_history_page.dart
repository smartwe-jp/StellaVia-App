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
            final filteredItems = items
                .where((WalletAccountHistory item) {
                  switch (_filter) {
                    case _WalletHistoryFilter.all:
                      return true;
                    case _WalletHistoryFilter.deposit:
                      return _parseInflowFlag(item.inOut) == true;
                    case _WalletHistoryFilter.withdraw:
                      return _parseInflowFlag(item.inOut) == false;
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
                        ...filteredItems.map(
                          (WalletAccountHistory item) => _buildHistoryCard(
                            context,
                            item,
                            l10n: l10n,
                            colors: colors,
                            formatter: currency,
                          ),
                        ),
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
    required AppSemanticColorTheme colors,
    required NumberFormat formatter,
  }) {
    final isIncome = _parseInflowFlag(item.inOut);
    return FundWalletTransactionCard(
      title: _resolveHistoryTitle(l10n, isIncome: isIncome),
      subtitle: _resolveHistorySubtitle(
        item,
        fallback: l10n.walletHistoryUnknownType,
      ),
      dateText: _formatDateText(item.tradeTime ?? item.createTime),
      amountText: _formatAmountText(
        amount: item.amount ?? item.money,
        isIncome: isIncome,
        formatter: formatter,
      ),
      amountColor: _resolveHistoryAmountColor(
        isIncome: isIncome,
        colors: colors,
      ),
      icon: _resolveHistoryIcon(isIncome: isIncome),
      iconBackgroundColor: _resolveHistoryIconBackground(
        isIncome: isIncome,
        colors: colors,
      ),
      iconColor: _resolveHistoryIconColor(isIncome: isIncome, colors: colors),
    );
  }
}

enum _WalletHistoryFilter { all, deposit, withdraw }

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

String _resolveHistoryTitle(AppLocalizations l10n, {required bool? isIncome}) {
  if (isIncome == null) {
    return l10n.walletHistoryUnknownType;
  }
  return isIncome
      ? l10n.walletHistoryFilterDeposit
      : l10n.walletHistoryFilterWithdraw;
}

String _resolveHistorySubtitle(
  WalletAccountHistory item, {
  required String fallback,
}) {
  final candidates = <String?>[item.tradeType, item.typeName, item.remark];
  for (final candidate in candidates) {
    final text = candidate?.trim() ?? '';
    if (text.isNotEmpty) {
      return text;
    }
  }
  return fallback;
}

Color _resolveHistoryAmountColor({
  required bool? isIncome,
  required AppSemanticColorTheme colors,
}) {
  if (isIncome == null) {
    return colors.textSecondary;
  }
  return isIncome ? colors.success : colors.textPrimary;
}

IconData _resolveHistoryIcon({required bool? isIncome}) {
  if (isIncome == null) {
    return Icons.swap_horiz_rounded;
  }
  return isIncome ? Icons.attach_money_rounded : Icons.remove_rounded;
}

Color _resolveHistoryIconBackground({
  required bool? isIncome,
  required AppSemanticColorTheme colors,
}) {
  if (isIncome == null) {
    return colors.surfaceAlt;
  }
  return isIncome ? colors.successSubtle : colors.dangerSubtle;
}

Color _resolveHistoryIconColor({
  required bool? isIncome,
  required AppSemanticColorTheme colors,
}) {
  if (isIncome == null) {
    return colors.textSecondary;
  }
  return isIncome ? colors.success : colors.danger;
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
