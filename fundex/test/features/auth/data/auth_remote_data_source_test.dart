import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/datasources/auth_remote_data_source.dart';

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

class _NoopTokenRefresher implements TokenRefresher {
  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    return null;
  }
}

ResponseBody _jsonOk([String body = '{}']) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

CoreHttpClient _buildClient(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);

  return CoreHttpClient(
    baseUrl: 'https://api.example.com/api',
    tokenStore: InMemoryTokenStore(),
    tokenRefresher: _NoopTokenRefresher(),
    dio: dio,
  );
}

void main() {
  group('AuthRemoteDataSourceImpl', () {
    test('sendLoginCode uses email endpoint for email account', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'GET');
        expect(options.path, AuthApiPaths.emailLoginCode);
        expect(options.queryParameters['email'], 'user@example.com');
        expect(options.extra['auth_required'], false);
        return _jsonOk();
      });
      final source = AuthRemoteDataSourceImpl(client);

      await source.sendLoginCode(account: 'user@example.com');
    });

    test('sendLoginCode uses sms endpoint for mobile account', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'GET');
        expect(options.path, AuthApiPaths.smsCode);
        expect(options.queryParameters['mobile'], '13900000000');
        expect(options.queryParameters['biz'], AuthApiDefaults.defaultIntlCode);
        expect(options.queryParameters['secret'], isA<String>());
        expect(
          (options.queryParameters['secret'] as String).isNotEmpty,
          isTrue,
        );
        expect(options.extra['auth_required'], false);
        return _jsonOk();
      });
      final source = AuthRemoteDataSourceImpl(client);

      await source.sendLoginCode(account: '13900000000');
    });

    test(
      'sendLoginCode forwards selected intl code for mobile account',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'GET');
          expect(options.path, AuthApiPaths.smsCode);
          expect(options.queryParameters['mobile'], '13900000000');
          expect(options.queryParameters['biz'], '86');
          return _jsonOk();
        });
        final source = AuthRemoteDataSourceImpl(client);

        await source.sendLoginCode(account: '13900000000', intlCode: '86');
      },
    );

    test(
      'sendRegisterCode uses email register endpoint for email account',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'GET');
          expect(options.path, AuthApiPaths.createRegisterEmailCode);
          expect(options.queryParameters['email'], 'user@example.com');
          expect(options.extra['auth_required'], false);
          return _jsonOk('{"code":200,"data":true}');
        });
        final source = AuthRemoteDataSourceImpl(client);

        await source.sendRegisterCode(
          account: 'user@example.com',
          intlCode: '81',
        );
      },
    );

    test(
      'sendRegisterCode uses mobile register endpoint for mobile account',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'GET');
          expect(options.path, AuthApiPaths.createRegisterMobileCode);
          expect(options.queryParameters['mobile'], '13900000000');
          expect(options.queryParameters['biz'], '81');
          expect(options.queryParameters['secret'], isA<String>());
          expect(options.extra['auth_required'], false);
          return _jsonOk('{"code":200,"data":true}');
        });
        final source = AuthRemoteDataSourceImpl(client);

        await source.sendRegisterCode(account: '13900000000', intlCode: '81');
      },
    );

    test(
      'loginWithCode uses oauth token endpoint and parses wrapped response',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'POST');
          expect(options.path, AuthApiPaths.oauthToken);
          expect(
            options.headers['Authorization'],
            AuthApiDefaults.oauthClientAuthorization,
          );
          expect(options.contentType, Headers.formUrlEncodedContentType);
          expect(options.extra['auth_required'], false);

          final body = options.data as Map<String, dynamic>;
          expect(body['username'], 'user@example.com');
          expect(body['password'], '123456');
          expect(body['grant_type'], 'password');
          expect(body['auth_type'], 'email');
          expect(body['scope'], 'app');

          return _jsonOk(
            '{"msg":"success","code":200,"data":{"access_token":"newA","refresh_token":"newR","expires_in":3600,"userId":126575,"memberLevel":10,"usename":"user@example.com","intlTelCode":""}}',
          );
        });
        final source = AuthRemoteDataSourceImpl(client);

        final result = await source.loginWithCode(
          account: 'user@example.com',
          code: '123456',
        );

        expect(result.session.accessToken, 'newA');
        expect(result.session.refreshToken, 'newR');
        expect(result.user, isNotNull);
        expect(result.user?.userId, 126575);
        expect(result.user?.memberLevel, 10);
        expect(result.user?.username, 'user@example.com');
      },
    );

    test('loginWithCode forwards selected intl code for mobile login', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, AuthApiPaths.oauthToken);
        final body = options.data as Map<String, dynamic>;
        expect(body['username'], '13900000000');
        expect(body['auth_type'], 'mobile');
        expect(body['code'], '86');
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"access_token":"newA","refresh_token":"newR","expires_in":3600,"mobile":"13900000000"}}',
        );
      });
      final source = AuthRemoteDataSourceImpl(client);

      final result = await source.loginWithCode(
        account: '13900000000',
        code: '123456',
        intlCode: '86',
      );

      expect(result.session.accessToken, 'newA');
      expect(result.session.refreshToken, 'newR');
    });

    test(
      'fetchCurrentUser uses crowdfunding user index-new endpoint and parses nested response',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'GET');
          expect(options.path, AuthApiPaths.crowdfundingUserIndex);
          expect(options.extra['auth_required'], true);
          return _jsonOk(
            '{"msg":"success","code":200,"data":{"baseInfo":{"id":"438786029784006656","memberId":125530,"accountId":"0125530","email":"dennis.diao@51fanxing.co.jp","firstName":"张","lastName":"冠李戴","intlTelCode":81,"phone":"09085309521","address":"東今里１－７－２４","status":4},"identityInfo":{"documentType":11,"documentFrontImage":"https://example.com/front-from-identity.jpg","documentBackImage":"https://example.com/back-from-identity.jpg"},"suitabilityInfo":{"occupation":"COMPANY_EMPLOYEE","annualIncome":"FROM_5M_TO_7M"}}}',
          );
        });
        final source = AuthRemoteDataSourceImpl(client);

        final user = await source.fetchCurrentUser();

        expect(user, isNotNull);
        expect(user?.id, '438786029784006656');
        expect(user?.memberId, 125530);
        expect(user?.userId, 125530);
        expect(user?.accountId, '0125530');
        expect(user?.email, 'dennis.diao@51fanxing.co.jp');
        expect(user?.phone, '09085309521');
        expect(user?.mobile, '09085309521');
        expect(user?.intlTelCode, '81');
        expect(user?.firstName, '张');
        expect(user?.lastName, '冠李戴');
        expect(user?.address, '東今里１－７－２４');
        expect(user?.status, 4);
        expect(user?.frontUrl, 'https://example.com/front-from-identity.jpg');
        expect(user?.backUrl, 'https://example.com/back-from-identity.jpg');
      },
    );

    test(
      'fetchCurrentUser keeps backward compatibility for legacy user index payload',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'GET');
          expect(options.path, AuthApiPaths.crowdfundingUserIndex);
          return _jsonOk(
            '{"msg":"success","code":200,"data":{"id":"438786029784006656","memberId":125530,"accountId":"0125530","email":"dennis.diao@51fanxing.co.jp","firstName":"张","lastName":"冠李戴","intlTelCode":81,"phone":"09085309521","address":"東今里１－７－２４","status":4,"frontUrl":"https://example.com/front.jpg","backUrl":"https://example.com/back.jpg"}}',
          );
        });
        final source = AuthRemoteDataSourceImpl(client);

        final user = await source.fetchCurrentUser();

        expect(user, isNotNull);
        expect(user?.frontUrl, 'https://example.com/front.jpg');
        expect(user?.backUrl, 'https://example.com/back.jpg');
      },
    );

    test(
      'refreshSession uses oauth refresh payload and parses response',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, 'POST');
          expect(options.path, AuthApiPaths.oauthToken);
          expect(
            options.headers['Authorization'],
            AuthApiDefaults.oauthClientAuthorization,
          );
          expect(options.contentType, Headers.formUrlEncodedContentType);
          expect(options.extra['auth_required'], false);

          final body = options.data as Map<String, dynamic>;
          expect(body['grant_type'], 'refresh_token');
          expect(body['refresh_token'], 'old-refresh');

          return _jsonOk(
            '{"access_token":"newA","refresh_token":"newR","expires_in":3600}',
          );
        });
        final source = AuthRemoteDataSourceImpl(client);

        final dto = await source.refreshSession(refreshToken: 'old-refresh');

        expect(dto, isNotNull);
        expect(dto?.accessToken, 'newA');
        expect(dto?.refreshToken, 'newR');
      },
    );

    test('logout uses oauth revoke endpoint with basic auth', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'DELETE');
        expect(options.path, AuthApiPaths.oauthToken);
        expect(
          options.headers['Authorization'],
          AuthApiDefaults.oauthClientAuthorization,
        );
        expect(options.contentType, Headers.jsonContentType);
        expect(options.extra['auth_required'], false);
        expect(options.data, <String, dynamic>{'accessToken': 'access-token'});
        return _jsonOk();
      });
      final source = AuthRemoteDataSourceImpl(client);

      await source.logout(accessToken: 'access-token');
    });

    test('registerApply uses email payload when account is email', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, AuthApiPaths.registerApply);
        expect(options.contentType, Headers.jsonContentType);
        expect(options.extra['auth_required'], false);

        final body = options.data as Map<String, dynamic>;
        expect(body['type'], 'email');
        expect(body['email'], 'user@example.com');
        expect(body['mobile'], '13900000000');
        expect(body['intlTelCode'], '81');
        expect(body['code'], '123456');
        return _jsonOk('{"code":200,"data":true}');
      });
      final source = AuthRemoteDataSourceImpl(client);

      await source.registerApply(
        account: 'user@example.com',
        code: '123456',
        intlCode: '81',
        contact: '13900000000',
      );
    });

    test('registerApply uses mobile payload when account is phone', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, AuthApiPaths.registerApply);
        expect(options.contentType, Headers.jsonContentType);
        expect(options.extra['auth_required'], false);

        final body = options.data as Map<String, dynamic>;
        expect(body['type'], 'mobile');
        expect(body['mobile'], '13900000000');
        expect(body['intlTelCode'], '81');
        expect(body['code'], '123456');
        return _jsonOk('{"code":200,"data":true}');
      });
      final source = AuthRemoteDataSourceImpl(client);

      await source.registerApply(
        account: '13900000000',
        code: '123456',
        intlCode: '81',
      );
    });
  });
}
