import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';
import '../support/home_display_name_resolver.dart';

const Set<int> _featuredProjectStatuses = <int>{0, 1};
const int _operatingProjectStatus = 4;

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
    final basicProfile = ref.watch(memberBasicProfileProvider);
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
    final accountStatistic = ref
        .watch(myPageAccountStatisticProvider)
        .asData
        ?.value;
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
    final activeProjects = projects
        .where(
          (FundProject project) =>
              project.projectStatus == _operatingProjectStatus,
        )
        .take(3)
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
    final activeFundCards = activeProjects
        .map(
          (FundProject project) => FundActiveFundCard(
            data: _buildActiveFundCardData(context, project),
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
      (_, true) => FundHomeHeroSummary(
        greeting: l10n.homeWelcomeUser(
          resolveHomeDisplayName(
            locale: Localizations.localeOf(context),
            profile: basicProfile,
          ),
        ),
        totalAssetsLabel: l10n.homeHeroTotalAssetsAmountLabel,
        totalAssetsValue: _formatCurrencyValue(
          accountStatistic?.total,
          currencyFormatter,
        ),
        totalAssetsDelta: null,
        activeInvestmentLabel: l10n.homeHeroActiveInvestmentLabel,
        activeInvestmentValue: _formatCompactCurrencyValue(
          accountStatistic?.crowdfundingTotal ?? 0,
        ),
        totalDividendsLabel: l10n.homeHeroCashLabel,
        totalDividendsValue: _formatCompactCurrencyValue(
          accountStatistic?.firstLevelAccountTotal,
        ),
        showNotificationDot: hasUnreadNotifications,
        onNotificationTap: () => context.push('/profile/notifications'),
      ),
      _ => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _HomeGuestTopBar(
            title: l10n.splashBrandName,
            onSettingsTap: () => context.push('/profile/settings'),
          ),
          FundGuestBrowsingBar(
            title: l10n.homeGuestBrowsingTitle,
            message: l10n.homeGuestBrowsingBody,
            loginLabel: l10n.loginSubmit,
            registerLabel: l10n.loginCreateAccount,
            onLoginTap: () => context.push('/login'),
            onRegisterTap: () => context.push('/login?openRegister=1'),
          ),
        ],
      ),
    };

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
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
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
                  if (activeFundCards.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiTokens.spacing16,
                      ),
                      child: FundSectionList(
                        title: l10n.homeActiveFundsTitle,
                        actionLabel: l10n.homeViewAllAction,
                        onActionTap: () => context.go('/funds'),
                        initialVisibleCount: 3,
                        children: activeFundCards,
                      ),
                    ),
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

class _HomeGuestTopBar extends StatelessWidget {
  const _HomeGuestTopBar({required this.title, this.onSettingsTap});

  final String title;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: appText.pageTitle.copyWith(color: colors.onDark),
              ),
            ),
            AppNavigationIconButton(icon: Icons.menu, onTap: onSettingsTap),
          ],
        ),
      ),
    );
  }
}

Future<void> _refreshHomeOverviewTab(WidgetRef ref) async {
  ref.invalidate(fundProjectListProvider);
  ref.invalidate(memberProfileDetailsProvider);
  ref.invalidate(myPageAccountStatisticProvider);
  ref.invalidate(secondaryMarketMarketplaceListProvider);
  await Future.wait<void>(<Future<void>>[
    ref.refresh(fundProjectListProvider.future).then((_) {}),
    ref.refresh(memberProfileDetailsProvider.future).then((_) {}),
    ref.refresh(myPageAccountStatisticProvider.future).then((_) {}),
    ref.refresh(secondaryMarketMarketplaceListProvider.future).then((_) {}),
  ]);
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

FundActiveFundCardData _buildActiveFundCardData(
  BuildContext context,
  FundProject project,
) {
  final locale = Localizations.localeOf(context);
  final currencyFormatter = NumberFormat.currency(
    locale: locale.toLanguageTag(),
    symbol: '¥',
    decimalDigits: 0,
  );
  final operationPeriod = _formatOperationPeriod(
    context,
    project.scheduledStartDate,
    project.scheduledEndDate,
  );

  return FundActiveFundCardData(
    title: project.projectName,
    annualYield: resolveFundProjectYieldDisplay(project),
    annualYieldColor: Theme.of(context).appColors.highlightGold,
    rows: <FundLabeledValue>[
      FundLabeledValue(
        label: context.l10n.fundDetailFundTotalLabel,
        value: _formatCurrency(project.amountApplication, currencyFormatter),
      ),
      FundLabeledValue(
        label: context.l10n.fundListPeriodLabel,
        value: operationPeriod ?? context.l10n.myPageResultAnnouncementTbd,
      ),
    ],
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

String _formatCompactCurrencyValue(num? amount) {
  if (amount == null) {
    return '-';
  }

  final value = amount.toDouble();
  final abs = value.abs();
  if (abs >= 1000000) {
    return '¥${_formatCompactNumber(value / 1000000)}M';
  }
  if (abs >= 10000) {
    return '¥${_formatCompactNumber(value / 1000)}K';
  }
  return '¥${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(double value) {
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
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

String? _formatOperationPeriod(
  BuildContext context,
  String? start,
  String? end,
) {
  final locale = Localizations.localeOf(context);
  final startDate = _parseDateTime(start);
  final endDate = _parseDateTime(end);
  if (startDate == null || endDate == null) {
    return null;
  }
  return '${_formatDateForLocale(startDate, locale)}～${_formatDateForLocale(endDate, locale)}';
}
