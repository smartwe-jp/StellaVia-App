import 'dart:typed_data';

enum CorporateDocument {
  registry,
  sealCertificate,
  delegation,
  beneficialOwnerEvidence,
  representativeIdFront,
  representativeIdBack,
  handlerIdFront,
  handlerIdBack;

  String get apiKey => switch (this) {
    representativeIdFront => 'representativeId_front',
    representativeIdBack => 'representativeId_back',
    handlerIdFront => 'handlerId_front',
    handlerIdBack => 'handlerId_back',
    _ => name,
  };
  bool get optional =>
      this == sealCertificate || this == beneficialOwnerEvidence;
  bool get identity => index >= representativeIdFront.index;
  List<String> get extensions => identity
      ? const ['jpg', 'jpeg', 'png']
      : this == beneficialOwnerEvidence
      ? const ['pdf', 'jpg', 'jpeg', 'png']
      : const ['pdf'];

  static const maxBytes = 10 * 1024 * 1024;
  String? mimeType(String filename, Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxBytes) return null;
    final ext = filename.split('.').last.toLowerCase();
    if (!filename.contains('.') || !extensions.contains(ext)) return null;
    bool starts(List<int> signature) =>
        bytes.length >= signature.length &&
        signature.indexed.every((part) => bytes[part.$1] == part.$2);
    return switch (ext) {
      'pdf' when starts([37, 80, 68, 70, 45]) => 'application/pdf',
      'png' when starts([137, 80, 78, 71, 13, 10, 26, 10]) => 'image/png',
      'jpg' || 'jpeg' when starts([255, 216, 255]) => 'image/jpeg',
      _ => null,
    };
  }
}

enum CorporateIdType {
  license('11'),
  myNumber('12'),
  residence('13');

  const CorporateIdType(this.code);
  final String code;
}

typedef CorporateAttachment = ({String filename, String fileId, String url});
typedef PendingAttachment = ({
  String filename,
  Uint8List bytes,
  String mimeType,
});

class CorporateDocuments {
  final submitted =
      <
        ({CorporateDocument? slot, String category, CorporateAttachment file})
      >[];
  final uploaded = <CorporateDocument, CorporateAttachment>{};
  final pending = <CorporateDocument, PendingAttachment>{};
  final _types = <bool, CorporateIdType>{};
  CorporateIdType? type(bool handler) => _types[handler];
  void selectType(bool handler, CorporateIdType value) {
    if (type(handler) == value) return;
    for (final slot
        in handler
            ? [
                CorporateDocument.handlerIdFront,
                CorporateDocument.handlerIdBack,
              ]
            : [
                CorporateDocument.representativeIdFront,
                CorporateDocument.representativeIdBack,
              ]) {
      uploaded.remove(slot);
      pending.remove(slot);
    }
    _types[handler] = value;
  }

  List<CorporateDocument> companySlots(bool delegate) => [
    CorporateDocument.registry,
    CorporateDocument.sealCertificate,
    if (delegate) CorporateDocument.delegation,
    CorporateDocument.beneficialOwnerEvidence,
  ];
  List<CorporateDocument> idSlots(bool handler) => [
    if (type(handler) != null) ...[
      handler
          ? CorporateDocument.handlerIdFront
          : CorporateDocument.representativeIdFront,
      if (type(handler) != CorporateIdType.myNumber)
        handler
            ? CorporateDocument.handlerIdBack
            : CorporateDocument.representativeIdBack,
    ],
  ];
  bool complete(bool identity, bool delegate) {
    if (identity && (type(false) == null || (delegate && type(true) == null))) {
      return false;
    }
    final slots = identity
        ? [...idSlots(false), if (delegate) ...idSlots(true)]
        : companySlots(delegate);
    return slots.every(
      (s) => !pending.containsKey(s) && (s.optional || uploaded.containsKey(s)),
    );
  }
}
