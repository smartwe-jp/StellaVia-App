import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
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
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.myPageResaleSubmitFailure);
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
                  onPressed: _isSubmitting ? null : () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l10n.myPageResaleBackButton),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryCtaButton(
                  label: l10n.myPageResaleSubmitButton,
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                  fullWidth: false,
                  height: 48,
                  horizontalPadding: 0,
                  backgroundColor: colors.danger,
                  shadowColor: colors.danger.withValues(alpha: 0.5),
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
          _ResaleSegmentHeader(
            current: _ResaleStep.confirm,
            orderLabel: l10n.myPageResaleTabOrder,
            confirmLabel: l10n.myPageResaleTabConfirm,
          ),
          const SizedBox(height: 12),
          _ResaleTableRow(
            label: l10n.myPageResaleFundNameLabel,
            value: Text(widget.draft.projectName),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleInvestorTypeLabel,
            value: Text(
              _buildInvestorTypeText(
                l10n,
                investorCode: widget.draft.investorCode,
                earningRatio: widget.draft.earningRatio,
              ),
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleOrderMethodLabel,
            value: Text(l10n.myPageResaleOrderMethodValue),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleAvailableUnitsLabel,
            value: Text(widget.draft.availableUnits.toString()),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleSellUnitsLabel,
            value: Text(
              '${widget.draft.sellNum}${l10n.myPageResaleUnitsSuffix}',
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleUnitPriceLabel,
            value: Text(
              '${formatter.format(widget.draft.price)} ${l10n.myPageResaleYenSuffix}',
            ),
          ),
          _ResaleTableRow(
            label: l10n.myPageResaleFeeLabel,
            value: Text(l10n.myPageResaleFeeValue),
          ),
          const SizedBox(height: 12),
          _PreviewCard(
            totalLabel: l10n.myPageResaleTotalAmountLabel,
            feeLabel: l10n.myPageResaleFeeAmountLabel,
            netLabel: l10n.myPageResaleNetAmountLabel,
            totalValue: formatter.format(widget.draft.totalAmount),
            feeValue: formatter.format(widget.draft.feeAmount),
            netValue: formatter.format(widget.draft.netAmount),
          ),
        ],
      ),
    );
  }
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
