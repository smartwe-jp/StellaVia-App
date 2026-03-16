import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/wallet_providers.dart';

class DepositPage extends ConsumerWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.compactCurrency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 1,
    );

    final asyncData = ref.watch(walletDepositPageViewDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavigationBar(
        title: l10n.walletDepositTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: asyncData.when(
        data: (data) {
          final historyEntries = data.recentHistory
              .map(
                (item) => FundWalletBalanceEntry(
                  label: _formatDateText(item.createTime),
                  value:
                      '${_formatMoneyValue(item.money, currency)} ${l10n.walletAutoReflectedSuffix}',
                  valueColor: AppColorTokens.fundexSuccess,
                ),
              )
              .toList(growable: false);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              FundDedicatedDepositAccountCard(
                title: '🏦 ${l10n.walletDedicatedAccountTitle}',
                bankNameLabel: l10n.walletBankNameLabel,
                bankNameValue: data.bankInfo.bankName,
                branchNameLabel: l10n.walletBranchNameLabel,
                branchNameValue: data.bankInfo.branchName,
                accountTypeLabel: l10n.walletAccountTypeLabel,
                accountTypeValue: data.bankInfo.accountType,
                accountNumberLabel: l10n.walletAccountNumberLabel,
                accountNumberValue: data.bankInfo.accountNumber,
                accountNumberCopyLabel: l10n.lotteryApplyCopyAction,
                onTapCopyAccountNumber: () async {
                  await Clipboard.setData(
                    ClipboardData(text: data.bankInfo.accountNumber),
                  );
                  if (context.mounted) {
                    AppNotice.show(
                      context,
                      message: l10n.lotteryApplyCopyDoneToast,
                    );
                  }
                },
                accountHolderLabel: l10n.walletAccountHolderLabel,
                accountHolderValue: data.bankInfo.accountHolder,
                helperMessage: l10n.walletDedicatedAccountDescription,
              ),
              const SizedBox(height: 20),
              FundWalletStandbyBalanceCard(
                title: '📋 ${l10n.walletStandbyBalanceLabel}',
                entries: historyEntries.isEmpty
                    ? <FundWalletBalanceEntry>[
                        const FundWalletBalanceEntry(
                          label: '--',
                          value: '--',
                          valueColor: AppColorTokens.fundexTextSecondary,
                        ),
                      ]
                    : historyEntries,
              ),
              const SizedBox(height: 12),
              FundWalletStandbyBalanceSummaryBox(
                label: l10n.walletStandbyBalanceLabel,
                value: currency.format(data.standbyBalance ?? 0),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            l10n.walletDataLoadError,
            style: const TextStyle(color: AppColorTokens.fundexTextSecondary),
          ),
        ),
      ),
    );
  }
}

String _formatMoneyValue(num? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return formatter.format(amount);
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
