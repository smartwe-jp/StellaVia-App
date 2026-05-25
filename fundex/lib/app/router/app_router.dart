import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/hotel_design_showcase_page.dart';
import '../pages/splash_page.dart';
import '../navigation/app_route_observers.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/real_person_auth_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/discussion_board/presentation/pages/discussion_board_tab_page.dart';
import '../../features/hotel_booking/domain/entities/hotel_models.dart';
import '../../features/hotel_booking/presentation/pages/hotel_booking_confirm_page.dart';
import '../../features/hotel_booking/presentation/pages/hotel_detail_page.dart';
import '../../features/hotel_booking/presentation/pages/hotel_map_page.dart';
import '../../features/hotel_booking/presentation/pages/hotel_booking_tab_page.dart';
import '../../features/hotel_booking/presentation/pages/hotel_member_profile_page.dart';
import '../../features/hotel_booking/presentation/support/hotel_map_route_args.dart';
import '../../features/discussion_board/presentation/widgets/kizunark_comment_composer_widgets.dart';
import '../../features/discussion_board/presentation/widgets/kizunark_draft_list_page.dart';
import '../../features/discussion_board/presentation/widgets/kizunark_thread_detail_page.dart';
import '../../features/home/presentation/pages/home_overview_tab_page.dart';
import '../../features/investment/presentation/pages/fund_project_detail_page.dart';
import '../../features/investment/presentation/pages/fund_lottery_apply_flow_page.dart';
import '../../features/investment/presentation/pages/investment_tab_page.dart';
import '../../features/investment/presentation/pages/secondary_market_buy_confirm_page.dart';
import '../../features/investment/presentation/pages/secondary_market_buy_order_page.dart';
import '../../features/investment/presentation/pages/secondary_market_marketplace_detail_page.dart';
import '../../features/investment/presentation/pages/secondary_market_marketplace_page.dart';
import '../../features/investment/presentation/support/fund_lottery_apply_models.dart';
import '../../features/investment/presentation/support/fund_lottery_apply_step.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/member_profile/presentation/pages/member_avatar_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_edit_flow_page.dart';
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
import '../../features/settings/presentation/pages/settings_face_verification_page.dart';
import '../../features/settings/presentation/pages/settings_contact_page.dart';
import '../../features/settings/presentation/pages/settings_contract_document_detail_page.dart';
import '../../features/settings/presentation/pages/settings_contract_documents_page.dart';
import '../../features/settings/presentation/pages/settings_email_verification_page.dart';
import '../../features/settings/presentation/pages/settings_faq_page.dart';
import '../../features/settings/presentation/pages/settings_operating_company_page.dart';
import '../../features/settings/presentation/pages/settings_phone_verification_page.dart';
import '../../features/settings/presentation/pages/settings_two_factor_page.dart';
import '../../features/settings/presentation/support/settings_contract_document_models.dart';
import '../../features/wallet/presentation/pages/deposit_detail_page.dart';
import '../../features/wallet/presentation/pages/deposit_list_page.dart';
import '../../features/wallet/presentation/pages/withdraw_page.dart';
import '../../features/wallet/presentation/pages/wallet_withdraw_confirm_page.dart';
import '../../features/wallet/presentation/pages/wallet_withdraw_verify_page.dart';
import '../../features/wallet/presentation/pages/wallet_bank_account_add_page.dart';
import '../../features/wallet/presentation/pages/wallet_overseas_bank_account_add_page.dart';
import '../../features/wallet/presentation/pages/wallet_bank_settings_page.dart';
import '../../features/wallet/presentation/pages/wallet_history_page.dart';
import '../../features/wallet/presentation/pages/wallet_withdraw_history_page.dart';
import '../../features/wallet/presentation/pages/wallet_withdrawing_list_page.dart';
import '../../features/wallet/presentation/support/wallet_withdraw_confirm_models.dart';
import '../../features/investment/presentation/support/secondary_market_trade_models.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GlobalKey<NavigatorState> get appRootNavigatorKey => _rootNavigatorKey;

CustomTransitionPage<void> _buildDiscussionBoardBottomUpPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    child: child,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
  );
}

String? resolveAuthRedirect({
  required AsyncValue<bool> authState,
  required String location,
}) {
  final isHotelMemberProfile = location == '/hotel-booking/member-profile';
  final isGuestAccessibleRoute =
      location == '/home' ||
      location == '/home/free-market' ||
      location.startsWith('/home/free-market/') ||
      location == '/discussion-board' ||
      location == '/hotel-booking' ||
      (location.startsWith('/hotel-booking/') &&
          !isHotelMemberProfile &&
          !location.endsWith('/confirm')) ||
      location.startsWith('/discussion-board/') ||
      location == '/funds' ||
      location.startsWith('/funds/') ||
      location == '/profile/settings' ||
      location == '/profile/settings/faq' ||
      location == '/profile/settings/contact' ||
      location == '/profile/settings/company';
  final isSplash = location == '/splash';
  final isLogin = location == '/login';
  final isRegister = location == '/register';
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
          final initialAccount = state.extra is String
              ? (state.extra! as String)
              : null;
          return LoginPage(
            openRegisterOnEnter: shouldOpenRegister,
            initialAccount: initialAccount,
          );
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
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
      GoRoute(
        path: '/discussion-board/drafts',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          if (extra is! KizunarkDraftListRouteArgs) {
            return const KizunarkDraftListPage();
          }
          return KizunarkDraftListPage(kind: extra.kind);
        },
      ),
      GoRoute(
        path: '/discussion-board/post',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          return _buildDiscussionBoardBottomUpPage(
            state: state,
            child: extra is KizunarkPostComposeRouteArgs
                ? extra.child
                : const DiscussionBoardTabPage(),
          );
        },
      ),
      GoRoute(
        path: '/discussion-board/reply/:threadId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final extra = state.extra;
          return _buildDiscussionBoardBottomUpPage(
            state: state,
            child: extra is KizunarkReplyComposeRouteArgs
                ? extra.child
                : const DiscussionBoardTabPage(),
          );
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
                    parentNavigatorKey: _rootNavigatorKey,
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
                      final extra = state.extra;
                      return FundLotteryApplyFlowPage(
                        projectId: id,
                        initialStep:
                            initialStep ?? FundLotteryApplyStep.amountInput,
                        allowSubmittedResultAdvance:
                            allowSubmittedResultAdvance,
                        initialSeed: extra is FundLotteryApplyFlowSeed
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
                path: '/discussion-board',
                builder: (BuildContext context, GoRouterState state) {
                  return const DiscussionBoardTabPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'thread/:threadId',
                    builder: (BuildContext context, GoRouterState state) {
                      final extra = state.extra;
                      if (extra is! KizunarkThreadDetailRouteArgs) {
                        return const DiscussionBoardTabPage();
                      }
                      return KizunarkThreadDetailPage(
                        thread: extra.thread,
                        isAuthenticated: extra.isAuthenticated,
                        currentUserId: extra.currentUserId,
                        onOpenImageViewer: extra.onOpenImageViewer,
                        onReply: extra.onReply,
                        onMessageLongPress: extra.onMessageLongPress,
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
                path: '/hotel-booking',
                builder: (BuildContext context, GoRouterState state) {
                  return const HotelBookingTabPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'map',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      final extra = state.extra;
                      return HotelMapPage(
                        initialCriteria: switch (extra) {
                          HotelMapRouteArgs(:final criteria) => criteria,
                          HotelSearchCriteria() => extra,
                          _ => null,
                        },
                        initialHotel: extra is HotelMapRouteArgs
                            ? extra.selectedHotel
                            : null,
                        initialSelectedHotelId: extra is HotelMapRouteArgs
                            ? extra.selectedHotelId
                            : null,
                        initialLatitude: extra is HotelMapRouteArgs
                            ? extra.latitude
                            : null,
                        initialLongitude: extra is HotelMapRouteArgs
                            ? extra.longitude
                            : null,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'member-profile',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const HotelMemberProfilePage();
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      final id = state.pathParameters['id'] ?? '';
                      final extra = state.extra;
                      return HotelDetailPage(
                        hotelId: id,
                        initialCriteria: extra is HotelSearchCriteria
                            ? extra
                            : HotelSearchCriteria.initial(DateTime.now()),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':id/confirm',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      final extra = state.extra;
                      if (extra is! HotelBookingConfirmSeed) {
                        return const _HotelBookingConfirmMissingSeedRedirect();
                      }
                      return HotelBookingConfirmPage(seed: extra);
                    },
                  ),
                ],
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
                    path: 'avatar',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const MemberAvatarPage();
                    },
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (BuildContext context, GoRouterState state) {
                      return const SettingsPage();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'contracts',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return const SettingsContractDocumentsPage();
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: ':projectKey',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder:
                                (BuildContext context, GoRouterState state) {
                                  final projectKey =
                                      state.pathParameters['projectKey'] ?? '';
                                  final extra = state.extra;
                                  return SettingsContractDocumentDetailPage(
                                    projectKey: projectKey,
                                    initialProject:
                                        extra is SettingsContractProject
                                        ? extra
                                        : null,
                                  );
                                },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'faq',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return const SettingsFaqPage();
                        },
                      ),
                      GoRoute(
                        path: 'contact',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return const SettingsContactPage();
                        },
                      ),
                      GoRoute(
                        path: 'company',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return const SettingsOperatingCompanyPage();
                        },
                      ),
                      GoRoute(
                        path: 'two-factor',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return const SettingsTwoFactorPage();
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: 'email',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder:
                                (BuildContext context, GoRouterState state) {
                                  return const SettingsEmailVerificationPage();
                                },
                          ),
                          GoRoute(
                            path: 'phone',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder:
                                (BuildContext context, GoRouterState state) {
                                  return const SettingsPhoneVerificationPage();
                                },
                          ),
                          GoRoute(
                            path: 'face',
                            parentNavigatorKey: _rootNavigatorKey,
                            builder:
                                (BuildContext context, GoRouterState state) {
                                  return const SettingsFaceVerificationPage();
                                },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'notifications',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const NotificationsPage();
                    },
                  ),
                  GoRoute(
                    path: 'wallet/bank-settings',
                    parentNavigatorKey: _rootNavigatorKey,
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
                      return MyPageActiveFundDetailPage(
                        projectId: projectId,
                        initialSeed: extra is MyPageActiveFundDetailSeed
                            ? extra
                            : null,
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
          return const DepositListPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: ':projectId',
            builder: (BuildContext context, GoRouterState state) {
              final projectId = state.pathParameters['projectId'] ?? '';
              final extra = state.extra;
              return DepositDetailPage(
                projectId: projectId,
                initialRecord: extra is MyPageApplyRecord ? extra : null,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/wallet/withdraw',
        builder: (BuildContext context, GoRouterState state) {
          return const WithdrawPage();
        },
      ),
      GoRoute(
        path: '/wallet/withdraw/confirm',
        builder: (BuildContext context, GoRouterState state) {
          final seed = state.extra;
          if (seed is! WalletWithdrawConfirmSeed) {
            return const WithdrawPage();
          }
          return WalletWithdrawConfirmPage(seed: seed);
        },
      ),
      GoRoute(
        path: '/wallet/withdraw/confirm/verify',
        builder: (BuildContext context, GoRouterState state) {
          final seed = state.extra;
          if (seed is! WalletWithdrawConfirmSeed) {
            return const WithdrawPage();
          }
          return WalletWithdrawVerifyPage(seed: seed);
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
        path: '/wallet/bank-settings/add/overseas',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletOverseasBankAccountAddPage();
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
        path: '/member-profile/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return const MemberProfileEditFlowPage();
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

class _HotelBookingConfirmMissingSeedRedirect extends ConsumerWidget {
  const _HotelBookingConfirmMissingSeedRedirect();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(isAuthenticatedProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      if (authState.hasError || authState.asData?.value == false) {
        context.go('/login');
        return;
      }
      if (authState.asData?.value == true) {
        context.go('/hotel-booking');
      }
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
