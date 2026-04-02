import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter/foundation.dart';

import '../support/app_request_error_message_resolver.dart';
import '../observability/app_observability_providers.dart';

class AppObservabilityInterceptor extends Interceptor {
  AppObservabilityInterceptor({
    required AppLogger logger,
    required void Function(AppUiMessageKey messageKey, {String? customMessage})
    reportErrorMessage,
    required void Function() markNetworkAccessDenied,
    required void Function() clearNetworkAccessDenied,
    this.includeHttpPayloadLog = false,
    this.includeHttpResponseLog = true,
  }) : _logger = logger,
       _reportErrorMessage = reportErrorMessage,
       _markNetworkAccessDenied = markNetworkAccessDenied,
       _clearNetworkAccessDenied = clearNetworkAccessDenied;

  final AppLogger _logger;
  final void Function(AppUiMessageKey messageKey, {String? customMessage})
  _reportErrorMessage;
  final void Function() _markNetworkAccessDenied;
  final void Function() _clearNetworkAccessDenied;
  final bool includeHttpPayloadLog;
  final bool includeHttpResponseLog;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final context = <String, Object?>{
      'method': options.method,
      'path': options.path,
    };
    if (includeHttpPayloadLog) {
      if (options.queryParameters.isNotEmpty) {
        context['query'] = _stringifyForLog(options.queryParameters);
      }
      if (options.data != null) {
        context['data'] = _stringifyForLog(options.data);
      }
    }
    _logger.debug('HTTP request', context: context);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _clearNetworkAccessDenied();
    if (!includeHttpResponseLog) {
      handler.next(response);
      return;
    }
    final context = <String, Object?>{
      'method': response.requestOptions.method,
      'path': response.requestOptions.path,
      'statusCode': response.statusCode,
    };
    if (includeHttpPayloadLog) {
      context['dataType'] = response.data.runtimeType.toString();
      context['data'] = _stringifyForLog(response.data);
    }
    _logger.debug('HTTP response', context: context);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = err.error;
    if (failure is NetworkFailure) {
      final context = <String, Object?>{
        'method': err.requestOptions.method,
        'path': err.requestOptions.path,
        'statusCode': failure.statusCode,
        'failureType': failure.type.name,
        if (includeHttpPayloadLog &&
            includeHttpResponseLog &&
            err.response?.data != null)
          'responseData': _stringifyForLog(err.response?.data),
      };
      final shouldTreatAsRestrictedNetwork =
          failure.type == NetworkFailureType.networkAccessDenied ||
          (_isApplePlatform &&
              failure.type == NetworkFailureType.connectionError &&
              failure.statusCode == null);
      if (shouldTreatAsRestrictedNetwork) {
        _markNetworkAccessDenied();
        _logger.warning('HTTP network access restricted', context: context);
      } else {
        _clearNetworkAccessDenied();
        _logger.error(
          'HTTP failure',
          error: failure,
          stackTrace: err.stackTrace,
          context: context,
        );
      }

      final userMessage = _mapUserMessage(failure);
      if (userMessage != null) {
        _reportErrorMessage(
          userMessage,
          customMessage: _resolveCustomMessage(err, failure),
        );
      }
      handler.next(err);
      return;
    }

    _logger.error(
      'Unexpected dio error',
      error: err.error ?? err.message,
      stackTrace: err.stackTrace,
      context: <String, Object?>{
        'method': err.requestOptions.method,
        'path': err.requestOptions.path,
        if (includeHttpPayloadLog &&
            includeHttpResponseLog &&
            err.response?.data != null)
          'responseData': _stringifyForLog(err.response?.data),
      },
    );
    _reportErrorMessage(
      AppUiMessageKey.requestFailed,
      customMessage: _resolveCustomMessage(err, null),
    );
    handler.next(err);
  }

  String? _resolveCustomMessage(DioException err, NetworkFailure? failure) {
    final statusCode = failure?.statusCode ?? err.response?.statusCode;
    if (!_shouldUseServerCustomMessage(statusCode)) {
      return null;
    }
    if (failure != null &&
        failure.type != NetworkFailureType.badResponse &&
        failure.type != NetworkFailureType.unauthorized &&
        failure.type != NetworkFailureType.forbidden) {
      return null;
    }
    final resolved = resolveAppRequestErrorMessage(err, '').trim();
    if (resolved.isEmpty ||
        resolved == 'Bad response' ||
        resolved == 'Request failed' ||
        resolved == 'Unknown network error' ||
        resolved == 'Server error') {
      return null;
    }
    return resolved;
  }

  bool _shouldUseServerCustomMessage(int? statusCode) {
    if (statusCode == null) {
      return false;
    }
    return statusCode >= 400 && statusCode < 500;
  }

  AppUiMessageKey? _mapUserMessage(NetworkFailure failure) {
    switch (failure.type) {
      case NetworkFailureType.cancelled:
        return null;
      case NetworkFailureType.connectionTimeout:
      case NetworkFailureType.sendTimeout:
      case NetworkFailureType.receiveTimeout:
        return AppUiMessageKey.networkUnavailable;
      case NetworkFailureType.connectionError:
        if (_isApplePlatform) {
          return AppUiMessageKey.networkAccessDenied;
        }
        return AppUiMessageKey.networkUnavailable;
      case NetworkFailureType.networkAccessDenied:
        return AppUiMessageKey.networkAccessDenied;
      case NetworkFailureType.unauthorized:
        return AppUiMessageKey.authExpired;
      case NetworkFailureType.forbidden:
        return AppUiMessageKey.forbidden;
      case NetworkFailureType.serverError:
        return AppUiMessageKey.serverUnavailable;
      case NetworkFailureType.badCertificate:
      case NetworkFailureType.badResponse:
      case NetworkFailureType.unknown:
        return AppUiMessageKey.requestFailed;
    }
  }

  String _stringifyForLog(dynamic value) {
    final text = value?.toString() ?? 'null';
    const maxLen = 2000;
    if (text.length <= maxLen) {
      return text;
    }
    return '${text.substring(0, maxLen)}...<truncated>';
  }

  bool get _isApplePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
}
