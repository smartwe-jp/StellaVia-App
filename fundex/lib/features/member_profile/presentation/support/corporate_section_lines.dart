import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/corporate_form_draft.dart';
import 'beneficial_owner_labels.dart';
import 'corporate_document_labels.dart';
import 'corporate_form_fields.dart';

typedef CorporateReviewLine = ({String? label, String value});

List<CorporateReviewLine> corporateSectionLines(
  AppLocalizations l,
  CorporateFormDraft draft,
  CorporateSection section,
) {
  final docs = draft.documents;
  final delegate = draft.handler == CorporateHandler.delegate;
  return <CorporateReviewLine>[
    if (section == CorporateSection.handler && draft.handler != null)
      (label: null, value: delegate ? l.corpFormDelegate : l.corpFormSelf),
    if (section == CorporateSection.owners && draft.ownerPresence != null) ...[
      (label: null, value: ownerPresenceLabel(l, draft.ownerPresence!)),
      for (final p in draft.declaredOwners)
        (
          label: null,
          value: [
            p.name,
            p.birthdate,
            p.country,
            p.address,
            ownerControlLabel(l, p.control),
            if (p.percentage.isNotEmpty) p.percentage,
          ].join(' ／ '),
        ),
    ],
    for (final f in draft.fields(section))
      if (draft.value(section, f).isNotEmpty)
        (
          label: corporateFieldLabel(l, f),
          value: corporateFieldValue(l, draft, section, f),
        ),
    if (section == CorporateSection.documents) ...[
      for (final slot in docs.companySlots(delegate))
        (
          label: documentLabel(l, slot),
          value: docs.uploaded[slot]?.filename ?? l.corpReviewMissing,
        ),
      for (final handler in [false, if (delegate) true]) ...[
        if (docs.type(handler) case final t?)
          (
            label: handler ? l.corpFormHandler : l.corpFormRep,
            value: idTypeLabel(l, t),
          ),
        for (final slot in docs.idSlots(handler))
          (
            label: documentLabel(l, slot),
            value: docs.uploaded[slot]?.filename ?? l.corpReviewMissing,
          ),
      ],
    ],
  ];
}

String corporateFieldValue(
  AppLocalizations l,
  CorporateFormDraft draft,
  CorporateSection section,
  CorporateField field, {
  bool maskAccountNumber = false,
}) {
  final value = draft.value(section, field);
  if (maskAccountNumber && field == CorporateField.accountNumber) {
    return '•••${value.substring(value.length > 4 ? value.length - 4 : 0)}';
  }
  return pickerOptions(l, field)[value] ?? value;
}
