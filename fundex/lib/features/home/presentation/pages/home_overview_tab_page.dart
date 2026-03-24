import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../investment/presentation/support/fund_project_yield_display.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../../member_profile/domain/entities/member_profile_details.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
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
    final isAuthenticated = authState.asData?.value ?? false;
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    final asyncProjects = ref.watch(fundProjectListProvider);
    final asyncSecondaryMarketRecords = ref.watch(
      secondaryMarketMarketplaceListProvider,
    );
    final asyncMemberProfile = ref.watch(memberProfileDetailsProvider);
    final accountStatistic =
        ref.watch(myPageAccountStatisticProvider).asData?.value;
    final memberProfile = asyncMemberProfile.asData?.value;
    final projects = asyncProjects.asData?.value ?? const <FundProject>[];
    final secondaryMarketRecords = asyncSecondaryMarketRecords.asData?.value ??
        const <MyPageOrderInquiryRecord>[];
    final locale = Localizations.localeOf(context);
    final currencyFormatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );

    final reminders = <FundReminderData>[
      if (!_isMemberProfileFlowComplete(asyncMemberProfile, memberProfile))
        FundReminderData(
          leading: const Icon(
            Icons.warning_rounded,
            size: 18,
            color: Color(0xFFFBBF24),
          ),
          title: l10n.homeReminderProfileTitle,
          message: l10n.homeReminderProfileBody,
          tone: FundReminderTone.danger,
          badgeLabel: l10n.homeReminderProfileBadge,
          segmentCount: MemberProfileDetails.flowStepCount,
          completedSegmentCount: memberProfile?.completedFlowStepCount ?? 0,
          onTap: () => context.push('/member-profile/onboarding'),
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
    final secondaryMarketCards = secondaryMarketRecords
        .take(4)
        .map(
          (MyPageOrderInquiryRecord record) => FundSecondaryMarketCard(
            fillHeight: true,
            data: _buildSecondaryMarketCardData(
              context,
              record,
              currencyFormatter,
            ),
            actionLabel: l10n.secondaryMarketBuyAction,
            yieldLabel: l10n.homeEstimatedYieldLabel,
            soldUnitsTitle: l10n.homeFreeMarketSoldUnitsLabel,
            unitPriceTitle: l10n.homeFreeMarketUnitPriceLabel,
          ),
        )
        .toList(growable: false);
    final loadError = asyncProjects.asError;

    final topSection = switch ((authState.isLoading, isAuthenticated)) {
      (true, _) => const SizedBox(height: UiTokens.spacing12),
      (_, true) => FundHomeHeroSummary(
          greeting: l10n.homeWelcomeUser(
            resolveHomeDisplayName(
              locale: Localizations.localeOf(context),
              user: currentUser,
            ),
          ),
          totalAssetsLabel: l10n.homeHeroTotalAssetsAmountLabel,
          totalAssetsValue: _formatCurrencyValue(
            accountStatistic?.total,
            currencyFormatter,
          ),
          totalAssetsDelta: l10n.homeHeroMonthlyDelta,
          activeInvestmentLabel: l10n.homeHeroActiveInvestmentLabel,
          activeInvestmentValue: _formatCompactCurrencyValue(
            accountStatistic?.crowdfundingTotal,
          ),
          totalDividendsLabel: l10n.homeHeroCashLabel,
          totalDividendsValue: _formatCompactCurrencyValue(
            accountStatistic?.firstLevelAccountTotal,
          ),
          showNotificationDot: true,
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
            if (networkAvailability == AppNetworkAvailability.offline)
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
                              style: (Theme.of(context).textTheme.bodyMedium ??
                                      const TextStyle())
                                  .copyWith(
                                color: AppColorTokens.fundexTextSecondary,
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
                      children: featuredFundCards,
                    ),
                  if (secondaryMarketCards.isNotEmpty)
                    FundFeaturedFundCarousel(
                      title: l10n.homeFreeMarketTitle,
                      // leading: Icon(
                      //   Icons.storefront_rounded,
                      //   size: 18,
                      //   color: Theme.of(context).appColors.warningAction,
                      // ),
                      actionLabel: l10n.homeViewAllAction,
                      onActionTap: () => context.push('/home/free-market'),
                      height: 262,
                      children: secondaryMarketCards,
                    ),
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
            AppNavigationIconButton(
              icon: Icons.menu,
              onTap: onSettingsTap,
            ),
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

bool _isMemberProfileFlowComplete(
  AsyncValue<MemberProfileDetails?> asyncMemberProfile,
  MemberProfileDetails? memberProfile,
) {
  if (asyncMemberProfile.isLoading) {
    return true;
  }
  return memberProfile?.isEditFlowComplete ?? false;
}

FundFeaturedFundCardData _buildFeaturedFundCardData(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final status = project.projectStatus;
  final statusTag = _buildStatusTag(context, status);
  final methodTag = _buildMethodTag(context, project.offeringMethod);
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
  return FundActiveFundCardData(
    title: project.projectName,
    annualYield: resolveFundProjectYieldDisplay(project),
    rows: <FundLabeledValue>[
      FundLabeledValue(
        label: context.l10n.fundListPeriodLabel,
        value: _resolvePeriodText(project),
      ),
      FundLabeledValue(
        label: context.l10n.fundListMethodLabel,
        value: _resolveMethodLabel(context, project.offeringMethod),
      ),
    ],
    progress: _normalizeProgress(project.achievementRate),
    progressColor: AppColorTokens.fundexSuccess,
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
    statusBackgroundColor: colors.warningSubtle,
    statusForegroundColor: colors.warningAction,
    annualYield: _formatYieldPercent(record.investorType?.earningsRadio),
    investorTypeLabel:
        investorCode != null && investorCode.isNotEmpty ? investorCode : '--',
    soldUnitsLabel: '${soldNum.toString()} / ${sellNum.toString()}口',
    unitPriceLabel: _formatCurrencyValue(record.price, currencyFormatter),
    progress: progress.clamp(0, 1),
    onTap: orderId == null || orderId.isEmpty
        ? null
        : () => context.push('/home/free-market/$orderId', extra: record),
  );
}

FundFeaturedFundTagData _buildStatusTag(BuildContext context, int? status) {
  switch (status) {
    case 1:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOpen,
        backgroundColor: AppColorTokens.fundexSuccess.withValues(alpha: 0.92),
        foregroundColor: Colors.white,
      );
    case 0:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusUpcoming,
        backgroundColor: AppColorTokens.fundexWarning.withValues(alpha: 0.92),
        foregroundColor: Colors.white,
      );
    case 4:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOperating,
        backgroundColor: AppColorTokens.fundexAccent.withValues(alpha: 0.88),
        foregroundColor: Colors.white,
      );
    default:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusUnknown,
        backgroundColor: AppColorTokens.fundexTextSecondary.withValues(
          alpha: 0.88,
        ),
        foregroundColor: Colors.white,
      );
  }
}

FundFeaturedFundTagData? _buildMethodTag(
  BuildContext context,
  String? offeringMethod,
) {
  final label = _resolveMethodLabel(context, offeringMethod).trim();
  if (label.isEmpty) {
    return null;
  }
  return FundFeaturedFundTagData(
    label: label,
    backgroundColor: AppColorTokens.fundexPink.withValues(alpha: 0.85),
    foregroundColor: Colors.white,
  );
}

List<Color> _featuredArtworkGradientColors(BuildContext context, int? status) {
  final colors = Theme.of(context).appColors;

  switch (status) {
    case 1:
      return <Color>[
        colors.brandPrimaryDark,
        colors.primary,
        colors.brandPrimaryBright,
      ];
    case 0:
      return <Color>[
        colors.warningForeground,
        colors.warning,
        colors.warningAction,
      ];
    case 4:
      return <Color>[
        colors.successForeground,
        colors.success,
        colors.successBorder,
      ];
    default:
      return <Color>[
        colors.textSecondary,
        colors.textSecondary.withValues(alpha: 0.84),
        colors.textTertiary,
      ];
  }
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
    final openDate = _parseDateTime(project.offeringStartDatetime) ??
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

String _resolvePeriodText(FundProject project) {
  final period = project.investmentPeriod?.trim();
  if (period != null && period.isNotEmpty) {
    return period;
  }
  return '--';
}

String _resolveMethodLabel(BuildContext context, String? offeringMethod) {
  final l10n = context.l10n;
  final value = offeringMethod?.trim();
  if (value == null || value.isEmpty) {
    return l10n.fundListMethodLottery;
  }

  final normalized = value.toLowerCase();
  if (normalized.contains('lottery') ||
      value.contains('抽選') ||
      value.contains('抽签')) {
    return l10n.fundListMethodLottery;
  }
  return value;
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
  final percentage = ratio > 1 ? ratio : ratio * 100;
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
