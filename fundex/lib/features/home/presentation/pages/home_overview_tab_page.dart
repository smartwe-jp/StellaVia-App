import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../../../app/navigation/app_root_tab_refresh.dart';
import '../../../hotel_booking/presentation/support/hotel_booking_presenter.dart';
import '../../../hotel_booking/presentation/support/hotel_detail_route_args.dart';
import '../../../hotel_booking/presentation/support/hotel_map_route_args.dart';
import '../../../hotel_booking/presentation/widgets/hotel_price_discount_dialog.dart';
import '../../../hotel_booking/presentation/widgets/hotel_summary_card.dart';
import '../providers/home_featured_hotels_provider.dart';
import '../support/home_featured_fund_card_mapper.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';

import '../widgets/home_redesign_header.dart';
import '../widgets/home_brand_intro.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_miles_data_sections.dart';
import '../widgets/home_miles_refresh_scope.dart';
import '../providers/home_miles_providers.dart';
import '../widgets/home_simulation_card.dart';
import '../support/home_design_theme.dart';
import '../support/home_display_name_resolver.dart';

class HomeOverviewTabPage extends ConsumerStatefulWidget {
  const HomeOverviewTabPage({super.key});

  @override
  ConsumerState<HomeOverviewTabPage> createState() =>
      _HomeOverviewTabPageState();
}

class _HomeOverviewTabPageState extends ConsumerState<HomeOverviewTabPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = context.l10n;
    final authState = ref.watch(isAuthenticatedProvider);
    final networkAvailability =
        ref.watch(appNetworkAvailabilityProvider).asData?.value ??
        AppNetworkAvailability.online;
    final networkAccessState = ref.watch(appNetworkAccessStateProvider);
    final isAuthenticated = authState.asData?.value ?? false;
    final unreadNotificationCount = isAuthenticated
        ? ref.watch(
            notificationsControllerProvider.select(
              (state) => state.unreadCount,
            ),
          )
        : 0;
    final asyncProjects = ref.watch(fundProjectListProvider);
    final asyncFeaturedHotels = ref.watch(homeFeaturedHotelsProvider);
    final projects = asyncProjects.valueOrNull ?? const <FundProject>[];
    final profile = isAuthenticated
        ? ref.watch(memberBasicProfileProvider)
        : null;
    final displayName = resolveHomeDisplayName(
      locale: Localizations.localeOf(context),
      profile: profile,
    );
    final featuredProjects = projects.take(4).toList(growable: false);
    final featuredFundCards = featuredProjects
        .map(
          (FundProject project) => FundFeaturedFundCard(
            data: buildHomeFeaturedFundCardData(context, project),
            yieldLabel: l10n.homeEstimatedYieldLabel,
            periodLabel: l10n.fundListPeriodLabel,
            minimumInvestmentLabel: l10n.fundDetailMinimumInvestmentLabel,
            fundDetailAchievementRateLabel: l10n.fundDetailAchievementRateLabel,
          ),
        )
        .toList(growable: false);
    final featuredHotels = asyncFeaturedHotels.valueOrNull;
    final hotelPresenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final featuredHotelCards = featuredHotels == null
        ? const <Widget>[]
        : featuredHotels.hotels
              .map((hotel) {
                final mapArgs = HotelMapRouteArgs.fromHotel(
                  criteria: featuredHotels.criteria,
                  hotel: hotel,
                );
                return SizedBox(
                  width: 320,
                  child: HotelSummaryCard(
                    hotel: hotel,
                    presenter: hotelPresenter,
                    onDiscountTap: hotel.id.trim().isEmpty
                        ? null
                        : () => showHotelPriceDiscountDialog(
                            context: context,
                            hotelId: hotel.id,
                            criteria: featuredHotels.criteria,
                            presenter: hotelPresenter,
                          ),
                    onTap: hotel.id.trim().isEmpty
                        ? null
                        : () => context.push(
                            '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                            extra: HotelDetailRouteArgs(
                              criteria: featuredHotels.criteria,
                              buildingCode: hotel.buildingCode,
                            ),
                          ),
                    onMapTap: mapArgs.hasValidTarget
                        ? () =>
                              context.push('/hotel-booking/map', extra: mapArgs)
                        : null,
                  ),
                );
              })
              .toList(growable: false);
    final loadError = asyncProjects.asError;

    void preparing() =>
        AppNotice.show(context, message: l10n.homeFeaturePreparing);
    return HomeMilesRefreshScope(
      onRefresh: () => _refreshHomeMiles(ref),
      child: ColoredBox(
        color: HomeDesignTheme.background(context),
        child: Column(
          children: [
            HomeRedesignHeader(
              isAuthenticated: isAuthenticated,
              unreadCount: unreadNotificationCount,
              onLogin: () => context.push('/login'),
              onNotifications: () => context.push('/profile/notifications'),
            ),
            Expanded(
              child: MainShellTabRefreshScope(
                tabIndex: MainShellTab.home.index,
                onRefresh: _refreshHomeOverviewTab,
                scrollController: _scrollController,
                child: RefreshIndicator(
                  onRefresh: () => _refreshHomeOverviewTab(ref),
                  child: ListView(
                    key: const Key('home_tab_content'),
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (networkAccessState == AppNetworkAccessState.denied ||
                          (_isApplePlatform &&
                              networkAvailability ==
                                  AppNetworkAvailability.offline))
                        AppNetworkStatusBar(
                          title: l10n.networkAccessDeniedBannerTitle,
                          message: l10n.networkAccessDeniedBannerMessage,
                          icon: Icons.wifi_find_outlined,
                        )
                      else if (networkAvailability ==
                          AppNetworkAvailability.offline)
                        AppNetworkStatusBar(
                          title: l10n.networkOfflineBannerTitle,
                          message: l10n.networkOfflineBannerMessage,
                        ),
                      HomeBrandIntro(
                        isAuthenticated: isAuthenticated,
                        displayName: displayName,
                        onServiceTap: () => context.push('/home/service'),
                      ),
                      const SizedBox(height: 20),
                      if (isAuthenticated) ...[
                        HomeQuickActions(
                          onFunds: () => context.go('/funds'),
                          onHotels: () => context.go('/hotel-booking'),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (isAuthenticated)
                        HomeMilesAccountSection(onTap: preparing),
                      if (asyncProjects.isLoading && projects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      if (loadError != null && projects.isEmpty)
                        Column(
                          children: [
                            Text(
                              l10n.fundListLoadError,
                              textAlign: TextAlign.center,
                              style: context.appTextTheme.bodyMuted,
                            ),
                            AppButton(
                              label: l10n.fundListRetry,
                              variant: AppButtonVariant.text,
                              onPressed: () =>
                                  ref.invalidate(fundProjectListProvider),
                            ),
                          ],
                        ),
                      if (featuredFundCards.isNotEmpty) ...[
                        FundFeaturedFundCarousel(
                          title: l10n.homeFeaturedFundsTitle,
                          actionLabel: l10n.homeViewAllAction,
                          onActionTap: () => context.go('/funds'),
                          children: featuredFundCards,
                        ),
                        const SizedBox(height: 20),
                      ],
                      // if (featuredHotelCards.isNotEmpty) ...[
                      //   FundFeaturedFundCarousel(
                      //     title: l10n.homeFeaturedHotelsTitle,
                      //     actionLabel: l10n.homeViewAllAction,
                      //     onActionTap: () => context.go('/hotel-booking'),
                      //     headerSpacing: 8,
                      //     children: featuredHotelCards,
                      //   ),
                      //   const SizedBox(height: 20),
                      // ],
                      //if (isAuthenticated)

                      //else
                      //const SizedBox(height: 20),
                      HomeSimulationCard(
                        onTap: () => context.push('/home/simulation'),
                      ),
                      const SizedBox(height: 20),
                      HomeMilesRankSection(
                        onTap: () => context.push('/home/ranks'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!isAuthenticated)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: AppButton(
                  label: l10n.homeRegisterFree,
                  onPressed: () => context.push('/login?openRegister=1'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

bool get _isApplePlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS);

Future<void> _refreshHomeOverviewTab(WidgetRef ref) async {
  if (shouldSkipAppNetworkRefresh(ref)) return;
  ref.invalidate(fundProjectListProvider);
  ref.invalidate(homeFeaturedHotelsProvider);
  ref.invalidate(memberProfileDetailsProvider);
  await Future.wait<void>([
    _refreshHomeMiles(ref),
    refreshRootTabSharedData(ref),
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(homeFeaturedHotelsProvider.future).then((_) {}),
    ref.refresh(memberProfileDetailsProvider.future).then((_) {}),
  ]);
}

Future<void> _refreshHomeMiles(WidgetRef ref) async {
  if (shouldSkipAppNetworkRefresh(ref)) return;
  await Future.wait<void>([
    ref.read(homeMilesRulesProvider.notifier).refresh(),
    if (ref.read(isAuthenticatedProvider).asData?.value == true)
      ref.read(homeMilesAccountProvider.notifier).refresh(),
  ]);
}
