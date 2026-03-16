import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';

import '../observability/app_observability_providers.dart';

class AppObservabilityInterceptor extends Interceptor {
  AppObservabilityInterceptor({
    required AppLogger logger,
    required void Function(AppUiMessageKey messageKey) reportErrorMessage,
    this.includeHttpPayloadLog = false,
  }) : _logger = logger,
       _reportErrorMessage = reportErrorMessage;

  final AppLogger _logger;
  final void Function(AppUiMessageKey messageKey) _reportErrorMessage;
  final bool includeHttpPayloadLog;

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
      _logger.error(
        'HTTP failure',
        error: failure,
        stackTrace: err.stackTrace,
        context: <String, Object?>{
          'method': err.requestOptions.method,
          'path': err.requestOptions.path,
          'statusCode': failure.statusCode,
          'failureType': failure.type.name,
          if (includeHttpPayloadLog && err.response?.data != null)
            'responseData': _stringifyForLog(err.response?.data),
        },
      );

      final userMessage = _mapUserMessage(failure);
      if (userMessage != null) {
        _reportErrorMessage(userMessage);
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
        if (includeHttpPayloadLog && err.response?.data != null)
          'responseData': _stringifyForLog(err.response?.data),
      },
    );
    _reportErrorMessage(AppUiMessageKey.requestFailed);
    handler.next(err);
  }

  AppUiMessageKey? _mapUserMessage(NetworkFailure failure) {
    switch (failure.type) {
      case NetworkFailureType.cancelled:
        return null;
      case NetworkFailureType.connectionTimeout:
      case NetworkFailureType.sendTimeout:
      case NetworkFailureType.receiveTimeout:
      case NetworkFailureType.connectionError:
        return AppUiMessageKey.networkUnavailable;
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
}
