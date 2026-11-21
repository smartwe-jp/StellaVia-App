import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/fund_project_providers.dart';
import '../widgets/secondary_market_buy_documents.dart';
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
  final _opened = <TradeDocument>{};
  final _checked = <TradeDocument>{};

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

  bool _isValid(List<TradeDocument> docs) {
    final buyUnits = _buyUnits;
    return widget.seed.orderId.trim().isNotEmpty &&
        hasAllTradeDocumentTypes(docs) &&
        docs.every(_checked.contains) &&
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

  void _goConfirm(List<TradeDocument> docs) {
    if (!_isValid(docs)) {
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
      confirmedDocuments: List.unmodifiable(docs),
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
    final provider = fundProjectDetailProvider(widget.seed.projectId);
    final project = ref.watch(provider);
    final docs = requiredTradeDocuments(
      project.asData?.value.pdfDocuments ?? [],
    );
    final valid = _isValid(docs);
    final totalAmount = (_buyUnits ?? 0) * widget.seed.unitPrice;
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
        amountValue: formatter.format(totalAmount),
        helperText: valid ? null : l10n.secondaryMarketBuyValidationMessage,
        primaryLabel: l10n.secondaryMarketBuyConfirmButton,
        onPrimaryPressed: valid ? () => _goConfirm(docs) : null,
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

                  orderLabel: l10n.secondaryMarketTradeTabBuy,
                  confirmLabel: l10n.secondaryMarketTradeTabConfirm,
                ),
                const SizedBox(height: 14),
                SecondaryMarketTradeOrderForm(
                  title: l10n.secondaryMarketBuyUnitsLabel,
                  availabilityLabel: l10n.secondaryMarketBuyAvailableUnitsLabel,
                  formulaLabel: l10n.secondaryMarketBuyLiveEstimateFormulaLabel,
                  formulaValue: formulaValue,
                  paymentLabel: l10n.secondaryMarketBuyPaymentAmountLabel,
                  paymentValue: formatter.format(totalAmount),
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
                if (project.isLoading)
                  const LinearProgressIndicator()
                else
                  SecondaryMarketBuyDocuments(
                    documents: docs,
                    opened: _opened,
                    checked: _checked,
                    onOpened: (doc) => setState(() => _opened.add(doc)),
                    onChanged: (doc, checked) => setState(() {
                      if (checked) {
                        _checked.add(doc);
                      } else {
                        _checked.remove(doc);
                      }
                    }),
                    retry: () => ref.invalidate(provider),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
