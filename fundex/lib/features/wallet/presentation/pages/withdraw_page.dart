import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../domain/entities/wallet_bank_account_info.dart';
import '../../domain/entities/wallet_withdraw_apply_draft.dart';
import '../providers/wallet_providers.dart';

class WithdrawPage extends ConsumerStatefulWidget {
  const WithdrawPage({super.key});

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  late final TextEditingController _amountController;
  WalletBankAccountInfo? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  WalletBankAccountInfo? _resolveSelectedAccount(
    List<WalletBankAccountInfo> accounts,
  ) {
    if (accounts.isEmpty) {
      return null;
    }
    if (_selectedAccount == null) {
      return accounts.first;
    }
    for (final account in accounts) {
      if (_isSameAccount(account, _selectedAccount!)) {
        return account;
      }
    }
    return accounts.first;
  }

  bool _isSameAccount(WalletBankAccountInfo lhs, WalletBankAccountInfo rhs) {
    if (lhs.id != null && rhs.id != null) {
      return lhs.id == rhs.id;
    }
    return lhs.bankName == rhs.bankName &&
        lhs.branchName == rhs.branchName &&
        lhs.accountNumber == rhs.accountNumber &&
        lhs.accountHolder == rhs.accountHolder;
  }

  String _buildAccountSummary(WalletBankAccountInfo account) {
    return '${account.bankName} ${account.branchName}';
  }

  Future<void> _openDestinationSelector(
    BuildContext context,
    List<WalletBankAccountInfo> accounts,
    WalletBankAccountInfo selected,
  ) async {
    final selectedAccount = await showModalBottomSheet<WalletBankAccountInfo>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        final l10n = sheetContext.l10n;
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Text(
                  l10n.walletWithdrawSelectSheetTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColorTokens.fundexText,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final account = accounts[index];
                    final checked = _isSameAccount(account, selected);
                    return ListTile(
                      onTap: () => Navigator.of(sheetContext).pop(account),
                      title: Text(
                        _buildAccountSummary(account),
                        style: const TextStyle(
                          color: AppColorTokens.fundexText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${account.accountType} ${account.accountNumber}',
                        style: const TextStyle(
                          color: AppColorTokens.fundexTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: checked
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColorTokens.fundexAccent,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: AppColorTokens.fundexTextTertiary,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || selectedAccount == null) {
      return;
    }
    setState(() {
      _selectedAccount = selectedAccount;
    });
  }

  Future<void> _openAddBankAccountPage() async {
    final added = await context.push<bool>('/wallet/bank-settings/add');
    if (!mounted || added != true) {
      return;
    }
    ref.invalidate(walletBankAccountListProvider);
    AppNotice.show(context, message: context.l10n.walletBankSettingsAddSuccess);
  }

  num? _parseAmountOrNull() {
    final raw = _amountController.text.trim();
    if (raw.isEmpty) {
      return null;
    }
    final sanitized = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    if (sanitized.isEmpty) {
      return null;
    }
    return num.tryParse(sanitized);
  }

  Future<void> _submitWithdraw({
    required WalletBankAccountInfo? selected,
  }) async {
    final l10n = context.l10n;
    final amount = _parseAmountOrNull();
    if (amount == null || amount <= 0) {
      AppNotice.show(context, message: l10n.walletWithdrawAmountInvalid);
      return;
    }
    if (selected == null ||
        selected.id == null ||
        selected.id!.trim().isEmpty) {
      AppNotice.show(context, message: l10n.walletWithdrawSelectAccountFirst);
      return;
    }

    final bankIdRaw = selected.id!.trim();
    final parsedBankId = int.tryParse(bankIdRaw);
    final bankId = parsedBankId ?? bankIdRaw;

    ref.read(walletWithdrawSubmittingProvider.notifier).state = true;
    try {
      await ref
          .read(submitWalletWithdrawApplyUseCaseProvider)
          .call(
            WalletWithdrawApplyDraft(
              amount: amount,
              bankId: bankId,
              withdrawType: 0,
            ),
          );
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.walletWithdrawSubmitSuccess);
      ref.invalidate(walletWithdrawingListProvider);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.walletWithdrawSubmitFailure);
    } finally {
      if (mounted) {
        ref.read(walletWithdrawSubmittingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );
    final accountsAsync = ref.watch(walletBankAccountListProvider);
    final isSubmitting = ref.watch(walletWithdrawSubmittingProvider);
    final availableAmountAsync = ref.watch(myPageAccountStatisticProvider);
    final availableAmount =
        availableAmountAsync.asData?.value?.firstLevelAccountTotal;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavigationBar(
        title: l10n.walletWithdrawTitle,
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
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/wallet/withdrawing'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 46),
                  side: const BorderSide(color: AppColorTokens.fundexBorder),
                ),
                child: Text(l10n.walletWithdrawingAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/wallet/withdraw/history'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 46),
                  side: const BorderSide(color: AppColorTokens.fundexBorder),
                ),
                child: Text(l10n.walletWithdrawHistoryAction),
              ),
            ),
          ],
        ),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          final selected = _resolveSelectedAccount(accounts);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: AppColorTokens.fundexBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      l10n.walletWithdrawAvailableAmountLabel,
                      style: const TextStyle(
                        color: AppColorTokens.fundexTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currency.format(availableAmount ?? 0),
                      style: const TextStyle(
                        color: AppColorTokens.fundexText,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              MemberProfileTextField(
                label: l10n.walletWithdrawAmountLabel,
                controller: _amountController,
                hintText: l10n.walletWithdrawAmountHint,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _WithdrawInfoCard(
                destinationLabel: l10n.walletWithdrawDestinationLabel,
                destinationValue: selected == null
                    ? l10n.walletWithdrawSelectDestination
                    : _buildAccountSummary(selected),
                feeLabel: l10n.walletWithdrawFeeLabel,
                feeValue: '¥145',
                onTapDestination: () {
                  if (accounts.isEmpty) {
                    _openAddBankAccountPage();
                    return;
                  }
                  _openDestinationSelector(context, accounts, selected!);
                },
              ),
              if (accounts.isEmpty) ...<Widget>[
                const SizedBox(height: 12),
                _WithdrawEmptyAccountCard(
                  message: l10n.walletWithdrawNeedAccountMessage,
                  actionLabel: l10n.walletWithdrawNeedAccountAction,
                  onTap: _openAddBankAccountPage,
                ),
              ],
              const SizedBox(height: 20),
              PrimaryCtaButton(
                label: l10n.walletWithdrawSubmitAction,
                fullWidth: true,
                isLoading: isSubmitting,
                onPressed: isSubmitting
                    ? null
                    : () => _submitWithdraw(selected: selected),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(walletBankAccountListProvider),
            child: Text(l10n.fundListRetry),
          ),
        ),
      ),
    );
  }
}

class _WithdrawInfoCard extends StatelessWidget {
  const _WithdrawInfoCard({
    required this.destinationLabel,
    required this.destinationValue,
    required this.feeLabel,
    required this.feeValue,
    this.onTapDestination,
  });

  final String destinationLabel;
  final String destinationValue;
  final String feeLabel;
  final String feeValue;
  final VoidCallback? onTapDestination;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColorTokens.fundexBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColorTokens.fundexBorder),
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onTapDestination,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      destinationLabel,
                      style: const TextStyle(
                        color: AppColorTokens.fundexTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Text(
                      destinationValue,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColorTokens.fundexText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColorTokens.fundexTextTertiary,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 18, color: AppColorTokens.fundexBorder),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  feeLabel,
                  style: const TextStyle(
                    color: AppColorTokens.fundexTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                feeValue,
                style: const TextStyle(
                  color: AppColorTokens.fundexDanger,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WithdrawEmptyAccountCard extends StatelessWidget {
  const _WithdrawEmptyAccountCard({
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColorTokens.fundexDangerLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColorTokens.fundexDanger.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: AppColorTokens.fundexDanger,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColorTokens.fundexDanger,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
