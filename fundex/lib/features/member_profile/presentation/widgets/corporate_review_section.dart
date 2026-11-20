import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/corporate_section_lines.dart';
import '../support/corporate_form_fields.dart';

class CorporateReviewSection extends StatelessWidget {
  const CorporateReviewSection({
    super.key,
    required this.draft,
    required this.section,
    required this.onEdit,
  });
  final CorporateFormDraft draft;
  final CorporateSection section;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, theme = Theme.of(context);
    final lines = corporateSectionLines(l, draft, section);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          onPressed: onEdit,
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 44),
          ),
          child: Wrap(
            spacing: 16,
            children: [Text(sectionTitle(l, section)), Text(l.commonEditText)],
          ),
        ),
        SelectableText(lines.join('\n'), style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
