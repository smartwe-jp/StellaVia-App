class SettingsContractPdfFile {
  const SettingsContractPdfFile({this.name, this.url, this.createTime});

  final String? name;
  final String? url;
  final String? createTime;

  bool get hasUrl => (url?.trim().isNotEmpty ?? false);

  DateTime? get createTimeDateTime {
    final raw = createTime?.trim() ?? '';
    if (raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  }
}

class SettingsContractDocument {
  const SettingsContractDocument({
    this.type,
    required this.description,
    this.files = const <SettingsContractPdfFile>[],
  });

  final int? type;
  final String description;
  final List<SettingsContractPdfFile> files;

  bool get hasAvailablePdf =>
      files.any((SettingsContractPdfFile file) => file.hasUrl);
}

class SettingsContractProject {
  const SettingsContractProject({
    this.projectId,
    required this.projectName,
    this.documents = const <SettingsContractDocument>[],
  });

  final String? projectId;
  final String projectName;
  final List<SettingsContractDocument> documents;

  String get routeKey {
    final normalizedProjectId = projectId?.trim() ?? '';
    if (normalizedProjectId.isNotEmpty) {
      return normalizedProjectId;
    }
    return projectName.trim();
  }

  int get availablePdfCount => documents.fold<int>(
    0,
    (int total, SettingsContractDocument document) =>
        total +
        document.files
            .where((SettingsContractPdfFile file) => file.hasUrl)
            .length,
  );

  int get availableDocumentCount => documents
      .where((SettingsContractDocument document) => document.hasAvailablePdf)
      .length;

  DateTime? get latestUpdatedAt {
    DateTime? latest;
    for (final document in documents) {
      for (final file in document.files) {
        final timestamp = file.createTimeDateTime;
        if (timestamp == null) {
          continue;
        }
        if (latest == null || timestamp.isAfter(latest)) {
          latest = timestamp;
        }
      }
    }
    return latest;
  }
}
