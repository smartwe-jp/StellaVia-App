import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../support/secondary_market_trade_models.dart';
import '../widgets/secondary_market_buy_flow_sections.dart';

class SecondaryMarketBuyOrderPage extends ConsumerStatefulWidget {
  const SecondaryMarketBuyOrderPage({super.key, required this.seed});

  final SecondaryMarketBuySeed seed;

  @override
  ConsumerState<SecondaryMarketBuyOrderPage> createState() =>
      _SecondaryMarketBuyOrderPageState();
}

class _SecondaryMarketBuyOrderPageState
    extends ConsumerState<SecondaryMarketBuyOrderPage> {
  late final TextEditingController _buyUnitsController;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _buyUnitsController = TextEditingController(
      text: widget.seed.availableUnits > 0 ? '1' : '0',
    );
  }

  @override
  void dispose() {
    _buyUnitsController.dispose();
    super.dispose();
  }

  int? get _buyUnits => int.tryParse(_buyUnitsController.text.trim());

  bool get _isValid {
    final buyUnits = _buyUnits;
    return widget.seed.orderId.trim().isNotEmpty &&
        _agreed &&
        buyUnits != null &&
        buyUnits > 0 &&
        buyUnits <= widget.seed.availableUnits;
  }

  void _setBuyUnits(int value) {
    final clamped = value.clamp(0, widget.seed.availableUnits);
    final text = clamped.toString();
    _buyUnitsController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() {});
  }

  void _increaseUnits() {
    final current = _buyUnits ?? 0;
    if (current >= widget.seed.availableUnits) {
      return;
    }
    _setBuyUnits(current + 1);
  }

  void _decreaseUnits() {
    final current = _buyUnits ?? 0;
    if (current <= 1) {
      _setBuyUnits(0);
      return;
    }
    _setBuyUnits(current - 1);
  }

  String? get _sampleDocumentUrl {
    for (final MyPagePdfDocument document in widget.seed.pdfDocuments) {
      for (final MyPagePdfUrl url in document.urls) {
        final value = url.url?.trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }

  void _openSampleDocument(BuildContext context, String url) {
    final l10n = context.l10n;
    openAppPdfViewer(
      context,
      url: url,
      title: l10n.secondaryMarketBuyAgreementSampleLabel,
      texts: AppPdfViewerTexts(
        pageTitle: l10n.pdfViewerPageTitle,
        openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
        openExternalLabel: l10n.pdfViewerOpenExternalLabel,
        loadingLabel: l10n.pdfViewerLoadingLabel,
        loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
        retryLabel: l10n.fundListRetry,
        invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
        openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
      ),
    );
  }

  void _goConfirm() {
    if (!_isValid) {
      return;
    }
    final draft = SecondaryMarketBuyDraft(
      orderId: widget.seed.orderId,
      projectId: widget.seed.projectId,
      projectName: widget.seed.projectName,
      availableUnits: widget.seed.availableUnits,
      buyNum: _buyUnits!,
      unitPrice: widget.seed.unitPrice,
      investorCode: widget.seed.investorCode,
      earningRatio: widget.seed.earningRatio,
      agreed: _agreed,
      sampleDocumentUrl: _sampleDocumentUrl,
    );
    context.push(
      '/free-market/${widget.seed.orderId}/buy/confirm',
      extra: draft,
    );
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
    final preview = SecondaryMarketBuyDraft(
      orderId: widget.seed.orderId,
      projectId: widget.seed.projectId,
      projectName: widget.seed.projectName,
      availableUnits: widget.seed.availableUnits,
      buyNum: _buyUnits ?? 0,
      unitPrice: widget.seed.unitPrice,
      investorCode: widget.seed.investorCode,
      earningRatio: widget.seed.earningRatio,
      agreed: _agreed,
      sampleDocumentUrl: _sampleDocumentUrl,
    );
    final formulaValue =
        '${_buyUnits ?? 0}${l10n.myPageResaleUnitsSuffix} × ${formatter.format(widget.seed.unitPrice)}';

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
        amountValue: formatter.format(preview.paymentAmount),
        helperText: _isValid ? null : l10n.secondaryMarketBuyValidationMessage,
        primaryLabel: l10n.secondaryMarketBuyConfirmButton,
        onPrimaryPressed: _isValid ? _goConfirm : null,
        primaryBackgroundColor: colors.primary,
        primaryShadowColor: colors.primary.withValues(alpha: 0.32),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SecondaryMarketTradePinnedTitleBar(title: widget.seed.projectName),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: <Widget>[
                SecondaryMarketTradeFlowHeader(
                  currentStep: 0,
                  title: l10n.secondaryMarketBuyFlowInputTitle,
                  subtitle: l10n.secondaryMarketBuyFlowInputSubtitle,
                  orderLabel: l10n.secondaryMarketTradeTabBuy,
                  confirmLabel: l10n.secondaryMarketTradeTabConfirm,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeQuantityCard(
                  title: l10n.secondaryMarketBuyUnitsLabel,
                  subtitle: l10n.secondaryMarketBuyQuantityHint,
                  availabilityLabel: l10n.secondaryMarketBuyAvailableUnitsLabel,
                  formulaLabel: l10n.secondaryMarketBuyLiveEstimateFormulaLabel,
                  formulaValue: formulaValue,
                  totalLabel: l10n.secondaryMarketBuyTotalAmountLabel,
                  totalValue: formatter.format(preview.totalAmount),
                  feeLabel: l10n.secondaryMarketBuyFeeAmountLabel,
                  feeValue: formatter.format(preview.feeAmount),
                  paymentLabel: l10n.secondaryMarketBuyPaymentAmountLabel,
                  paymentValue: formatter.format(preview.paymentAmount),
                  controller: _buyUnitsController,
                  selectedUnits: _buyUnits ?? 0,
                  availableUnits: widget.seed.availableUnits,
                  unitLabel: l10n.myPageResaleUnitsSuffix,
                  maxChipLabel: l10n.secondaryMarketBuyQuickMax,
                  onChanged: (_) => setState(() {}),
                  onDecrease: widget.seed.availableUnits > 0
                      ? _decreaseUnits
                      : null,
                  onIncrease: widget.seed.availableUnits > 0
                      ? _increaseUnits
                      : null,
                  onSelectPreset: _setBuyUnits,
                  enabled: widget.seed.availableUnits > 0,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeAgreementCard(
                  title: l10n.secondaryMarketBuyAgreementSectionTitle,
                  body: l10n.secondaryMarketBuyAgreementBody,
                  agreed: _agreed,
                  onChanged: (bool value) {
                    setState(() {
                      _agreed = value;
                    });
                  },
                  documentLabel: l10n.secondaryMarketBuyAgreementSampleLabel,
                  documentActionLabel: _sampleDocumentUrl == null
                      ? l10n.secondaryMarketDocumentPending
                      : l10n.secondaryMarketDocumentOpenAction,
                  documentAvailable: _sampleDocumentUrl != null,
                  onOpenDocument: _sampleDocumentUrl == null
                      ? null
                      : () => _openSampleDocument(context, _sampleDocumentUrl!),
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
