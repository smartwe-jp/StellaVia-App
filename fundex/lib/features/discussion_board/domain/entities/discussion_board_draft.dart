enum DiscussionDraftKind { post, reply }

class DiscussionBoardDraft {
  const DiscussionBoardDraft({
    required this.id,
    required this.kind,
    required this.content,
    required this.imageFilePaths,
    required this.updatedAtIso,
    this.projectId,
    this.projectName,
    this.replyThreadId,
    this.replyTargetName,
    this.replyTargetBody,
    this.replyTargetThreadJson,
  });

  final String id;
  final DiscussionDraftKind kind;
  final String content;
  final List<String> imageFilePaths;
  final String updatedAtIso;
  final String? projectId;
  final String? projectName;
  final String? replyThreadId;
  final String? replyTargetName;
  final String? replyTargetBody;
  final Map<String, dynamic>? replyTargetThreadJson;

  bool get hasContent =>
      content.trim().isNotEmpty ||
      imageFilePaths.any((path) => path.trim().isNotEmpty);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'kind': kind.name,
      'content': content,
      'imageFilePaths': imageFilePaths,
      'updatedAtIso': updatedAtIso,
      'projectId': projectId,
      'projectName': projectName,
      'replyThreadId': replyThreadId,
      'replyTargetName': replyTargetName,
      'replyTargetBody': replyTargetBody,
      'replyTargetThreadJson': replyTargetThreadJson,
    };
  }

  factory DiscussionBoardDraft.fromJson(Map<String, dynamic> json) {
    final kindName = json['kind']?.toString();
    return DiscussionBoardDraft(
      id: json['id']?.toString() ?? '',
      kind: DiscussionDraftKind.values.firstWhere(
        (kind) => kind.name == kindName,
        orElse: () => DiscussionDraftKind.post,
      ),
      content: json['content']?.toString() ?? '',
      imageFilePaths:
          (json['imageFilePaths'] as List?)
              ?.map((item) => item.toString())
              .where((item) => item.trim().isNotEmpty)
              .toList(growable: false) ??
          const <String>[],
      updatedAtIso: json['updatedAtIso']?.toString() ?? '',
      projectId: _nullableTrimmedString(json['projectId']),
      projectName: _nullableTrimmedString(json['projectName']),
      replyThreadId: _nullableTrimmedString(json['replyThreadId']),
      replyTargetName: _nullableTrimmedString(json['replyTargetName']),
      replyTargetBody: _nullableTrimmedString(json['replyTargetBody']),
      replyTargetThreadJson: _nullableMap(json['replyTargetThreadJson']),
    );
  }
}

String? _nullableTrimmedString(Object? value) {
  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}

Map<String, dynamic>? _nullableMap(Object? value) {
  if (value is! Map) {
    return null;
  }
  return Map<String, dynamic>.from(value);
}
