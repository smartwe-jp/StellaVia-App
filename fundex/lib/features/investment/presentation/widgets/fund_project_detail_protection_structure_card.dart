import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundProjectDetailProtectionStructureData {
  const FundProjectDetailProtectionStructureData({
    required this.primaryLabel,
    required this.primaryRatio,
    required this.secondaryLabel,
    required this.secondaryRatio,
  });

  final String primaryLabel;
  final double primaryRatio;
  final String secondaryLabel;
  final double secondaryRatio;
}

class FundProjectDetailProtectionStructureCard extends StatelessWidget {
  const FundProjectDetailProtectionStructureCard({
    super.key,
    required this.data,
  });

  final FundProjectDetailProtectionStructureData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return FundDetailContentCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 24,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: (data.primaryRatio * 1000).round().clamp(1, 999),
                    child: Container(
                      color: colors.primary,
                      alignment: Alignment.center,
                      child: Text(
                        '${data.primaryLabel} ${(data.primaryRatio * 100).round()}%',
                        style: appText.micro.copyWith(
                          color: colors.onDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (data.secondaryRatio * 1000).round().clamp(1, 999),
                    child: Container(
                      color: colors.warning,
                      alignment: Alignment.center,
                      child: Text(
                        '${data.secondaryLabel} ${(data.secondaryRatio * 100).round()}%',
                        style: appText.micro.copyWith(
                          color: colors.onDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  data.primaryLabel,
                  style: appText.caption.copyWith(color: colors.textSecondary),
                ),
              ),
              Text(
                data.secondaryLabel,
                style: appText.caption.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
