import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/corporate_progress.dart';

class CorporateProgressTimeline extends StatelessWidget {
  const CorporateProgressTimeline({
    super.key,
    required this.progress,
    required this.status,
  });
  final CorporateProgress progress;
  final String status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        theme = Theme.of(context),
        colors = theme.colorScheme;
    final accent = theme.appColors.primaryAlt;
    final labels = [
      l.corpProgressSubmitted,
      l.corpProgressOriginal,
      l.corpProgressReview,
      l.corpProgressCompanyMail,
      l.corpProgressReceipt,
      l.corpProgressFinal,
    ];
    return Column(
      children: [
        for (final stage in CorporateStage.values)
          Builder(
            builder: (context) {
              final done =
                  progress.complete || stage.index < progress.current.index;
              final active = !progress.complete && stage == progress.current;
              final description = done
                  ? l.walletWithdrawRecordStatusDone
                  : active
                  ? (progress.actionRequired
                        ? l.corpProgressAction
                        : l.corporateStatus(status))
                  : l.walletHistoryPendingStatus;
              return Semantics(
                label: '${labels[stage.index]}、$description',
                excludeSemantics: true,
                child: Stack(
                  children: [
                    if (stage != CorporateStage.finalCheck)
                      PositionedDirectional(
                        start: 13,
                        top: 14,
                        bottom: 0,
                        child: SizedBox(
                          width: 2,
                          child: ColoredBox(
                            color: done ? accent : colors.outlineVariant,
                          ),
                        ),
                      ),
                    if (stage.index > 0)
                      PositionedDirectional(
                        start: 13,
                        top: 0,
                        height: 14,
                        child: SizedBox(
                          width: 2,
                          child: ColoredBox(
                            color: done || active
                                ? accent
                                : colors.outlineVariant,
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: done ? accent : colors.surface,
                            border: Border.all(
                              color: done || active
                                  ? accent
                                  : colors.outlineVariant,
                              width: active ? 2.5 : 1.5,
                            ),
                          ),
                          child: done
                              ? Icon(
                                  CupertinoIcons.check_mark,
                                  size: 18,
                                  color: theme.appColors.onDark,
                                )
                              : active
                              ? Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accent,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 80),
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  labels[stage.index],
                                  style:
                                      (active
                                              ? theme.textTheme.titleMedium
                                              : theme.textTheme.bodyLarge)
                                          ?.copyWith(
                                            color: active || done
                                                ? colors.onSurface
                                                : colors.onSurfaceVariant,
                                          ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: active
                                        ? accent
                                        : colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
