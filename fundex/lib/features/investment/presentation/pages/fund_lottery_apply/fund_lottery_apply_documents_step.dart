import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplyDocumentsStep extends StatelessWidget {
  const FundLotteryApplyDocumentsStep({
    super.key,
    required this.title,
    required this.description,
    required this.documents,
    required this.checkedIndexes,
    required this.onToggleDocument,
    required this.infoBody,
    required this.nextButtonLabel,
    required this.onNext,
  });

  final String title;
  final String description;
  final List<FundLotteryDocumentItem> documents;
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
        ...List<Widget>.generate(documents.length, (int index) {
          final item = documents[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == documents.length - 1 ? 0 : 10,
            ),
            child: _DocumentTile(
              title: item.title,
              subtitle: item.subtitle,
              checked: checkedIndexes.contains(index),
              onTap: () => onToggleDocument(index),
            ),
          );
        }),
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

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.checked,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.dangerSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 18,
                  color: colors.danger,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: appText.bodyStrong.copyWith(
                        color: colors.textPrimary,
                      ),
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
              AnimatedContainer(
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
            ],
          ),
        ),
      ),
    );
  }
}
