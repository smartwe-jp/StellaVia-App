import 'package:dio/dio.dart';

import '../auth/auth_failure_handler.dart';
import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../models/token_pair.dart';
import 'auth_interceptor.dart';

const String _retryAttemptExtraKey = 'token_retry_attempt';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required Dio dio,
    required TokenStore tokenStore,
    required TokenRefresher tokenRefresher,
    AuthFailureHandler? authFailureHandler,
    int maxRetryAttempts = 1,
  }) : _dio = dio,
       _tokenStore = tokenStore,
       _tokenRefresher = tokenRefresher,
       _authFailureHandler =
           authFailureHandler ?? const NoopAuthFailureHandler(),
       _maxRetryAttempts = maxRetryAttempts < 1 ? 1 : maxRetryAttempts;

  final Dio _dio;
  final TokenStore _tokenStore;
  final TokenRefresher _tokenRefresher;
  final AuthFailureHandler _authFailureHandler;
  final int _maxRetryAttempts;

  Future<TokenPair?>? _refreshing;
  Future<void>? _handlingAuthFailure;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isUnauthorized(err.requestOptions, err.response?.statusCode) &&
        !_shouldRefresh(err.requestOptions, err.response?.statusCode)) {
      await _handleAuthFailure(AuthFailureReason.retryExhausted);
      handler.next(err);
      return;
    }

    if (!_shouldRefresh(err.requestOptions, err.response?.statusCode)) {
      handler.next(err);
      return;
    }

    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _handleAuthFailure(AuthFailureReason.missingRefreshToken);
      handler.next(err);
      return;
    }

    TokenPair? pair;
    try {
      pair = await _queueRefresh(refreshToken);
    } on DioException {
      await _handleAuthFailure(AuthFailureReason.refreshRequestFailed);
      handler.next(err);
      return;
    } catch (_) {
      await _handleAuthFailure(AuthFailureReason.refreshRequestFailed);
      handler.next(err);
      return;
    }

    if (pair == null) {
      await _handleAuthFailure(AuthFailureReason.refreshReturnedNull);
      handler.next(err);
      return;
    }

    await _tokenStore.save(pair);

    try {
      final response = await _retryWithToken(
        err.requestOptions,
        pair.accessToken,
      );
      handler.resolve(response);
    } on DioException catch (retryErr) {
      if (_isUnauthorized(
            retryErr.requestOptions,
            retryErr.response?.statusCode,
          ) &&
          !_shouldRefresh(
            retryErr.requestOptions,
            retryErr.response?.statusCode,
          )) {
        await _handleAuthFailure(AuthFailureReason.retryExhausted);
      }
      handler.next(retryErr);
    } catch (_) {
      handler.next(err);
    }
  }

  bool _isUnauthorized(RequestOptions request, int? statusCode) {
    return statusCode == 401 && isAuthRequired(request);
  }

  bool _shouldRefresh(RequestOptions request, int? statusCode) {
    if (!_isUnauthorized(request, statusCode)) {
      return false;
    }

    return _readRetryAttempt(request) < _maxRetryAttempts;
  }

  int _readRetryAttempt(RequestOptions request) {
    final value = request.extra[_retryAttemptExtraKey];
    if (value is int) {
      return value;
    }
    return 0;
  }

  Future<TokenPair?> _queueRefresh(String refreshToken) {
    if (_refreshing != null) {
      return _refreshing!;
    }

    final future = _tokenRefresher.refresh(refreshToken);
    _refreshing = future.whenComplete(() {
      _refreshing = null;
    });
    return _refreshing!;
  }

  Future<void> _handleAuthFailure(AuthFailureReason reason) {
    if (_handlingAuthFailure != null) {
      return _handlingAuthFailure!;
    }

    final future = () async {
      await _tokenStore.clear();
      await _authFailureHandler.onAuthFailure(reason);
    }();

    _handlingAuthFailure = future.whenComplete(() {
      _handlingAuthFailure = null;
    });

    return _handlingAuthFailure!;
  }

  Future<Response<dynamic>> _retryWithToken(
    RequestOptions request,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(request.headers)
      ..['Authorization'] = 'Bearer $accessToken';
    final extra = Map<String, dynamic>.from(request.extra)
      ..[_retryAttemptExtraKey] = _readRetryAttempt(request) + 1;

    final retry = request.copyWith(headers: headers, extra: extra);

    return _dio.fetch<dynamic>(retry);
  }
}
