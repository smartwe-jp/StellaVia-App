import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class CorporateStageIndicator extends StatelessWidget {
  const CorporateStageIndicator({super.key, required this.current});
  final int current;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n, theme = Theme.of(context);
    final stages = [
      l.corpFormMember,
      l.corpFormCompany,
      l.corporateVerificationTitle,
    ];
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final (i, label) in stages.indexed) ...[
            if (i > 0)
              SizedBox(
                width: 10,
                child: Divider(color: theme.colorScheme.outlineVariant),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: i == current
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: i == current
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(label, style: theme.textTheme.labelSmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
