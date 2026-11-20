import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class CorporateMailFields extends StatelessWidget {
  const CorporateMailFields({
    super.key,
    required this.sendingOriginals,
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });
  final bool sendingOriginals, enabled;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, theme = Theme.of(context);
    Widget notice(String title, String body) => Card(
      margin: EdgeInsets.zero,
      color: theme.appColors.surfaceAlt,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(sendingOriginals ? l.corpMailDetails : l.corpMailQuestion),
        const SizedBox(height: 24),
        notice(
          sendingOriginals ? l.corpMailAfterSend : l.corpMailConfirmAfter,
          sendingOriginals ? l.corpMailOriginals : l.corpMailConfirmBody,
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: sendingOriginals ? 3 : 1,
          label: sendingOriginals ? l.corpMailMessage : l.corpMailNote,
          requiredLabel: sendingOriginals ? l.corpFormRequired : null,
          hintText: sendingOriginals ? null : l.corpMailNoteHint,
        ),
        const SizedBox(height: 16),
        Text(sendingOriginals ? l.corpMailHint : l.corpMailFinalCheck),
        if (sendingOriginals) ...[
          const SizedBox(height: 16),
          notice(l.corpMailAfter, l.corpMailAfterBody),
        ],
      ],
    );
  }
}
