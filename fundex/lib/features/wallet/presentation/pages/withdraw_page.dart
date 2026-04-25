import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';
import '../../domain/entities/wallet_bank_account_info.dart';
import '../../domain/entities/wallet_withdraw_apply_draft.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_bank_account_add_entry.dart';
import '../support/wallet_withdraw_confirm_models.dart';

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
    _amountController = TextEditingController()
      ..addListener(_handleAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_handleAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _handleAmountChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final selectedAccount = await showModalBottomSheet<WalletBankAccountInfo>(
      context: context,
      useSafeArea: true,
      backgroundColor: colors.surface,
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
                  style: appText.cardTitle,
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
                        style: appText.cardTitle,
                      ),
                      subtitle: Text(
                        '${account.accountType} ${account.accountNumber}',
                        style: appText.bodyMuted,
                      ),
                      trailing: checked
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: colors.primary,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: colors.textTertiary,
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
    final entry = await showWalletBankAccountAddEntrySheet(context);
    if (!mounted || entry == null) {
      return;
    }
    final added = await context.push<bool>(
      walletBankAccountAddRouteForEntry(entry),
    );
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

  bool _canSubmitWithdraw({
    required WalletBankAccountInfo? selected,
    required num? availableAmount,
    required num? feeAmount,
  }) {
    final amount = _parseAmountOrNull();
    if (amount == null || amount <= 0) {
      return false;
    }
    if (feeAmount == null) {
      return false;
    }
    if (availableAmount != null && amount + feeAmount > availableAmount) {
      return false;
    }
    final selectedId = selected?.id?.trim();
    return selectedId != null && selectedId.isNotEmpty;
  }

  Future<void> _openWithdrawConfirmPage({
    required WalletBankAccountInfo? selected,
    required num? availableAmount,
    required num? feeAmount,
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
    if (feeAmount == null) {
      return;
    }
    if (availableAmount != null && amount + feeAmount > availableAmount) {
      AppNotice.show(context, message: l10n.walletWithdrawInsufficientBalance);
      return;
    }

    final bankIdRaw = selected.id!.trim();
    final parsedBankId = int.tryParse(bankIdRaw);
    final bankId = parsedBankId ?? bankIdRaw;
    final submitted = await context.push<bool>(
      '/wallet/withdraw/confirm',
      extra: WalletWithdrawConfirmSeed(
        draft: WalletWithdrawApplyDraft(
          amount: amount,
          bankId: bankId,
          withdrawType: 0,
        ),
        account: selected,
      ),
    );
    if (!mounted || submitted != true) {
      return;
    }
    _amountController.clear();
    ref.invalidate(walletWithdrawingListProvider);
    ref.invalidate(walletWithdrawHistoryProvider);
    ref.invalidate(myPageAccountStatisticProvider);
  }

  Future<void> _handleSubmitTap({
    required WalletBankAccountInfo? selected,
    required num? availableAmount,
    required num? feeAmount,
  }) async {
    final allowed = await ensureRealPersonVerifiedAndAuthorizeSensitiveAction(
      context,
      ref,
      faceVerificationTitle:
          context.l10n.walletWithdrawRequiresFaceVerificationTitle,
      faceVerificationMessage:
          context.l10n.walletWithdrawRequiresFaceVerificationMessage,
    );
    if (!mounted || !allowed) {
      return;
    }

    await _openWithdrawConfirmPage(
      selected: selected,
      availableAmount: availableAmount,
      feeAmount: feeAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );
    final accountsAsync = ref.watch(walletBankAccountListProvider);
    final availableAmountAsync = ref.watch(myPageAccountStatisticProvider);
    final phoneVerifiedAsync = ref.watch(settingsPhoneVerifiedProvider);
    final accountStatistic = availableAmountAsync.asData?.value;
    final availableAmount = accountStatistic?.withdrawableAmount;
    final lockedAmount = accountStatistic?.lockedFee ?? 0;
    final lockedItems =
        accountStatistic?.lockedList ?? const <MyPageLockedAmount>[];
    final accounts = accountsAsync.asData?.value;
    final selected = accounts == null
        ? null
        : _resolveSelectedAccount(accounts);
    final selectedBankId = selected?.id?.trim();
    final feeAsync = selectedBankId == null || selectedBankId.isEmpty
        ? const AsyncData<num>(0)
        : ref.watch(walletWithdrawCostProvider(selectedBankId));
    final feeValueText = feeAsync.when(
      data: (num fee) => currency.format(fee),
      loading: () => '--',
      error: (_, __) => '--',
    );
    final feeValue = feeAsync.asData?.value;
    final canSubmit = _canSubmitWithdraw(
      selected: selected,
      availableAmount: availableAmount,
      feeAmount: feeValue,
    );
    final bool? phoneVerified = phoneVerifiedAsync.asData?.value;

    return AppRootRouteRefreshScope(
      onRefresh: (WidgetRef ref) async {
        ref.invalidate(walletBankAccountListProvider);
        ref.invalidate(myPageAccountStatisticProvider);
        await Future.wait<void>(<Future<void>>[
          ref.refresh(walletBankAccountListProvider.future).then((_) {}),
          ref.refresh(myPageAccountStatisticProvider.future).then((_) {}),
        ]);
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppNavigationBar(
          title: l10n.walletWithdrawTitle,
          height: 52,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),
        bottomNavigationBar: accounts == null || phoneVerified != true
            ? null
            : _WithdrawBottomActionBar(
                label: l10n.walletWithdrawSubmitAction,
                enabled: canSubmit,
                onTap: () => _handleSubmitTap(
                  selected: selected,
                  availableAmount: availableAmount,
                  feeAmount: feeValue,
                ),
              ),
        body: accountsAsync.when(
          data: (accounts) {
            return ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                phoneVerified == true ? 120 : 24,
              ),
              children: <Widget>[
                _WithdrawBalanceHeroCard(
                  label: l10n.walletWithdrawAvailableAmountLabel,
                  subTitle: l10n.walletWithdrawHistoryAction,
                  value: currency.format(availableAmount ?? 0),
                  onTapHistory: () => context.push('/wallet/withdraw/history'),
                ),
                const SizedBox(height: 16),
                if (lockedAmount > 0 || lockedItems.isNotEmpty) ...<Widget>[
                  _WithdrawLockedAmountSection(
                    totalLockedAmount: lockedAmount,
                    items: lockedItems,
                    currency: currency,
                  ),
                  const SizedBox(height: 16),
                ],
                if (phoneVerifiedAsync.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (phoneVerified != true)
                  _WithdrawPhoneVerificationGateCard(
                    message:
                        l10n.walletWithdrawPhoneVerificationRequiredMessage,
                    actionLabel:
                        l10n.walletWithdrawPhoneVerificationRequiredAction,
                    onTap: () =>
                        context.push('/profile/settings/two-factor/phone'),
                  )
                else ...<Widget>[
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
                    feeValue: feeValueText,
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
                ],
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
      ),
    );
  }
}

class _WithdrawPhoneVerificationGateCard extends StatelessWidget {
  const _WithdrawPhoneVerificationGateCard({
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.infoSubtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.sms_rounded, color: colors.info),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: appText.body.copyWith(
                    color: colors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryCtaButton(
            label: actionLabel,
            fullWidth: true,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class _WithdrawBalanceHeroCard extends StatelessWidget {
  const _WithdrawBalanceHeroCard({
    required this.label,
    required this.subTitle,
    required this.value,
    required this.onTapHistory,
  });

  final String label;
  final String subTitle;
  final String value;
  final VoidCallback onTapHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final foregroundColor = colors.onDark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
        border: Border.all(color: colors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -34,
            right: -34,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      colors.primary.withValues(alpha: 0.22),
                      colors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            label,
                            style: appText.caption.copyWith(
                              color: foregroundColor.withValues(alpha: 0.82),
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            value,
                            style: appText.heroMetricPrimary.copyWith(
                              color: foregroundColor,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          subTitle,
                          style: appText.caption.copyWith(
                            color: foregroundColor.withValues(alpha: 0.82),
                            letterSpacing: 0.2,
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colors.surface.withValues(alpha: 0.22),
                            ),
                          ),
                          child: IconButton(
                            onPressed: onTapHistory,
                            tooltip: context.l10n.walletWithdrawHistoryAction,
                            icon: Icon(
                              Icons.history_rounded,
                              color: foregroundColor,
                            ),
                          ),
                        ),
                      ]
                    )
                    
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: colors.surface.withValues(alpha: 0.16),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
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
                    child: Text(destinationLabel, style: appText.tableLabel),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Text(
                      destinationValue,
                      textAlign: TextAlign.right,
                      style: appText.tableValue,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
                ],
              ),
            ),
          ),
          Divider(height: 18, color: colors.border),
          Row(
            children: <Widget>[
              Expanded(child: Text(feeLabel, style: appText.tableLabel)),
              Text(
                feeValue,
                style: appText.tableValue.copyWith(color: colors.danger),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WithdrawLockedAmountSection extends StatelessWidget {
  const _WithdrawLockedAmountSection({
    required this.totalLockedAmount,
    required this.items,
    required this.currency,
  });

  final num totalLockedAmount;
  final List<MyPageLockedAmount> items;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.walletWithdrawLockedAmountTitle,
                      style: appText.caption.copyWith(
                        color: colors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currency.format(totalLockedAmount),
                      style: appText.heroTitle.copyWith(
                        color: colors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    l10n.walletWithdrawLockedBreakdownTitle,
                    style: appText.caption.copyWith(
                      color: colors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${items.length}',
                    style: appText.heroTitle.copyWith(
                      color: colors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${l10n.walletWithdrawLockedBreakdownTitle} :',
            style: appText.bodyStrong.copyWith(color: colors.textSecondary),
          ),
          if (items.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WithdrawLockedAmountItemCard(
                  item: item,
                  currency: currency,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WithdrawLockedAmountItemCard extends StatelessWidget {
  const _WithdrawLockedAmountItemCard({
    required this.item,
    required this.currency,
  });

  final MyPageLockedAmount item;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final reason = _displayText(item.lockedReason);
    final start = _displayText(item.startLockedTime);
    final release = _displayText(item.lockExpireTime);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                currency.format(item.lockedAmount ?? 0),
                style: appText.heroSubtitle.copyWith(
                  color: colors.textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  reason,
                  style: appText.bodySemi.copyWith(
                    color: colors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${l10n.walletWithdrawLockedStartLabel} : $start',
                  style: appText.bodyMuted.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${l10n.walletWithdrawLockedReleaseLabel} : $release',
                  textAlign: TextAlign.left,
                  style: appText.bodyMuted.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _displayText(String? raw) {
    final normalized = raw?.trim() ?? '';
    return normalized.isEmpty ? '-' : normalized;
  }
}

class _WithdrawBottomActionBar extends StatelessWidget {
  const _WithdrawBottomActionBar({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderSoft)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: PrimaryCtaButton(
            label: label,
            fullWidth: true,
            onPressed: enabled ? onTap : null,
          ),
        ),
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
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: colors.dangerSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.dangerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: colors.danger,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message,
                  style: appText.bodyStrong.copyWith(
                    color: colors.dangerForeground,
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
