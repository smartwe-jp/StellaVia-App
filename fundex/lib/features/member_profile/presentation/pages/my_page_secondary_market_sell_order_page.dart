import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../investment/presentation/widgets/secondary_market_buy_flow_sections.dart';
import '../support/mypage_secondary_market_models.dart';

class MyPageSecondaryMarketSellOrderPage extends ConsumerStatefulWidget {
  const MyPageSecondaryMarketSellOrderPage({super.key, required this.seed});

  final MyPageSecondaryMarketSellSeed seed;

  @override
  ConsumerState<MyPageSecondaryMarketSellOrderPage> createState() =>
      _MyPageSecondaryMarketSellOrderPageState();
}

class _MyPageSecondaryMarketSellOrderPageState
    extends ConsumerState<MyPageSecondaryMarketSellOrderPage> {
  late final TextEditingController _sellUnitsController;
  late final TextEditingController _priceController;

  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _sellUnitsController = TextEditingController(
      text: widget.seed.availableUnits > 0 ? '1' : '0',
    );
    _priceController = TextEditingController(text: '1000000');
  }

  @override
  void dispose() {
    _sellUnitsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  int? get _sellUnits => int.tryParse(_sellUnitsController.text.trim());
  int? get _price => int.tryParse(_priceController.text.trim());

  bool get _isValid {
    final sellUnits = _sellUnits;
    final price = _price;
    final hasProcessId = widget.seed.fromProcessId.trim().isNotEmpty;
    return hasProcessId &&
        _agreed &&
        sellUnits != null &&
        sellUnits > 0 &&
        sellUnits <= widget.seed.availableUnits &&
        price != null &&
        price > 0;
  }

  void _setSellUnits(int value) {
    final clamped = value.clamp(0, widget.seed.availableUnits);
    final text = clamped.toString();
    _sellUnitsController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() {});
  }

  void _increaseUnits() {
    final current = _sellUnits ?? 0;
    if (current >= widget.seed.availableUnits) {
      return;
    }
    _setSellUnits(current + 1);
  }

  void _decreaseUnits() {
    final current = _sellUnits ?? 0;
    if (current <= 1) {
      _setSellUnits(0);
      return;
    }
    _setSellUnits(current - 1);
  }

  String get _sampleDocumentUrl {
    final oaApiBaseUrl = ref.read(oaApiBaseUrlProvider);
    return _buildSampleContractUrl(oaApiBaseUrl);
  }

  void _openContractSample(BuildContext context) {
    final l10n = context.l10n;
    openAppPdfViewer(
      context,
      url: _sampleDocumentUrl,
      title: l10n.myPageResaleAgreementSampleLabel,
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
    final draft = MyPageSecondaryMarketSellDraft(
      projectId: widget.seed.projectId,
      projectName: widget.seed.projectName,
      fromProcessId: widget.seed.fromProcessId,
      availableUnits: widget.seed.availableUnits,
      sellNum: _sellUnits!,
      price: _price!,
      investorCode: widget.seed.investorCode,
      earningRatio: widget.seed.earningRatio,
      agreed: _agreed,
    );
    context.push('/my/secondary-market/sell/confirm', extra: draft);
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
    final draftPreview = MyPageSecondaryMarketSellDraft(
      projectId: widget.seed.projectId,
      projectName: widget.seed.projectName,
      fromProcessId: widget.seed.fromProcessId,
      availableUnits: widget.seed.availableUnits,
      sellNum: _sellUnits ?? 0,
      price: _price ?? 0,
      investorCode: widget.seed.investorCode,
      earningRatio: widget.seed.earningRatio,
      agreed: _agreed,
    );
    final formulaValue =
        '${_sellUnits ?? 0}${l10n.myPageResaleUnitsSuffix} × ${formatter.format(_price ?? 0)}';

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
        amountValue: formatter.format(draftPreview.netAmount),
        helperText: _isValid ? null : l10n.myPageResaleValidationMessage,
        primaryLabel: l10n.myPageResaleConfirmButton,
        onPrimaryPressed: _isValid ? _goConfirm : null,
        primaryBackgroundColor: colors.danger,
        primaryShadowColor: colors.danger.withValues(alpha: 0.36),
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
                  title: l10n.myPageResaleFlowOrderTitle,
                  subtitle: l10n.myPageResaleFlowOrderSubtitle,
                  orderLabel: l10n.myPageResaleTabOrder,
                  confirmLabel: l10n.secondaryMarketTradeTabConfirm,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeSellEntryCard(
                  title: l10n.myPageResaleSellUnitsLabel,
                  subtitle: l10n.myPageResaleQuantityHint,
                  availabilityLabel: l10n.myPageResaleAvailableUnitsLabel,
                  priceLabel: l10n.myPageResaleUnitPriceLabel,
                  formulaLabel: l10n.myPageResaleLiveEstimateFormulaLabel,
                  formulaValue: formulaValue,
                  totalLabel: l10n.myPageResaleTotalAmountLabel,
                  totalValue: formatter.format(draftPreview.totalAmount),
                  feeLabel: l10n.myPageResaleFeeAmountLabel,
                  feeValue: formatter.format(draftPreview.feeAmount),
                  netLabel: l10n.myPageResaleNetAmountLabel,
                  netValue: formatter.format(draftPreview.netAmount),
                  quantityController: _sellUnitsController,
                  priceController: _priceController,
                  selectedUnits: _sellUnits ?? 0,
                  availableUnits: widget.seed.availableUnits,
                  unitLabel: l10n.myPageResaleUnitsSuffix,
                  priceUnitLabel: l10n.myPageResaleYenSuffix,
                  maxChipLabel: l10n.myPageResaleQuickMax,
                  onQuantityChanged: (_) => setState(() {}),
                  onPriceChanged: (_) => setState(() {}),
                  onDecrease: widget.seed.availableUnits > 0
                      ? _decreaseUnits
                      : null,
                  onIncrease: widget.seed.availableUnits > 0
                      ? _increaseUnits
                      : null,
                  onSelectPreset: _setSellUnits,
                  enabled: widget.seed.availableUnits > 0,
                  validationMessage: _isValid
                      ? null
                      : l10n.myPageResaleValidationMessage,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeAgreementCard(
                  title: l10n.myPageResaleAgreementSectionTitle,
                  body: l10n.myPageResaleAgreementBody,
                  agreed: _agreed,
                  onChanged: (bool value) {
                    setState(() {
                      _agreed = value;
                    });
                  },
                  documentLabel: l10n.myPageResaleAgreementSampleLabel,
                  documentActionLabel: l10n.secondaryMarketDocumentOpenAction,
                  documentAvailable: true,
                  onOpenDocument: () => _openContractSample(context),
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

String _buildSampleContractUrl(String oaApiBaseUrl) {
  final uri = Uri.tryParse(oaApiBaseUrl);
  if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) {
    return 'https://testoa.gutingjun.com/keiyakusho.pdf';
  }
  final origin =
      '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  return '$origin/keiyakusho.pdf';
}
