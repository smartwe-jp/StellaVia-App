import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../support/home_featured_fund_card_mapper.dart';
import '../support/home_member_profile_reminder_support.dart';
import '../widgets/home_attraction_detail_sheet.dart';
import '../widgets/home_attraction_section.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_investment_flow_section.dart';
import '../widgets/home_license_bar.dart';
import '../widgets/home_official_site_link.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../../member_profile/domain/entities/member_profile_details.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';

const Set<int> _featuredProjectStatuses = <int>{0, 1};
final Uri _officialSiteUri = Uri.parse('https://stellavia.co.jp/');

class HomeOverviewTabPage extends ConsumerWidget {
  const HomeOverviewTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final authState = ref.watch(isAuthenticatedProvider);
    final networkAvailability =
        ref.watch(appNetworkAvailabilityProvider).asData?.value ??
        AppNetworkAvailability.online;
    final networkAccessState = ref.watch(appNetworkAccessStateProvider);
    final isAuthenticated = authState.asData?.value ?? false;
    final hasUnreadNotifications =
        isAuthenticated &&
        ref.watch(
          notificationsControllerProvider.select(
            (state) => state.unreadCount > 0,
          ),
        );
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    final isMemberProfileCompleted = ref
        .watch(isMemberProfileCompletedProvider)
        .asData
        ?.value;
    final isEmailVerified = ref
        .watch(settingsEmailVerifiedProvider)
        .asData
        ?.value;
    final asyncProjects = ref.watch(fundProjectListProvider);
    final asyncMemberProfile = ref.watch(memberProfileDetailsProvider);
    final asyncVerificationStatus = ref.watch(
      settingsRemoteVerificationStatusProvider,
    );
    final memberProfile = asyncMemberProfile.asData?.value;
    final verificationStatus = asyncVerificationStatus.asData?.value;
    final projects = asyncProjects.asData?.value ?? const <FundProject>[];
    final locale = Localizations.localeOf(context);
    final currencyFormatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final shouldShowMemberProfileReminder = kDebugMode
        ? true
        : shouldShowHomeMemberProfileReminder(
            currentUser,
            isMemberProfileCompleted: isMemberProfileCompleted,
          );

    final reminders = <FundReminderData>[
      if (shouldShowMemberProfileReminder)
        FundReminderData(
          leading: const Icon(Icons.person_outline, size: 30),
          title: l10n.homeReminderProfileTitle,
          message: l10n.homeReminderProfileBody,
          tone: FundReminderTone.danger,
          badgeLabel: l10n.homeReminderProfileBadge,
          actionLabel: l10n.memberProfileOverviewStartIntakeAction,
          segmentCount: MemberProfileDetails.flowStepCount,
          completedSegmentCount: memberProfile?.completedFlowStepCount ?? 0,
          onActionTap: () => context.push('/member-profile/onboarding'),
          onTap: () => context.push('/member-profile/onboarding'),
        ),
      if (isEmailVerified == false)
        FundReminderData(
          leading: const Icon(Icons.alternate_email_rounded, size: 30),
          title: l10n.homeReminderEmailVerificationTitle,
          message: l10n.homeReminderEmailVerificationBody,
          tone: FundReminderTone.warning,
          badgeLabel: l10n.homeReminderProfileBadge,
          actionLabel: l10n.homeReminderVerifyAction,
          onActionTap: () => context.push('/profile/settings/two-factor/email'),
          onTap: () => context.push('/profile/settings/two-factor/email'),
        ),
      if (verificationStatus?.isPhoneVerified == false)
        FundReminderData(
          leading: const Icon(Icons.smartphone_rounded, size: 30),
          title: l10n.homeReminderPhoneVerificationTitle,
          message: l10n.homeReminderPhoneVerificationBody,
          tone: FundReminderTone.warning,
          badgeLabel: l10n.homeReminderProfileBadge,
          actionLabel: l10n.homeReminderVerifyAction,
          onActionTap: () => context.push('/profile/settings/two-factor/phone'),
          onTap: () => context.push('/profile/settings/two-factor/phone'),
        ),
      if (!shouldShowMemberProfileReminder &&
          verificationStatus?.isRealPersonVerified == false)
        FundReminderData(
          leading: const Icon(Icons.verified_user_outlined, size: 30),
          title: l10n.homeReminderRealPersonVerificationTitle,
          message: l10n.homeReminderRealPersonVerificationBody,
          tone: FundReminderTone.danger,
          badgeLabel: l10n.homeReminderProfileBadge,
          actionLabel: l10n.homeReminderVerifyAction,
          onActionTap: () => context.push('/profile/settings/two-factor/face'),
          onTap: () => context.push('/profile/settings/two-factor/face'),
        ),
    ];

    final featuredProjects = projects
        // .where(
        //   (FundProject project) =>
        //       _featuredProjectStatuses.contains(project.projectStatus),
        // )
        .take(6)
        .toList(growable: false);
    final featuredFundCards = featuredProjects
        .map(
          (FundProject project) => FundFeaturedFundCard(
            data: buildHomeFeaturedFundCardData(
              context,
              project,
              currencyFormatter,
            ),
            yieldLabel: l10n.homeEstimatedYieldLabel,
          ),
        )
        .toList(growable: false);
    final loadError = asyncProjects.asError;

    final bool showGuide = shouldShowMemberProfileReminder || isEmailVerified == false || verificationStatus?.isPhoneVerified == false ||verificationStatus?.isRealPersonVerified == false;

    final topSection = switch ((authState.isLoading, isAuthenticated)) {
      (true, _) => const SizedBox(height: UiTokens.spacing12),
      _ => HomeHeroBanner(
        registerBonusTitle: l10n.homeGuestRegisterBonusTitle,
        registerBonusBody: l10n.homeGuestRegisterBonusBar,
        registerLabel: l10n.homeTopBannerRegisterAction,
        loginLabel: l10n.loginSubmit,
        onLoginTap: isAuthenticated ? null : () => context.push('/login'),
        onRegisterTap: isAuthenticated
            ? null
            : () => context.push('/login?openRegister=1'),
        onSettingsTap: () => context.push('/profile/settings'),
        onNotificationTap: () => context.push('/profile/notifications'),
        showNotificationDot: hasUnreadNotifications,
        showGuestActions: !isAuthenticated,
      ),
    };
    final attractionSection = HomeAttractionSection(
      title: l10n.homeAttractionSectionTitle,
      items: <HomeAttractionItemData>[
        HomeAttractionItemData(
          icon: Icons.home_outlined,
          title: l10n.homeAttractionAreaTitle,
          body: l10n.homeAttractionAreaBody,
          onTap: () =>
              _openAttractionDetail(context, HomeAttractionDetailKind.area),
        ),
        HomeAttractionItemData(
          icon: Icons.hotel_outlined,
          title: l10n.homeAttractionStructureTitle,
          body: l10n.homeAttractionStructureBody,
          onTap: () =>
              _openAttractionDetail(context, HomeAttractionDetailKind.stay),
        ),
        HomeAttractionItemData(
          icon: Icons.account_balance_outlined,
          title: l10n.homeAttractionFundsTitle,
          body: l10n.homeAttractionFundsBody,
          onTap: () =>
              _openAttractionDetail(context, HomeAttractionDetailKind.shield),
        ),
      ],
    );

    return MainShellTabRefreshScope(
      tabIndex: 0,
      onRefresh: _refreshHomeOverviewTab,
      child: RefreshIndicator(
        onRefresh: () => _refreshHomeOverviewTab(ref),
        child: ListView(
          key: const Key('home_tab_content'),
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            if (networkAccessState == AppNetworkAccessState.denied ||
                (_isApplePlatform &&
                    networkAvailability == AppNetworkAvailability.offline))
              AppNetworkStatusBar(
                title: l10n.networkAccessDeniedBannerTitle,
                message: l10n.networkAccessDeniedBannerMessage,
                icon: Icons.wifi_find_outlined,
              )
            else if (networkAvailability == AppNetworkAvailability.offline)
              AppNetworkStatusBar(
                title: l10n.networkOfflineBannerTitle,
                message: l10n.networkOfflineBannerMessage,
              ),
            topSection,
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Column(
                spacing: UiTokens.spacing16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (isAuthenticated)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiTokens.spacing16,
                      ),
                      child: FundReminderFeed(items: reminders),
                    ),
                  //if (!isAuthenticated)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiTokens.spacing16,
                      ),
                      child: attractionSection,
                    ),
                  if (asyncProjects.isLoading && projects.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: UiTokens.spacing16,
                        ),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  if (loadError != null && projects.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiTokens.spacing16,
                      ),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              l10n.fundListLoadError,
                              textAlign: TextAlign.center,
                              style:
                                  (Theme.of(context).textTheme.bodyMedium ??
                                          const TextStyle())
                                      .copyWith(
                                        color:
                                            AppColorTokens.fundexTextSecondary,
                                      ),
                            ),
                            const SizedBox(height: UiTokens.spacing12),
                            OutlinedButton(
                              onPressed: () =>
                                  ref.invalidate(fundProjectListProvider),
                              child: Text(l10n.fundListRetry),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (featuredFundCards.isNotEmpty)
                    FundFeaturedFundCarousel(
                      title: l10n.homeFeaturedFundsTitle,
                      actionLabel: l10n.homeViewAllAction,
                      onActionTap: () => context.go('/funds'),
                      height: 350,
                      children: featuredFundCards,
                    ),
                  if (showGuide)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiTokens.spacing16,
                      ),
                      child: HomeInvestmentFlowSection(
                        title: l10n.homeInvestmentFlowTitle,
                        steps: <HomeInvestmentFlowStepData>[
                          HomeInvestmentFlowStepData(
                            stepNumber: 1,
                            icon: Icons.person_outline_rounded,
                            title: l10n.homeInvestmentFlowStep1Title,
                            body: l10n.homeInvestmentFlowStep1Body,
                          ),
                          HomeInvestmentFlowStepData(
                            stepNumber: 2,
                            icon: Icons.badge_outlined,
                            title: l10n.homeInvestmentFlowStep2Title,
                            body: l10n.homeInvestmentFlowStep2Body,
                          ),
                          HomeInvestmentFlowStepData(
                            stepNumber: 3,
                            icon: Icons.bar_chart_rounded,
                            title: l10n.homeInvestmentFlowStep3Title,
                            body: l10n.homeInvestmentFlowStep3Body,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: UiTokens.spacing32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiTokens.spacing16,
                    ),
                    child: HomeOfficialSiteLink(
                      label: l10n.homeOfficialSiteAction,
                      onTap: () => _openOfficialSite(context),
                    ),
                  ),
                  const HomeLicenseBar(),
                ],
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
  ref.invalidate(fundProjectListProvider);
  ref.invalidate(memberProfileDetailsProvider);
  await Future.wait<void>(<Future<void>>[
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(memberProfileDetailsProvider.future).then((_) {}),
  ]);
}

Future<void> _openOfficialSite(BuildContext context) async {
  final launched = await launchUrl(
    _officialSiteUri,
    mode: LaunchMode.externalApplication,
  );
  if (launched || !context.mounted) {
    return;
  }
  AppNotice.show(context, message: context.l10n.homeOfficialSiteOpenFailed);
}

Future<void> _openAttractionDetail(
  BuildContext context,
  HomeAttractionDetailKind kind,
) {
  return AppBottomSheet.showAdaptive<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    builder: (BuildContext bottomSheetContext) {
      return HomeAttractionDetailSheet(kind: kind);
    },
  );
}
