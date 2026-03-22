import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../investment/presentation/support/secondary_market_trade_widgets.dart';
import '../../../investment/presentation/widgets/secondary_market_buy_flow_sections.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_secondary_market_models.dart';

class MyPageSecondaryMarketSellConfirmPage extends ConsumerStatefulWidget {
  const MyPageSecondaryMarketSellConfirmPage({super.key, required this.draft});

  final MyPageSecondaryMarketSellDraft draft;

  @override
  ConsumerState<MyPageSecondaryMarketSellConfirmPage> createState() =>
      _MyPageSecondaryMarketSellConfirmPageState();
}

class _MyPageSecondaryMarketSellConfirmPageState
    extends ConsumerState<MyPageSecondaryMarketSellConfirmPage> {
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final l10n = context.l10n;
    final priceText = NumberFormat.decimalPattern().format(widget.draft.price);
    final unitText = NumberFormat.decimalPattern().format(widget.draft.sellNum);
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.myPageResaleHintTitle,
      message: l10n.myPageResaleFinalConfirmMessage(priceText, unitText),
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(
          label: l10n.walletBankSettingsCancelAction,
          value: false,
        ),
        AppDialogAction<bool>(
          label: l10n.myPageResaleSubmitButton,
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
          .read(submitMyPageSecondaryMarketCreateUseCaseProvider)
          .call(
            fromProcessId: widget.draft.fromProcessId,
            sellNum: widget.draft.sellNum,
            price: widget.draft.price,
          );
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.myPageResaleSubmitSuccess);
      context.go('/profile/my/secondary-market');
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.myPageResaleSubmitFailure,
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
    final investorTypeText = buildSecondaryMarketInvestorTypeText(
      investorCode: widget.draft.investorCode,
      earningRatio: widget.draft.earningRatio,
      fallbackBuilder: l10n.myPageResaleInvestorTypeFallback,
      fixedYieldBuilder: l10n.myPageResaleFixedYieldLabel,
    );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.myPageResaleOrderTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      bottomNavigationBar: SecondaryMarketTradeStickyActionBar(
        amountLabel: l10n.myPageResaleNetAmountLabel,
        amountValue: formatter.format(widget.draft.netAmount),
        primaryLabel: l10n.myPageResaleSubmitButton,
        onPrimaryPressed: _isSubmitting ? null : _submit,
        primaryBackgroundColor: colors.danger,
        primaryShadowColor: colors.danger.withValues(alpha: 0.38),
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
                  title: l10n.myPageResaleFlowConfirmTitle,
                  subtitle: l10n.myPageResaleFlowConfirmSubtitle,
                  orderLabel: l10n.myPageResaleTabOrder,
                  confirmLabel: l10n.secondaryMarketTradeTabConfirm,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeFinalNoticeCard(
                  title: l10n.myPageResaleFinalNoticeTitle,
                  body: l10n.myPageResaleFinalNoticeBody,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeReviewCard(
                  title: l10n.myPageResaleReviewSectionTitle,
                  subtitle: l10n.myPageResaleReviewHint,
                  rows: <SecondaryMarketTradeInfoRowData>[
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleOrderMethodLabel,
                      value: l10n.myPageResaleOrderMethodValue,
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleInvestorTypeLabel,
                      value: investorTypeText.replaceAll('\n', ' / '),
                      emphasized: true,
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleSellUnitsLabel,
                      value:
                          '${widget.draft.sellNum}${l10n.myPageResaleUnitsSuffix}',
                      emphasized: true,
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleUnitPriceLabel,
                      value:
                          '${formatter.format(widget.draft.price)} ${l10n.myPageResaleYenSuffix}',
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleAgreementLabel,
                      value: l10n.myPageResaleAgreementSampleLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeSummaryCard(
                  title: l10n.myPageResaleSummarySectionTitle,
                  rows: <SecondaryMarketTradeInfoRowData>[
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleTotalAmountLabel,
                      value: formatter.format(widget.draft.totalAmount),
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleFeeAmountLabel,
                      value: formatter.format(widget.draft.feeAmount),
                    ),
                    SecondaryMarketTradeInfoRowData(
                      label: l10n.myPageResaleFeeLabel,
                      value: l10n.myPageResaleFeeValue,
                    ),
                  ],
                  highlightLabel: l10n.myPageResaleNetAmountLabel,
                  highlightValue: formatter.format(widget.draft.netAmount),
                  highlightColor: colors.danger,
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
