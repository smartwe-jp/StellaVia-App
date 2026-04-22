import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../domain/entities/wallet_bank_account_info.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_bank_account_add_entry.dart';

class WalletBankSettingsPage extends ConsumerStatefulWidget {
  const WalletBankSettingsPage({super.key});

  @override
  ConsumerState<WalletBankSettingsPage> createState() =>
      _WalletBankSettingsPageState();
}

class _WalletBankSettingsPageState
    extends ConsumerState<WalletBankSettingsPage> {
  final Set<String> _deletingAccountIds = <String>{};

  Future<void> _openAddBankAccountPage() async {
    final l10n = context.l10n;
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
    try {
      ref.invalidate(walletBankAccountListProvider);
      await ref.read(walletBankAccountListProvider.future);
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.walletBankSettingsAddSuccess);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.walletBankSettingsAddFailure,
        ),
      );
    }
  }

  Future<void> _deleteBankAccount(WalletBankAccountInfo account) async {
    final l10n = context.l10n;
    final accountId = account.id?.trim();
    if (accountId == null || accountId.isEmpty) {
      return;
    }

    final shouldDelete = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.walletBankSettingsDeleteConfirmTitle,
      message: l10n.walletBankSettingsDeleteConfirmBody,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(
          label: l10n.walletBankSettingsCancelAction,
          value: false,
        ),
        AppDialogAction<bool>(
          label: l10n.walletBankSettingsDeleteAction,
          value: true,
          isDestructive: true,
        ),
      ],
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() {
      _deletingAccountIds.add(accountId);
    });

    try {
      await ref
          .read(deleteWalletBankAccountUseCaseProvider)
          .call(id: accountId);
      ref.invalidate(walletBankAccountListProvider);
      await ref.read(walletBankAccountListProvider.future);
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.walletBankSettingsDeleteSuccess);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.walletBankSettingsDeleteFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deletingAccountIds.remove(accountId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final asyncAccounts = ref.watch(walletBankAccountListProvider);

    return AppRootRouteRefreshScope(
      onRefresh: (WidgetRef ref) async {
        ref.invalidate(walletBankAccountListProvider);
        await ref.refresh(walletBankAccountListProvider.future).then((_) {});
      },
      child: Scaffold(
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
                    _WalletBankAccountCard(
                      account: account,
                      isDeleting: _deletingAccountIds.contains(
                        account.id?.trim(),
                      ),
                      onDelete: () => _deleteBankAccount(account),
                    ),
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
      ),
    );
  }
}

class _WalletBankAccountCard extends StatelessWidget {
  const _WalletBankAccountCard({
    required this.account,
    required this.isDeleting,
    required this.onDelete,
  });

  final WalletBankAccountInfo account;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isOverseas = account.bankType == 1;
    final gradientColors = isOverseas
        ? <Color>[colors.heroStart, colors.primary]
        : <Color>[
            Color.lerp(colors.highlightGold, colors.primary, 0.18)!,
            Color.lerp(colors.highlightGold, colors.primary, 0.34)!,
          ];
    final chipBorderColor = colors.brandWhite.withValues(alpha: 0.35);
    final foreground = colors.brandWhite;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -26,
            top: -18,
            child: IgnorePointer(
              child: Container(
                width: 176,
                height: 176,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.brandWhite.withValues(alpha: 0.10),
                ),
              ),
            ),
          ),
          Positioned(
            left: -54,
            bottom: -90,
            child: IgnorePointer(
              child: Container(
                width: 240,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.brandWhite.withValues(alpha: 0.08),
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
                      child: Text(
                        account.bankName,
                        style: appText.pageTitle.copyWith(
                          color: foreground,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _WalletBankTypeChip(
                      label: isOverseas
                          ? l10n.walletBankSettingsOverseasChipLabel
                          : l10n.walletBankSettingsDomesticChipLabel,
                      borderColor: chipBorderColor,
                      foregroundColor: foreground,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: isDeleting
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  foreground,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: onDelete,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: foreground,
                                size: 24,
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _WalletBankAccountInfoRow(
                  label: l10n.walletBranchNameLabel,
                  value: _buildBranchValue(account),
                  foregroundColor: foreground,
                ),
                _WalletBankAccountInfoRow(
                  label: l10n.walletAccountNumberLabel,
                  value: account.accountNumber,
                  foregroundColor: foreground,
                ),
                _WalletBankAccountInfoRow(
                  label: l10n.walletAccountHolderLabel,
                  value: account.accountHolder,
                  foregroundColor: foreground,
                  isLast: true,
                ),
              ],
            ),
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
    required this.foregroundColor,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color foregroundColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.bodySemi.copyWith(
                color: foregroundColor.withValues(alpha: 0.92),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: appText.cardTitle.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletBankTypeChip extends StatelessWidget {
  const _WalletBankTypeChip({
    required this.label,
    required this.borderColor,
    required this.foregroundColor,
  });

  final String label;
  final Color borderColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        label,
        style: appText.bodySemi.copyWith(color: foregroundColor),
      ),
    );
  }
}

String _buildBranchValue(WalletBankAccountInfo account) {
  final branchName = account.branchName.trim();
  final branchNumber = account.branchNumber?.trim();
  if (branchNumber == null || branchNumber.isEmpty) {
    return branchName;
  }
  return '$branchName ($branchNumber)';
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
