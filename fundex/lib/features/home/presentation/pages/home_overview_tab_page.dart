import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../investment/presentation/support/fund_project_gain_type_label.dart';
import '../../../investment/presentation/support/fund_project_yield_display.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../member_profile/domain/entities/member_profile_details.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';

const Set<int> _featuredProjectStatuses = <int>{0, 1};
final Uri _officialSiteUri = Uri.parse('https://stellavia.co.jp/');
const List<String> _homeHeroImageUrls = <String>[
  'https://upload.wikimedia.org/wikipedia/commons/3/35/Minato_City%2C_Tokyo%2C_Japan.jpg',
  'https://upload.wikimedia.org/wikipedia/commons/4/4e/Gion_kyoto_japan.JPG',
  'https://upload.wikimedia.org/wikipedia/commons/e/e7/Biei_Hokkaido.jpg',
];

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
    // final asyncSecondaryMarketRecords = ref.watch(
    //   secondaryMarketMarketplaceListProvider,
    // );
    final asyncMemberProfile = ref.watch(memberProfileDetailsProvider);
    final asyncVerificationStatus = ref.watch(
      settingsRemoteVerificationStatusProvider,
    );
    final memberProfile = asyncMemberProfile.asData?.value;
    final verificationStatus = asyncVerificationStatus.asData?.value;
    final projects = asyncProjects.asData?.value ?? const <FundProject>[];
    // final secondaryMarketRecords =
    //     asyncSecondaryMarketRecords.asData?.value ??
    //     const <MyPageOrderInquiryRecord>[];
    final locale = Localizations.localeOf(context);
    final currencyFormatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final shouldShowMemberProfileReminder = _shouldShowMemberProfileReminder(
      currentUser,
      isMemberProfileCompleted: isMemberProfileCompleted,
    );

    final reminders = <FundReminderData>[
      if (shouldShowMemberProfileReminder)
        FundReminderData(
          leading: Icon(
            Icons.warning_rounded,
            size: 18,
            color: Theme.of(context).appColors.highlightGold,
          ),
          title: l10n.homeReminderProfileTitle,
          message: l10n.homeReminderProfileBody,
          tone: FundReminderTone.danger,
          badgeLabel: l10n.homeReminderProfileBadge,
          segmentCount: MemberProfileDetails.flowStepCount,
          completedSegmentCount: memberProfile?.completedFlowStepCount ?? 0,
          onTap: () => context.push('/member-profile/onboarding'),
        ),
      if (isEmailVerified == false)
        FundReminderData(
          leading: Icon(
            Icons.alternate_email_rounded,
            size: 18,
            color: Theme.of(context).appColors.warningAction,
          ),
          title: l10n.homeReminderEmailVerificationTitle,
          message: l10n.homeReminderEmailVerificationBody,
          tone: FundReminderTone.warning,
          badgeLabel: l10n.homeReminderProfileBadge,
          onTap: () => context.push('/profile/settings/two-factor/email'),
        ),
      if (verificationStatus?.isPhoneVerified == false)
        FundReminderData(
          leading: Icon(
            Icons.sms_outlined,
            size: 18,
            color: Theme.of(context).appColors.warningAction,
          ),
          title: l10n.homeReminderPhoneVerificationTitle,
          message: l10n.homeReminderPhoneVerificationBody,
          tone: FundReminderTone.warning,
          badgeLabel: l10n.homeReminderProfileBadge,
          onTap: () => context.push('/profile/settings/two-factor/phone'),
        ),
      if (!shouldShowMemberProfileReminder &&
          verificationStatus?.isRealPersonVerified == false)
        FundReminderData(
          leading: Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: Theme.of(context).appColors.highlightGold,
          ),
          title: l10n.homeReminderRealPersonVerificationTitle,
          message: l10n.homeReminderRealPersonVerificationBody,
          tone: FundReminderTone.danger,
          badgeLabel: l10n.homeReminderProfileBadge,
          onTap: () => context.push('/profile/settings/two-factor/face'),
        ),
    ];

    final featuredProjects = projects
        .where(
          (FundProject project) =>
              _featuredProjectStatuses.contains(project.projectStatus),
        )
        .take(6)
        .toList(growable: false);
    final featuredFundCards = featuredProjects
        .map(
          (FundProject project) => FundFeaturedFundCard(
            data: _buildFeaturedFundCardData(
              context,
              project,
              currencyFormatter,
            ),
            yieldLabel: l10n.homeEstimatedYieldLabel,
          ),
        )
        .toList(growable: false);
    // final secondaryMarketCards = secondaryMarketRecords
    //     .take(4)
    //     .map(
    //       (MyPageOrderInquiryRecord record) => FundSecondaryMarketCard(
    //         fillHeight: true,
    //         data: _buildSecondaryMarketCardData(
    //           context,
    //           record,
    //           currencyFormatter,
    //         ),
    //         actionLabel: l10n.secondaryMarketBuyAction,
    //         yieldLabel: l10n.homeEstimatedYieldLabel,
    //         soldUnitsTitle: l10n.homeFreeMarketSoldUnitsLabel,
    //         unitPriceTitle: l10n.homeFreeMarketUnitPriceLabel,
    //       ),
    //     )
    //     .toList(growable: false);
    final loadError = asyncProjects.asError;

    final topSection = switch ((authState.isLoading, isAuthenticated)) {
      (true, _) => const SizedBox(height: UiTokens.spacing12),
      _ => _HomeHeroBanner(
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
    final attractionSection = _HomeAttractionSection(
      title: l10n.homeAttractionSectionTitle,
      items: <_HomeAttractionItemData>[
        _HomeAttractionItemData(
          icon: Icons.home_outlined,
          title: l10n.homeAttractionAreaTitle,
          body: l10n.homeAttractionAreaBody,
          onTap: () => _openOfficialSite(context),
        ),
        _HomeAttractionItemData(
          icon: Icons.hotel_outlined,
          title: l10n.homeAttractionStructureTitle,
          body: l10n.homeAttractionStructureBody,
          onTap: () => _openOfficialSite(context),
        ),
        _HomeAttractionItemData(
          icon: Icons.account_balance_outlined,
          title: l10n.homeAttractionFundsTitle,
          body: l10n.homeAttractionFundsBody,
          onTap: () => _openOfficialSite(context),
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
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
                      height: 272,
                      children: featuredFundCards,
                    ),
                  // if (secondaryMarketCards.isNotEmpty)
                  //   FundFeaturedFundCarousel(
                  //     title: l10n.homeFreeMarketTitle,
                  //     // leading: Icon(
                  //     //   Icons.storefront_rounded,
                  //     //   size: 18,
                  //     //   color: Theme.of(context).appColors.warningAction,
                  //     // ),
                  //     actionLabel: l10n.homeViewAllAction,
                  //     onActionTap: () => context.push('/home/free-market'),
                  //     height: 262,
                  //     children: secondaryMarketCards,
                  //   ),
                  const SizedBox(height: UiTokens.spacing32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiTokens.spacing16,
                    ),
                    child: _HomeOfficialSiteLink(
                      label: l10n.homeOfficialSiteAction,
                      onTap: () => _openOfficialSite(context),
                    ),
                  ),
                  const _HomeLicenseBar(),
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

class _HomeHeroBanner extends StatelessWidget {
  const _HomeHeroBanner({
    required this.registerBonusTitle,
    required this.registerBonusBody,
    required this.registerLabel,
    required this.loginLabel,
    required this.showGuestActions,
    this.showNotificationDot = false,
    this.onSettingsTap,
    this.onNotificationTap,
    this.onRegisterTap,
    this.onLoginTap,
  });

  final String registerBonusTitle;
  final String registerBonusBody;
  final String registerLabel;
  final String loginLabel;
  final bool showGuestActions;
  final bool showNotificationDot;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    double borderRadius = showGuestActions ? UiTokens.radius20 : 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: <Widget>[
                  //"StellaVia" text
                  Expanded(
                    child: Text(
                      "StellaVia",
                      style: theme.appTextTheme.pageTitle.copyWith(
                        color: colors.onDark,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  if (showGuestActions)
                    AppNavigationIconButton(
                      icon: Icons.menu_rounded,
                      size: 40,
                      borderRadius: 12,
                      backgroundColor: colors.onDark.withValues(alpha: 0.08),
                      onTap: onSettingsTap,
                    )
                  else
                    _HomeHeroNotificationButton(
                      showDot: showNotificationDot,
                      onTap: onNotificationTap,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const _HomeHeroVisual(),
            if (showGuestActions)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 52,
                      child: _HomeHeroRegisterBonusCard(
                        title: registerBonusTitle,
                        body: registerBonusBody,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _HomeHeroActionButton(
                              label: registerLabel,
                              onTap: onRegisterTap,
                              isPrimary: true,
                            ),
                          ),
                          const SizedBox(width: UiTokens.spacing12),
                          Expanded(
                            child: _HomeHeroActionButton(
                              label: loginLabel,
                              onTap: onLoginTap,
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (!showGuestActions)
              Divider(height: 1, thickness: 1, color: colors.highlightGold),
          ],
        ),
      ),
    );
  }
}

class _HomeHeroNotificationButton extends StatelessWidget {
  const _HomeHeroNotificationButton({
    required this.showDot,
    required this.onTap,
  });

  final bool showDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: AppNavigationIconButton(
              icon: Icons.notifications_none_rounded,
              size: 40,
              borderRadius: 12,
              backgroundColor: colors.onDark.withValues(alpha: 0.08),
              onTap: onTap,
            ),
          ),
          if (showDot)
            Positioned(
              right: 7,
              top: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.heroStart, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeHeroVisual extends StatelessWidget {
  const _HomeHeroVisual();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return Container(
      decoration: BoxDecoration(color: colors.onDark),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: FundHeroMediaBackground(
          gradientColors: <Color>[colors.heroMiddle, colors.primaryAlt],
          imageUrls: _homeHeroImageUrls,
          showArtworkOverlay: false,
          autoPlay: _homeHeroImageUrls.length > 1,
          autoPlayInterval: const Duration(seconds: 5),
        ),
      ),
    );
  }
}

class _HomeHeroRegisterBonusCard extends StatelessWidget {
  const _HomeHeroRegisterBonusCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.heroMiddle.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        border: Border.all(
          color: colors.highlightGold.withValues(alpha: 0.7),
          width: 1.25,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.brandSecondary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 20,
              color: colors.highlightGold,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: appText.bodyStrong.copyWith(
                  color: colors.onDark,
                  height: 1.35,
                ),
              ),
              Text(
                body,
                style: appText.bodyStrong.copyWith(
                  color: colors.highlightGold,
                  height: 1.35,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          //const SizedBox(width: 8),
          // Icon(
          //   Icons.chevron_right_rounded,
          //   size: 22,
          //   color: colors.highlightGold,
          // ),
        ],
      ),
    );
  }
}

class _HomeHeroActionButton extends StatelessWidget {
  const _HomeHeroActionButton({
    required this.label,
    required this.isPrimary,
    this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    final backgroundColor = isPrimary
        ? colors.highlightGold
        : Colors.transparent;
    final foregroundColor = isPrimary ? colors.brandPrimaryDark : colors.onDark;
    final borderColor = isPrimary
        ? colors.highlightGold
        : colors.onDark.withValues(alpha: 0.54);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(UiTokens.radius8),
            border: Border.all(color: borderColor, width: 1.4),
          ),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                label,
                style: appText.button.copyWith(color: foregroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeAttractionSection extends StatelessWidget {
  const _HomeAttractionSection({required this.title, required this.items});

  final String title;
  final List<_HomeAttractionItemData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).appTextTheme.heroMetricSecondary),
        const SizedBox(height: UiTokens.spacing12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var index = 0; index < items.length; index++) ...<Widget>[
              Expanded(child: _HomeAttractionCard(data: items[index])),
              if (index < items.length - 1)
                const SizedBox(width: UiTokens.spacing12),
            ],
          ],
        ),
      ],
    );
  }
}

class _HomeAttractionItemData {
  const _HomeAttractionItemData({
    required this.icon,
    required this.title,
    required this.body,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;
}

class _HomeAttractionCard extends StatelessWidget {
  const _HomeAttractionCard({required this.data});

  final _HomeAttractionItemData data;

  String get _headlineText {
    final title = data.title.trim();
    final body = data.body.trim();
    if (body.isEmpty) {
      return title;
    }
    return '$title$body';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        onTap: data.onTap,
        child: SizedBox(
          //height: 168,
          child: Ink(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(UiTokens.radius12),
              border: Border.all(color: colors.primarySubtle),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(data.icon, size: 32, color: colors.highlightGold),
                ),
                const SizedBox(height: 2),
                Text(
                  _headlineText,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: appText.bodyStrong.copyWith(
                    color: colors.textPrimary,
                    height: 1.45,
                  ),
                ),
                
                const SizedBox(height: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: colors.brandPrimaryDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeOfficialSiteLink extends StatelessWidget {
  const _HomeOfficialSiteLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final baseFontSize = appText.bodyStrong.fontSize ?? 14;

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(UiTokens.radius12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.highlightGold.withValues(alpha: 0.72),
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      label,
                      style: appText.bodyStrong.copyWith(
                        color: colors.highlightGold,
                        fontSize: baseFontSize * 1.2,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.north_east_rounded,
                      size: 22,
                      color: colors.highlightGold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeLicenseBar extends StatelessWidget {
  const _HomeLicenseBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.highlightGold),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 72,
        child: Text(
          context.l10n.myPageLicenseNotice,
          textAlign: TextAlign.center,
          style: appText.meta.copyWith(
            color: colors.brandPrimaryDark,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

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

bool _shouldShowMemberProfileReminder(
  AuthUser? user, {
  bool? isMemberProfileCompleted,
}) {
  final status = user?.status;
  if (status == null) {
    if (isMemberProfileCompleted != null) {
      return !isMemberProfileCompleted;
    }
    return false;
  }
  return status == 0 || status == 1 || status == 3;
}

FundFeaturedFundCardData _buildFeaturedFundCardData(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final status = project.projectStatus;
  final statusTag = _buildStatusTag(context, status);
  final methodTag = _buildMethodTag(context, project.gainType);
  final metadata = _buildFeaturedMetadata(context, project);

  return FundFeaturedFundCardData(
    title: project.projectName,
    annualYield: resolveFundProjectYieldDisplay(project),
    metadata: metadata,
    progress: _normalizeProgress(project.achievementRate),
    progressLabel: _buildProgressLabel(context, project, currencyFormatter),
    tags: <FundFeaturedFundTagData>[
      statusTag,
      if (methodTag != null) methodTag,
    ],
    artworkGradientColors: _featuredArtworkGradientColors(context, status),
    imageUrls: project.photos,
    onTap: () => context.push('/funds/${project.id}'),
  );
}

FundSecondaryMarketCardData _buildSecondaryMarketCardData(
  BuildContext context,
  MyPageOrderInquiryRecord record,
  NumberFormat currencyFormatter,
) {
  final theme = Theme.of(context);
  final colors = theme.appColors;
  final investorCode = record.investorType?.investorCode?.trim();
  final sellNum = record.sellNum ?? 0;
  final soldNum = record.soldNum ?? 0;
  final progress = sellNum <= 0 ? 0.0 : soldNum / sellNum;
  final orderId = record.id?.trim();

  return FundSecondaryMarketCardData(
    title: record.projectName,
    statusLabel: context.l10n.homeFreeMarketStatusListed,
    statusBackgroundColor: colors.primary,
    statusForegroundColor: colors.onDark,
    annualYield: _formatYieldPercent(record.investorType?.earningsRadio),
    investorTypeLabel: investorCode != null && investorCode.isNotEmpty
        ? investorCode
        : '--',
    soldUnitsLabel: '${soldNum.toString()} / ${sellNum.toString()}口',
    unitPriceLabel: _formatCurrencyValue(record.price, currencyFormatter),
    progress: progress.clamp(0, 1),
    onTap: orderId == null || orderId.isEmpty
        ? null
        : () => context.push('/home/free-market/$orderId', extra: record),
  );
}

FundFeaturedFundTagData _buildStatusTag(BuildContext context, int? status) {
  final palette = _resolveFeaturedStatusPalette(context, status);
  switch (status) {
    case 7:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusCompleted,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 5:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOperatingEnded,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 1:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOpen,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 0:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusUpcoming,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 4:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOperating,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 3:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusClosed,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 2:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusFailed,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    default:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusUnknown,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
  }
}

FundFeaturedFundTagData? _buildMethodTag(
  BuildContext context,
  String? gainType,
) {
  final label = resolveFundProjectGainTypeLabel(context, gainType).trim();
  if (label.isEmpty) {
    return null;
  }
  return FundFeaturedFundTagData(
    label: label,
    backgroundColor: Theme.of(context).appColors.onDark.withValues(alpha: 0.14),
    foregroundColor: Theme.of(context).appColors.onDark.withValues(alpha: 0.92),
  );
}

List<Color> _featuredArtworkGradientColors(BuildContext context, int? status) {
  return _resolveFeaturedStatusPalette(context, status).gradientColors;
}

_FeaturedFundStatusPalette _resolveFeaturedStatusPalette(
  BuildContext context,
  int? status,
) {
  final colors = Theme.of(context).appColors;

  switch (status) {
    case 4:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.infoForeground, colors.primary],
        tagBackgroundColor: colors.infoSubtle,
        tagForegroundColor: colors.infoForeground,
      );
    case 5:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
        tagBackgroundColor: colors.surfaceAlt,
        tagForegroundColor: colors.textSecondary,
      );
    case 1:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.brandPrimaryDark, colors.primary],
        tagBackgroundColor: colors.highlightGold,
        tagForegroundColor: colors.onDark,
      );
    case 0:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.brandPrimaryDark, colors.primary],
        tagBackgroundColor: colors.surface,
        tagForegroundColor: colors.primary,
      );
    case 3:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
        tagBackgroundColor: colors.surfaceAlt,
        tagForegroundColor: colors.textSecondary,
      );
    case 7:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.primaryAlt, colors.primary],
        tagBackgroundColor: colors.primarySubtle,
        tagForegroundColor: colors.primary,
      );
    case 2:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.dangerForeground, colors.danger],
        tagBackgroundColor: colors.dangerSubtle,
        tagForegroundColor: colors.dangerForeground,
      );
    default:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
        tagBackgroundColor: colors.surfaceAlt,
        tagForegroundColor: colors.textSecondary,
      );
  }
}

class _FeaturedFundStatusPalette {
  const _FeaturedFundStatusPalette({
    required this.gradientColors,
    required this.tagBackgroundColor,
    required this.tagForegroundColor,
  });

  final List<Color> gradientColors;
  final Color tagBackgroundColor;
  final Color tagForegroundColor;
}

String _buildFeaturedMetadata(BuildContext context, FundProject project) {
  final company = project.operatingCompany?.trim();
  if (company != null && company.isNotEmpty) {
    return company;
  }
  final period = project.investmentPeriod?.trim();
  if (period != null && period.isNotEmpty) {
    return period;
  }
  return _resolveStatusLabel(context, project.projectStatus);
}

String _buildProgressLabel(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  if (project.projectStatus == 0) {
    final openDate =
        _parseDateTime(project.offeringStartDatetime) ??
        _parseDateTime(project.scheduledStartDate);
    if (openDate != null) {
      return context.l10n.fundListOpenStartAt(
        _formatDateForLocale(openDate, Localizations.localeOf(context)),
      );
    }
  }

  final amount = _formatCurrency(
    project.currentlySubscribed ?? project.amountApplication,
    currencyFormatter,
  );
  return context.l10n.fundListAppliedAmount(
    amount,
    _formatProgressPercent(project.achievementRate),
  );
}

String _resolveStatusLabel(BuildContext context, int? status) {
  final l10n = context.l10n;
  switch (status) {
    case 4:
      return l10n.fundListStatusOperating;
    case 5:
      return l10n.fundListStatusOperatingEnded;
    case 1:
      return l10n.fundListStatusOpen;
    case 0:
      return l10n.fundListStatusUpcoming;
    case 3:
      return l10n.fundListStatusClosed;
    case 7:
      return l10n.fundListStatusCompleted;
    case 2:
      return l10n.fundListStatusFailed;
    default:
      return l10n.fundListStatusUnknown;
  }
}

String _formatYieldPercent(double? ratio) {
  return formatFundYieldPercent(ratio);
}

double _normalizeProgress(double? ratio) {
  if (ratio == null) {
    return 0;
  }
  if (ratio < 0) {
    return 0;
  }
  return ratio > 1 ? ratio / 100 : ratio;
}

String _formatProgressPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

String _formatCurrency(int? amount, NumberFormat formatter) {
  if (amount == null) {
    return '-';
  }
  return formatter.format(amount);
}

String _formatCurrencyValue(num? amount, NumberFormat formatter) {
  if (amount == null) {
    return '-';
  }
  return formatter.format(amount);
}

DateTime? _parseDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  final normalized = raw.trim().replaceAll(' ', 'T');
  return DateTime.tryParse(normalized);
}

String _formatDateForLocale(DateTime value, Locale locale) {
  final languageCode = locale.languageCode;
  if (languageCode == 'ja') {
    return DateFormat.yMMMMd('ja').format(value);
  }
  if (languageCode == 'zh') {
    return DateFormat.yMd('zh').format(value);
  }
  return DateFormat.yMMMd(locale.toLanguageTag()).format(value);
}
