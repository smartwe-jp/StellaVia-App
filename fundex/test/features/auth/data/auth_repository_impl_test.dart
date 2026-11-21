import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fundex/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fundex/features/auth/data/models/auth_login_result_dto.dart';
import 'package:fundex/features/auth/data/models/auth_session_dto.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';
import 'package:fundex/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fundex/features/auth/domain/repositories/auth_repository.dart';

class _FakeRemoteDataSource implements AuthRemoteDataSource {
  String? lastSendCodeAccount;
  String? lastRegisterCodeAccount;
  String? lastRegisterIntlCode;
  String? registrationUuid = 'registered-uuid';
  bool exchangeExpired = false;
  int exchangeCount = 0;
  String? lastRegisterAccount;
  String? lastRegisterCode;
  String? lastRegisterContact;
  String? lastRegisterInviteCode;
  String? lastLoginAccount;
  String? lastLoginCode;
  String? lastLoginIntlCode;
  String? lastSendLoginIntlCode;
  String? lastRefreshToken;
  String? lastLogoutAccessToken;
  int fetchCurrentUserCallCount = 0;
  AuthUserDto? fetchedCurrentUser = const AuthUserDto(
    username: 'user@example.com',
    userId: 1001,
    memberId: 1001,
    email: 'user@example.com',
    phone: '09000000000',
    mobile: '09000000000',
    memberLevel: 10,
    intlTelCode: '81',
    firstName: 'Taro',
    lastName: 'Yamada',
  );
  Object? fetchCurrentUserError;

  AuthLoginResultDto loginResult = AuthLoginResultDto(
    session: AuthSessionDto(
      accessToken: 'login-access',
      refreshToken: 'login-refresh',
      expiresAt: DateTime.utc(2100, 1, 1),
    ),
    user: const AuthUserDto(
      username: 'user@example.com',
      userId: 1001,
      email: 'user@example.com',
      memberLevel: 10,
      intlTelCode: '81',
    ),
  );
  AuthSessionDto? refreshResult;
  Object? refreshError;
  Object? logoutError;

  @override
  Future<AuthLoginResultDto> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    lastLoginAccount = account;
    lastLoginCode = code;
    lastLoginIntlCode = intlCode;
    return loginResult;
  }

  @override
  Future<AuthSessionDto?> refreshSession({required String refreshToken}) async {
    lastRefreshToken = refreshToken;
    if (refreshError != null) {
      throw refreshError!;
    }
    return refreshResult;
  }

  @override
  Future<AuthUserDto?> fetchCurrentUser() async {
    fetchCurrentUserCallCount += 1;
    if (fetchCurrentUserError != null) {
      throw fetchCurrentUserError!;
    }
    return fetchedCurrentUser;
  }

  @override
  Future<AuthLoginResultDto> loginWithRegistrationUuid(String uuid) async {
    exchangeCount++;
    if (exchangeExpired) throw StateError('expired');
    expect(uuid, 'registered-uuid');
    return loginResult;
  }

  @override
  Future<String?> registerApply({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
    String? inviteCode,
  }) async {
    lastRegisterAccount = account;
    lastRegisterCode = code;
    lastRegisterIntlCode = intlCode;
    lastRegisterContact = contact;
    lastRegisterInviteCode = inviteCode;
    return registrationUuid;
  }

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {
    lastRegisterCodeAccount = account;
    lastRegisterIntlCode = intlCode;
  }

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {
    lastSendCodeAccount = account;
    lastSendLoginIntlCode = intlCode;
  }

  @override
  Future<void> logout({required String accessToken}) async {
    lastLogoutAccessToken = accessToken;
    if (logoutError != null) {
      throw logoutError!;
    }
  }
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  AuthUserDto? savedUser;
  String? lastSignedOutAccount;
  int clearCount = 0;

  @override
  Future<void> clearCurrentUser() async {
    clearCount += 1;
    savedUser = null;
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async => savedUser;

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    savedUser = user;
  }

  @override
  Future<void> clearLastSignedOutAccount() async {
    lastSignedOutAccount = null;
  }

  @override
  Future<String?> readLastSignedOutAccount() async => lastSignedOutAccount;

  @override
  Future<void> saveLastSignedOutAccount(String account) async {
    lastSignedOutAccount = account;
  }
}

void main() {
  group('AuthRepositoryImpl', () {
    late _FakeRemoteDataSource remote;
    late _FakeAuthLocalDataSource local;
    late InMemoryTokenStore tokenStore;
    late AuthRepositoryImpl repository;

    setUp(() {
      remote = _FakeRemoteDataSource();
      local = _FakeAuthLocalDataSource();
      tokenStore = InMemoryTokenStore();
      repository = AuthRepositoryImpl(
        remote: remote,
        local: local,
        tokenStore: tokenStore,
      );
    });

    test(
      'loginWithCode persists token pair and fetched current user profile',
      () async {
        remote.loginResult = AuthLoginResultDto(
          session: AuthSessionDto(
            accessToken: 'login-access',
            refreshToken: 'login-refresh',
            expiresAt: DateTime.utc(2100, 1, 1),
          ),
          user: null,
        );
        final session = await repository.loginWithCode(
          account: 'user@example.com',
          code: '123456',
          intlCode: '86',
        );

        expect(session.accessToken, 'login-access');
        expect(await tokenStore.readAccessToken(), 'login-access');
        expect(await tokenStore.readRefreshToken(), 'login-refresh');
        expect(remote.lastLoginAccount, 'user@example.com');
        expect(remote.lastLoginCode, '123456');
        expect(remote.lastLoginIntlCode, '86');
        expect(remote.fetchCurrentUserCallCount, 1);
        expect(local.savedUser, isNotNull);
        expect(local.savedUser?.username, 'user@example.com');
        expect(local.savedUser?.memberLevel, 10);
        expect(local.savedUser?.firstName, 'Taro');
        expect(local.savedUser?.phone, '09000000000');
      },
    );

    test(
      'loginWithCode clears persisted auth and rethrows when user fetch fails without fallback user',
      () async {
        remote.loginResult = AuthLoginResultDto(
          session: AuthSessionDto(
            accessToken: 'login-access',
            refreshToken: 'login-refresh',
            expiresAt: DateTime.utc(2100, 1, 1),
          ),
          user: null,
        );
        remote.fetchCurrentUserError = StateError('user fetch failed');

        await expectLater(
          repository.loginWithCode(account: 'user@example.com', code: '123456'),
          throwsA(isA<StateError>()),
        );

        expect(await tokenStore.readAccessToken(), isNull);
        expect(await tokenStore.readRefreshToken(), isNull);
        expect(local.savedUser, isNull);
      },
    );

    test('restoreSession returns true when access token exists', () async {
      await tokenStore.save(
        const TokenPair(accessToken: 'cached-access', refreshToken: 'cached-r'),
      );

      final restored = await repository.restoreSession();

      expect(restored, isTrue);
      expect(remote.lastRefreshToken, isNull);
    });

    test(
      'restoreSession refreshes when only refresh token is available',
      () async {
        await tokenStore.save(
          const TokenPair(accessToken: '', refreshToken: 'r1'),
        );
        remote.refreshResult = AuthSessionDto(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
          expiresAt: DateTime.utc(2100, 1, 1),
        );

        final restored = await repository.restoreSession();

        expect(restored, isTrue);
        expect(remote.lastRefreshToken, 'r1');
        expect(await tokenStore.readAccessToken(), 'new-access');
        expect(await tokenStore.readRefreshToken(), 'new-refresh');
        expect(local.savedUser?.username, 'user@example.com');
      },
    );

    test(
      'registerAccount exchanges the uuid, saves new tokens and refreshes the user',
      () async {
        await tokenStore.save(
          const TokenPair(accessToken: 'access', refreshToken: 'refresh'),
        );
        remote.fetchedCurrentUser = const AuthUserDto(
          username: 'registered@example.com',
          email: 'registered@example.com',
          memberId: 2002,
        );

        await repository.registerAccount(
          account: 'user@example.com',
          code: '123456',
          intlCode: '81',
          contact: '13900000000',
          inviteCode: 'STLV-ABCD1234',
        );

        expect(await tokenStore.readAccessToken(), 'login-access');
        expect(await tokenStore.readRefreshToken(), 'login-refresh');
        expect(remote.lastRegisterAccount, 'user@example.com');
        expect(remote.lastRegisterInviteCode, 'STLV-ABCD1234');
        expect(remote.fetchCurrentUserCallCount, 1);
        expect(local.savedUser?.username, 'registered@example.com');
        expect(local.savedUser?.memberId, 2002);
      },
    );

    test(
      'refreshSession clears local token and user cache when refresh fails',
      () async {
        await tokenStore.save(
          const TokenPair(
            accessToken: 'old-access',
            refreshToken: 'old-refresh',
          ),
        );
        await local.saveCurrentUser(const AuthUserDto(username: 'cached'));
        remote.refreshError = StateError('refresh failed');

        final refreshed = await repository.refreshSession();

        expect(refreshed, isFalse);
        expect(await tokenStore.readAccessToken(), isNull);
        expect(await tokenStore.readRefreshToken(), isNull);
        expect(local.savedUser, isNull);
        expect(local.clearCount, greaterThanOrEqualTo(1));
      },
    );

    test('logout calls remote revoke and clears local auth cache', () async {
      await tokenStore.save(
        const TokenPair(accessToken: 'old-access', refreshToken: 'old-refresh'),
      );
      await local.saveCurrentUser(const AuthUserDto(username: 'cached'));

      await repository.logout();

      expect(remote.lastLogoutAccessToken, 'old-access');
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
      expect(local.savedUser, isNull);
      expect(local.lastSignedOutAccount, 'cached');
    });

    test(
      'logout still clears local auth cache when remote revoke fails',
      () async {
        await tokenStore.save(
          const TokenPair(
            accessToken: 'old-access',
            refreshToken: 'old-refresh',
          ),
        );
        await local.saveCurrentUser(const AuthUserDto(username: 'cached'));
        remote.logoutError = StateError('network');

        await repository.logout();

        expect(remote.lastLogoutAccessToken, 'old-access');
        expect(await tokenStore.readAccessToken(), isNull);
        expect(await tokenStore.readRefreshToken(), isNull);
        expect(local.savedUser, isNull);
        expect(local.lastSignedOutAccount, 'cached');
      },
    );

    test('sendRegisterCode forwards account and intl code', () async {
      await repository.sendRegisterCode(
        account: 'user@example.com',
        intlCode: '81',
      );

      expect(remote.lastRegisterCodeAccount, 'user@example.com');
      expect(remote.lastRegisterIntlCode, '81');
    });

    test('sendLoginCode forwards account and optional intl code', () async {
      await repository.sendLoginCode(account: '13900000000', intlCode: '86');

      expect(remote.lastSendCodeAccount, '13900000000');
      expect(remote.lastSendLoginIntlCode, '86');
    });

    for (final expired in [false, true]) {
      test(
        'registered account can sign in manually when UUID is ${expired ? "expired" : "missing"}',
        () async {
          remote.registrationUuid = expired ? 'registered-uuid' : null;
          remote.exchangeExpired = expired;
          await expectLater(
            repository.registerAccount(
              account: 'new@example.com',
              code: '123456',
              intlCode: '81',
            ),
            throwsA(isA<RegistrationSignInRequired>()),
          );
          expect(remote.exchangeCount, expired ? 1 : 0);
          expect(await tokenStore.readAccessToken(), isNull);
        },
      );
    }

    test('registerAccount forwards register payload', () async {
      await repository.registerAccount(
        account: 'user@example.com',
        code: '123456',
        intlCode: '81',
        contact: '13900000000',
        inviteCode: 'STLV-ABCD1234',
      );

      expect(remote.lastRegisterAccount, 'user@example.com');
      expect(remote.lastRegisterCode, '123456');
      expect(remote.lastRegisterIntlCode, '81');
      expect(remote.lastRegisterContact, '13900000000');
      expect(remote.lastRegisterInviteCode, 'STLV-ABCD1234');
    });
  });
}
