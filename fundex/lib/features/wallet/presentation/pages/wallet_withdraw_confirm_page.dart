import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_withdraw_confirm_models.dart';

class WalletWithdrawConfirmPage extends ConsumerStatefulWidget {
  const WalletWithdrawConfirmPage({
    super.key,
    required this.seed,
  });

  final WalletWithdrawConfirmSeed seed;

  @override
  ConsumerState<WalletWithdrawConfirmPage> createState() =>
      _WalletWithdrawConfirmPageState();
}

class _WalletWithdrawConfirmPageState
    extends ConsumerState<WalletWithdrawConfirmPage> {
  bool _isSendingCode = false;

  String _resolveBankId() {
    final accountId = widget.seed.account.id?.trim() ?? '';
    if (accountId.isNotEmpty) {
      return accountId;
    }
    return widget.seed.draft.bankId.toString().trim();
  }

  String _maskBankAccountLabel() {
    final account = widget.seed.account;
    final number = account.accountNumber.trim();
    final suffix = number.length <= 4
        ? number
        : number.substring(number.length - 4);
    return '${account.bankName} ••••$suffix';
  }

  Future<void> _sendCodeAndContinue() async {
    if (_isSendingCode) {
      return;
    }
    setState(() {
      _isSendingCode = true;
    });
    try {
      await ref.read(sendWalletWithdrawApplyCodeUseCaseProvider).call();
      if (!mounted) {
        return;
      }
      final submitted = await context.push<bool>(
        '/wallet/withdraw/confirm/verify',
        extra: widget.seed,
      );
      if (!mounted || submitted != true) {
        return;
      }
      context.pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.loginErrorSendCodeFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );
    final bankId = _resolveBankId();
    final feeAsync = bankId.isEmpty
        ? const AsyncData<num>(0)
        : ref.watch(walletWithdrawCostProvider(bankId));
    final feeValueText = feeAsync.when(
      data: (num fee) => currency.format(fee),
      loading: () => '--',
      error: (_, __) => '--',
    );
    final actualArrivalValueText = currency.format(widget.seed.draft.amount);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.walletWithdrawConfirmTitle,
        height: 52,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _WithdrawConfirmCard(
                      amountLabel: l10n.walletWithdrawAmountLabel,
                      amountValue: currency.format(widget.seed.draft.amount),
                      accountLabel: l10n.walletWithdrawDestinationLabel,
                      accountValue: _maskBankAccountLabel(),
                      feeLabel: l10n.walletWithdrawFeeLabel,
                      feeValue: feeValueText,
                      estimatedArrivalLabel: l10n.walletWithdrawEstimatedArrivalLabel,
                      estimatedArrivalValue: l10n.walletWithdrawEstimatedArrivalValue,
                      netLabel: l10n.walletWithdrawNetAmountLabel,
                      netValue: actualArrivalValueText,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        color: colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(UiTokens.radius16),
                      ),
                      child: Text(
                        l10n.walletWithdrawConfirmHint,
                        style: appText.bodySemi.copyWith(
                          color: colors.textSecondary,
                          height: 1.65,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryCtaButton(
                      label: l10n.walletWithdrawConfirmSendCodeAction,
                      fullWidth: true,
                      horizontalPadding: 0,
                      isLoading: _isSendingCode,
                      onPressed: _isSendingCode ? null : _sendCodeAndContinue,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colors.surfaceAlt,
                          side: BorderSide(color: colors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiTokens.radius14),
                          ),
                        ),
                        child: Text(
                          l10n.walletWithdrawBackEditAction,
                          style: appText.cardTitle.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithdrawConfirmCard extends StatelessWidget {
  const _WithdrawConfirmCard({
    required this.amountLabel,
    required this.amountValue,
    required this.accountLabel,
    required this.accountValue,
    required this.feeLabel,
    required this.feeValue,
    required this.estimatedArrivalLabel,
    required this.estimatedArrivalValue,
    required this.netLabel,
    required this.netValue,
  });

  final String amountLabel;
  final String amountValue;
  final String accountLabel;
  final String accountValue;
  final String feeLabel;
  final String feeValue;
  final String estimatedArrivalLabel;
  final String estimatedArrivalValue;
  final String netLabel;
  final String netValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Column(
      children: <Widget>[
        _WithdrawConfirmRow(
          label: amountLabel,
          value: amountValue,
          valueColor: colors.primary,
          valueStyle: appText.sectionTitle.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 22),
        _WithdrawConfirmRow(
          label: accountLabel,
          value: accountValue,
          valueStyle: appText.bodySemi.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 22),
        Divider(height: 1, color: colors.borderSoft),
        const SizedBox(height: 22),
        _WithdrawConfirmRow(
          label: feeLabel,
          value: feeValue,
          valueStyle: appText.bodySemi.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        _WithdrawConfirmRow(
          label: estimatedArrivalLabel,
          value: estimatedArrivalValue,
          valueStyle: appText.bodySemi.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 22),
        Divider(height: 1, color: colors.borderSoft),
        const SizedBox(height: 22),
        _WithdrawConfirmRow(
          label: netLabel,
          value: netValue,
          labelStyle: appText.bodySemi.copyWith(
            fontSize: 18,
          ),
          valueStyle: appText.pageTitle.copyWith(
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _WithdrawConfirmRow extends StatelessWidget {
  const _WithdrawConfirmRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: (labelStyle ?? appText.body).copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: (valueStyle ?? appText.bodyStrong).copyWith(
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
