import 'package:flutter/material.dart';
import '../pages/corporate_attachment_page.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/corporate_document_labels.dart';
import '../support/beneficial_owner_labels.dart';
import '../support/corporate_form_fields.dart';
import '../support/corporate_section_lines.dart';

class CorporateDetailSections extends StatelessWidget {
  const CorporateDetailSections({super.key, required this.form});
  final CorporateFormDraft form;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );
    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 35,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 65, child: Text(value, style: valueStyle)),
        ],
      ),
    );
    Iterable<Widget> fields(CorporateSection section) sync* {
      if (section == CorporateSection.handler && form.handler != null) {
        yield row(
          l.corpFormHandler,
          form.handler == CorporateHandler.delegate
              ? l.corpFormDelegate
              : l.corpFormSelf,
        );
      }
      if (section == CorporateSection.owners && form.ownerPresence != null) {
        yield row(l.corpOwnerTitle, ownerPresenceLabel(l, form.ownerPresence!));
        for (final owner in form.declaredOwners) {
          yield const Divider();
          for (final (label, value) in [
            (l.corpFormName, owner.name),
            (l.corpFormBirth, owner.birthdate),
            (l.corpOwnerCountry, owner.country),
            (l.corpFormAddress, owner.address),
            (l.corpOwnerControl, ownerControlLabel(l, owner.control)),
            (l.corpOwnerPercentage, owner.percentage),
          ]) {
            if (value.isNotEmpty) yield row(label, value);
          }
        }
      }
      for (final field in form.fields(section)) {
        if (form.value(section, field).isNotEmpty) {
          yield row(
            corporateFieldLabel(l, field),
            corporateFieldValue(
              l,
              form,
              section,
              field,
              maskAccountNumber: true,
            ),
          );
        }
      }
    }

    List<Widget> sectionRows(CorporateSection section) {
      final rows = fields(section).toList();
      return rows.isEmpty ? [Text(l.corpDetailEmpty)] : rows;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final section in const [
          CorporateSection.company,
          CorporateSection.representative,
          CorporateSection.handler,
          CorporateSection.owners,
          CorporateSection.bank,
          CorporateSection.documents,
        ]) ...[
          const SizedBox(height: 24),
          Text(
            section == CorporateSection.documents
                ? l.corpDetailFiles
                : sectionTitle(l, section),
            style: theme.textTheme.titleLarge,
          ),
          const Divider(),
          if (section == CorporateSection.documents) ...[
            if (form.documents.submitted.isEmpty) Text(l.corpDetailEmpty),
            for (final attachment in form.documents.submitted)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: row(
                  attachment.slot == null
                      ? attachment.category
                      : documentLabel(l, attachment.slot!),
                  attachment.file.filename,
                ),
                onTap: () =>
                    CorporateAttachmentPage.open(context, attachment.file),
              ),
          ] else
            ...sectionRows(section),
        ],
      ],
    );
  }
}
