import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../pages/corporate_attachment_page.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/beneficial_owner_labels.dart';
import '../support/corporate_document_labels.dart';
import '../support/corporate_form_fields.dart';
import '../support/corporate_section_lines.dart';

class CorporateDetailSections extends StatefulWidget {
  const CorporateDetailSections({super.key, required this.form});
  final CorporateFormDraft form;
  @override
  State<CorporateDetailSections> createState() =>
      _CorporateDetailSectionsState();
}

class _CorporateDetailSectionsState extends State<CorporateDetailSections> {
  final expanded = <CorporateSection>{};
  @override
  Widget build(BuildContext context) {
    final l = context.l10n, f = widget.form, theme = Theme.of(context);
    String val(CorporateSection s, CorporateField key) => f.value(s, key);
    final bank = val(CorporateSection.bank, CorporateField.accountNumber);
    final groups = <CorporateSection, (String, String)>{
      CorporateSection.company: (
        l.corpFormCompany,
        [
          val(CorporateSection.company, CorporateField.businessName),
          val(CorporateSection.company, CorporateField.number),
        ].where((s) => s.isNotEmpty).join('\n'),
      ),
      CorporateSection.representative: (
        l.corpDetailPeople,
        [
          val(CorporateSection.representative, CorporateField.name),
          if (f.handler == CorporateHandler.delegate)
            val(CorporateSection.handler, CorporateField.name),
        ].where((s) => s.isNotEmpty).join(' ／ '),
      ),
      CorporateSection.owners: (
        l.corpOwnerTitle,
        f.ownerPresence == null ? '' : ownerPresenceLabel(l, f.ownerPresence!),
      ),
      CorporateSection.bank: (
        l.corpBankTitle,
        [
          val(CorporateSection.bank, CorporateField.bankName),
          val(CorporateSection.bank, CorporateField.branchName),
          if (bank.isNotEmpty)
            '•••${bank.substring(bank.length > 4 ? bank.length - 4 : 0)}',
        ].where((s) => s.isNotEmpty).join(' '),
      ),
      CorporateSection.documents: (
        l.corpDetailFiles,
        f.documents.submitted
            .map((a) => a.slot == null ? a.category : documentLabel(l, a.slot!))
            .join(' ／ '),
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in groups.entries) ...[
          const SizedBox(height: 20),
          Text(item.value.$1, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            item.value.$2.isEmpty ? l.corpDetailEmpty : item.value.$2,
            style: theme.textTheme.titleMedium,
          ),
          const Divider(),
          if (expanded.contains(item.key))
            if (item.key == CorporateSection.documents) ...[
              for (final a in f.documents.submitted)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    a.slot == null ? a.category : documentLabel(l, a.slot!),
                  ),
                  subtitle: Text(a.file.filename),
                  trailing: const Icon(Icons.visibility_outlined),
                  onTap: () => CorporateAttachmentPage.open(context, a.file),
                ),
            ] else ...[
              for (final section in [
                item.key,
                if (item.key == CorporateSection.representative)
                  CorporateSection.handler,
              ]) ...[
                if (item.key == CorporateSection.representative)
                  Text(
                    sectionTitle(l, section),
                    style: theme.textTheme.labelLarge,
                  ),
                SelectableText(corporateSectionLines(l, f, section).join('\n')),
              ],
            ],
          AppButton(
            variant: AppButtonVariant.secondary,
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(StadiumBorder()),
            ),
            label: expanded.contains(item.key)
                ? l.corpDetailHide
                : item.key == CorporateSection.documents
                ? l.corpDetailPreview
                : '${item.value.$1} · ${l.corpDetailExpand}',
            onPressed:
                item.value.$2.isEmpty && item.key == CorporateSection.documents
                ? null
                : () => setState(() {
                    if (!expanded.remove(item.key)) expanded.add(item.key);
                  }),
          ),
        ],
      ],
    );
  }
}
