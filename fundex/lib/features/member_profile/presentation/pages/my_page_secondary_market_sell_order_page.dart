import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../investment/presentation/providers/fund_project_providers.dart';
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

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint(
        '[SecondaryMarketSellOrder] projectId=${widget.seed.projectId} '
        'processId=${widget.seed.fromProcessId} '
        'sellLimit=${widget.seed.availableUnits}',
      );
    }
    _sellUnitsController = TextEditingController(
      text: widget.seed.availableUnits > 0 ? '1' : '0',
    );
  }

  @override
  void dispose() {
    _sellUnitsController.dispose();
    super.dispose();
  }

  int? get _sellUnits => int.tryParse(_sellUnitsController.text.trim());

  bool _isValid(int? price) {
    final sellUnits = _sellUnits;
    final hasProcessId = widget.seed.fromProcessId.trim().isNotEmpty;
    return hasProcessId &&
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

  void _goConfirm(int price) {
    if (!_isValid(price)) {
      return;
    }
    final draft = MyPageSecondaryMarketSellDraft(
      projectId: widget.seed.projectId,
      projectName: widget.seed.projectName,
      fromProcessId: widget.seed.fromProcessId,
      availableUnits: widget.seed.availableUnits,
      sellNum: _sellUnits!,
      price: price,
      investorCode: widget.seed.investorCode,
      earningRatio: widget.seed.earningRatio,
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
    final presetPrice = widget.seed.initialUnitPrice;
    final needsPrice = presetPrice == null || presetPrice <= 0;
    final projectProvider = fundProjectDetailProvider(widget.seed.projectId);
    final project = needsPrice ? ref.watch(projectProvider) : null;
    final price = needsPrice
        ? project?.asData?.value.investmentUnit
        : presetPrice;
    final hasPrice = price != null && price > 0;
    final units = _sellUnits ?? 0;
    final total = hasPrice ? formatter.format(units * price) : '—';
    final formulaValue = hasPrice
        ? '$units${l10n.myPageResaleUnitsSuffix} × ${formatter.format(price)}'
        : '—';
    final valid = _isValid(price);

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
        amountValue: total,
        helperText: hasPrice && !valid
            ? l10n.myPageResaleValidationMessage
            : null,
        primaryLabel: l10n.myPageResaleConfirmButton,
        onPrimaryPressed: valid ? () => _goConfirm(price!) : null,
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

                  orderLabel: l10n.myPageResaleTabOrder,
                  confirmLabel: l10n.secondaryMarketTradeTabConfirm,
                ),
                const SizedBox(height: 14),
                if (!hasPrice)
                  if (project?.isLoading == true)
                    const LinearProgressIndicator()
                  else
                    Column(
                      children: [
                        Text(l10n.myPageResalePriceUnavailable),
                        TextButton(
                          onPressed: () => ref.invalidate(projectProvider),
                          child: Text(l10n.commonRetry),
                        ),
                      ],
                    ),
                SecondaryMarketTradeOrderForm(
                  title: l10n.myPageResaleSellUnitsLabel,
                  availabilityLabel: l10n.myPageResaleAvailableUnitsLabel,
                  formulaLabel: l10n.myPageResaleLiveEstimateFormulaLabel,
                  formulaValue: formulaValue,
                  paymentLabel: l10n.myPageResaleNetAmountLabel,
                  paymentValue: total,
                  controller: _sellUnitsController,
                  selectedUnits: units,
                  availableUnits: widget.seed.availableUnits,
                  unitLabel: l10n.myPageResaleUnitsSuffix,
                  maxChipLabel: l10n.myPageResaleQuickMax,
                  onChanged: (_) => setState(() {}),
                  onDecrease: units > 1 ? () => _setSellUnits(units - 1) : null,
                  onIncrease: units < widget.seed.availableUnits
                      ? () => _setSellUnits(units + 1)
                      : null,
                  onSelectPreset: _setSellUnits,
                  enabled: widget.seed.availableUnits > 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
