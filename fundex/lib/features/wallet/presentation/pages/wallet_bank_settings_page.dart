import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/wallet_bank_account_info.dart';
import '../providers/wallet_providers.dart';

class WalletBankSettingsPage extends ConsumerStatefulWidget {
  const WalletBankSettingsPage({super.key});

  @override
  ConsumerState<WalletBankSettingsPage> createState() =>
      _WalletBankSettingsPageState();
}

class _WalletBankSettingsPageState
    extends ConsumerState<WalletBankSettingsPage> {
  Future<void> _openAddBankAccountPage() async {
    final l10n = context.l10n;
    final added = await context.push<bool>('/wallet/bank-settings/add');
    if (!mounted || added != true) {
      return;
    }
    try {
      ref.invalidate(walletBankAccountListProvider);
      await ref.read(walletBankAccountListProvider.future);
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.walletBankSettingsAddSuccess);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.walletBankSettingsAddFailure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final asyncAccounts = ref.watch(walletBankAccountListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.menuItemBankSettings,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: asyncAccounts.when(
        data: (List<WalletBankAccountInfo> accounts) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: <Widget>[
              if (accounts.isEmpty)
                _WalletBankAccountEmptyCard(onAdd: _openAddBankAccountPage)
              else ...<Widget>[
                Text(
                  l10n.walletBankSettingsRegisteredTitle,
                  style: appText.cardTitle,
                ),
                const SizedBox(height: 10),
                for (final account in accounts)
                  _WalletBankAccountCard(account: account),
                const SizedBox(height: 18),
                PrimaryCtaButton(
                  label: l10n.walletBankSettingsAddAction,
                  fullWidth: true,
                  onPressed: _openAddBankAccountPage,
                ),
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
    );
  }
}

class _WalletBankAccountCard extends StatelessWidget {
  const _WalletBankAccountCard({required this.account});

  final WalletBankAccountInfo account;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            account.bankName,
            style: appText.sectionTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 10),
          _WalletBankAccountInfoRow(
            label: l10n.walletBranchNameLabel,
            value: account.branchName,
          ),
          _WalletBankAccountInfoRow(
            label: l10n.walletAccountTypeLabel,
            value: account.accountType,
          ),
          _WalletBankAccountInfoRow(
            label: l10n.walletAccountNumberLabel,
            value: account.accountNumber,
          ),
          _WalletBankAccountInfoRow(
            label: l10n.walletAccountHolderLabel,
            value: account.accountHolder,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _WalletBankAccountInfoRow extends StatelessWidget {
  const _WalletBankAccountInfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: appText.tableLabel)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: appText.tableValue,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletBankAccountEmptyCard extends StatelessWidget {
  const _WalletBankAccountEmptyCard({required this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.walletBankSettingsEmptyMessage,
            style: appText.bodyMuted.copyWith(height: 1.55),
          ),
          const SizedBox(height: 14),
          PrimaryCtaButton(
            label: l10n.walletBankSettingsAddAction,
            fullWidth: false,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
