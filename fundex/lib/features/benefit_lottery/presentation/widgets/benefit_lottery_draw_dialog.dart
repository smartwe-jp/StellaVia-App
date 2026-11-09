import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/benefit_lottery_draw_controller.dart';
import '../models/benefit_lottery_models.dart';
import 'benefit_lottery_draw_button.dart';
import 'benefit_lottery_wheel.dart';
import 'benefit_lottery_win_dialog.dart';

Future<void> showBenefitLotteryDrawDialog(
  BuildContext context, {
  required BenefitLotteryWheelModel model,
  required BenefitLotteryDrawRequest drawRequest,
  VoidCallback? onDetailsTap,
  VoidCallback? onCouponsTap,
  BenefitLotteryWinPresenter winPresenter = showBenefitLotteryWinPresentation,
}) {
  final colors = Theme.of(context).appColors;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: colors.scrim.withValues(alpha: 0.58),
    builder: (BuildContext dialogContext) {
      return BenefitLotteryDrawDialog(
        model: model,
        drawRequest: drawRequest,
        onDetailsTap: onDetailsTap,
        onCouponsTap: onCouponsTap,
        winPresenter: winPresenter,
      );
    },
  );
}

class BenefitLotteryDrawDialog extends StatefulWidget {
  const BenefitLotteryDrawDialog({
    super.key,
    required this.model,
    required this.drawRequest,
    this.onDetailsTap,
    this.onCouponsTap,
    this.winPresenter = showBenefitLotteryWinPresentation,
  });

  final BenefitLotteryWheelModel model;
  final BenefitLotteryDrawRequest drawRequest;
  final VoidCallback? onDetailsTap;
  final VoidCallback? onCouponsTap;
  final BenefitLotteryWinPresenter winPresenter;

  @override
  State<BenefitLotteryDrawDialog> createState() =>
      _BenefitLotteryDrawDialogState();
}

class _BenefitLotteryDrawDialogState extends State<BenefitLotteryDrawDialog> {
  late final BenefitLotteryDrawController _controller =
      BenefitLotteryDrawController(model: widget.model)
        ..addListener(_handleDrawStateChanged);
  bool _isPresentingWin = false;

  @override
  void dispose() {
    _controller
      ..removeListener(_handleDrawStateChanged)
      ..dispose();
    super.dispose();
  }

  void _handleDrawStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _startDraw() async {
    try {
      await _controller.draw(widget.drawRequest);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: context.l10n.benefitLotteryDrawFailed);
    }
  }

  void _handlePrimaryAction() {
    switch (_controller.phase) {
      case BenefitLotteryDrawPhase.idle:
      case BenefitLotteryDrawPhase.failed:
      case BenefitLotteryDrawPhase.completed:
        _startDraw();
      case BenefitLotteryDrawPhase.requesting:
      case BenefitLotteryDrawPhase.spinning:
        break;
    }
  }

  void _handleDetailsAction() {
    Navigator.of(context).pop();
    widget.onDetailsTap?.call();
  }

  Future<void> _handleSpinCompleted(BenefitLotteryPrize prize) async {
    if (prize.isNoWin || _isPresentingWin) {
      return;
    }
    setState(() => _isPresentingWin = true);
    final confirmed = await widget.winPresenter(context, prize: prize);
    if (!mounted) {
      return;
    }
    if (confirmed) {
      Navigator.of(context).pop();
      widget.onCouponsTap?.call();
      return;
    }
    setState(() => _isPresentingWin = false);
  }

  String _primaryActionLabel() {
    final l10n = context.l10n;
    return switch (_controller.phase) {
      BenefitLotteryDrawPhase.idle ||
      BenefitLotteryDrawPhase.failed => l10n.benefitLotterySpinAction,
      BenefitLotteryDrawPhase.requesting => l10n.benefitLotteryRequestingAction,
      BenefitLotteryDrawPhase.spinning => l10n.benefitLotterySpinningAction,
      BenefitLotteryDrawPhase.completed => l10n.benefitLotterySpinAction,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isBusy = _controller.isBusy || _isPresentingWin;

    return Dialog(
      key: const Key('benefit_lottery_draw_dialog'),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: UiTokens.spacing16,
        vertical: UiTokens.spacing24,
      ),
      backgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      shadowColor: colors.scrim.withValues(alpha: 0.36),
      elevation: 18,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiTokens.radius20),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            UiTokens.spacing16,
            UiTokens.spacing16,
            UiTokens.spacing16,
            UiTokens.spacing20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _DialogHeader(
                title: context.l10n.benefitLotteryDialogTitle,
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: UiTokens.spacing12),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final wheelSize = constraints.maxWidth.clamp(220.0, 280.0);
                  return _DialogWheelStage(
                    size: wheelSize,
                    child: BenefitLotteryWheel(
                      controller: _controller,
                      centerLabel: context.l10n.benefitLotteryCenterLabel,
                      size: wheelSize,
                      onSpinCompleted: _handleSpinCompleted,
                    ),
                  );
                },
              ),
              const SizedBox(height: UiTokens.spacing12),
              _PrizeLegend(model: widget.model),
              const SizedBox(height: UiTokens.spacing12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: UiTokens.spacing12,
                  vertical: UiTokens.spacing8,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryAlt.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(UiTokens.radius8),
                ),
                child: Text(
                  context.l10n.benefitLotteryDisclaimer,
                  style: appText.micro.copyWith(
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: UiTokens.spacing12),
              BenefitLotteryDrawButton(
                key: const Key('benefit_lottery_primary_action'),
                label: _primaryActionLabel(),
                isLoading: isBusy,
                onPressed: _handlePrimaryAction,
              ),
              const SizedBox(height: UiTokens.spacing8),
              TextButton(
                onPressed: _handleDetailsAction,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      context.l10n.benefitLotteryDetailsAction,
                      style: appText.link.copyWith(color: colors.heroStart),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: colors.heroStart,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogWheelStage extends StatelessWidget {
  const _DialogWheelStage({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(size * 0.045),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.scrim.withValues(alpha: 0.40),
                      blurRadius: size * 0.16,
                      offset: Offset(0, size * 0.07),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return SizedBox(
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appText.cardTitle.copyWith(
                color: colors.heroStart,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              key: const Key('benefit_lottery_close_action'),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 30, height: 30),
              style: IconButton.styleFrom(
                foregroundColor: colors.heroStart,
                backgroundColor: colors.surface,
                side: BorderSide(color: colors.border),
              ),
              icon: const Icon(Icons.close_rounded, size: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrizeLegend extends StatelessWidget {
  const _PrizeLegend({required this.model});

  final BenefitLotteryWheelModel model;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final priceFormatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    const wheelPalette = BenefitLotteryWheelPalette.stellaVia;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final columnCount = model.prizes.length <= 4 ? model.prizes.length : 3;
        const spacing = UiTokens.spacing8;
        final itemWidth =
            (constraints.maxWidth - spacing * (columnCount - 1)) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            for (
              var index = 0, prizeIndex = 0;
              index < model.prizes.length;
              index++
            )
              SizedBox(
                width: itemWidth,
                child: _PrizeLegendItem(
                  prize: model.prizes[index],
                  color: model.prizes[index].isNoWin
                      ? wheelPalette.noWinColor
                      : wheelPalette.colorForPrizeIndex(prizeIndex++),
                  priceText: model.prizes[index].isNoWin
                      ? null
                      : priceFormatter.format(model.prizes[index].price),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PrizeLegendItem extends StatelessWidget {
  const _PrizeLegendItem({
    required this.prize,
    required this.color,
    required this.priceText,
  });

  final BenefitLotteryPrize prize;
  final Color color;
  final String? priceText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final foregroundColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? colors.onDark
        : colors.heroStart;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: UiTokens.spacing4,
            vertical: UiTokens.spacing8,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(UiTokens.radius8),
          ),
          child: Text(
            prize.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: appText.chip.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (priceText != null) ...<Widget>[
          const SizedBox(height: UiTokens.spacing4),
          Text(
            priceText!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: appText.micro.copyWith(color: colors.textSecondary),
          ),
        ],
      ],
    );
  }
}
