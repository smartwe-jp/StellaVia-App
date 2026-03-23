import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/hotel_design_showcase_page.dart';
import '../pages/splash_page.dart';
import '../navigation/app_route_observers.dart';
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
import '../../features/investment/presentation/pages/secondary_market_buy_confirm_page.dart';
import '../../features/investment/presentation/pages/secondary_market_buy_order_page.dart';
import '../../features/investment/presentation/pages/secondary_market_marketplace_detail_page.dart';
import '../../features/investment/presentation/pages/secondary_market_marketplace_page.dart';
import '../../features/investment/presentation/support/fund_lottery_apply_step.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_edit_flow_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_intake_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_overview_page.dart';
import '../../features/member_profile/presentation/pages/my_page_active_fund_detail_page.dart';
import '../../features/member_profile/presentation/pages/my_page_secondary_market_sell_confirm_page.dart';
import '../../features/member_profile/presentation/pages/my_page_secondary_market_sell_order_page.dart';
import '../../features/member_profile/presentation/pages/my_page_section_list_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/member_profile/presentation/pages/profile_center_tab_page.dart';
import '../../features/member_profile/domain/entities/mypage_models.dart';
import '../../features/member_profile/presentation/support/mypage_secondary_market_models.dart';
import '../../features/member_profile/presentation/support/mypage_section_support.dart';
import '../../features/member_profile/presentation/support/member_profile_edit_step.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wallet/presentation/pages/deposit_page.dart';
import '../../features/wallet/presentation/pages/withdraw_page.dart';
import '../../features/wallet/presentation/pages/wallet_bank_account_add_page.dart';
import '../../features/wallet/presentation/pages/wallet_bank_settings_page.dart';
import '../../features/wallet/presentation/pages/wallet_history_page.dart';
import '../../features/wallet/presentation/pages/wallet_withdraw_history_page.dart';
import '../../features/wallet/presentation/pages/wallet_withdrawing_list_page.dart';
import '../../features/investment/presentation/support/secondary_market_trade_models.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

String? resolveAuthRedirect({
  required AsyncValue<bool> authState,
  required String location,
}) {
  final isGuestAccessibleRoute =
      location == '/home' ||
      location == '/home/free-market' ||
      location.startsWith('/home/free-market/') ||
      location == '/funds' ||
      location.startsWith('/funds/');
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
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    observers: <NavigatorObserver>[appRootRouteObserver],
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
                routes: <RouteBase>[
                  GoRoute(
                    path: 'free-market',
                    builder: (BuildContext context, GoRouterState state) {
                      return const SecondaryMarketMarketplacePage();
                    },
                  ),
                  GoRoute(
                    path: 'free-market/:id',
                    builder: (BuildContext context, GoRouterState state) {
                      final id = state.pathParameters['id'] ?? '';
                      final extra = state.extra;
                      return SecondaryMarketMarketplaceDetailPage(
                        orderId: id,
                        initialRecord: extra is MyPageOrderInquiryRecord
                            ? extra
                            : null,
                      );
                    },
                  ),
                ],
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
                routes: <RouteBase>[
                  GoRoute(
                    path: ':id',
                    builder: (BuildContext context, GoRouterState state) {
                      final id = state.pathParameters['id'] ?? '';
                      return FundProjectDetailPage(projectId: id);
                    },
                  ),
                  GoRoute(
                    path: ':id/lottery-apply',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      final id = state.pathParameters['id'] ?? '';
                      final initialStep = fundLotteryApplyStepFromQueryValue(
                        state.uri.queryParameters['step'],
                      );
                      final allowSubmittedResultAdvance =
                          state.uri.queryParameters['allowSubmittedAdvance'] !=
                          'false';
                      return FundLotteryApplyFlowPage(
                        projectId: id,
                        initialStep:
                            initialStep ?? FundLotteryApplyStep.amountInput,
                        allowSubmittedResultAdvance:
                            allowSubmittedResultAdvance,
                      );
                    },
                  ),
                ],
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
                routes: <RouteBase>[
                  GoRoute(
                    path: 'settings',
                    builder: (BuildContext context, GoRouterState state) {
                      return const SettingsPage();
                    },
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (BuildContext context, GoRouterState state) {
                      return const NotificationsPage();
                    },
                  ),
                  GoRoute(
                    path: 'wallet/bank-settings',
                    builder: (BuildContext context, GoRouterState state) {
                      return const WalletBankSettingsPage();
                    },
                  ),
                  GoRoute(
                    path: 'wallet/history',
                    builder: (BuildContext context, GoRouterState state) {
                      return const WalletHistoryPage();
                    },
                  ),
                  GoRoute(
                    path: 'my/section-list',
                    builder: (BuildContext context, GoRouterState state) {
                      final sectionType = MyPageSectionType.fromQueryValue(
                        state.uri.queryParameters['type'],
                      );
                      final applyFilter =
                          MyPageApplyHistoryFilterX.fromQueryValue(
                            state.uri.queryParameters['filter'],
                          );
                      return MyPageSectionListPage(
                        sectionType:
                            sectionType ??
                            MyPageSectionType.pendingApplications,
                        initialApplyFilter:
                            applyFilter ?? MyPageApplyHistoryFilter.all,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'my/secondary-market',
                    builder: (BuildContext context, GoRouterState state) {
                      return const MyPageSectionListPage(
                        sectionType: MyPageSectionType.coolingOff,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'my/active-funds/:projectId',
                    builder: (BuildContext context, GoRouterState state) {
                      final projectId = state.pathParameters['projectId'] ?? '';
                      final extra = state.extra;
                      final seedRecords = extra is List<MyPageInvestmentRecord>
                          ? extra
                          : const <MyPageInvestmentRecord>[];
                      return MyPageActiveFundDetailPage(
                        projectId: projectId,
                        seedRecords: seedRecords,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'secondary-market',
                    redirect: (BuildContext context, GoRouterState state) {
                      return '/profile/my/secondary-market';
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        redirect: (BuildContext context, GoRouterState state) {
          return '/profile/settings';
        },
      ),
      GoRoute(
        path: '/notifications',
        redirect: (BuildContext context, GoRouterState state) {
          return '/profile/notifications';
        },
      ),
      GoRoute(
        path: '/wallet/deposit',
        builder: (BuildContext context, GoRouterState state) {
          return const DepositPage();
        },
      ),
      GoRoute(
        path: '/wallet/withdraw',
        builder: (BuildContext context, GoRouterState state) {
          return const WithdrawPage();
        },
      ),
      GoRoute(
        path: '/wallet/bank-settings',
        redirect: (BuildContext context, GoRouterState state) {
          return '/profile/wallet/bank-settings';
        },
      ),
      GoRoute(
        path: '/wallet/bank-settings/add',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletBankAccountAddPage();
        },
      ),
      GoRoute(
        path: '/wallet/history',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletHistoryPage();
        },
      ),
      GoRoute(
        path: '/wallet/withdraw/history',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletWithdrawHistoryPage();
        },
      ),
      GoRoute(
        path: '/wallet/withdrawing',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletWithdrawingListPage();
        },
      ),
      GoRoute(
        path: '/my/section-list',
        redirect: (BuildContext context, GoRouterState state) {
          return Uri(
            path: '/profile/my/section-list',
            queryParameters: state.uri.queryParameters,
          ).toString();
        },
      ),
      GoRoute(
        path: '/my/secondary-market',
        redirect: (BuildContext context, GoRouterState state) {
          return '/profile/my/secondary-market';
        },
      ),
      GoRoute(
        path: '/my/secondary-market/sell',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          if (extra is! MyPageSecondaryMarketSellSeed) {
            return const Scaffold(
              body: Center(child: Text('Invalid sell order context')),
            );
          }
          return MyPageSecondaryMarketSellOrderPage(seed: extra);
        },
      ),
      GoRoute(
        path: '/my/secondary-market/sell/confirm',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          if (extra is! MyPageSecondaryMarketSellDraft) {
            return const Scaffold(
              body: Center(child: Text('Invalid sell confirmation context')),
            );
          }
          return MyPageSecondaryMarketSellConfirmPage(draft: extra);
        },
      ),
      GoRoute(
        path: '/free-market',
        redirect: (BuildContext context, GoRouterState state) {
          return '/home/free-market';
        },
      ),
      GoRoute(
        path: '/free-market/:id',
        redirect: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'] ?? '';
          return '/home/free-market/$id';
        },
      ),
      GoRoute(
        path: '/free-market/:id/buy',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          if (extra is! SecondaryMarketBuySeed) {
            return const Scaffold(
              body: Center(child: Text('Invalid secondary market buy context')),
            );
          }
          return SecondaryMarketBuyOrderPage(seed: extra);
        },
      ),
      GoRoute(
        path: '/free-market/:id/buy/confirm',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          if (extra is! SecondaryMarketBuyDraft) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Invalid secondary market buy confirmation context',
                ),
              ),
            );
          }
          return SecondaryMarketBuyConfirmPage(draft: extra);
        },
      ),
      GoRoute(
        path: '/my/active-funds/:projectId',
        redirect: (BuildContext context, GoRouterState state) {
          final projectId = state.pathParameters['projectId'] ?? '';
          return '/profile/my/active-funds/$projectId';
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
          return const MemberProfileOverviewPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'section/:section',
            builder: (BuildContext context, GoRouterState state) {
              final rawStep = state.pathParameters['section'];
              final step =
                  memberProfileEditStepFromRouteValue(rawStep) ??
                  MemberProfileEditStep.basicInfo;
              return MemberProfileEditFlowPage.section(initialStep: step);
            },
          ),
        ],
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
