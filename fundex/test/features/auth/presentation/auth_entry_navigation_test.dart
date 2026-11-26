import 'package:fundex/features/auth/presentation/pages/register_page.dart';
import 'package:fundex/features/guest_onboarding/presentation/pages/guest_welcome_page.dart';
import 'package:fundex/features/home/presentation/controllers/home_simulation_controller.dart';
import 'package:fundex/features/home/presentation/pages/home_simulation_page.dart';
import 'dart:io';
import 'package:fundex/features/investment/data/datasources/fund_project_favorites_local_data_source.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_favorite_providers.dart';
import 'package:fundex/features/home/presentation/widgets/home_featured_section.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';
import 'package:fundex/features/main_shell/presentation/widgets/main_shell_bottom_bar.dart';
import 'package:core_ui_kit/core_ui_kit.dart' show AppBottomTabBar, AppButton;
import 'package:fundex/features/home/presentation/pages/home_overview_tab_page.dart';

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
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/features/member_profile/presentation/widgets/verification_entry_content.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class _Favorites implements FundProjectFavoritesLocalDataSource {
  Set<String> _ids = {};
  @override
  Future<Set<String>> readFavoriteProjectIds() async => _ids;
  @override
  Future<void> saveFavoriteProjectIds(Set<String> projectIds) async =>
      _ids = projectIds;
}

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
    String? inviteCode,
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

Future<void> _pumpApp(WidgetTester tester, {bool member = false}) async {
  final environment = EnvironmentFactory.fromFlavor(AppFlavor.dev);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        fundProjectFavoritesLocalDataSourceProvider.overrideWithValue(
          _Favorites(),
        ),
        fundProjectListProvider.overrideWith(
          (_) async => const [FundProject(id: '1', projectName: 'Guest fund')],
        ),
        appEnvironmentProvider.overrideWithValue(environment),
        appLoggerProvider.overrideWithValue(_NoopAppLogger()),
        tokenStoreProvider.overrideWithValue(
          member
              ? _SeededTokenStore(
                  accessToken: 'access',
                  refreshToken: 'refresh',
                )
              : _SeededTokenStore(),
        ),
        tokenRefresherProvider.overrideWithValue(
          _FakeTokenRefresher((_) async => null),
        ),
        authLocalDataSourceProvider.overrideWithValue(
          _InMemoryAuthLocalDataSource(),
        ),
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        verificationEntryProvider.overrideWith(
          (_) async => const VerificationEntry(
            VerificationEntryKind.choice,
            personalStatus: 1,
          ),
        ),
      ],
      child: const MemberTemplateApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 2600));
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
      final page = find.byType(RegisterPage);
      final l = AppLocalizations.of(tester.element(page));
      expect(find.text(l.guestSendCode), findsOneWidget);
      await tester.tap(find.byTooltip(l.commonBack));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_page')), findsOneWidget);
    });

    testWidgets(
      'closing login opens guest home with the video welcome underneath',
      (tester) async {
        await _pumpApp(tester);
        await _openLoginPage(tester);
        await tester.tap(find.byKey(const Key('login_close_button')));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(HomeOverviewTabPage), findsOneWidget);
        expect(find.byType(AppBottomTabBar), findsNothing);
        await tester.dragFrom(const Offset(1, 120), const Offset(700, 0));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(GuestWelcomePage), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 3));
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );

    testWidgets('restored member startup reveals the member home', (
      tester,
    ) async {
      await _pumpApp(tester, member: true);
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      final context = tester.element(find.byType(Navigator).first);
      expect(
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.path,
        '/home',
      );
      expect(find.byType(GuestWelcomePage), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets(
      'guest startup opens the guide and registers after email verification',
      (tester) async {
        Future<void> finishNavigation() async {
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));
          await tester.pump();
        }

        await _pumpApp(tester);
        await tester.binding.setSurfaceSize(const Size(480, 1600));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await finishNavigation();
        final welcome = find.byType(GuestWelcomePage);
        expect(welcome, findsOneWidget);
        final l = AppLocalizations.of(tester.element(welcome));
        await tester.tap(find.byIcon(Icons.arrow_downward_rounded));
        await finishNavigation();
        expect(find.byType(HomeOverviewTabPage), findsOneWidget);
        expect(find.byType(AppBottomTabBar), findsNothing);
        expect(find.text(l.homeLearnService), findsOneWidget);
        tester.view.padding = FakeViewPadding(
          bottom: 34 * tester.view.devicePixelRatio,
        );
        addTearDown(tester.view.resetPadding);
        await tester.pump();
        final back = find.byTooltip(
          MaterialLocalizations.of(
            tester.element(find.byType(HomeOverviewTabPage)),
          ).backButtonTooltip,
        );
        final register = find.text(l.homeRegisterFree);
        expect(back, findsNothing);
        final registerButton = find.ancestor(
          of: register,
          matching: find.byType(AppButton),
        );
        final pageBottom = tester
            .getBottomLeft(find.byType(HomeOverviewTabPage))
            .dy;
        expect(pageBottom - tester.getBottomLeft(registerButton).dy, 34);
        await tester.dragFrom(const Offset(1, 120), const Offset(400, 0));
        await finishNavigation();
        expect(welcome, findsOneWidget);
        final tagline = find.text(l.guestGuideTagline);
        final restingY = tester.getCenter(tagline).dy;
        final drag = await tester.startGesture(const Offset(160, 390));
        await drag.moveBy(const Offset(0, -40));
        await tester.pump();
        await drag.moveBy(const Offset(0, -59));
        await tester.pump();
        expect(tester.getCenter(tagline).dy, lessThan(restingY));
        await drag.up();
        await finishNavigation();
        expect(welcome, findsOneWidget);
        expect(tester.getCenter(tagline).dy, closeTo(restingY, 1));
        await tester.dragFrom(const Offset(160, 390), const Offset(0, -100));
        await finishNavigation();
        for (final entry in {
          l.homeFeaturedFundsTitle: l.fundListTitle,
          l.homeFeaturedHotelsTitle: l.homeBookWithMiles,
        }.entries) {
          final section = find.byWidgetPredicate(
            (w) => w is HomeFeaturedSection && w.title == entry.key,
          );
          final action = find.descendant(
            of: section,
            matching: find.text(l.homeViewAllAction),
          );
          await tester.ensureVisible(action);
          await tester.tap(action);
          await finishNavigation();
          expect(find.text(entry.value), findsOneWidget);
          expect(find.byType(MainShellBottomBar), findsNothing);
          await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
          await finishNavigation();
          expect(find.byType(HomeOverviewTabPage), findsOneWidget);
        }
        await tester.ensureVisible(find.text(l.homeSimulationTitle));
        await tester.tap(find.text(l.homeSimulationTitle));
        await finishNavigation();
        final scope = ProviderScope.containerOf(
          tester.element(find.byType(HomeSimulationPage)),
        );
        expect(scope.read(homeSimulationInputProvider).principal, 100000);
        await tester.ensureVisible(find.text(l.simRegister));
        await tester.tap(find.text(l.simRegister));
        await finishNavigation();
        await tester.enterText(find.byType(TextField).first, 'new@example.com');
        await tester.pump();
        await tester.tap(find.text(l.guestSendCode));
        await finishNavigation();
        expect(find.text(l.guestGuideCheckEmail), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, '123456');
        for (final label in [
          l.settingsCompanyLinkTerms,
          l.guestElectronic,
          l.guestAntiSocial,
          l.guestPersonal,
        ]) {
          await tester.ensureVisible(find.bySemanticsLabel(label).first);
          await tester.tap(find.bySemanticsLabel(label).first);
          await tester.pump();
        }
        await tester.ensureVisible(
          find.byKey(const Key('guest_register_submit')),
        );
        await tester.tap(find.byKey(const Key('guest_register_submit')));
        await finishNavigation();
        expect(find.text(l.guestGuideCreated), findsOneWidget);
        await tester.tap(find.text(l.guestGuideVerify));
        await finishNavigation();
        expect(find.byType(InvestorChoice), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 3));
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );

    for (final path in [
      '/register?ref=demo',
      '/login?openRegister=1&ref=demo',
    ]) {
      testWidgets('legacy registration entry $path opens the new form', (
        tester,
      ) async {
        await _pumpApp(tester);
        await _openLoginPage(tester);
        await _openRoute(tester, path);
        final page = find.byType(RegisterPage);
        final context = tester.element(page);
        expect(GoRouter.of(context).state.uri.path, '/guest-guide/register');
        expect(tester.widget<RegisterPage>(page).initialInviteCode, 'demo');
        expect(
          find.text(AppLocalizations.of(context).guestSendCode),
          findsOneWidget,
        );
      });
    }

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
      await tester.pump(const Duration(seconds: 3));
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
