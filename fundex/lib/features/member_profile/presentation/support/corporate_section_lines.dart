import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/corporate_form_draft.dart';
import 'beneficial_owner_labels.dart';
import 'corporate_document_labels.dart';
import 'corporate_form_fields.dart';

List<String> corporateSectionLines(
  AppLocalizations l,
  CorporateFormDraft draft,
  CorporateSection section,
) {
  final docs = draft.documents;
  final delegate = draft.handler == CorporateHandler.delegate;
  return <String>[
    if (section == CorporateSection.handler && draft.handler != null)
      delegate ? l.corpFormDelegate : l.corpFormSelf,
    if (section == CorporateSection.owners && draft.ownerPresence != null) ...[
      ownerPresenceLabel(l, draft.ownerPresence!),
      for (final p in draft.declaredOwners)
        [
          p.name,
          p.birthdate,
          p.country,
          p.address,
          ownerControlLabel(l, p.control),
          if (p.percentage.isNotEmpty) p.percentage,
        ].join(' ／ '),
    ],
    for (final f in draft.fields(section))
      if (draft.value(section, f).isNotEmpty)
        '${corporateFieldLabel(l, f)}　${pickerOptions(l, f)[draft.value(section, f)] ?? draft.value(section, f)}',
    if (section == CorporateSection.documents) ...[
      for (final slot in docs.companySlots(delegate))
        '${documentLabel(l, slot)}　${docs.uploaded[slot]?.filename ?? l.corpReviewMissing}',
      for (final handler in [false, if (delegate) true]) ...[
        if (docs.type(handler) case final t?)
          '${handler ? l.corpFormHandler : l.corpFormRep}　${idTypeLabel(l, t)}',
        for (final slot in docs.idSlots(handler))
          '${documentLabel(l, slot)}　${docs.uploaded[slot]?.filename ?? l.corpReviewMissing}',
      ],
    ],
  ];
}
