import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../domain/entities/fund_project.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../providers/fund_project_favorite_providers.dart';
import '../providers/fund_project_providers.dart';
import '../support/fund_project_gain_type_label.dart';
import '../support/fund_project_yield_display.dart';

enum _FundListFilter {
  all,
  opening,
  completed,
  operating,
  operatingEnded,
  favorites,
}

extension on _FundListFilter {
  int? get projectStatusCode {
    switch (this) {
      case _FundListFilter.all:
        return null;
      case _FundListFilter.opening:
        return 1;
      case _FundListFilter.completed:
        return 7;
      case _FundListFilter.operating:
        return 4;
      case _FundListFilter.operatingEnded:
        return 5;
      case _FundListFilter.favorites:
        return null;
    }
  }
}

class _FundListFilterOption {
  const _FundListFilterOption({
    required this.filter,
    required this.label,
    this.style = AppFilterBarItemStyle.primary,
    this.leadingIcon,
  });

  final _FundListFilter filter;
  final String label;
  final AppFilterBarItemStyle style;
  final IconData? leadingIcon;
}

class _FundStatusPalette {
  const _FundStatusPalette({
    required this.heroGradientColors,
    required this.tagBackgroundColor,
    required this.tagForegroundColor,
    required this.amountGradientColors,
  });

  final List<Color> heroGradientColors;
  final Color tagBackgroundColor;
  final Color tagForegroundColor;
  final List<Color> amountGradientColors;
}

class InvestmentTabPage extends ConsumerStatefulWidget {
  const InvestmentTabPage({super.key});

  @override
  ConsumerState<InvestmentTabPage> createState() => _InvestmentTabPageState();
}

class _InvestmentTabPageState extends ConsumerState<InvestmentTabPage> {
  _FundListFilter _selectedFilter = _FundListFilter.all;

  _FundListFilter get _effectiveSelectedFilter =>
      _selectedFilter == _FundListFilter.completed
      ? _FundListFilter.all
      : _selectedFilter;

  List<_FundListFilterOption> _buildFilterOptions(BuildContext context) {
    final l10n = context.l10n;
    return <_FundListFilterOption>[
      _FundListFilterOption(
        filter: _FundListFilter.all,
        label: l10n.fundListFilterAll,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.opening,
        label: l10n.fundListFilterOpen,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.operating,
        label: l10n.fundListFilterOperating,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.operatingEnded,
        label: l10n.fundListFilterOperatingEnded,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.favorites,
        label: l10n.fundListFilterFavorites,
        style: AppFilterBarItemStyle.accent,
        leadingIcon: Icons.star_rounded,
      ),
    ];
  }

  Future<void> _refreshProjects() async {
    if (shouldSkipAppNetworkRefresh(ref)) {
      return;
    }
    ref.invalidate(fundProjectListProvider);
    await ref.read(fundProjectListProvider.future);
  }

  List<FundProject> _applyFilter(
    List<FundProject> projects,
    Set<String> favoriteIds,
  ) {
    final effectiveFilter = _effectiveSelectedFilter;
    if (effectiveFilter == _FundListFilter.favorites) {
      return projects
          .where(
            (FundProject project) => favoriteIds.contains(project.id.trim()),
          )
          .toList(growable: false);
    }
    final statusCode = effectiveFilter.projectStatusCode;
    if (statusCode == null) {
      return projects;
    }
    return projects
        .where((FundProject project) => project.projectStatus == statusCode)
        .toList(growable: false);
  }

  String _formatCurrency(int? amount, NumberFormat formatter) {
    if (amount == null) {
      return '-';
    }
    return formatter.format(amount);
  }

  String _formatProgressPercent(double? ratio) {
    if (ratio == null) {
      return '--';
    }
    final percentage = ratio * 100;
    final hasFraction = percentage % 1 != 0;
    return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
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

  String _resolveLocationHint(FundProject project) {
    // final name = project.projectName.trim();
    // if (name.contains(' ')) {
    //   return name.split(' ').first;
    // }
    // if (name.contains('　')) {
    //   return name.split('　').first;
    // }
    final company = project.operatingCompany?.trim();
    if (company != null && company.isNotEmpty) {
      return company;
    }
    return '-';
  }

  String _resolveMinimumInvestmentText(
    BuildContext context,
    FundProject project,
    Locale locale,
  ) {
    final amount = project.investmentUnit;
    if (amount == null || amount <= 0) {
      return context.l10n.fundDetailUnknownValue;
    }

    final localizedAmount =
        _formatMinimumInvestmentAmountForLocale(amount, locale) ??
        NumberFormat.decimalPattern(locale.toLanguageTag()).format(amount);

    return context.l10n.fundListMinimumInvestmentValue(localizedAmount);
  }

  String? _formatMinimumInvestmentAmountForLocale(int amount, Locale locale) {
    if (amount < 10000 || amount % 10000 != 0) {
      return null;
    }

    final manCount = amount ~/ 10000;
    final manText = NumberFormat.decimalPattern(
      locale.toLanguageTag(),
    ).format(manCount);

    switch (locale.languageCode) {
      case 'ja':
      case 'zh':
        return '$manText万';
      default:
        return null;
    }
  }

  String _resolveStatusLabel(BuildContext context, int? status) {
    final l10n = context.l10n;
    switch (status) {
      case 4:
        return l10n.fundListStatusOperating; //运用中
      case 5:
        return l10n.fundListStatusOperatingEnded; //运用结束
      case 1:
        return l10n.fundListStatusOpen; //募集中
      case 0:
        return l10n.fundListStatusUpcoming; //募集前
      case 3:
        return l10n.fundListStatusClosed; //募集结束
      case 7:
        return l10n.fundListStatusCompleted; //募集完成
      case 2:
        return l10n.fundListStatusFailed; //募集失败
      default:
        return l10n.fundListStatusUnknown; //未设定
    }
  }

  _FundStatusPalette _resolveStatusPalette(BuildContext context, int? status) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final openAccentColor = isDark
        ? colors.primaryAlt
        : Color.alphaBlend(
            colors.brandPrimaryDark.withValues(alpha: 0.20),
            colors.primary,
          );
    final openTagBackgroundColor = isDark
        ? Color.alphaBlend(colors.highlightGold, colors.surfaceAlt)
        : Color.alphaBlend(colors.highlightGold, colors.primarySubtle);
    final openTagForegroundColor = isDark ? colors.onDark : colors.primary;
    switch (status) {
      case 4: // 运用中
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.infoForeground, colors.primary],
          tagBackgroundColor: colors.infoSubtle,
          tagForegroundColor: colors.infoForeground,
          amountGradientColors: <Color>[colors.info, colors.primaryAlt],
        );
      case 5: // 运用结束
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
          tagBackgroundColor: colors.surfaceAlt,
          tagForegroundColor: colors.textSecondary,
          amountGradientColors: <Color>[
            colors.textSecondary,
            colors.heroMiddle,
          ],
        );
      case 1: // 募集中
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.brandPrimaryDark, openAccentColor],
          tagBackgroundColor: openTagBackgroundColor,
          tagForegroundColor: colors.onDark,
          amountGradientColors: <Color>[openAccentColor, colors.primary],
        );
      case 0: // 募集前
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.warningForeground, colors.warning],
          tagBackgroundColor: colors.warningSubtle,
          tagForegroundColor: colors.warningForeground,
          amountGradientColors: <Color>[colors.warningAction, colors.warning],
        );
      case 3: // 募集结束
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
          tagBackgroundColor: colors.surfaceAlt,
          tagForegroundColor: colors.textSecondary,
          amountGradientColors: <Color>[
            colors.textSecondary,
            colors.heroMiddle,
          ],
        );
      case 7: // 募集完成
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.brandPrimaryDark, colors.primary],
          tagBackgroundColor: openTagBackgroundColor,
          tagForegroundColor: openTagForegroundColor,
          amountGradientColors: <Color>[colors.primaryAlt, colors.primary],
        );
      case 2: // 募集失败
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.dangerForeground, colors.danger],
          tagBackgroundColor: colors.dangerSubtle,
          tagForegroundColor: colors.dangerForeground,
          amountGradientColors: <Color>[colors.dangerForeground, colors.danger],
        );
      default:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
          tagBackgroundColor: colors.surfaceAlt,
          tagForegroundColor: colors.textSecondary,
          amountGradientColors: <Color>[
            colors.textSecondary,
            colors.heroMiddle,
          ],
        );
    }
  }

  String _resolveMethodLabel(BuildContext context, String? gainType) {
    return resolveFundProjectGainTypeLabel(context, gainType);
  }

  String _resolveAmountBannerText(
    BuildContext context,
    FundProject project,
    NumberFormat currencyFormatter,
  ) {
    final l10n = context.l10n;
    if (project.projectStatus == 0) {
      final openDate =
          _parseDateTime(project.offeringStartDatetime) ??
          _parseDateTime(project.scheduledStartDate);
      if (openDate != null) {
        final text = _formatDateForLocale(
          openDate,
          Localizations.localeOf(context),
        );
        return l10n.fundListOpenStartAt(text);
      }
    }

    final amount = _formatCurrency(
      project.currentlySubscribed,
      currencyFormatter,
    );
    final progress = _formatProgressPercent(project.achievementRate);
    return l10n.fundListAppliedAmount(amount, progress);
  }

  String _resolveVolumeLabel(BuildContext context, FundProject project) {
    final numberText = project.times?.toString() ?? '--';
    return context.l10n.fundListVolume(numberText);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final appText = context.appTextTheme;
    final locale = Localizations.localeOf(context);
    final currencyFormatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final favoriteAddedMessage = l10n.favoriteAddedToast;
    final favoriteRemovedMessage = l10n.favoriteRemovedToast;
    final favoriteProjectIds = ref.watch(
      fundProjectFavoritesControllerProvider,
    );

    final asyncProjects = ref.watch(fundProjectListProvider);
    final filterOptions = _buildFilterOptions(context);

    return MainShellTabRefreshScope(
      tabIndex: 1,
      onRefresh: _refreshInvestmentTab,
      child: Container(
        key: const Key('investment_tab_content'),
        color: colors.background,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: colors.surface,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.fundListTitle,
                    style: appText.pageTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppFilterBar<_FundListFilter>(
                    padding: EdgeInsets.zero,
                    value: _effectiveSelectedFilter,
                    onChanged: (_FundListFilter value) {
                      setState(() {
                        _selectedFilter = value;
                      });
                    },
                    items: filterOptions
                        .map(
                          (_FundListFilterOption option) =>
                              AppFilterBarItem<_FundListFilter>(
                                value: option.filter,
                                label: option.label,
                                style: option.style,
                                leadingIcon: option.leadingIcon,
                              ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: colors.border),
            Expanded(
              child: asyncProjects.when(
                skipError: true,
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (Object error, StackTrace stackTrace) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            l10n.fundListLoadError,
                            textAlign: TextAlign.center,
                            style: appText.bodyMuted.copyWith(
                              color: colors.textSecondary,
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
                  );
                },
                data: (List<FundProject> projects) {
                  final visibleProjects = _applyFilter(
                    projects,
                    favoriteProjectIds,
                  );
                  if (visibleProjects.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshProjects,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                            child: Text(
                              l10n.fundListEmpty,
                              textAlign: TextAlign.center,
                              style: appText.bodyMuted.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshProjects,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                      itemCount: visibleProjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (BuildContext context, int index) {
                        final project = visibleProjects[index];
                        final projectId = project.id.trim();
                        final palette = _resolveStatusPalette(
                          context,
                          project.projectStatus,
                        );
                        final statusLabel = _resolveStatusLabel(
                          context,
                          project.projectStatus,
                        );
                        final gainType = _resolveMethodLabel(
                          context,
                          project.gainType,
                        );
                        final minimumInvestmentText =
                            _resolveMinimumInvestmentText(
                              context,
                              project,
                              locale,
                            );
                        final periodText =
                            (project.investmentPeriod?.trim().isNotEmpty ??
                                false)
                            ? project.investmentPeriod!.trim()
                            : '--';

                        return _FundProjectCard(
                          project: project,
                          isFavorite: favoriteProjectIds.contains(projectId),
                          palette: palette,
                          statusLabel: statusLabel,
                          methodLabel: project.offeringMethod ?? '--',
                          gainTypeLabel: gainType,
                          yieldLabel: l10n.fundListYieldLabel,
                          periodLabel: l10n.fundListPeriodLabel,
                          methodTitleLabel: l10n.fundListMethodLabel,
                          appliedAmountText: _resolveAmountBannerText(
                            context,
                            project,
                            currencyFormatter,
                          ),
                          annualYieldText: resolveFundProjectYieldDisplay(
                            project,
                          ),
                          periodValueText: periodText,
                          minimumInvestmentLabel:
                              l10n.fundDetailMinimumInvestmentLabel,
                          minimumInvestmentText: minimumInvestmentText,
                          locationText: _resolveLocationHint(project),
                          viewDetailText: l10n.fundListViewDetail,
                          volumeText: _resolveVolumeLabel(context, project),
                          onFavoriteTap: () {
                            ref
                                .read(
                                  fundProjectFavoritesControllerProvider
                                      .notifier,
                                )
                                .toggleFavorite(projectId);
                          },
                          favoriteAddedMessage: favoriteAddedMessage,
                          favoriteRemovedMessage: favoriteRemovedMessage,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _refreshInvestmentTab(WidgetRef ref) async {
  if (shouldSkipAppNetworkRefresh(ref)) {
    return;
  }
  ref.invalidate(fundProjectListProvider);
  await ref.refresh(fundProjectListProvider.future).then((_) {});
}

class _FundProjectCard extends StatelessWidget {
  const _FundProjectCard({
    required this.project,
    required this.isFavorite,
    required this.palette,
    required this.statusLabel,
    required this.methodLabel,
    required this.gainTypeLabel,
    required this.yieldLabel,
    required this.periodLabel,
    required this.methodTitleLabel,
    required this.appliedAmountText,
    required this.annualYieldText,
    required this.periodValueText,
    required this.minimumInvestmentLabel,
    required this.minimumInvestmentText,
    required this.locationText,
    required this.viewDetailText,
    required this.volumeText,
    required this.onFavoriteTap,
    required this.favoriteAddedMessage,
    required this.favoriteRemovedMessage,
  });

  final FundProject project;
  final bool isFavorite;
  final _FundStatusPalette palette;
  final String statusLabel;
  final String methodLabel;
  final String gainTypeLabel;
  final String yieldLabel;
  final String periodLabel;
  final String methodTitleLabel;
  final String appliedAmountText;
  final String annualYieldText;
  final String periodValueText;
  final String minimumInvestmentLabel;
  final String minimumInvestmentText;
  final String locationText;
  final String viewDetailText;
  final String volumeText;
  final VoidCallback onFavoriteTap;
  final String favoriteAddedMessage;
  final String favoriteRemovedMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final achievementPalette = _resolveAchievementBarPalette(
      colors: colors,
      achievementRate: project.achievementRate,
    );
    final cardRadius = BorderRadius.circular(UiTokens.radius16);

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: cardRadius,
            side: BorderSide(color: colors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: cardRadius,
            onTap: () => context.push('/funds/${project.id}'),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 160,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      FundHeroMediaBackground(
                        gradientColors: palette.heroGradientColors,
                        imageUrls: project.photos,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(UiTokens.radius16),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.transparent,
                                colors.scrim.withValues(alpha: 0.56),
                              ],
                              stops: const <double>[0.25, 1],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: FundFavoriteButton(
                          selected: isFavorite,
                          onTap: onFavoriteTap,
                          selectedToastMessage: favoriteAddedMessage,
                          unselectedToastMessage: favoriteRemovedMessage,
                        ),
                      ),

                      Positioned(
                        left: 10,
                        top: 12,
                        child: _PillTag(
                          label: statusLabel,
                          backgroundColor: palette.tagBackgroundColor,
                          foregroundColor: palette.tagForegroundColor,
                        ),
                      ),

                      // Positioned(
                      //   right: 10,
                      //   top: 10,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 8,
                      //       vertical: 3,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: heroGlassColor,
                      //       borderRadius: BorderRadius.circular(6),
                      //       border: Border.all(color: heroGlassBorderColor),
                      //     ),
                      //     child: Text(
                      //       volumeText,
                      //       style: appText.chip.copyWith(
                      //         color: heroGlassSecondaryTextColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              project.projectName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: appText.cardTitle.copyWith(
                                color: colors.onDark.withValues(
                                  alpha: isDark ? 0.94 : 1,
                                ),
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                height: 1.25,
                                shadows: <Shadow>[
                                  Shadow(
                                    color: colors.scrim.withValues(
                                      alpha: isDark ? 0.52 : 0.35,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Wrap(
                            //   spacing: 6,
                            //   runSpacing: 6,
                            //   children: <Widget>[
                            //     _HeroInfoBubble(
                            //       label: yieldLabel,
                            //       value: annualYieldText,
                            //       backgroundColor: heroGlassColor,
                            //       borderColor: heroGlassBorderColor,
                            //       labelColor: heroGlassSecondaryTextColor,
                            //       valueColor: heroGlassPrimaryTextColor,
                            //     ),
                            //     _HeroInfoBubble(
                            //       label: periodLabel,
                            //       value: periodValueText,
                            //       backgroundColor: heroGlassColor,
                            //       borderColor: heroGlassBorderColor,
                            //       labelColor: heroGlassSecondaryTextColor,
                            //       valueColor: heroGlassPrimaryTextColor,
                            //     ),
                            //     _HeroInfoBubble(
                            //       label: methodTitleLabel,
                            //       value: methodLabel,
                            //       backgroundColor: heroGlassColor,
                            //       borderColor: heroGlassBorderColor,
                            //       labelColor: heroGlassSecondaryTextColor,
                            //       valueColor: heroGlassPrimaryTextColor,
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: <Widget>[
                          _PillTag(
                            label: methodLabel,
                            backgroundColor: colors.primary,
                            foregroundColor: colors.infoSubtle,
                          ),
                          _PillTag(
                            label: gainTypeLabel,
                            backgroundColor: colors.communitySecondary
                                .withValues(alpha: 0.24),
                            foregroundColor: colors.textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: UiTokens.spacing8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: achievementPalette.gradientColors,
                          ),
                          border: Border.all(
                            color: achievementPalette.borderColor,
                          ),
                        ),
                        child: Text(
                          appliedAmountText,
                          textAlign: TextAlign.center,
                          style: appText.button.copyWith(
                            color: achievementPalette.foregroundColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: UiTokens.spacing8),
                      Container(
                        padding: const EdgeInsets.only(top: UiTokens.spacing8),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: colors.border)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _CardStatCell(
                                label: yieldLabel,
                                value: annualYieldText,
                                valueColor: colors.highlightGold,
                                useNumericValueStyle: true,
                              ),
                            ),
                            SizedBox(
                              height: 36,
                              child: VerticalDivider(
                                width: 16,
                                thickness: 1,
                                color: colors.border,
                              ),
                            ),
                            Expanded(
                              child: _CardStatCell(
                                label: periodLabel,
                                value: periodValueText,
                              ),
                            ),
                            SizedBox(
                              height: 36,
                              child: VerticalDivider(
                                width: 16,
                                thickness: 1,
                                color: colors.border,
                              ),
                            ),
                            Expanded(
                              child: _CardStatCell(
                                label: minimumInvestmentLabel,
                                value: minimumInvestmentText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              locationText,
                              style: appText.meta.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                          ),
                          Text(
                            viewDetailText,
                            style: appText.link.copyWith(color: colors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AchievementBarPalette {
  const _AchievementBarPalette({
    required this.gradientColors,
    required this.foregroundColor,
    required this.borderColor,
  });

  final List<Color> gradientColors;
  final Color foregroundColor;
  final Color borderColor;
}

_AchievementBarPalette _resolveAchievementBarPalette({
  required AppSemanticColorTheme colors,
  required double? achievementRate,
}) {
  final normalizedValue = (achievementRate ?? 0).clamp(0, 1).toDouble();
  if (normalizedValue <= 0) {
    return _AchievementBarPalette(
      gradientColors: const <Color>[Colors.transparent, Colors.transparent],
      foregroundColor: colors.textPrimary,
      borderColor: colors.border,
    );
  }

  final trackColor = colors.surfaceAlt;
  final visibility =
      0.36 + (0.64 * Curves.easeOutCubic.transform(normalizedValue));
  final blueShift = _resolveAchievementBlueShift(normalizedValue);
  final shiftedGradientColors = <Color>[
    Color.lerp(colors.primary, colors.brandPrimaryDark, blueShift * 0.58) ??
        colors.brandPrimaryDark,
    Color.lerp(colors.primaryAlt, colors.primary, blueShift) ?? colors.primary,
  ];
  final effectiveGradientColors = shiftedGradientColors
      .map((Color color) => Color.lerp(trackColor, color, visibility) ?? color)
      .toList(growable: false);
  final foregroundColor = normalizedValue >= 0.15
      ? colors.onDark
      : colors.textPrimary;
  final borderColor =
      Color.lerp(colors.border, effectiveGradientColors.last, 0.42) ??
      colors.border;

  return _AchievementBarPalette(
    gradientColors: effectiveGradientColors,
    foregroundColor: foregroundColor,
    borderColor: borderColor,
  );
}

double _resolveAchievementBlueShift(double normalizedValue) {
  if (normalizedValue <= 0.20) {
    return 0.00;
  }
  if (normalizedValue <= 0.40) {
    return _lerpAchievementWindow(normalizedValue, 0.20, 0.40, 0.00, 0.22);
  }
  if (normalizedValue <= 0.60) {
    return _lerpAchievementWindow(normalizedValue, 0.40, 0.60, 0.22, 0.46);
  }
  if (normalizedValue <= 0.80) {
    return _lerpAchievementWindow(normalizedValue, 0.60, 0.80, 0.46, 0.72);
  }
  return _lerpAchievementWindow(normalizedValue, 0.80, 1.00, 0.72, 0.96);
}

double _lerpAchievementWindow(
  double value,
  double start,
  double end,
  double startOutput,
  double endOutput,
) {
  final t = ((value - start) / (end - start)).clamp(0, 1).toDouble();
  return startOutput + ((endOutput - startOutput) * t);
}

class _PillTag extends StatelessWidget {
  const _PillTag({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Text(
          label,
          style: context.appTextTheme.micro.copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}

class _CardStatCell extends StatelessWidget {
  const _CardStatCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.useNumericValueStyle = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool useNumericValueStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appText = context.appTextTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: appText.meta.copyWith(color: colors.textTertiary)),
        const SizedBox(height: 2),
        Text(
          value,
          style:
              (useNumericValueStyle
                      ? appText.sectionTitle
                      : appText.sectionTitle)
                  .copyWith(color: valueColor ?? colors.textPrimary),
        ),
      ],
    );
  }
}
