import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/router/app_router.dart';

void main() {
  group('resolveAuthRedirect', () {
    test('keeps loading state on public home route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncLoading<bool>(),
        location: '/home',
      );

      expect(redirect, isNull);
    });

    test('redirects loading state to splash for protected route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncLoading<bool>(),
        location: '/profile',
      );

      expect(redirect, '/splash');
    });

    test('keeps splash while loading', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncLoading<bool>(),
        location: '/splash',
      );

      expect(redirect, isNull);
    });

    test('keeps splash while unauthenticated', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/splash',
      );

      expect(redirect, isNull);
    });

    test('keeps splash while authenticated', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/splash',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on guest-accessible home route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/home',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on guest-accessible funds route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/funds',
      );

      expect(redirect, isNull);
    });

    test(
      'keeps unauthenticated user on guest-accessible fund detail route',
      () {
        final redirect = resolveAuthRedirect(
          authState: const AsyncData<bool>(false),
          location: '/funds/123',
        );

        expect(redirect, isNull);
      },
    );

    test(
      'keeps unauthenticated user on guest-accessible discussion board route',
      () {
        final redirect = resolveAuthRedirect(
          authState: const AsyncData<bool>(false),
          location: '/discussion-board',
        );

        expect(redirect, isNull);
      },
    );

    test('redirects unauthenticated user to login from profile route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/profile',
      );

      expect(redirect, '/login');
    });

    test('keeps unauthenticated user on login', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/login',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on register', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/register',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on forgot password', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/forgot-password',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on design showcase', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/design-showcase/hotel',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on member profile onboarding', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/member-profile/onboarding',
      );

      expect(redirect, isNull);
    });

    test('redirects authenticated user from login to home', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/login',
      );

      expect(redirect, '/home');
    });

    test('keeps authenticated user on protected routes', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/home',
      );

      expect(redirect, isNull);
    });

    test('keeps authenticated user on protected tab branch route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/profile',
      );

      expect(redirect, isNull);
    });

    test('redirects authenticated user from register to home', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/register',
      );

      expect(redirect, '/home');
    });
  });
}
