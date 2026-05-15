import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';

class _SeededTokenStore implements TokenStore {
  _SeededTokenStore({String? accessToken, String? refreshToken})
    : _accessToken = accessToken,
      _refreshToken = refreshToken;

  String? _accessToken;
  String? _refreshToken;
  bool clearCalled = false;

  @override
  Future<void> clear() async {
    clearCalled = true;
    _accessToken = null;
    _refreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> save(TokenPair pair) async {
    _accessToken = pair.accessToken;
    _refreshToken = pair.refreshToken;
  }
}

class _FakeTokenRefresher implements TokenRefresher {
  _FakeTokenRefresher(this._handler);

  final Future<TokenPair?> Function(String refreshToken) _handler;
  int refreshCalled = 0;

  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    refreshCalled += 1;
    return _handler(refreshToken);
  }
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  bool clearCalled = false;
  AuthUserDto? cachedUser;
  String? lastSignedOutAccount;
  Completer<void>? clearCompleter;

  @override
  Future<void> clearCurrentUser() async {
    clearCalled = true;
    cachedUser = null;
    final completer = clearCompleter;
    if (completer != null) {
      await completer.future;
    }
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async => cachedUser;

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    cachedUser = user;
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
  group('AuthSessionController', () {
    test('keeps authenticated state when access token exists', () async {
      final tokenStore = _SeededTokenStore(
        accessToken: 'cached-access',
        refreshToken: 'cached-refresh',
      );
      final refresher = _FakeTokenRefresher((_) async => null);
      final local = _FakeAuthLocalDataSource();

      final controller = AuthSessionController(tokenStore, refresher, local);
      await controller.refresh();

      expect(controller.state.value, isTrue);
      expect(refresher.refreshCalled, 0);
      expect(local.clearCalled, isFalse);
    });

    test('refreshes with refresh token when access token missing', () async {
      final tokenStore = _SeededTokenStore(refreshToken: 'old-refresh');
      final refresher = _FakeTokenRefresher((refreshToken) async {
        expect(refreshToken, 'old-refresh');
        return const TokenPair(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
      });
      final local = _FakeAuthLocalDataSource();

      final controller = AuthSessionController(tokenStore, refresher, local);
      await controller.refresh();

      expect(controller.state.value, isTrue);
      expect(await tokenStore.readAccessToken(), 'new-access');
      expect(await tokenStore.readRefreshToken(), 'new-refresh');
      expect(local.clearCalled, isFalse);
    });

    test(
      'refreshes with refresh token and syncs cached user via fetchCurrentUser callback',
      () async {
        final tokenStore = _SeededTokenStore(refreshToken: 'old-refresh');
        final refresher = _FakeTokenRefresher((_) async {
          return const TokenPair(
            accessToken: 'new-access',
            refreshToken: 'new-refresh',
          );
        });
        final local = _FakeAuthLocalDataSource();
        var fetchCalled = 0;

        final controller = AuthSessionController(
          tokenStore,
          refresher,
          local,
          fetchCurrentUser: () async {
            fetchCalled += 1;
            return const AuthUserDto(
              username: 'dennis.diao@51fanxing.co.jp',
              email: 'dennis.diao@51fanxing.co.jp',
              phone: '09085309521',
              memberId: 125530,
              intlTelCode: '81',
            );
          },
        );
        await controller.refresh();

        expect(controller.state.value, isTrue);
        expect(fetchCalled, greaterThanOrEqualTo(1));
        expect(local.cachedUser, isNotNull);
        expect(local.cachedUser?.email, 'dennis.diao@51fanxing.co.jp');
        expect(local.cachedUser?.phone, '09085309521');
        expect(local.cachedUser?.memberId, 125530);
      },
    );

    test(
      'falls back to unauthenticated and clears token and cached user on refresh failure',
      () async {
        final tokenStore = _SeededTokenStore(refreshToken: 'old-refresh');
        final refresher = _FakeTokenRefresher((_) async {
          throw StateError('refresh failed');
        });
        final local = _FakeAuthLocalDataSource()
          ..cachedUser = const AuthUserDto(username: 'cached-user');

        final controller = AuthSessionController(tokenStore, refresher, local);
        await controller.refresh();

        expect(controller.state.value, isFalse);
        expect(tokenStore.clearCalled, isTrue);
        expect(await tokenStore.readAccessToken(), isNull);
        expect(await tokenStore.readRefreshToken(), isNull);
        expect(local.clearCalled, isTrue);
        expect(local.cachedUser, isNull);
      },
    );

    test(
      'marks unauthenticated before cached user cleanup completes',
      () async {
        final tokenStore = _SeededTokenStore(
          accessToken: 'cached-access',
          refreshToken: 'cached-refresh',
        );
        final refresher = _FakeTokenRefresher((_) async => null);
        final local = _FakeAuthLocalDataSource()
          ..cachedUser = const AuthUserDto(username: 'cached-user')
          ..clearCompleter = Completer<void>();

        final controller = AuthSessionController(tokenStore, refresher, local);
        await controller.refresh();
        expect(controller.state.value, isTrue);

        final markFuture = controller.markUnauthenticated();

        expect(controller.state.value, isFalse);
        expect(local.clearCalled, isTrue);
        local.clearCompleter!.complete();
        await markFuture;
      },
    );
  });
}
