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
import '../widgets/secondary_market_buy_flow_sections.dart';

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
    final yieldText = widget.draft.earningRatio == null
        ? '--'
        : '${(widget.draft.earningRatio! * 100).toStringAsFixed(2)}%';
    final investorTypeText = buildSecondaryMarketInvestorTypeText(
      investorCode: widget.draft.investorCode,
      earningRatio: widget.draft.earningRatio,
      fallbackBuilder: l10n.myPageResaleInvestorTypeFallback,
      fixedYieldBuilder: l10n.myPageResaleFixedYieldLabel,
    );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.secondaryMarketBuyOrderTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      bottomNavigationBar: SecondaryMarketTradeStickyActionBar(
        amountLabel: l10n.secondaryMarketBuyStickyAmountLabel,
        amountValue: formatter.format(widget.draft.paymentAmount),
        primaryLabel: l10n.secondaryMarketBuySubmitButton,
        onPrimaryPressed: _isSubmitting ? null : _submit,
        primaryBackgroundColor: colors.primary,
        primaryShadowColor: colors.primary.withValues(alpha: 0.32),
        isLoading: _isSubmitting,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SecondaryMarketTradePinnedTitleBar(title: widget.draft.projectName),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: <Widget>[
                SecondaryMarketTradeFlowHeader(
                  currentStep: 1,
                  title: l10n.secondaryMarketBuyFlowConfirmTitle,
                  subtitle: l10n.secondaryMarketBuyFlowConfirmSubtitle,
                  orderLabel: l10n.secondaryMarketTradeTabBuy,
                  confirmLabel: l10n.secondaryMarketTradeTabConfirm,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeFinalNoticeCard(
                  title: l10n.secondaryMarketBuyFinalNoticeTitle,
                  body: l10n.secondaryMarketBuyFinalNoticeBody,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeReviewCard(
                  title: l10n.secondaryMarketBuyReviewSectionTitle,
                  subtitle: l10n.secondaryMarketBuyReviewHint,
                  rows: <SecondaryMarketTradeInfoRowData>[
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.secondaryMarketBuyOrderMethodLabel,
                      value: l10n.secondaryMarketBuyOrderMethodValue,
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleInvestorTypeLabel,
                      value: investorTypeText.replaceAll('\n', ' / '),
                      emphasized: true,
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.secondaryMarketBuyUnitsLabel,
                      value:
                          '${widget.draft.buyNum}${l10n.myPageResaleUnitsSuffix}',
                      emphasized: true,
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.secondaryMarketBuyAgreementLabel,
                      value: widget.draft.sampleDocumentUrl == null
                          ? l10n.secondaryMarketDocumentPending
                          : l10n.secondaryMarketBuyAgreementSampleLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeSummaryCard(
                  title: l10n.secondaryMarketBuySummarySectionTitle,
                  rows: <SecondaryMarketTradeInfoRowData>[
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.secondaryMarketBuyTotalAmountLabel,
                      value: formatter.format(widget.draft.totalAmount),
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.secondaryMarketBuyFeeAmountLabel,
                      value: formatter.format(widget.draft.feeAmount),
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.homeEstimatedYieldLabel,
                      value: yieldText,
                    ),
                  ],
                  highlightLabel: l10n.secondaryMarketBuyPaymentAmountLabel,
                  highlightValue: formatter.format(widget.draft.paymentAmount),
                  highlightColor: colors.primary,
                ),
                const SizedBox(height: 112),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
