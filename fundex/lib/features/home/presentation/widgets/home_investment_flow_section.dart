import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HomeInvestmentFlowSection extends StatelessWidget {
  const HomeInvestmentFlowSection({
    super.key,
    required this.title,
    required this.steps,
  });

  final String title;
  final List<HomeInvestmentFlowStepData> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.appTextTheme.heroMetricSecondary),
        const SizedBox(height: UiTokens.spacing12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var index = 0; index < steps.length; index++) ...<Widget>[
              Expanded(child: _HomeInvestmentFlowCard(data: steps[index])),
              if (index < steps.length - 1)
                Icon(
                  Icons.play_arrow_rounded,
                  size: 24,
                  color: colors.highlightGold,
                ),
            ],
          ],
        ),
      ],
    );
  }
}

class HomeInvestmentFlowStepData {
  const HomeInvestmentFlowStepData({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.body,
  });

  final int stepNumber;
  final IconData icon;
  final String title;
  final String body;
}

class _HomeInvestmentFlowCard extends StatelessWidget {
  const _HomeInvestmentFlowCard({required this.data});

  final HomeInvestmentFlowStepData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      height: 146,
      padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.primarySubtle),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: 0,
            top: -4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors.highlightGold,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${data.stepNumber}',
                style: appText.caption.copyWith(
                  color: colors.onDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(data.icon, size: 32, color: colors.primary),
              const SizedBox(height: 8),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: appText.bodyStrong.copyWith(
                  color: colors.primary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.body,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: appText.body.copyWith(
                  color: colors.textSecondary,
                  height: 1.35,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
