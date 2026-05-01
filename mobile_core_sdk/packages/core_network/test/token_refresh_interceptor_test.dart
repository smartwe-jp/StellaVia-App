import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }
}

class _FakeTokenRefresher implements TokenRefresher {
  _FakeTokenRefresher(this.onRefresh);

  final Future<TokenPair?> Function(String refreshToken) onRefresh;

  @override
  Future<TokenPair?> refresh(String refreshToken) => onRefresh(refreshToken);
}

class _FakeAuthFailureHandler implements AuthFailureHandler {
  final List<AuthFailureReason> reasons = <AuthFailureReason>[];

  @override
  Future<void> onAuthFailure(AuthFailureReason reason) async {
    reasons.add(reason);
  }
}

ResponseBody _jsonOk() {
  return ResponseBody.fromString(
    '{"ok":true}',
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

void main() {
  group('CoreHttpClient auth + error flow', () {
    test('adds Authorization header from token store on request', () async {
      final store = InMemoryTokenStore();
      await store.save(
        const TokenPair(accessToken: 'oldA', refreshToken: 'oldR'),
      );

      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        expect(options.headers['Authorization'], 'Bearer oldA');
        return _jsonOk();
      });

      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((_) async => null),
        dio: dio,
      );

      final response = await client.dio.get<Map<String, dynamic>>('/check');
      expect(response.statusCode, 200);
    });

    test('refreshes token and retries after single 401', () async {
      final store = InMemoryTokenStore();
      await store.save(
        const TokenPair(accessToken: 'expiredA', refreshToken: 'validR'),
      );

      var callCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        callCount += 1;
        if (callCount == 1) {
          return ResponseBody.fromString('unauthorized', 401);
        }

        expect(options.headers['Authorization'], 'Bearer newA');
        expect(options.extra['token_retry_attempt'], 1);
        return _jsonOk();
      });

      var refreshCount = 0;
      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((refreshToken) async {
          refreshCount += 1;
          expect(refreshToken, 'validR');
          return const TokenPair(accessToken: 'newA', refreshToken: 'newR');
        }),
        dio: dio,
      );

      final response = await client.dio.get<Map<String, dynamic>>('/secure');

      expect(response.statusCode, 200);
      expect(refreshCount, 1);
      expect(callCount, 2);
      expect(await store.readAccessToken(), 'newA');
      expect(await store.readRefreshToken(), 'newR');
    });

    test('uses one refresh for concurrent 401 responses', () async {
      final store = InMemoryTokenStore();
      await store.save(
        const TokenPair(accessToken: 'expiredA', refreshToken: 'validR'),
      );

      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        final authHeader = options.headers['Authorization'];
        if (authHeader == 'Bearer expiredA') {
          return ResponseBody.fromString('unauthorized', 401);
        }
        return _jsonOk();
      });

      var refreshCount = 0;
      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((_) async {
          refreshCount += 1;
          await Future<void>.delayed(const Duration(milliseconds: 80));
          return const TokenPair(accessToken: 'newA', refreshToken: 'newR');
        }),
        dio: dio,
      );

      final responses = await Future.wait(<Future<Response<dynamic>>>[
        client.dio.get<dynamic>('/secure-a'),
        client.dio.get<dynamic>('/secure-b'),
      ]);

      expect(responses, hasLength(2));
      expect(responses.every((response) => response.statusCode == 200), isTrue);
      expect(refreshCount, 1);
      expect(await store.readAccessToken(), 'newA');
    });

    test(
      'retries more than once when maxAuthRetryAttempts is configured',
      () async {
        final store = InMemoryTokenStore();
        await store.save(
          const TokenPair(accessToken: 'expiredA', refreshToken: 'validR'),
        );

        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
        dio.httpClientAdapter = _FakeAdapter((options) async {
          final attempt = (options.extra['token_retry_attempt'] as int?) ?? 0;
          if (attempt < 2) {
            return ResponseBody.fromString('unauthorized', 401);
          }

          expect(options.headers['Authorization'], 'Bearer newA2');
          return _jsonOk();
        });

        var refreshCount = 0;
        final client = CoreHttpClient(
          baseUrl: 'https://api.example.com',
          tokenStore: store,
          tokenRefresher: _FakeTokenRefresher((_) async {
            refreshCount += 1;
            return TokenPair(
              accessToken: 'newA$refreshCount',
              refreshToken: 'newR$refreshCount',
            );
          }),
          maxAuthRetryAttempts: 2,
          dio: dio,
        );

        final response = await client.dio.get<dynamic>('/secure');

        expect(response.statusCode, 200);
        expect(refreshCount, 2);
        expect(await store.readAccessToken(), 'newA2');
        expect(await store.readRefreshToken(), 'newR2');
      },
    );

    test(
      'clears token and triggers unified logout when refresh returns null',
      () async {
        final store = InMemoryTokenStore();
        await store.save(
          const TokenPair(accessToken: 'expiredA', refreshToken: 'badR'),
        );

        final failureHandler = _FakeAuthFailureHandler();
        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
        dio.httpClientAdapter = _FakeAdapter((_) async {
          return ResponseBody.fromString('unauthorized', 401);
        });

        final client = CoreHttpClient(
          baseUrl: 'https://api.example.com',
          tokenStore: store,
          tokenRefresher: _FakeTokenRefresher((_) async => null),
          authFailureHandler: failureHandler,
          dio: dio,
        );

        await expectLater(
          () => client.dio.get<Map<String, dynamic>>('/secure'),
          throwsA(isA<DioException>()),
        );

        expect(failureHandler.reasons, <AuthFailureReason>[
          AuthFailureReason.refreshReturnedNull,
        ]);
        expect(await store.readAccessToken(), isNull);
        expect(await store.readRefreshToken(), isNull);
      },
    );

    test(
      'clears token and triggers unified logout when retry is exhausted',
      () async {
        final store = InMemoryTokenStore();
        await store.save(
          const TokenPair(accessToken: 'expiredA', refreshToken: 'validR'),
        );

        final failureHandler = _FakeAuthFailureHandler();
        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
        dio.httpClientAdapter = _FakeAdapter((_) async {
          return ResponseBody.fromString('unauthorized', 401);
        });

        final client = CoreHttpClient(
          baseUrl: 'https://api.example.com',
          tokenStore: store,
          tokenRefresher: _FakeTokenRefresher((_) async {
            return const TokenPair(accessToken: 'newA', refreshToken: 'newR');
          }),
          authFailureHandler: failureHandler,
          maxAuthRetryAttempts: 1,
          dio: dio,
        );

        await expectLater(
          () => client.dio.get<Map<String, dynamic>>('/secure'),
          throwsA(isA<DioException>()),
        );

        expect(
          failureHandler.reasons,
          contains(AuthFailureReason.retryExhausted),
        );
        expect(await store.readAccessToken(), isNull);
        expect(await store.readRefreshToken(), isNull);
      },
    );

    test(
      'oauth2 endpoint refresher builds legacy payload and parses snake_case',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
        dio.httpClientAdapter = _FakeAdapter((options) async {
          expect(options.path, 'uaa/oauth/token');
          expect(options.method, 'POST');
          expect(options.contentType, Headers.formUrlEncodedContentType);
          expect(options.headers['Authorization'], 'Basic abc123');
          expect(options.extra['auth_required'], false);

          final body = options.data as Map<String, dynamic>;
          expect(body['grant_type'], 'refresh_token');
          expect(body['refresh_token'], 'oldR');
          expect(body['stellavia_app'], 'app');

          return ResponseBody.fromString(
            '{"access_token":"newA","refresh_token":"newR"}',
            200,
            headers: <String, List<String>>{
              Headers.contentTypeHeader: <String>['application/json'],
            },
          );
        });

        final refresher = EndpointTokenRefresher.oauth2(
          dio,
          refreshPath: 'uaa/oauth/token',
          basicAuthorization: 'Basic abc123',
          scope: 'app',
        );

        final pair = await refresher.refresh('oldR');

        expect(pair?.accessToken, 'newA');
        expect(pair?.refreshToken, 'newR');
      },
    );

    test('maps dio errors into NetworkFailure model', () async {
      final store = InMemoryTokenStore();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'network down',
        );
      });

      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((_) async => null),
        dio: dio,
      );

      try {
        await client.dio.get<dynamic>('/health');
        fail('expected error');
      } on DioException catch (error) {
        expect(error.error, isA<NetworkFailure>());
        final failure = error.error as NetworkFailure;
        expect(failure.type, NetworkFailureType.connectionError);
        expect(failure.path, '/health');
      }
    });

    test(
      'maps iOS denied interface errors into network access denied failure',
      () async {
        final store = InMemoryTokenStore();
        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
        dio.httpClientAdapter = _FakeAdapter((options) async {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'unsatisfied (Denied over Wi-Fi interface)',
          );
        });

        final client = CoreHttpClient(
          baseUrl: 'https://api.example.com',
          tokenStore: store,
          tokenRefresher: _FakeTokenRefresher((_) async => null),
          dio: dio,
        );

        try {
          await client.dio.get<dynamic>('/health');
          fail('expected error');
        } on DioException catch (error) {
          expect(error.error, isA<NetworkFailure>());
          final failure = error.error as NetworkFailure;
          expect(failure.type, NetworkFailureType.networkAccessDenied);
          expect(failure.code, 'network_access_denied');
        }
      },
    );
  });
}
