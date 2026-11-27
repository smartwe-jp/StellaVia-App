import 'dart:convert';

import 'package:core_network/core_network.dart';

/// Returns backend text only; callers supply their own localized fallback.
String? authErrorMessage(Object error) {
  if (error is DioException) return authResponseMessage(error.response?.data);
  if (error is NetworkFailure && error.rawError != null) {
    return authErrorMessage(error.rawError!);
  }
  if (error is StateError) return authResponseMessage(error.message);
  return null;
}

String? authResponseMessage(Object? payload) {
  if (payload is String) {
    final text = payload.trim();
    if (text.isEmpty) return null;
    if (text.startsWith('{') || text.startsWith('[')) {
      try {
        return authResponseMessage(jsonDecode(text));
      } on FormatException {
        // A plain-text message may also start with a bracket.
      }
    }
    return text;
  }
  if (payload is Map) {
    for (final key in const [
      'error_description',
      'errorDescription',
      'msg',
      'message',
      'detail',
      'error',
      'errors',
    ]) {
      final message = authResponseMessage(payload[key]);
      if (message != null) return message;
    }
    final data = payload['data'];
    if (data is Map || data is List) return authResponseMessage(data);
  }
  if (payload is List) {
    for (final value in payload) {
      final message = authResponseMessage(value);
      if (message != null) return message;
    }
  }
  return null;
}
