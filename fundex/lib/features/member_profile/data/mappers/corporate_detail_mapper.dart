import 'package:company_api_runtime/company_api_runtime.dart';
import '../../domain/entities/beneficial_owner.dart';
import '../../domain/entities/corporate_documents.dart';
import '../../domain/entities/corporate_form_draft.dart';

CorporateFormDraft corporateDetailForm(CorporateDetailDto dto) {
  final draft = CorporateFormDraft(
    companyName: dto.companyName,
    sourceApplicationId: dto.applicationId,
  );
  void fill(
    CorporateSection section,
    Map<String, String> source,
    Map<CorporateField, String> keys,
  ) {
    for (final e in keys.entries) {
      final value = source[e.value];
      if (value != null && value.isNotEmpty) draft.set(section, e.key, value);
    }
  }

  fill(CorporateSection.company, dto.company, const {
    CorporateField.businessName: 'companyName',
    CorporateField.businessKana: 'companyNameKana',
    CorporateField.legalForm: 'legalForm',
    CorporateField.number: 'corporateNumber',
    CorporateField.postal: 'postalCode',
    CorporateField.office: 'address',
    CorporateField.founded: 'establishedDate',
    CorporateField.phone: 'phone',
    CorporateField.business: 'businessDescription',
    CorporateField.purpose: 'transactionPurpose',
    CorporateField.otherPurpose: 'transactionPurposeOther',
  });
  const person = {
    CorporateField.name: 'name',
    CorporateField.kana: 'nameKana',
    CorporateField.postal: 'postalCode',
    CorporateField.address: 'address',
    CorporateField.birth: 'birthdate',
    CorporateField.phone: 'phone',
    CorporateField.email: 'email',
  };
  fill(CorporateSection.representative, dto.representative, {
    ...person,
    CorporateField.role: 'role',
  });
  draft.handler = CorporateHandler.values
      .where(
        (v) => v.name == (dto.handler['handlerType'] ?? dto.handler['type']),
      )
      .firstOrNull;
  fill(CorporateSection.handler, dto.handler, {
    ...person,
    CorporateField.department: 'department',
  });
  fill(CorporateSection.bank, dto.bank, const {
    CorporateField.bankName: 'bankName',
    CorporateField.branchName: 'branchBankName',
    CorporateField.branchCode: 'branchBankNumber',
    CorporateField.accountNumber: 'bankNumber',
    CorporateField.accountType: 'bankAccountType',
    CorporateField.accountHolder: 'bankAccountOwnerName',
  });
  draft.ownerPresence = OwnerPresence.values
      .where((v) => v.name == dto.ownerStatus?.toLowerCase())
      .firstOrNull;
  for (final row in dto.owners) {
    if ((row['name'] ?? '').isEmpty) continue;
    final control = switch (row['controlType']?.toLowerCase()) {
      'ownership_over_25' => OwnerControl.ownershipOver25,
      'material_influence' => OwnerControl.materialInfluence,
      _ => null,
    };
    draft.owners.add(
      BeneficialOwner(
        name: row['name']!,
        birthdate: row['birthdate'] ?? '',
        country: row['country'] ?? '',
        address: row['address'] ?? '',
        control: control,
        percentage: row['percentage'] ?? '',
      ),
    );
  }
  if (draft.owners.isNotEmpty) draft.ownerPresence ??= OwnerPresence.yes;
  for (final file in dto.documents) {
    String normalize(String s) => s.replaceAll('_', '').toLowerCase();
    final slot = CorporateDocument.values
        .where((v) => normalize(v.apiKey) == normalize(file.category))
        .firstOrNull;
    final attachment = (
      filename: file.filename.isNotEmpty
          ? file.filename
          : (Uri.tryParse(file.url)?.pathSegments.lastOrNull ?? file.category),
      fileId: file.fileId,
      url: file.url,
    );
    draft.documents.submitted.add((
      slot: slot,
      category: file.category,
      file: attachment,
    ));
    if (slot == null) continue;
    final type = CorporateIdType.values
        .where((t) => t.code == file.fileId)
        .firstOrNull;
    if (slot.identity) {
      if (type == null) continue;
      final handler =
          slot == CorporateDocument.handlerIdFront ||
          slot == CorporateDocument.handlerIdBack;
      if (draft.documents.type(handler) == null) {
        draft.documents.selectType(handler, type);
      } else if (draft.documents.type(handler) != type) {
        continue;
      }
    }
    draft.documents.uploaded[slot] = attachment;
  }
  return draft;
}
