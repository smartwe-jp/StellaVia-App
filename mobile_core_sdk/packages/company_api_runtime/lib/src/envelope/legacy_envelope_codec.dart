class LegacyEnvelopeProfile {
  const LegacyEnvelopeProfile({
    required this.successCodes,
    this.codeKey = 'code',
    this.dataKey = 'data',
    this.primaryMessageKey = 'msg',
    this.secondaryMessageKey = 'message',
  });

  final Set<String> successCodes;
  final String codeKey;
  final String dataKey;
  final String primaryMessageKey;
  final String secondaryMessageKey;
}

class LegacyPageProfile {
  const LegacyPageProfile({this.containerKey = 'data', this.rowsKey = 'rows'});

  final String containerKey;
  final String rowsKey;
}

class LegacyEnvelopeCodec {
  const LegacyEnvelopeCodec({
    this.profile = const LegacyEnvelopeProfile(successCodes: <String>{'200'}),
  });

  final LegacyEnvelopeProfile profile;

  Map<String, dynamic> toJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> toJsonMapList(dynamic value) {
    if (value is List) {
      return value
          .map<Map<String, dynamic>>((dynamic item) => toJsonMap(item))
          .where((Map<String, dynamic> item) => item.isNotEmpty)
          .toList(growable: false);
    }

    final single = toJsonMap(value);
    if (single.isEmpty) {
      return const <Map<String, dynamic>>[];
    }
    return <Map<String, dynamic>>[single];
  }

  bool looksLikeEnvelope(Map<String, dynamic> payload) {
    return payload.containsKey(profile.codeKey) ||
        payload.containsKey(profile.primaryMessageKey) ||
        payload.containsKey(profile.secondaryMessageKey) ||
        payload.containsKey(profile.dataKey);
  }

  bool isSuccessCode(dynamic code) {
    if (code == null) {
      return false;
    }
    final normalized = code.toString().trim();
    return profile.successCodes.contains(normalized);
  }

  bool isTruthyData(dynamic data) {
    if (data == null) {
      return true;
    }
    if (data is bool) {
      return data;
    }
    if (data is num) {
      return data != 0;
    }
    if (data is String) {
      final normalized = data.trim().toLowerCase();
      if (normalized.isEmpty) {
        return true;
      }
      return normalized != 'false' &&
          normalized != '0' &&
          normalized != 'error' &&
          normalized != 'failed' &&
          normalized != 'fail';
    }
    return true;
  }

  String resolveErrorMessage(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final resolved =
        _extractMessageText(payload[profile.primaryMessageKey]) ??
        _extractMessageText(payload[profile.secondaryMessageKey]) ??
        _extractMessageText(payload['error_description']) ??
        _extractMessageText(payload['errorDescription']) ??
        _extractMessageText(payload['detail']) ??
        _extractMessageText(payload['error']) ??
        _extractMessageText(payload);
    return resolved ?? fallbackMessage;
  }

  String? _extractMessageText(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final normalized = value.trim();
      return normalized.isEmpty ? null : normalized;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    if (value is Map) {
      final map = toJsonMap(value);
      final prioritized = <dynamic>[
        map['error_description'],
        map['errorDescription'],
        map[profile.primaryMessageKey],
        map[profile.secondaryMessageKey],
        map['detail'],
        map['error'],
      ];
      for (final candidate in prioritized) {
        final resolved = _extractMessageText(candidate);
        if (resolved != null) {
          return resolved;
        }
      }
      for (final candidate in map.values) {
        final resolved = _extractMessageText(candidate);
        if (resolved != null) {
          return resolved;
        }
      }
      return null;
    }
    if (value is List) {
      for (final item in value) {
        final resolved = _extractMessageText(item);
        if (resolved != null) {
          return resolved;
        }
      }
      return null;
    }
    final normalized = value.toString().trim();
    return normalized.isEmpty ? null : normalized;
  }

  bool isSuccessEnvelope(
    Map<String, dynamic> payload, {
    bool requireTruthyData = false,
  }) {
    if (!looksLikeEnvelope(payload)) {
      return true;
    }

    final code = payload[profile.codeKey];
    if (!isSuccessCode(code)) {
      return false;
    }

    if (!requireTruthyData) {
      return true;
    }

    return isTruthyData(payload[profile.dataKey]);
  }

  Never throwFailure(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    throw StateError(
      resolveErrorMessage(payload, fallbackMessage: fallbackMessage),
    );
  }

  void assertSuccessIfEnvelope(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
    bool requireTruthyData = false,
  }) {
    if (payload.isEmpty || !looksLikeEnvelope(payload)) {
      return;
    }
    if (!isSuccessEnvelope(payload, requireTruthyData: requireTruthyData)) {
      throwFailure(payload, fallbackMessage: fallbackMessage);
    }
  }

  Map<String, dynamic> extractDataMap(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
    bool allowDirectPayload = true,
  }) {
    if (payload.isEmpty) {
      return const <String, dynamic>{};
    }

    if (looksLikeEnvelope(payload)) {
      assertSuccessIfEnvelope(payload, fallbackMessage: fallbackMessage);
      return toJsonMap(payload[profile.dataKey]);
    }

    return allowDirectPayload ? payload : const <String, dynamic>{};
  }

  List<Map<String, dynamic>> extractDataList(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
    bool allowDirectPayload = true,
  }) {
    if (payload.isEmpty) {
      return const <Map<String, dynamic>>[];
    }

    if (looksLikeEnvelope(payload)) {
      assertSuccessIfEnvelope(payload, fallbackMessage: fallbackMessage);
      return toJsonMapList(payload[profile.dataKey]);
    }

    if (!allowDirectPayload) {
      return const <Map<String, dynamic>>[];
    }
    return toJsonMapList(payload);
  }

  List<Map<String, dynamic>> extractPagedRows(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
    LegacyPageProfile pageProfile = const LegacyPageProfile(),
    bool allowDirectRows = true,
  }) {
    if (payload.isEmpty) {
      return const <Map<String, dynamic>>[];
    }

    if (looksLikeEnvelope(payload)) {
      assertSuccessIfEnvelope(payload, fallbackMessage: fallbackMessage);
      final pageData = toJsonMap(payload[pageProfile.containerKey]);
      return toJsonMapList(pageData[pageProfile.rowsKey]);
    }

    if (!allowDirectRows) {
      return const <Map<String, dynamic>>[];
    }
    return toJsonMapList(payload[pageProfile.rowsKey]);
  }

  String extractDataString(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
    List<String> fallbackKeys = const <String>[],
    bool requireTruthyData = true,
  }) {
    if (payload.isEmpty) {
      throw StateError(fallbackMessage);
    }

    if (looksLikeEnvelope(payload)) {
      assertSuccessIfEnvelope(
        payload,
        fallbackMessage: fallbackMessage,
        requireTruthyData: requireTruthyData,
      );
      final text = payload[profile.dataKey]?.toString().trim() ?? '';
      if (text.isEmpty) {
        throw StateError(fallbackMessage);
      }
      return text;
    }

    final keys = <String>[profile.dataKey, ...fallbackKeys];
    for (final key in keys) {
      final text = payload[key]?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }
    throw StateError(fallbackMessage);
  }
}
