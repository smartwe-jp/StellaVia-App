class DiscussionAuthorBadge {
  const DiscussionAuthorBadge({
    required this.label,
    required this.backgroundColorValue,
    required this.foregroundColorValue,
  });

  final String label;
  final int backgroundColorValue;
  final int foregroundColorValue;

  DiscussionAuthorBadge copyWith({
    String? label,
    int? backgroundColorValue,
    int? foregroundColorValue,
  }) {
    return DiscussionAuthorBadge(
      label: label ?? this.label,
      backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
      foregroundColorValue: foregroundColorValue ?? this.foregroundColorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'label': label,
      'backgroundColorValue': backgroundColorValue,
      'foregroundColorValue': foregroundColorValue,
    };
  }

  factory DiscussionAuthorBadge.fromJson(Map<String, dynamic> json) {
    return DiscussionAuthorBadge(
      label: json['label']?.toString() ?? '',
      backgroundColorValue: _toInt(json['backgroundColorValue']),
      foregroundColorValue: _toInt(json['foregroundColorValue']),
    );
  }
}

class DiscussionAuthor {
  const DiscussionAuthor({
    required this.id,
    required this.displayName,
    required this.accountHandle,
    this.avatarUrl,
    required this.avatarText,
    required this.avatarGradientColorValues,
    required this.badge,
  });

  final String id;
  final String displayName;
  final String accountHandle;
  final String? avatarUrl;
  final String avatarText;
  final List<int> avatarGradientColorValues;
  final DiscussionAuthorBadge badge;

  DiscussionAuthor copyWith({
    String? id,
    String? displayName,
    String? accountHandle,
    String? avatarUrl,
    String? avatarText,
    List<int>? avatarGradientColorValues,
    DiscussionAuthorBadge? badge,
  }) {
    return DiscussionAuthor(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      accountHandle: accountHandle ?? this.accountHandle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarText: avatarText ?? this.avatarText,
      avatarGradientColorValues:
          avatarGradientColorValues ?? this.avatarGradientColorValues,
      badge: badge ?? this.badge,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'accountHandle': accountHandle,
      'avatarUrl': avatarUrl,
      'avatarText': avatarText,
      'avatarGradientColorValues': avatarGradientColorValues,
      'badge': badge.toJson(),
    };
  }

  factory DiscussionAuthor.fromJson(Map<String, dynamic> json) {
    return DiscussionAuthor(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      accountHandle: json['accountHandle']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      avatarText: json['avatarText']?.toString() ?? '',
      avatarGradientColorValues: _toIntList(json['avatarGradientColorValues']),
      badge: DiscussionAuthorBadge.fromJson(_toMap(json['badge'])),
    );
  }
}

class DiscussionQuote {
  const DiscussionQuote({required this.sourceText, required this.body});

  final String sourceText;
  final String body;

  DiscussionQuote copyWith({String? sourceText, String? body}) {
    return DiscussionQuote(
      sourceText: sourceText ?? this.sourceText,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'sourceText': sourceText, 'body': body};
  }

  factory DiscussionQuote.fromJson(Map<String, dynamic> json) {
    return DiscussionQuote(
      sourceText: json['sourceText']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }
}

class DiscussionReply {
  const DiscussionReply({
    required this.id,
    required this.author,
    required this.timeLabel,
    required this.body,
    required this.createdAtIso,
    this.quote,
  });

  final String id;
  final DiscussionAuthor author;
  final String timeLabel;
  final String body;
  final String createdAtIso;
  final DiscussionQuote? quote;

  DiscussionReply copyWith({
    String? id,
    DiscussionAuthor? author,
    String? timeLabel,
    String? body,
    String? createdAtIso,
    DiscussionQuote? quote,
  }) {
    return DiscussionReply(
      id: id ?? this.id,
      author: author ?? this.author,
      timeLabel: timeLabel ?? this.timeLabel,
      body: body ?? this.body,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      quote: quote ?? this.quote,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'author': author.toJson(),
      'timeLabel': timeLabel,
      'body': body,
      'createdAtIso': createdAtIso,
      'quote': quote?.toJson(),
    };
  }

  factory DiscussionReply.fromJson(Map<String, dynamic> json) {
    return DiscussionReply(
      id: json['id']?.toString() ?? '',
      author: DiscussionAuthor.fromJson(_toMap(json['author'])),
      timeLabel: json['timeLabel']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAtIso: json['createdAtIso']?.toString() ?? '',
      quote: _toNullableMap(json['quote']) == null
          ? null
          : DiscussionQuote.fromJson(_toMap(json['quote'])),
    );
  }
}

class DiscussionThread {
  const DiscussionThread({
    required this.id,
    required this.author,
    required this.timeLabel,
    required this.body,
    required this.createdAtIso,
    required this.commentCount,
    required this.replies,
    this.fundReferenceLabel,
    this.fundReferenceId,
  });

  final String id;
  final DiscussionAuthor author;
  final String timeLabel;
  final String body;
  final String createdAtIso;
  final int commentCount;
  final List<DiscussionReply> replies;
  final String? fundReferenceLabel;
  final String? fundReferenceId;

  DiscussionThread copyWith({
    String? id,
    DiscussionAuthor? author,
    String? timeLabel,
    String? body,
    String? createdAtIso,
    int? commentCount,
    List<DiscussionReply>? replies,
    String? fundReferenceLabel,
    String? fundReferenceId,
  }) {
    return DiscussionThread(
      id: id ?? this.id,
      author: author ?? this.author,
      timeLabel: timeLabel ?? this.timeLabel,
      body: body ?? this.body,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      commentCount: commentCount ?? this.commentCount,
      replies: replies ?? this.replies,
      fundReferenceLabel: fundReferenceLabel ?? this.fundReferenceLabel,
      fundReferenceId: fundReferenceId ?? this.fundReferenceId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'author': author.toJson(),
      'timeLabel': timeLabel,
      'body': body,
      'createdAtIso': createdAtIso,
      'commentCount': commentCount,
      'replies': replies.map((DiscussionReply item) => item.toJson()).toList(),
      'fundReferenceLabel': fundReferenceLabel,
      'fundReferenceId': fundReferenceId,
    };
  }

  factory DiscussionThread.fromJson(Map<String, dynamic> json) {
    return DiscussionThread(
      id: json['id']?.toString() ?? '',
      author: DiscussionAuthor.fromJson(_toMap(json['author'])),
      timeLabel: json['timeLabel']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAtIso: json['createdAtIso']?.toString() ?? '',
      commentCount: _toInt(json['commentCount']),
      replies: _toMapList(
        json['replies'],
      ).map(DiscussionReply.fromJson).toList(growable: false),
      fundReferenceLabel: json['fundReferenceLabel']?.toString(),
      fundReferenceId: json['fundReferenceId']?.toString(),
    );
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

Map<String, dynamic> _toMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const <String, dynamic>{};
}

Map<String, dynamic>? _toNullableMap(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

List<Map<String, dynamic>> _toMapList(Object? value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }
  return value
      .whereType<Map>()
      .map((Map item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}

List<int> _toIntList(Object? value) {
  if (value is! List) {
    return const <int>[];
  }
  return value.map(_toInt).toList(growable: false);
}
