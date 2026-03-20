import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../support/secondary_market_trade_models.dart';
import '../support/secondary_market_trade_widgets.dart';

class SecondaryMarketBuyConfirmPage extends ConsumerStatefulWidget {
  const SecondaryMarketBuyConfirmPage({super.key, required this.draft});

  final SecondaryMarketBuyDraft draft;

  @override
  ConsumerState<SecondaryMarketBuyConfirmPage> createState() =>
      _SecondaryMarketBuyConfirmPageState();
}

class _SecondaryMarketBuyConfirmPageState
    extends ConsumerState<SecondaryMarketBuyConfirmPage> {
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final l10n = context.l10n;
    final priceText = NumberFormat.decimalPattern().format(
      widget.draft.unitPrice,
    );
    final unitText = NumberFormat.decimalPattern().format(widget.draft.buyNum);
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.secondaryMarketBuyFinalConfirmTitle,
      message: l10n.secondaryMarketBuyFinalConfirmMessage(priceText, unitText),
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(
          label: l10n.walletBankSettingsCancelAction,
          value: false,
        ),
        AppDialogAction<bool>(
          label: l10n.secondaryMarketBuySubmitButton,
          value: true,
          isDestructive: true,
        ),
      ],
    );
    if (confirmed != true || !mounted) {
      return;
    }

    final allowed = await ensureSensitiveActionAuthorized(context, ref);
    if (!mounted || !allowed) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(submitMyPageSecondaryMarketPurchaseUseCaseProvider)
          .call(id: widget.draft.orderId, buyNum: widget.draft.buyNum);
      if (!mounted) {
        return;
      }
      ref.invalidate(secondaryMarketMarketplaceListProvider);
      ref.invalidate(myPageInvestmentListProvider);
      ref.invalidate(myPageAccountStatisticProvider);
      AppNotice.show(context, message: l10n.secondaryMarketBuySubmitSuccess);
      context.go('/home/free-market');
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.secondaryMarketBuySubmitFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppNavigationBar(
        title: l10n.secondaryMarketBuyOrderTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(top: BorderSide(color: colors.border)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l10n.secondaryMarketBuyBackButton),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryCtaButton(
                  label: l10n.secondaryMarketBuySubmitButton,
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                  fullWidth: false,
                  height: 48,
                  horizontalPadding: 0,
                  backgroundColor: colors.primary,
                  shadowColor: colors.primary.withValues(alpha: 0.45),
                  threeSideShadow: true,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          SecondaryMarketSegmentHeader(
            current: SecondaryMarketTradeStep.confirm,
            orderLabel: l10n.secondaryMarketTradeTabBuy,
            confirmLabel: l10n.secondaryMarketTradeTabConfirm,
          ),
          const SizedBox(height: 12),
          SecondaryMarketTableRow(
            label: l10n.myPageResaleFundNameLabel,
            value: Text(widget.draft.projectName),
          ),
          SecondaryMarketTableRow(
            label: l10n.myPageResaleInvestorTypeLabel,
            value: Text(
              buildSecondaryMarketInvestorTypeText(
                investorCode: widget.draft.investorCode,
                earningRatio: widget.draft.earningRatio,
                fallbackBuilder: l10n.myPageResaleInvestorTypeFallback,
                fixedYieldBuilder: l10n.myPageResaleFixedYieldLabel,
              ),
            ),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyOrderMethodLabel,
            value: Text(l10n.secondaryMarketBuyOrderMethodValue),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyAvailableUnitsLabel,
            value: Text(widget.draft.availableUnits.toString()),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyUnitsLabel,
            value: Text(
              '${widget.draft.buyNum}${l10n.myPageResaleUnitsSuffix}',
            ),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyUnitPriceLabel,
            value: Text(
              '${formatter.format(widget.draft.unitPrice)} ${l10n.myPageResaleYenSuffix}',
            ),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyFeeLabel,
            value: Text(l10n.secondaryMarketBuyFeeValue),
          ),
          const SizedBox(height: 12),
          SecondaryMarketPreviewCard(
            totalLabel: l10n.secondaryMarketBuyTotalAmountLabel,
            feeLabel: l10n.secondaryMarketBuyFeeAmountLabel,
            netLabel: l10n.secondaryMarketBuyPaymentAmountLabel,
            totalValue: formatter.format(widget.draft.totalAmount),
            feeValue: formatter.format(widget.draft.feeAmount),
            netValue: formatter.format(widget.draft.paymentAmount),
            highlightColor: colors.primary,
          ),
        ],
      ),
    );
  }
}
