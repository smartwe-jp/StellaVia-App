import '../../domain/entities/beneficial_owner.dart';
import '../../domain/entities/corporate_documents.dart';
import '../../domain/entities/corporate_form_draft.dart';

Map<String, dynamic> corporateSubmission(
  CorporateFormDraft draft, {
  required bool antiSocial,
  required bool mail,
}) {
  final delegate = draft.handler == CorporateHandler.delegate;
  final docs = draft.documents;
  if (!antiSocial ||
      !mail ||
      draft.handler == null ||
      !draft.ownersComplete ||
      !docs.complete(false, delegate) ||
      !docs.complete(true, delegate)) {
    throw StateError('Incomplete corporate application');
  }
  String value(CorporateSection section, CorporateField field) {
    final v = draft.value(section, field).trim();
    return field == CorporateField.postal ? v.replaceAll('-', '') : v;
  }

  String company(CorporateField f) => value(CorporateSection.company, f);
  String bank(CorporateField f) => value(CorporateSection.bank, f);
  Map<String, String> person(CorporateSection s) => {
    'name': value(s, CorporateField.name),
    'nameKana': value(s, CorporateField.kana),
    'postalCode': value(s, CorporateField.postal),
    'address': value(s, CorporateField.address),
    'birthdate': value(s, CorporateField.birth),
    'phone': value(s, CorporateField.phone),
    'email': value(s, CorporateField.email),
  };
  final active = {
    ...docs.companySlots(delegate),
    ...docs.idSlots(false),
    if (delegate) ...docs.idSlots(true),
  };
  final documents = <String, dynamic>{};
  for (final slot in CorporateDocument.values) {
    final key = slot.apiKey;
    final file = active.contains(slot) ? docs.uploaded[slot] : null;
    documents[key] = file == null
        ? null
        : {
            'fileId': file.fileId,
            'name': slot.identity ? key : file.filename,
            'url': file.url,
          };
  }
  return {
    'applicantType': 'corporate',
    'company': {
      'name': company(CorporateField.businessName),
      'nameKana': company(CorporateField.businessKana),
      'legalForm': company(CorporateField.legalForm),
      'corporateNumber': company(CorporateField.number),
      'postalCode': company(CorporateField.postal),
      'address': company(CorporateField.office),
      'establishedDate': company(CorporateField.founded),
      'phone': company(CorporateField.phone),
      'businessDescription': company(CorporateField.business),
    },
    'transaction': {
      'purpose': company(CorporateField.purpose),
      'purposeOther': company(CorporateField.otherPurpose),
    },
    'representative': {
      ...person(CorporateSection.representative),
      'role': value(CorporateSection.representative, CorporateField.role),
    },
    'handler': {
      'type': draft.handler!.name,
      if (delegate) ...{
        ...person(CorporateSection.handler),
        'department': value(
          CorporateSection.handler,
          CorporateField.department,
        ),
      },
    },
    'beneficialOwners': {
      'status': draft.ownerPresence!.name.toUpperCase(),
      'people': [
        for (final p in draft.declaredOwners)
          {
            'name': p.name,
            'birthdate': p.birthdate,
            'country': p.country,
            'address': p.address,
            'controlType': p.control == OwnerControl.ownershipOver25
                ? 'ownership_over_25'
                : 'material_influence',
            'percentage': p.percentage,
          },
      ],
    },
    if (!draft.isCorrection)
      'bank': {
        'bankType': 0,
        'liveType': '0',
        'bankName': bank(CorporateField.bankName) == 'other'
            ? bank(CorporateField.manualBankName)
            : bank(CorporateField.bankName),
        'branchBankName': bank(CorporateField.branchName),
        'branchBankNumber': bank(CorporateField.branchCode),
        'bankNumber': bank(CorporateField.accountNumber),
        'bankAccountType': bank(CorporateField.accountType),
        'bankAccountOwnerName': bank(CorporateField.accountHolder),
        'bankAccountOwnerAddress': '',
        'bankAccountOwnerNationality': '',
        'bankAccountSwiftCode': '',
        'bankCountry': '',
        'branchBankAddress': '',
      },
    'documents': documents,
    'declarations': {'antiSocial': antiSocial, 'mail': mail},
  };
}
