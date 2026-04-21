import 'package:core_foundation/core_foundation.dart';
import 'package:core_network/core_network.dart';

String resolveAppRequestErrorMessage(Object error, String fallbackMessage) {
  if (error is StateError) {
    final dynamic raw = error.message;
    final String text = raw?.toString().trim() ?? '';
    if (_isMeaningfulUserFacingMessage(text)) {
      return text;
    }
  }
  if (error is NetworkFailure) {
    if (!_shouldExposeServerMessage(error.statusCode)) {
      return fallbackMessage;
    }
    final raw = error.rawError;
    if (raw != null) {
      final nested = resolveAppRequestErrorMessage(raw, '');
      if (nested.trim().isNotEmpty) {
        return nested;
      }
    }
    final text = error.message.trim();
    if (_isMeaningfulUserFacingMessage(text)) {
      return text;
    }
    return fallbackMessage;
  }
  if (error is Failure) {
    final text = error.message.trim();
    if (_isMeaningfulUserFacingMessage(text)) {
      return text;
    }
  }
  if (error is DioException) {
    if (!_shouldExposeServerMessage(error.response?.statusCode)) {
      return fallbackMessage;
    }
    final responseData = error.response?.data;
    final resolved = _extractErrorMessageFromPayload(responseData);
    if (resolved != null) {
      return resolved;
    }
    final nestedError = error.error;
    if (nestedError != null && nestedError != error) {
      final nested = resolveAppRequestErrorMessage(nestedError, '');
      if (nested.trim().isNotEmpty) {
        return nested;
      }
    }
    final message = error.message?.trim() ?? '';
    if (_isMeaningfulUserFacingMessage(message)) {
      return message;
    }
  }
  return fallbackMessage;
}

bool _shouldExposeServerMessage(int? statusCode) {
  if (statusCode == null) {
    return true;
  }
  return statusCode >= 400 && statusCode < 500;
}

String? _extractErrorMessageFromPayload(dynamic payload) {
  if (payload == null) {
    return null;
  }
  if (payload is String) {
    final normalized = payload.trim();
    return _isMeaningfulUserFacingMessage(normalized) ? normalized : null;
  }
  if (payload is num || payload is bool) {
    return payload.toString();
  }
  if (payload is Map) {
    final map = payload is Map<String, dynamic>
        ? payload
        : Map<String, dynamic>.from(payload);
    final prioritized = <dynamic>[
      map['error_description'],
      map['errorDescription'],
      map['msg'],
      map['message'],
      map['detail'],
      map['error'],
    ];
    for (final candidate in prioritized) {
      final resolved = _extractErrorMessageFromPayload(candidate);
      if (resolved != null) {
        return resolved;
      }
    }
    for (final candidate in map.values) {
      final resolved = _extractErrorMessageFromPayload(candidate);
      if (resolved != null) {
        return resolved;
      }
    }
    return null;
  }
  if (payload is List) {
    for (final item in payload) {
      final resolved = _extractErrorMessageFromPayload(item);
      if (resolved != null) {
        return resolved;
      }
    }
    return null;
  }
  final normalized = payload.toString().trim();
  return _isMeaningfulUserFacingMessage(normalized) ? normalized : null;
}

bool _isMeaningfulUserFacingMessage(String text) {
  if (text.isEmpty) {
    return false;
  }
  final normalized = text.trim().toLowerCase();
  const genericMessages = <String>{
    'bad response',
    'request failed',
    'unknown network error',
    'server error',
    'internal server error',
  };
  return !genericMessages.contains(normalized);
}
