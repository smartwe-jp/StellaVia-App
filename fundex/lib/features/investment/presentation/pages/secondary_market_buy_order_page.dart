import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../support/secondary_market_trade_models.dart';
import '../support/secondary_market_trade_widgets.dart';

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
    final appText = theme.appTextTheme;
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
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l10n.walletBankSettingsCancelAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryCtaButton(
                  label: l10n.secondaryMarketBuyConfirmButton,
                  onPressed: _isValid ? _goConfirm : null,
                  fullWidth: false,
                  height: 48,
                  horizontalPadding: 0,
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
            current: SecondaryMarketTradeStep.order,
            orderLabel: l10n.secondaryMarketTradeTabBuy,
            confirmLabel: l10n.secondaryMarketTradeTabConfirm,
          ),
          const SizedBox(height: 12),
          SecondaryMarketTableRow(
            label: l10n.myPageResaleFundNameLabel,
            value: Text(
              widget.seed.projectName,
              style: appText.bodyStrong.copyWith(color: colors.primary),
            ),
          ),
          SecondaryMarketTableRow(
            label: l10n.myPageResaleInvestorTypeLabel,
            value: Text(
              buildSecondaryMarketInvestorTypeText(
                investorCode: widget.seed.investorCode,
                earningRatio: widget.seed.earningRatio,
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
            value: Text(widget.seed.availableUnits.toString()),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyUnitsLabel,
            value: SecondaryMarketUnitInputField(
              controller: _buyUnitsController,
              unitLabel: l10n.myPageResaleUnitsSuffix,
              onChanged: (_) => setState(() {}),
            ),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyUnitPriceLabel,
            value: Text(
              '${formatter.format(widget.seed.unitPrice)} ${l10n.myPageResaleYenSuffix}',
            ),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyFeeLabel,
            value: Text(l10n.secondaryMarketBuyFeeValue),
          ),
          SecondaryMarketTableRow(
            label: l10n.secondaryMarketBuyAgreementLabel,
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: _agreed,
                      onChanged: (value) {
                        setState(() {
                          _agreed = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(l10n.secondaryMarketBuyAgreementBody),
                      ),
                    ),
                  ],
                ),
                if (_sampleDocumentUrl != null)
                  TextButton(
                    onPressed: () =>
                        _openSampleDocument(context, _sampleDocumentUrl!),
                    child: Text(l10n.secondaryMarketBuyAgreementSampleLabel),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SecondaryMarketPreviewCard(
            totalLabel: l10n.secondaryMarketBuyTotalAmountLabel,
            feeLabel: l10n.secondaryMarketBuyFeeAmountLabel,
            netLabel: l10n.secondaryMarketBuyPaymentAmountLabel,
            totalValue: formatter.format(preview.totalAmount),
            feeValue: formatter.format(preview.feeAmount),
            netValue: formatter.format(preview.paymentAmount),
            highlightColor: colors.primary,
          ),
          if (!_isValid)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l10n.secondaryMarketBuyValidationMessage,
                style: appText.caption.copyWith(color: colors.danger),
              ),
            ),
        ],
      ),
    );
  }
}
