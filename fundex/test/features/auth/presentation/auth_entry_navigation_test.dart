import 'dart:io';

import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/app.dart';
import 'package:fundex/app/config/app_environment.dart';
import 'package:fundex/app/config/app_flavor.dart';
import 'package:fundex/app/config/environment_provider.dart';
import 'package:fundex/app/network/app_network_providers.dart';
import 'package:fundex/app/observability/app_observability_providers.dart';
import 'package:fundex/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';
import 'package:fundex/features/auth/domain/entities/auth_session.dart';
import 'package:fundex/features/auth/domain/repositories/auth_repository.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';

class _NoopAppLogger implements AppLogger {
  @override
  void debug(String message, {Map<String, Object?> context = const {}}) {}

  @override
  Future<void> dispose() async {}

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {}

  @override
  Future<File> exportLogs({Directory? outputDirectory}) {
    throw UnsupportedError('No log file is available in widget tests.');
  }

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {}

  @override
  Future<List<File>> listLogFiles() async => <File>[];

  @override
  void log(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {}

  @override
  void warning(String message, {Map<String, Object?> context = const {}}) {}
}

class _SeededTokenStore implements TokenStore {
  _SeededTokenStore({String? accessToken, String? refreshToken})
    : _accessToken = accessToken,
      _refreshToken = refreshToken;

  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> clear() async {
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
  _FakeTokenRefresher(this._onRefresh);

  final Future<TokenPair?> Function(String refreshToken) _onRefresh;

  @override
  Future<TokenPair?> refresh(String refreshToken) {
    return _onRefresh(refreshToken);
  }
}

class _InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  AuthUserDto? _user;
  String? _lastSignedOutAccount;

  @override
  Future<void> clearCurrentUser() async {
    _user = null;
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async => _user;

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    _user = user;
  }

  @override
  Future<void> clearLastSignedOutAccount() async {
    _lastSignedOutAccount = null;
  }

  @override
  Future<String?> readLastSignedOutAccount() async => _lastSignedOutAccount;

  @override
  Future<void> saveLastSignedOutAccount(String account) async {
    _lastSignedOutAccount = account;
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    return AuthSession(
      accessToken: 'token-a',
      refreshToken: 'token-r',
      expiresAt: DateTime.utc(2100, 1, 1),
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> refreshSession() async {
    return true;
  }

  @override
  Future<bool> restoreSession() async {
    return true;
  }

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {}

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {}

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {}
}

Future<void> _pumpApp(WidgetTester tester) async {
  final environment = EnvironmentFactory.fromFlavor(AppFlavor.dev);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appEnvironmentProvider.overrideWithValue(environment),
        appLoggerProvider.overrideWithValue(_NoopAppLogger()),
        tokenStoreProvider.overrideWithValue(_SeededTokenStore()),
        tokenRefresherProvider.overrideWithValue(
          _FakeTokenRefresher((_) async => null),
        ),
        authLocalDataSourceProvider.overrideWithValue(
          _InMemoryAuthLocalDataSource(),
        ),
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
      ],
      child: const MemberTemplateApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 2600));
  await tester.pumpAndSettle();
}

Future<void> _openLoginPage(WidgetTester tester) async {
  await _openRoute(tester, '/login');
}

Future<void> _openRoute(
  WidgetTester tester,
  String path, {
  Object? extra,
}) async {
  final routerContext = tester.element(find.byType(Navigator).first);
  GoRouter.of(routerContext).go(path, extra: extra);
  await tester.pumpAndSettle();
}

void main() {
  group('Auth login navigation', () {
    testWidgets('navigates from login to register flow and back', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openLoginPage(tester);
      expect(find.byKey(const Key('login_page')), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('to_register_button')));
      await tester.tap(find.byKey(const Key('to_register_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('register_page')), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('register_back_login_button')),
      );
      await tester.tap(find.byKey(const Key('register_back_login_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_page')), findsOneWidget);
    });

    testWidgets('opens forgot password route and returns to login', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openRoute(tester, '/forgot-password');
      expect(find.byKey(const Key('forgot_password_page')), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('forgot_back_login_button')),
      );
      await tester.tap(find.byKey(const Key('forgot_back_login_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_page')), findsOneWidget);
    });

    testWidgets('refreshes login account when route extra changes', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openLoginPage(tester);
      expect(find.byKey(const Key('login_page')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('login_account_input')),
        'old@example.com',
      );
      await _openRoute(tester, '/login', extra: 'registered@example.com');

      final accountField = tester.widget<TextField>(
        find.byKey(const Key('login_account_input')),
      );
      expect(accountField.controller?.text, 'registered@example.com');

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });
}
