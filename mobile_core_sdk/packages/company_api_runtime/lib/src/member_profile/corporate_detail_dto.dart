class CorporateAuditLogDto {
  const CorporateAuditLogDto({
    required this.action,
    this.createdAt,
    this.customerMessage,
    this.id,
  });
  final String action;
  final DateTime? createdAt;
  final String? customerMessage;
  final int? id;

  factory CorporateAuditLogDto.fromJson(Map json) => CorporateAuditLogDto(
    action: (json['action'] as String?)?.trim() ?? '',
    createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    customerMessage: (json['customerMessage'] as String?)?.trim(),
    id: int.tryParse(json['id']?.toString() ?? ''),
  );
}

typedef CorporateDocumentDto = ({
  String category,
  String fileId,
  String filename,
  String url,
});

/// Detail returns scalar form sections and table rows; older responses group attachments by category.
Map<String, String> _fields(dynamic object) => {
  if (object is Map)
    for (final e in object.entries)
      if (e.key is String && (e.value is String || e.value is num))
        e.key as String: e.value.toString().trim(),
};

Iterable<CorporateDocumentDto> _documents(dynamic source) sync* {
  final rows = source is List
      ? source.whereType<Map>().map(
          (row) => MapEntry(row['documentCategory'], row),
        )
      : source is Map
      ? source.entries
      : const <MapEntry<dynamic, dynamic>>[];
  for (final row in rows) {
    final f = _fields(row.value), url = f['fileUrl'] ?? f['url'] ?? '';
    if (url.isEmpty) continue;
    yield (
      category: row.key.toString(),
      fileId: f['fileId'] ?? '',
      filename: f['fileName'] ?? f['name'] ?? '',
      url: url,
    );
  }
}

class CorporateDetailDto {
  const CorporateDetailDto({
    this.companyName,
    this.company = const {},
    this.representative = const {},
    this.handler = const {},
    this.bank = const {},
    this.owners = const [],
    this.ownerStatus,
    this.documents = const [],
    this.verificationStatus,
    this.hasRegisteredBank = false,
    this.applicationId,
    this.userOps = const {},
    this.auditLogs = const [],
  });
  final int? applicationId;
  final Map<String, String> company, representative, handler, bank;
  final List<Map<String, String>> owners;
  final String? ownerStatus;
  final List<CorporateDocumentDto> documents;
  final bool hasRegisteredBank;
  final String? companyName, verificationStatus;
  final Set<String> userOps;
  final List<CorporateAuditLogDto> auditLogs;

  factory CorporateDetailDto.fromJson(Map<String, dynamic> data) {
    final application = data['application'] as Map?;
    final bank = data['bank'];
    final owners = data['beneficialOwners'] ?? application?['beneficialOwners'];
    final people = owners is Map ? owners['people'] : owners;
    final rows = people is List
        ? people.whereType<Map>().map(_fields).toList()
        : <Map<String, String>>[];
    return CorporateDetailDto(
      company: _fields(application),
      representative: _fields(data['representative']),
      handler: _fields(data['handler']),
      bank: _fields(bank),
      owners: rows,
      ownerStatus: owners is Map
          ? _fields(owners)['status']
          : rows.firstOrNull?['boStatus'],
      documents: _documents(data['documents']).toList(),
      applicationId:
          int.tryParse(application?['id']?.toString() ?? '') ??
          int.tryParse(data['id']?.toString() ?? ''),
      hasRegisteredBank:
          bank is Map &&
          (bank['id'] != null ||
              (bank['bankNumber']?.toString().trim().isNotEmpty ?? false)),
      companyName: (application?['companyName'] as String?)?.trim(),
      verificationStatus: (application?['verificationStatus'] as String?)
          ?.trim(),
      userOps: (data['userOps'] as List? ?? []).whereType<String>().toSet(),
      auditLogs: [
        for (final row in (data['auditLogs'] as List? ?? []).whereType<Map>())
          CorporateAuditLogDto.fromJson(row),
      ],
    );
  }
}
