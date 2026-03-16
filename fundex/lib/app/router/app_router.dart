import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/hotel_design_showcase_page.dart';
import '../pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/pages/auth_entry_page.dart';
import '../../features/auth/presentation/pages/auth_mode_pages.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/real_person_auth_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/discussion_board/presentation/pages/discussion_board_tab_page.dart';
import '../../features/home/presentation/pages/home_overview_tab_page.dart';
import '../../features/investment/presentation/pages/fund_project_detail_page.dart';
import '../../features/investment/presentation/pages/fund_lottery_apply_flow_page.dart';
import '../../features/investment/presentation/pages/investment_tab_page.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_edit_flow_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_intake_page.dart';
import '../../features/member_profile/presentation/pages/my_page_section_list_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/member_profile/presentation/pages/profile_center_tab_page.dart';
import '../../features/member_profile/presentation/support/mypage_section_support.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wallet/presentation/pages/deposit_page.dart';
import '../../features/wallet/presentation/pages/wallet_history_page.dart';

String? resolveAuthRedirect({
  required AsyncValue<bool> authState,
  required String location,
}) {
  final isGuestAccessibleRoute =
      location == '/home' ||
      location == '/funds' ||
      location.startsWith('/funds/') ||
      location == '/discussion-board';
  final isSplash = location == '/splash';
  final isLogin =
      location == '/login' ||
      location.startsWith('/login/') ||
      location == '/login-legacy';
  final isRegister =
      location == '/register' ||
      location.startsWith('/register/') ||
      location == '/register-legacy';
  final isForgotPassword = location == '/forgot-password';
  final isMemberProfileOnboarding = location == '/member-profile/onboarding';
  final isHotelDesignShowcase = location == '/design-showcase/hotel';
  final isAuthRoute = isLogin || isRegister || isForgotPassword;
  final isPublicRoute =
      isAuthRoute ||
      isHotelDesignShowcase ||
      isMemberProfileOnboarding ||
      isGuestAccessibleRoute;

  if (isSplash) {
    return null;
  }

  if (authState.isLoading) {
    return isPublicRoute ? null : '/splash';
  }

  if (authState.hasError) {
    return isPublicRoute ? null : '/login';
  }

  final isAuthenticated = authState.asData?.value ?? false;
  if (!isAuthenticated) {
    return isPublicRoute ? null : '/login';
  }

  if (isAuthRoute) {
    return '/home';
  }

  return null;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<int>(0);
  ref.onDispose(refreshNotifier.dispose);
  ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
    refreshNotifier.value++;
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(isAuthenticatedProvider);
      return resolveAuthRedirect(
        authState: authState,
        location: state.matchedLocation,
      );
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          final shouldOpenRegister =
              state.uri.queryParameters['openRegister'] == '1';
          return LoginPage(openRegisterOnEnter: shouldOpenRegister);
        },
      ),
      GoRoute(
        path: '/login/mobile',
        builder: (BuildContext context, GoRouterState state) {
          return const MobileLoginMethodPage();
        },
      ),
      GoRoute(
        path: '/login/email',
        builder: (BuildContext context, GoRouterState state) {
          return const EmailLoginMethodPage();
        },
      ),
      GoRoute(
        path: '/login-legacy',
        redirect: (BuildContext context, GoRouterState state) => '/login',
      ),
      GoRoute(
        path: '/login-entry',
        builder: (BuildContext context, GoRouterState state) {
          return const AuthEntryPage();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: '/register/mobile',
        builder: (BuildContext context, GoRouterState state) {
          return const MobileRegisterMethodPage();
        },
      ),
      GoRoute(
        path: '/register/email',
        builder: (BuildContext context, GoRouterState state) {
          return const EmailRegisterMethodPage();
        },
      ),
      GoRoute(
        path: '/register-legacy',
        redirect: (BuildContext context, GoRouterState state) => '/register',
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: '/auth/real-person',
        builder: (BuildContext context, GoRouterState state) {
          return const RealPersonAuthPage();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return MainShellPage(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomeOverviewTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/funds',
                builder: (BuildContext context, GoRouterState state) {
                  return const InvestmentTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/discussion-board',
                builder: (BuildContext context, GoRouterState state) {
                  return const DiscussionBoardTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) {
                  return const ProfileCenterTabPage();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsPage();
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsPage();
        },
      ),
      GoRoute(
        path: '/wallet/deposit',
        builder: (BuildContext context, GoRouterState state) {
          return const DepositPage();
        },
      ),
      GoRoute(
        path: '/wallet/history',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletHistoryPage();
        },
      ),
      GoRoute(
        path: '/my/section-list',
        builder: (BuildContext context, GoRouterState state) {
          final sectionType = MyPageSectionType.fromQueryValue(
            state.uri.queryParameters['type'],
          );
          return MyPageSectionListPage(
            sectionType: sectionType ?? MyPageSectionType.pendingApplications,
          );
        },
      ),
      GoRoute(
        path: '/funds/:id/lottery-apply',
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'] ?? '';
          return FundLotteryApplyFlowPage(projectId: id);
        },
      ),
      GoRoute(
        path: '/funds/:id',
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'] ?? '';
          return FundProjectDetailPage(projectId: id);
        },
      ),
      GoRoute(
        path: '/investment',
        redirect: (BuildContext context, GoRouterState state) => '/funds',
      ),
      GoRoute(
        path: '/hotel-booking',
        redirect: (BuildContext context, GoRouterState state) => '/funds',
      ),
      GoRoute(
        path: '/member-profile/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          final query = state.uri.queryParameters;
          return MemberProfileIntakePage.onboarding(
            nextRoute: query['next'],
            seedPhone: query['phone'],
            seedEmail: query['email'],
          );
        },
      ),
      GoRoute(
        path: '/member-profile/edit',
        builder: (BuildContext context, GoRouterState state) {
          return const MemberProfileEditFlowPage();
        },
      ),
      GoRoute(
        path: '/design-showcase/hotel',
        builder: (BuildContext context, GoRouterState state) {
          return const HotelDesignShowcasePage();
        },
      ),
    ],
  );
});
