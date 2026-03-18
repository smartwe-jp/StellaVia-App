import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/wallet_providers.dart';

class DepositPage extends ConsumerWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );

    final asyncData = ref.watch(walletDepositPageViewDataProvider);
    final isApplyingBankAccount = ref.watch(walletBankAccountApplyingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavigationBar(
        title: l10n.walletDepositTitle,
        height: 52,
        foregroundColor: AppColorTokens.fundexText,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColorTokens.fundexBorder),
          ),
        ),
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColorTokens.fundexText,
        ),
      ),
      body: asyncData.when(
        data: (data) {
          final bankInfo = data.bankInfo;
          final historyEntries = data.recentHistory
              .map(
                (item) => FundWalletBalanceEntry(
                  label:
                      '${_formatDateText(item.tradeTime ?? item.createTime)} · ${item.tradeType ?? item.typeName ?? l10n.walletHistoryUnknownType}',
                  value: _formatAmountText(
                    amount: item.amount ?? item.money,
                    isIncome: _parseInflowFlag(item.inOut),
                    formatter: currency,
                  ),
                  valueColor: _resolveAmountColor(_parseInflowFlag(item.inOut)),
                ),
              )
              .toList(growable: false);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: <Widget>[
              if (bankInfo == null)
                FundWalletBankAccountApplyCard(
                  title: '🏦 ${l10n.walletDedicatedAccountTitle}',
                  description: l10n.walletBankAccountMissingDescription,
                  actionLabel: l10n.walletBankAccountApplyAction,
                  isApplying: isApplyingBankAccount,
                  onTapAction: isApplyingBankAccount
                      ? null
                      : () async {
                          ref
                                  .read(
                                    walletBankAccountApplyingProvider.notifier,
                                  )
                                  .state =
                              true;
                          try {
                            await ref
                                .read(applyWalletBankAccountUseCaseProvider)
                                .call();
                            ref.invalidate(walletDepositPageViewDataProvider);
                            if (context.mounted) {
                              AppNotice.show(
                                context,
                                message: l10n.walletBankAccountApplySuccess,
                              );
                            }
                          } catch (_) {
                            if (context.mounted) {
                              AppNotice.show(
                                context,
                                message: l10n.walletBankAccountApplyFailure,
                              );
                            }
                          } finally {
                            ref
                                    .read(
                                      walletBankAccountApplyingProvider
                                          .notifier,
                                    )
                                    .state =
                                false;
                          }
                        },
                )
              else
                FundDedicatedDepositAccountCard(
                  title: '🏦 ${l10n.walletDedicatedAccountTitle}',
                  bankNameLabel: l10n.walletBankNameLabel,
                  bankNameValue: bankInfo.bankName,
                  branchNameLabel: l10n.walletBranchNameLabel,
                  branchNameValue: bankInfo.branchName,
                  accountTypeLabel: l10n.walletAccountTypeLabel,
                  accountTypeValue: bankInfo.accountType,
                  accountNumberLabel: l10n.walletAccountNumberLabel,
                  accountNumberValue: bankInfo.accountNumber,
                  accountNumberCopyLabel: l10n.lotteryApplyCopyAction,
                  onTapCopyAccountNumber: () async {
                    await Clipboard.setData(
                      ClipboardData(text: bankInfo.accountNumber),
                    );
                    if (context.mounted) {
                      AppNotice.show(
                        context,
                        message: l10n.lotteryApplyCopyDoneToast,
                      );
                    }
                  },
                  accountHolderLabel: l10n.walletAccountHolderLabel,
                  accountHolderValue: bankInfo.accountHolder,
                  helperMessage: l10n.walletDedicatedAccountDescription,
                  expirationMessage: _buildExpirationMessage(
                    l10n,
                    bankInfo.expireTime,
                  ),
                ),
              const SizedBox(height: 20),
              FundWalletStandbyBalanceCard(
                title: '📋 ${l10n.walletStandbyBalanceLabel}',
                actionLabel: l10n.walletHistoryMoreAction,
                onTapAction: () => context.push('/profile/wallet/history'),
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
              const SizedBox(height: 20),
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

String _formatAmountText({
  required num? amount,
  required bool? isIncome,
  required NumberFormat formatter,
}) {
  if (amount == null) {
    return '--';
  }
  final sign = isIncome == null ? '' : (isIncome ? '+' : '-');
  return '$sign${formatter.format(amount.abs())}';
}

Color _resolveAmountColor(bool? isIncome) {
  if (isIncome == null) {
    return AppColorTokens.fundexTextSecondary;
  }
  return isIncome ? AppColorTokens.fundexSuccess : AppColorTokens.fundexDanger;
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

String? _buildExpirationMessage(AppLocalizations l10n, String? expireTime) {
  if (expireTime == null || expireTime.trim().isEmpty) {
    return null;
  }
  final formatted = _formatDateText(expireTime);
  return l10n.walletBankAccountExpireNotice(formatted);
}
