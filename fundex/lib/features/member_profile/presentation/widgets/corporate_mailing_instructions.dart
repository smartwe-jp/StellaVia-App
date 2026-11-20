import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';

class CorporateMailingInstructions extends StatelessWidget {
  const CorporateMailingInstructions({super.key, required this.handler});
  final CorporateHandler? handler;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: theme.appColors.surfaceAlt,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.corpMailDestinationTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SelectableText(
              l.corpMailDestination,
              style: theme.textTheme.bodyLarge,
            ),
            const Divider(height: 24),
            Text(switch (handler) {
              CorporateHandler.representative =>
                l.corpMailRepresentativeOriginal,
              CorporateHandler.delegate => l.corpMailDelegateOriginals,
              null => l.corpProgressMailHint,
            }),
          ],
        ),
      ),
    );
  }
}
