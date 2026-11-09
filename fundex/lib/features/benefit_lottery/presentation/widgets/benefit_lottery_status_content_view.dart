import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/benefit_lottery_draw_controller.dart';
import '../models/benefit_lottery_models.dart';
import '../support/benefit_lottery_mock_catalog.dart';
import '../support/benefit_lottery_mock_draw_source.dart';
import '../support/benefit_lottery_status_content.dart';
import 'benefit_lottery_draw_button.dart';
import '../widgets/benefit_lottery_wheel.dart';
import 'benefit_lottery_win_dialog.dart';

class BenefitLotteryStatusContentView extends StatelessWidget {
  const BenefitLotteryStatusContentView({
    required this.content,
    required this.hasEligibility,
    required this.isEligibilityLoading,
    required this.onRefresh,
    super.key,
  });

  final BenefitLotteryStatusContent content;
  final bool hasEligibility;
  final bool isEligibilityLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: context.l10n.benefitLotteryStatusTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          key: const Key('benefit_lottery_status_back'),
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  UiTokens.spacing16,
                  UiTokens.spacing8,
                  UiTokens.spacing16,
                  UiTokens.spacing24,
                ),
                sliver: SliverList.list(
                  children: <Widget>[
                    if (hasEligibility)
                      _EligibleHeroCard(
                        isEligibilityLoading: isEligibilityLoading,
                      )
                    else ...<Widget>[
                      _LockedHeroCard(content: content.locked),
                      const SizedBox(height: UiTokens.spacing16),
                      _LockedCtaCard(content: content.locked),
                    ],
                    const SizedBox(height: UiTokens.spacing16),
                    if (hasEligibility) ...<Widget>[
                      _EvaluationCard(content: content.evaluation),
                      const SizedBox(height: UiTokens.spacing16),
                    ],
                    _PrizeListCard(
                      model: buildBenefitLotteryMockWheelModel(context.l10n),
                      notice: hasEligibility
                          ? content.prizeNotice
                          : content.lockedPrizeNotice,
                      lockedMode: !hasEligibility,
                    ),
                    if (hasEligibility) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      _HistoryCard(items: content.history),
                      const SizedBox(height: UiTokens.spacing16),
                      _RulesCard(rules: content.rules),
                    ],
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

class _EligibleHeroCard extends StatefulWidget {
  const _EligibleHeroCard({required this.isEligibilityLoading});

  final bool isEligibilityLoading;

  @override
  State<_EligibleHeroCard> createState() => _EligibleHeroCardState();
}

class _EligibleHeroCardState extends State<_EligibleHeroCard> {
  BenefitLotteryWheelModel? _model;
  BenefitLotteryDrawController? _controller;
  final BenefitLotteryMockDrawSource _drawSource =
      BenefitLotteryMockDrawSource();
  bool _isPresentingWin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextModel = buildBenefitLotteryMockWheelModel(context.l10n);
    final currentModel = _model;
    if (currentModel != null) {
      if (_samePrizeIds(currentModel, nextModel)) {
        return;
      }
      _controller
        ?..removeListener(_handleDrawStateChanged)
        ..dispose();
    }
    _model = nextModel;
    _controller = BenefitLotteryDrawController(model: nextModel)
      ..addListener(_handleDrawStateChanged);
  }

  bool _samePrizeIds(
    BenefitLotteryWheelModel left,
    BenefitLotteryWheelModel right,
  ) {
    if (left.prizes.length != right.prizes.length) {
      return false;
    }
    for (var index = 0; index < left.prizes.length; index++) {
      if (left.prizes[index].id != right.prizes[index].id) {
        return false;
      }
    }
    return true;
  }

  void _handleDrawStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller
      ?..removeListener(_handleDrawStateChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _draw() async {
    final controller = _controller;
    final model = _model;
    if (controller == null || model == null) {
      return;
    }
    try {
      await controller.draw(() => _drawSource.draw(model));
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: context.l10n.benefitLotteryDrawFailed);
    }
  }

  String _drawActionLabel() {
    final l10n = context.l10n;
    return switch (_controller?.phase) {
      BenefitLotteryDrawPhase.requesting => l10n.benefitLotteryRequestingAction,
      BenefitLotteryDrawPhase.spinning => l10n.benefitLotterySpinningAction,
      _ => l10n.benefitLotterySpinAction,
    };
  }

  Future<void> _handleSpinCompleted(BenefitLotteryPrize prize) async {
    if (prize.isNoWin || _isPresentingWin) {
      return;
    }
    setState(() => _isPresentingWin = true);
    final confirmed = await showBenefitLotteryWinPresentation(
      context,
      prize: prize,
    );
    if (!mounted) {
      return;
    }
    if (confirmed) {
      context.go('/hotel-booking/coupons');
      return;
    }
    setState(() => _isPresentingWin = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }
    final isBusy =
        controller.isBusy || widget.isEligibilityLoading || _isPresentingWin;

    return _StatusCard(
      padding: const EdgeInsets.fromLTRB(
        UiTokens.spacing16,
        UiTokens.spacing24,
        UiTokens.spacing16,
        UiTokens.spacing20,
      ),
      background: BoxDecoration(
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroMiddle, colors.heroStart],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.28),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            context.l10n.benefitLotteryStatusHeroEyebrow,
            style: appText.micro.copyWith(
              color: BenefitLotteryWheelPalette.stellaVia.middleRingColor,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(
            context.l10n.benefitLotteryStatusHeroTitle,
            style: appText.sectionTitle.copyWith(
              color: colors.onDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          _WheelStage(
            size: 235,
            shadowColor: colors.scrim.withValues(alpha: 0.40),
            child: BenefitLotteryWheel(
              controller: controller,
              centerLabel: context.l10n.benefitLotteryCenterLabel,
              size: 235,
              onSpinCompleted: _handleSpinCompleted,
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          BenefitLotteryDrawButton(
            key: const Key('benefit_lottery_status_draw_action'),
            label: _drawActionLabel(),
            isLoading: isBusy,
            onPressed: _draw,
          ),
          const SizedBox(height: UiTokens.spacing12),
          Text(
            context.l10n.benefitLotteryStatusHeroCaption,
            style: appText.micro.copyWith(
              color: colors.onDark.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedHeroCard extends StatefulWidget {
  const _LockedHeroCard({required this.content});

  final BenefitLotteryLockedContent content;

  @override
  State<_LockedHeroCard> createState() => _LockedHeroCardState();
}

class _LockedHeroCardState extends State<_LockedHeroCard> {
  BenefitLotteryDrawController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = buildBenefitLotteryMockWheelModel(context.l10n);
    _controller ??= BenefitLotteryDrawController(model: model);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return _StatusCard(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiTokens.spacing12),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0.48,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    colors.brandNeutral,
                    BlendMode.saturation,
                  ),
                  child: BenefitLotteryWheel(
                    controller: controller,
                    centerLabel: context.l10n.benefitLotteryCenterLabel,
                    size: 200,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.heroStart.withValues(alpha: 0.90),
                  border: Border.all(
                    color: BenefitLotteryWheelPalette.stellaVia.middleRingColor
                        .withValues(alpha: 0.42),
                  ),
                ),
                child: SizedBox.square(
                  dimension: 78,
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: BenefitLotteryWheelPalette.stellaVia.middleRingColor,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing12),
          Text(
            widget.content.title,
            textAlign: TextAlign.center,
            style: appText.cardTitle.copyWith(
              color: colors.heroStart,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(
            widget.content.body,
            textAlign: TextAlign.center,
            style: appText.body.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _LockedCtaCard extends StatelessWidget {
  const _LockedCtaCard({required this.content});

  final BenefitLotteryLockedContent content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiTokens.spacing20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        color: colors.primaryAlt.withValues(alpha: 0.18),
        border: Border.all(color: colors.primaryAlt.withValues(alpha: 0.45)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            content.ctaEyebrow,
            style: appText.micro.copyWith(
              color: colors.heroStart,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(
            content.ctaTitle,
            textAlign: TextAlign.center,
            style: appText.cardTitle.copyWith(
              color: colors.heroStart,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(
            content.ctaBody,
            textAlign: TextAlign.center,
            style: appText.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: UiTokens.spacing16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/funds'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.heroStart,
                foregroundColor: colors.onDark,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UiTokens.radius20),
                ),
              ),
              child: Text(context.l10n.benefitLotteryStatusFindFundsAction),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  const _EvaluationCard({required this.content});

  final BenefitLotteryEvaluationContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return _StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: l10n.benefitLotteryStatusEvaluationTitle),
          Text(
            content.description,
            style: appText.body.copyWith(
              color: colors.textPrimary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: UiTokens.spacing16),
          GridView.builder(
            itemCount: content.factors.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: UiTokens.spacing12,
              crossAxisSpacing: UiTokens.spacing12,
              childAspectRatio: 2.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _EvaluationFactorTile(
                factor: content.factors[index],
                icon: _factorIcon(index),
              );
            },
          ),
          const SizedBox(height: UiTokens.spacing12),
          Container(
            padding: const EdgeInsets.all(UiTokens.spacing12),
            decoration: BoxDecoration(
              color: colors.primaryAlt.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(UiTokens.radius14),
            ),
            child: Text(
              content.note,
              style: appText.micro.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _factorIcon(int index) {
    return switch (index) {
      0 => Icons.currency_yen_rounded,
      1 => Icons.calendar_month_rounded,
      2 => Icons.savings_outlined,
      _ => Icons.groups_2_outlined,
    };
  }
}

class _EvaluationFactorTile extends StatelessWidget {
  const _EvaluationFactorTile({required this.factor, required this.icon});

  final BenefitLotteryEvaluationFactorContent factor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.all(UiTokens.spacing12),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(UiTokens.radius14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.primaryAlt.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(UiTokens.radius12),
            ),
            child: SizedBox.square(
              dimension: 36,
              child: Icon(icon, color: colors.infoForeground, size: 20),
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  factor.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appText.chip.copyWith(
                    color: colors.heroStart,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  factor.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appText.micro.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrizeListCard extends StatelessWidget {
  const _PrizeListCard({
    required this.model,
    required this.notice,
    required this.lockedMode,
  });

  final BenefitLotteryWheelModel model;
  final String notice;
  final bool lockedMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final visiblePrizes = model.prizes.where((prize) => !prize.isNoWin);
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return _StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(
            title: lockedMode
                ? l10n.benefitLotteryStatusPrizeExampleTitle
                : l10n.benefitLotteryStatusPrizeListTitle,
          ),
          for (final prize in visiblePrizes)
            _PrizeRow(
              prize: prize,
              subtitle: lockedMode
                  ? l10n.benefitLotteryStatusPrizeLockedSubtitle
                  : l10n.benefitLotteryStatusPrizeSubtitle,
            ),
          const SizedBox(height: UiTokens.spacing8),
          Container(
            padding: const EdgeInsets.all(UiTokens.spacing12),
            decoration: BoxDecoration(
              color: colors.primaryAlt.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(UiTokens.radius14),
            ),
            child: Text(
              notice,
              style: Theme.of(context).appTextTheme.micro.copyWith(
                color: Theme.of(context).appColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrizeRow extends StatelessWidget {
  const _PrizeRow({required this.prize, required this.subtitle});

  final BenefitLotteryPrize prize;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final grade = _gradeFromPrize(prize);

    return _DividerRow(
      child: Row(
        children: <Widget>[
          _GradeChip(grade: grade),
          const SizedBox(width: UiTokens.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.benefitLotteryStatusPrizeName(grade),
                  style: Theme.of(context).appTextTheme.chip.copyWith(
                    color: Theme.of(context).appColors.heroStart,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).appTextTheme.micro.copyWith(
                    color: Theme.of(context).appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            context.l10n.benefitLotteryStatusApproxAmount(
              formatter.format(prize.price),
            ),
            style: Theme.of(context).appTextTheme.bodyStrong.copyWith(
              color: Theme.of(context).appColors.infoForeground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.items});

  final List<BenefitLotteryHistoryItemContent> items;

  @override
  Widget build(BuildContext context) {
    return _StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: context.l10n.benefitLotteryStatusHistoryTitle),
          for (final item in items) _HistoryRow(item: item),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});

  final BenefitLotteryHistoryItemContent item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return _DividerRow(
      onTap: item.isAvailable
          ? () => context.go('/hotel-booking/stay-benefits')
          : null,
      child: Row(
        children: <Widget>[
          _GradeChip(grade: item.grade),
          const SizedBox(width: UiTokens.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: appText.chip.copyWith(
                    color: colors.heroStart,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: appText.micro.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          _HistoryStatusBadge(item: item),
          if (item.isAvailable) ...<Widget>[
            const SizedBox(width: UiTokens.spacing4),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: colors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryStatusBadge extends StatelessWidget {
  const _HistoryStatusBadge({required this.item});

  final BenefitLotteryHistoryItemContent item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final foreground = switch (item.tone) {
      'available' => colors.success,
      'used' => colors.textSecondary,
      'expired' => colors.danger,
      _ => colors.textSecondary,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(UiTokens.radius20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiTokens.spacing8,
          vertical: UiTokens.spacing4,
        ),
        child: Text(
          item.status,
          style: appText.micro.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return _StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: context.l10n.benefitLotteryStatusRulesTitle),
          for (var index = 0; index < rules.length; index++)
            _RuleRow(index: index + 1, body: rules[index]),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.index, required this.body});

  final int index;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: UiTokens.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.heroStart,
            ),
            child: SizedBox.square(
              dimension: 24,
              child: Center(
                child: Text(
                  '$index',
                  style: appText.micro.copyWith(
                    color: colors.onDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: UiTokens.spacing12),
          Expanded(
            child: Text(
              body,
              style: appText.body.copyWith(
                color: colors.textPrimary,
                height: 1.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: UiTokens.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            title,
            style: appText.cardTitle.copyWith(
              color: colors.heroStart,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.child,
    this.padding = const EdgeInsets.all(UiTokens.spacing16),
    this.background,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? background;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration:
          background ??
          BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(UiTokens.radius20),
            border: Border.all(color: colors.border),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.heroStart.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
      child: child,
    );
  }
}

class _DividerRow extends StatelessWidget {
  const _DividerRow({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: UiTokens.spacing12),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GradeChip extends StatelessWidget {
  const _GradeChip({required this.grade});

  final String grade;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final background = switch (grade.toUpperCase()) {
      'S' => colors.primary,
      'A' => colors.success,
      'B' => colors.info,
      'C' => colors.communitySecondary,
      _ => colors.brandNeutral,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(UiTokens.radius8),
      ),
      child: SizedBox.square(
        dimension: 30,
        child: Center(
          child: Text(
            grade,
            style: appText.bodyStrong.copyWith(
              color: colors.onDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _WheelStage extends StatelessWidget {
  const _WheelStage({
    required this.size,
    required this.shadowColor,
    required this.child,
  });

  final double size;
  final Color shadowColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
                      color: shadowColor,
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

class BenefitLotteryStatusLoadError extends StatelessWidget {
  const BenefitLotteryStatusLoadError({
    required this.onRetry,
    required this.onBack,
    super.key,
  });

  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiTokens.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.l10n.fundListLoadError,
              textAlign: TextAlign.center,
              style: Theme.of(context).appTextTheme.body.copyWith(
                color: Theme.of(context).appColors.textSecondary,
              ),
            ),
            const SizedBox(height: UiTokens.spacing12),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(context.l10n.fundListRetry),
            ),
            const SizedBox(height: UiTokens.spacing4),
            TextButton(onPressed: onBack, child: Text(context.l10n.commonBack)),
          ],
        ),
      ),
    );
  }
}

String _gradeFromPrize(BenefitLotteryPrize prize) {
  final normalized = prize.id.trim();
  if (normalized.length == 1) {
    return normalized.toUpperCase();
  }
  final title = prize.title.trim();
  return title.isEmpty ? '' : title[0].toUpperCase();
}
