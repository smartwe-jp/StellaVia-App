import 'beneficial_owner.dart';
import 'corporate_documents.dart';

enum CorporateSection {
  company,
  representative,
  handler,
  owners,
  bank,
  documents,
}

enum CorporateField {
  businessName,
  businessKana,
  legalForm,
  number,
  postal,
  office,
  founded,
  phone,
  business,
  purpose,
  otherPurpose,
  name,
  kana,
  role,
  address,
  birth,
  email,
  department,
  bankName,
  manualBankName,
  branchName,
  branchCode,
  accountNumber,
  accountType,
  accountHolder,
}

enum CorporateHandler { representative, delegate }

class CorporateFormDraft {
  CorporateFormDraft({
    String? companyName,
    this.isCorrection = false,
    this.sourceApplicationId,
    this.localAccountKey,
  }) {
    if (companyName != null) {
      set(CorporateSection.company, CorporateField.businessName, companyName);
    }
  }
  CorporateFormDraft copyForEditing({
    required bool correction,
    String? accountKey,
  }) {
    final copy =
        CorporateFormDraft(
            isCorrection: correction,
            localAccountKey: correction ? null : accountKey ?? localAccountKey,
            sourceApplicationId: sourceApplicationId,
          )
          ..handler = handler
          ..ownerPresence = ownerPresence;
    copy._entries.addAll(_entries);
    copy.owners.addAll(owners);
    for (final handler in [false, true]) {
      final type = documents.type(handler);
      if (type != null) copy.documents.selectType(handler, type);
    }
    copy.documents.uploaded.addAll(documents.uploaded);
    if (!correction) copy.documents.pending.addAll(documents.pending);
    return copy;
  }

  final documents = CorporateDocuments();
  final bool isCorrection;
  final String? localAccountKey;
  bool submitted = false;
  final int? sourceApplicationId;
  Iterable<CorporateSection> get sections => CorporateSection.values.where(
    (s) => !isCorrection || s != CorporateSection.bank,
  );
  final _entries = <(CorporateSection, CorporateField), String>{};
  CorporateHandler? handler;
  OwnerPresence? ownerPresence;
  final owners = <BeneficialOwner>[];
  List<BeneficialOwner> get declaredOwners =>
      ownerPresence == OwnerPresence.yes ? List.unmodifiable(owners) : const [];
  bool get ownersComplete =>
      ownerPresence != null &&
      (ownerPresence != OwnerPresence.yes ||
          (owners.isNotEmpty && owners.every((p) => p.complete)));
  bool get hasEntries => _entries.isNotEmpty || handler != null;
  String value(CorporateSection section, CorporateField field) =>
      _entries[(section, field)] ?? '';
  void set(CorporateSection section, CorporateField field, String value) {
    _entries[(section, field)] = value;
    if (field == CorporateField.purpose && value != 'other') {
      _entries.remove((section, CorporateField.otherPurpose));
    }
  }

  List<CorporateField> fields(CorporateSection section) {
    return switch (section) {
      CorporateSection.bank => [
        CorporateField.bankName,
        if (value(section, CorporateField.bankName) == 'other')
          CorporateField.manualBankName,
        CorporateField.branchName,
        CorporateField.branchCode,
        CorporateField.accountNumber,
        CorporateField.accountType,
        CorporateField.accountHolder,
      ],
      CorporateSection.owners || CorporateSection.documents => const [],
      CorporateSection.company => [
        CorporateField.businessName,
        CorporateField.businessKana,
        CorporateField.legalForm,
        CorporateField.number,
        CorporateField.postal,
        CorporateField.office,
        CorporateField.founded,
        CorporateField.phone,
        CorporateField.business,
        CorporateField.purpose,
        if (value(section, CorporateField.purpose) == 'other')
          CorporateField.otherPurpose,
      ],
      CorporateSection.representative => [
        CorporateField.name,
        CorporateField.kana,
        CorporateField.role,
        CorporateField.postal,
        CorporateField.address,
        CorporateField.birth,
        CorporateField.phone,
        CorporateField.email,
      ],
      CorporateSection.handler =>
        handler == CorporateHandler.delegate
            ? [
                CorporateField.name,
                CorporateField.kana,
                CorporateField.department,
                CorporateField.postal,
                CorporateField.address,
                CorporateField.birth,
                CorporateField.phone,
                CorporateField.email,
              ]
            : [],
    };
  }
}
