import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_localizations_ext.dart';
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
  final TextEditingController _sellUnitsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(
    text: '1000000',
  );

  bool _agreed = false;

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

  void _openContractSample(BuildContext context) {
    final oaApiBaseUrl = ref.read(oaApiBaseUrlProvider);
    final url = _buildSampleContractUrl(oaApiBaseUrl);
    final l10n = context.l10n;
    openAppPdfViewer(
      context,
      url: url,
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
    final appText = theme.appTextTheme;
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPageResaleOrderTitle)),
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
                  label: l10n.myPageResaleConfirmButton,
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
          _ResaleSegmentHeader(
            current: _ResaleStep.order,
            orderLabel: l10n.myPageResaleTabOrder,
            confirmLabel: l10n.myPageResaleTabConfirm,
          ),
          const SizedBox(height: 12),
          _ResaleTableRow(
            label: l10n.myPageResaleFundNameLabel,
            value: Text(
              widget.seed.projectName,
              style: appText.bodyStrong.copyWith(color: colors.primary),
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleInvestorTypeLabel,
            value: Text(
              _buildInvestorTypeText(
                l10n,
                investorCode: widget.seed.investorCode,
                earningRatio: widget.seed.earningRatio,
              ),
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleOrderMethodLabel,
            value: Text(l10n.myPageResaleOrderMethodValue),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleAvailableUnitsLabel,
            value: Text(widget.seed.availableUnits.toString()),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleSellUnitsLabel,
            value: _UnitInputField(
              controller: _sellUnitsController,
              unitLabel: l10n.myPageResaleUnitsSuffix,
              onChanged: (_) => setState(() {}),
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleUnitPriceLabel,
            value: _UnitInputField(
              controller: _priceController,
              unitLabel: l10n.myPageResaleYenSuffix,
              onChanged: (_) => setState(() {}),
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleFeeLabel,
            value: Text(l10n.myPageResaleFeeValue),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleAgreementLabel,
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
                        child: Text(l10n.myPageResaleAgreementBody),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _openContractSample(context),
                  child: Text(l10n.myPageResaleAgreementSampleLabel),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _PreviewCard(
            totalLabel: l10n.myPageResaleTotalAmountLabel,
            feeLabel: l10n.myPageResaleFeeAmountLabel,
            netLabel: l10n.myPageResaleNetAmountLabel,
            totalValue: formatter.format(draftPreview.totalAmount),
            feeValue: formatter.format(draftPreview.feeAmount),
            netValue: formatter.format(draftPreview.netAmount),
          ),
          if (!_isValid)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l10n.myPageResaleValidationMessage,
                style: appText.caption.copyWith(color: colors.danger),
              ),
            ),
        ],
      ),
    );
  }
}

String _buildInvestorTypeText(
  dynamic l10n, {
  required String? investorCode,
  required double? earningRatio,
}) {
  final code = investorCode?.trim();
  final ratio = earningRatio == null
      ? '--'
      : '${(earningRatio * 100).toStringAsFixed(2)}%';
  if (code == null || code.isEmpty) {
    return l10n.myPageResaleInvestorTypeFallback(ratio);
  }
  return '$code\n${l10n.myPageResaleFixedYieldLabel(ratio)}';
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

enum _ResaleStep { order, confirm }

class _ResaleSegmentHeader extends StatelessWidget {
  const _ResaleSegmentHeader({
    required this.current,
    required this.orderLabel,
    required this.confirmLabel,
  });

  final _ResaleStep current;
  final String orderLabel;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _ResaleSegmentChip(
          label: orderLabel,
          selected: current == _ResaleStep.order,
        ),
        const SizedBox(width: 8),
        _ResaleSegmentChip(
          label: confirmLabel,
          selected: current == _ResaleStep.confirm,
        ),
      ],
    );
  }
}

class _ResaleSegmentChip extends StatelessWidget {
  const _ResaleSegmentChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? colors.infoSubtle : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: appText.chip.copyWith(
          color: selected ? colors.primary : colors.textSecondary,
        ),
      ),
    );
  }
}

class _ResaleTableRow extends StatelessWidget {
  const _ResaleTableRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: colors.border),
          right: BorderSide(color: colors.border),
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 120,
              padding: const EdgeInsets.all(12),
              color: colors.surfaceAlt,
              alignment: Alignment.centerLeft,
              child: Text(label, style: appText.bodyStrong),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Align(alignment: Alignment.centerLeft, child: value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitInputField extends StatelessWidget {
  const _UnitInputField({
    required this.controller,
    required this.unitLabel,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String unitLabel;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          unitLabel,
          style: appText.bodyMuted.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.totalLabel,
    required this.feeLabel,
    required this.netLabel,
    required this.totalValue,
    required this.feeValue,
    required this.netValue,
  });

  final String totalLabel;
  final String feeLabel;
  final String netLabel;
  final String totalValue;
  final String feeValue;
  final String netValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.infoSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.infoBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            _previewRow(context, totalLabel, totalValue),
            const SizedBox(height: 6),
            _previewRow(context, feeLabel, feeValue),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _previewRow(
              context,
              netLabel,
              netValue,
              valueStyle: appText.numericTitle.copyWith(color: colors.danger),
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewRow(
    BuildContext context,
    String label,
    String value, {
    TextStyle? valueStyle,
  }) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: appText.bodyMuted.copyWith(color: colors.textSecondary),
          ),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}
