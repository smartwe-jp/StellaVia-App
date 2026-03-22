import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';
import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplyDocumentsStep extends StatelessWidget {
  const FundLotteryApplyDocumentsStep({
    super.key,
    required this.title,
    required this.description,
    required this.documentGroups,
    required this.checkedIndexes,
    required this.onToggleDocument,
    required this.infoBody,
    required this.nextButtonLabel,
    required this.onNext,
  });

  final String title;
  final String description;
  final List<FundLotteryDocumentGroup> documentGroups;
  final Set<int> checkedIndexes;
  final ValueChanged<int> onToggleDocument;
  final String infoBody;
  final String nextButtonLabel;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: <Widget>[
        Text(
          title,
          style: appText.sectionTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 18),
        Text(
          description,
          style: appText.caption.copyWith(
            color: colors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        for (var groupIndex = 0; groupIndex < documentGroups.length; groupIndex++)
          Padding(
            padding: EdgeInsets.only(
              bottom: groupIndex == documentGroups.length - 1 ? 0 : 16,
            ),
            child: _DocumentGroupSection(
              group: documentGroups[groupIndex],
              checkedIndexes: checkedIndexes,
              onToggleDocument: onToggleDocument,
            ),
          ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('💡'),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    infoBody,
                    style: appText.meta.copyWith(
                      color: colors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        PrimaryCtaButton(
          label: nextButtonLabel,
          onPressed: onNext,
          horizontalPadding: 0,
          backgroundColor: onNext == null ? colors.disabled : colors.primary,
          disabledOpacity: 1,
          textStyle: appText.button.copyWith(color: colors.brandWhite),
        ),
      ],
    );
  }
}

class _DocumentGroupSection extends StatelessWidget {
  const _DocumentGroupSection({
    required this.group,
    required this.checkedIndexes,
    required this.onToggleDocument,
  });

  final FundLotteryDocumentGroup group;
  final Set<int> checkedIndexes;
  final ValueChanged<int> onToggleDocument;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          group.title,
          style: appText.cardTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        if (group.items.isEmpty)
          FundDetailContentCard(
            child: Text(
              context.l10n.fundDetailDocumentUnavailable,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
          )
        else
          Column(
            children: <Widget>[
              for (var index = 0; index < group.items.length; index++) ...<Widget>[
                _DocumentTile(
                  title: group.items[index].title,
                  subtitle: group.items[index].subtitle,
                  checked: checkedIndexes.contains(
                    group.items[index].selectionIndex,
                  ),
                  onTap: () =>
                      onToggleDocument(group.items[index].selectionIndex),
                  onOpen: group.items[index].onOpen,
                ),
                if (index < group.items.length - 1)
                  const SizedBox(height: 10),
              ],
            ],
          ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.checked,
    required this.onTap,
    this.onOpen,
  });

  final String title;
  final String subtitle;
  final bool checked;
  final VoidCallback onTap;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final tileBackgroundColor = checked
        ? colors.successSubtle
        : colors.surfaceAlt;
    final tileBorderColor = checked ? colors.successBorder : colors.borderSoft;
    final iconBackgroundColor = checked
        ? colors.success.withValues(alpha: 0.14)
        : colors.dangerSubtle;
    final iconForegroundColor = checked ? colors.success : colors.danger;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tileBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tileBorderColor, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 18,
                color: iconForegroundColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onOpen,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: appText.bodyStrong.copyWith(
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: appText.meta.copyWith(
                                  color: colors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: checked
                              ? colors.success
                              : colors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: checked ? colors.primary : colors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: checked ? colors.primary : colors.border,
                      width: 2,
                    ),
                  ),
                  child: checked
                      ? Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: colors.brandWhite,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
