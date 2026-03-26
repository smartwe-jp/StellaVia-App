import 'package:core_foundation/core_foundation.dart';
import 'package:core_network/core_network.dart';

String resolveAppRequestErrorMessage(Object error, String fallbackMessage) {
  if (error is StateError) {
    final dynamic raw = error.message;
    final String text = raw?.toString().trim() ?? '';
    if (text.isNotEmpty) {
      return text;
    }
  }
  if (error is Failure) {
    final text = error.message.trim();
    if (text.isNotEmpty &&
        text != 'Bad response' &&
        text != 'Request failed' &&
        text != 'Unknown network error') {
      return text;
    }
  }
  if (error is NetworkFailure) {
    final raw = error.rawError;
    if (raw != null) {
      final nested = resolveAppRequestErrorMessage(raw, '');
      if (nested.trim().isNotEmpty) {
        return nested;
      }
    }
  }
  if (error is DioException) {
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
    if (message.isNotEmpty) {
      return message;
    }
  }
  return fallbackMessage;
}

String? _extractErrorMessageFromPayload(dynamic payload) {
  if (payload == null) {
    return null;
  }
  if (payload is String) {
    final normalized = payload.trim();
    return normalized.isEmpty ? null : normalized;
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
  return normalized.isEmpty ? null : normalized;
}
