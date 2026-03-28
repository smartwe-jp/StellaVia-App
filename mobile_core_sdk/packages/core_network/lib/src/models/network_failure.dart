import 'package:core_foundation/core_foundation.dart';
import 'package:dio/dio.dart';

enum NetworkFailureType {
  cancelled,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  badResponse,
  connectionError,
  networkAccessDenied,
  unauthorized,
  forbidden,
  serverError,
  unknown,
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required this.type,
    required String message,
    String? code,
    this.statusCode,
    this.path,
    this.rawError,
  }) : super(message, code: code);

  final NetworkFailureType type;
  final int? statusCode;
  final String? path;
  final Object? rawError;

  @override
  String toString() {
    return 'NetworkFailure(type: $type, code: $code, statusCode: $statusCode, path: $path, message: $message)';
  }
}

NetworkFailure mapDioExceptionToFailure(DioException exception) {
  final statusCode = exception.response?.statusCode;
  final path = exception.requestOptions.path;

  switch (exception.type) {
    case DioExceptionType.cancel:
      return NetworkFailure(
        type: NetworkFailureType.cancelled,
        message: 'Request cancelled',
        code: 'request_cancelled',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.connectionTimeout:
      return NetworkFailure(
        type: NetworkFailureType.connectionTimeout,
        message: 'Connection timeout',
        code: 'connection_timeout',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.sendTimeout:
      return NetworkFailure(
        type: NetworkFailureType.sendTimeout,
        message: 'Send timeout',
        code: 'send_timeout',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.receiveTimeout:
      return NetworkFailure(
        type: NetworkFailureType.receiveTimeout,
        message: 'Receive timeout',
        code: 'receive_timeout',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.badCertificate:
      return NetworkFailure(
        type: NetworkFailureType.badCertificate,
        message: 'Bad certificate',
        code: 'bad_certificate',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.connectionError:
      if (_isNetworkAccessDeniedException(exception)) {
        return NetworkFailure(
          type: NetworkFailureType.networkAccessDenied,
          message: 'Network access denied',
          code: 'network_access_denied',
          statusCode: statusCode,
          path: path,
          rawError: exception.error,
        );
      }
      return NetworkFailure(
        type: NetworkFailureType.connectionError,
        message: 'Connection error',
        code: 'connection_error',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.badResponse:
      if (statusCode == 401) {
        return NetworkFailure(
          type: NetworkFailureType.unauthorized,
          message: 'Unauthorized',
          code: 'unauthorized',
          statusCode: statusCode,
          path: path,
          rawError: exception.error,
        );
      }

      if (statusCode == 403) {
        return NetworkFailure(
          type: NetworkFailureType.forbidden,
          message: 'Forbidden',
          code: 'forbidden',
          statusCode: statusCode,
          path: path,
          rawError: exception.error,
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return NetworkFailure(
          type: NetworkFailureType.serverError,
          message: 'Server error',
          code: 'server_error',
          statusCode: statusCode,
          path: path,
          rawError: exception.error,
        );
      }

      return NetworkFailure(
        type: NetworkFailureType.badResponse,
        message: 'Bad response',
        code: 'bad_response',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
    case DioExceptionType.unknown:
      if (_isNetworkAccessDeniedException(exception)) {
        return NetworkFailure(
          type: NetworkFailureType.networkAccessDenied,
          message: 'Network access denied',
          code: 'network_access_denied',
          statusCode: statusCode,
          path: path,
          rawError: exception.error,
        );
      }
      return NetworkFailure(
        type: NetworkFailureType.unknown,
        message: 'Unknown network error',
        code: 'unknown',
        statusCode: statusCode,
        path: path,
        rawError: exception.error,
      );
  }
}

bool _isNetworkAccessDeniedException(DioException exception) {
  final normalized = <String>[
    exception.message ?? '',
    exception.error?.toString() ?? '',
    exception.response?.statusMessage ?? '',
  ].join('\n').toLowerCase();

  return normalized.contains('denied over wi-fi interface') ||
      normalized.contains('denied over wifi interface') ||
      normalized.contains('denied over cellular interface');
}
