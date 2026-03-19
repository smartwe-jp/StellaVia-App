import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_providers.dart';

enum _FundListFilter {
  all,
  operating,
  operatingEnded,
  opening,
  upcoming,
  recruitmentClosed,
  recruitmentCompleted,
  recruitmentFailed,
}

extension on _FundListFilter {
  int? get projectStatusCode {
    switch (this) {
      case _FundListFilter.all:
        return null;
      case _FundListFilter.operating:
        return 4;
      case _FundListFilter.operatingEnded:
        return 5;
      case _FundListFilter.opening:
        return 1;
      case _FundListFilter.upcoming:
        return 0;
      case _FundListFilter.recruitmentClosed:
        return 3;
      case _FundListFilter.recruitmentCompleted:
        return 7;
      case _FundListFilter.recruitmentFailed:
        return 2;
    }
  }
}

class _FundListFilterOption {
  const _FundListFilterOption({required this.filter, required this.label});

  final _FundListFilter filter;
  final String label;
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
  final Set<String> _favoriteIds = <String>{};

  List<_FundListFilterOption> _buildFilterOptions(BuildContext context) {
    final l10n = context.l10n;
    return <_FundListFilterOption>[
      _FundListFilterOption(
        filter: _FundListFilter.all,
        label: l10n.fundListFilterAll,
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
        filter: _FundListFilter.opening,
        label: l10n.fundListFilterOpen,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.upcoming,
        label: l10n.fundListFilterUpcoming,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.recruitmentClosed,
        label: l10n.fundListFilterClosed,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.recruitmentCompleted,
        label: l10n.fundListFilterCompleted,
      ),
      _FundListFilterOption(
        filter: _FundListFilter.recruitmentFailed,
        label: l10n.fundListFilterFailed,
      ),
    ];
  }

  Future<void> _refreshProjects() async {
    ref.invalidate(fundProjectListProvider);
    await ref.read(fundProjectListProvider.future);
  }

  List<FundProject> _applyFilter(List<FundProject> projects) {
    final statusCode = _selectedFilter.projectStatusCode;
    if (statusCode == null) {
      return projects;
    }
    return projects
        .where((FundProject project) => project.projectStatus == statusCode)
        .toList(growable: false);
  }

  void _toggleFavorite(String projectId) {
    setState(() {
      if (_favoriteIds.contains(projectId)) {
        _favoriteIds.remove(projectId);
      } else {
        _favoriteIds.add(projectId);
      }
    });
  }

  String _formatCurrency(int? amount, NumberFormat formatter) {
    if (amount == null) {
      return '-';
    }
    return formatter.format(amount);
  }

  String _formatYieldPercent(double? ratio) {
    if (ratio == null) {
      return '--';
    }
    final percentage = ratio > 1 ? ratio : ratio * 100;
    final hasFraction = percentage % 1 != 0;
    return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
  }

  String _formatProgressPercent(double? ratio) {
    if (ratio == null) {
      return '--';
    }
    final percentage = ratio > 1 ? ratio : ratio * 100;
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
    final name = project.projectName.trim();
    if (name.contains(' ')) {
      return name.split(' ').first;
    }
    if (name.contains('　')) {
      return name.split('　').first;
    }
    final company = project.operatingCompany?.trim();
    if (company != null && company.isNotEmpty) {
      return company;
    }
    return '-';
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

  _FundStatusPalette _resolveStatusPalette(BuildContext context, int? status) {
    final colors = context.appColors;
    switch (status) {
      case 4:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.infoForeground, colors.primary],
          tagBackgroundColor: colors.infoSubtle,
          tagForegroundColor: colors.infoForeground,
          amountGradientColors: <Color>[colors.info, colors.primaryAlt],
        );
      case 5:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
          tagBackgroundColor: colors.surfaceAlt,
          tagForegroundColor: colors.textSecondary,
          amountGradientColors: <Color>[
            colors.textSecondary,
            colors.heroMiddle,
          ],
        );
      case 1:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.successForeground, colors.success],
          tagBackgroundColor: colors.successSubtle,
          tagForegroundColor: colors.successForeground,
          amountGradientColors: <Color>[
            colors.success,
            colors.successForeground,
          ],
        );
      case 0:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.warningForeground, colors.warning],
          tagBackgroundColor: colors.warningSubtle,
          tagForegroundColor: colors.warningForeground,
          amountGradientColors: <Color>[colors.warningAction, colors.warning],
        );
      case 3:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
          tagBackgroundColor: colors.surfaceAlt,
          tagForegroundColor: colors.textSecondary,
          amountGradientColors: <Color>[
            colors.textSecondary,
            colors.heroMiddle,
          ],
        );
      case 7:
        return _FundStatusPalette(
          heroGradientColors: <Color>[colors.successForeground, colors.success],
          tagBackgroundColor: colors.successSubtle,
          tagForegroundColor: colors.successForeground,
          amountGradientColors: <Color>[
            colors.successForeground,
            colors.success,
          ],
        );
      case 2:
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

    final asyncProjects = ref.watch(fundProjectListProvider);
    final filterOptions = _buildFilterOptions(context);

    return Container(
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
                  style: appText.pageTitle.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filterOptions
                        .map(
                          (_FundListFilterOption option) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _FilterChip(
                              label: option.label,
                              selected: option.filter == _selectedFilter,
                              onTap: () {
                                setState(() {
                                  _selectedFilter = option.filter;
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: colors.border),
          Expanded(
            child: asyncProjects.when(
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
                final visibleProjects = _applyFilter(projects);
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
                      final palette = _resolveStatusPalette(
                        context,
                        project.projectStatus,
                      );
                      final statusLabel = _resolveStatusLabel(
                        context,
                        project.projectStatus,
                      );
                      final methodLabel = _resolveMethodLabel(
                        context,
                        project.offeringMethod,
                      );
                      final periodText =
                          (project.investmentPeriod?.trim().isNotEmpty ?? false)
                          ? project.investmentPeriod!.trim()
                          : '--';

                      return _FundProjectCard(
                        project: project,
                        isFavorite: _favoriteIds.contains(project.id),
                        palette: palette,
                        statusLabel: statusLabel,
                        methodLabel: methodLabel,
                        yieldLabel: l10n.fundListYieldLabel,
                        periodLabel: l10n.fundListPeriodLabel,
                        methodTitleLabel: l10n.fundListMethodLabel,
                        appliedAmountText: _resolveAmountBannerText(
                          context,
                          project,
                          currencyFormatter,
                        ),
                        annualYieldText: _formatYieldPercent(
                          project.expectedDistributionRatioMax ??
                              project.expectedDistributionRatioMin,
                        ),
                        periodValueText: periodText,
                        locationText: _resolveLocationHint(project),
                        viewDetailText: l10n.fundListViewDetail,
                        volumeText: _resolveVolumeLabel(context, project),
                        onFavoriteTap: () => _toggleFavorite(project.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: 1.5,
            ),
            color: selected ? colors.primary : colors.surface,
          ),
          child: Text(
            label,
            style: appText.chip.copyWith(
              color: selected ? colors.brandWhite : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FundProjectCard extends StatelessWidget {
  const _FundProjectCard({
    required this.project,
    required this.isFavorite,
    required this.palette,
    required this.statusLabel,
    required this.methodLabel,
    required this.yieldLabel,
    required this.periodLabel,
    required this.methodTitleLabel,
    required this.appliedAmountText,
    required this.annualYieldText,
    required this.periodValueText,
    required this.locationText,
    required this.viewDetailText,
    required this.volumeText,
    required this.onFavoriteTap,
  });

  final FundProject project;
  final bool isFavorite;
  final _FundStatusPalette palette;
  final String statusLabel;
  final String methodLabel;
  final String yieldLabel;
  final String periodLabel;
  final String methodTitleLabel;
  final String appliedAmountText;
  final String annualYieldText;
  final String periodValueText;
  final String locationText;
  final String viewDetailText;
  final String volumeText;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardRadius = BorderRadius.circular(UiTokens.radius16);
    final heroGlassColor = _resolveHeroGlassSurfaceColor(theme);
    final heroGlassBorderColor = _resolveHeroGlassBorderColor(theme);
    final heroGlassPrimaryTextColor = _resolveHeroGlassPrimaryTextColor(theme);
    final heroGlassSecondaryTextColor = _resolveHeroGlassSecondaryTextColor(
      theme,
    );

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
                        left: 10,
                        top: 10,
                        child: _FavoriteButton(
                          selected: isFavorite,
                          onTap: onFavoriteTap,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: heroGlassColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: heroGlassBorderColor),
                          ),
                          child: Text(
                            volumeText,
                            style: appText.chip.copyWith(
                              color: heroGlassSecondaryTextColor,
                            ),
                          ),
                        ),
                      ),
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
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: <Widget>[
                                _HeroInfoBubble(
                                  label: yieldLabel,
                                  value: annualYieldText,
                                  backgroundColor: heroGlassColor,
                                  borderColor: heroGlassBorderColor,
                                  labelColor: heroGlassSecondaryTextColor,
                                  valueColor: heroGlassPrimaryTextColor,
                                ),
                                _HeroInfoBubble(
                                  label: periodLabel,
                                  value: periodValueText,
                                  backgroundColor: heroGlassColor,
                                  borderColor: heroGlassBorderColor,
                                  labelColor: heroGlassSecondaryTextColor,
                                  valueColor: heroGlassPrimaryTextColor,
                                ),
                                _HeroInfoBubble(
                                  label: methodTitleLabel,
                                  value: methodLabel,
                                  backgroundColor: heroGlassColor,
                                  borderColor: heroGlassBorderColor,
                                  labelColor: heroGlassSecondaryTextColor,
                                  valueColor: heroGlassPrimaryTextColor,
                                ),
                              ],
                            ),
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
                            label: statusLabel,
                            backgroundColor: palette.tagBackgroundColor,
                            foregroundColor: palette.tagForegroundColor,
                          ),
                          _PillTag(
                            label: methodLabel,
                            backgroundColor: colors.communitySecondary
                                .withValues(alpha: 0.14),
                            foregroundColor: colors.communitySecondary,
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
                            colors: palette.amountGradientColors,
                          ),
                        ),
                        child: Text(
                          appliedAmountText,
                          textAlign: TextAlign.center,
                          style: appText.button.copyWith(
                            color: colors.brandWhite,
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
                                valueColor: colors.danger,
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

Color _resolveHeroGlassSurfaceColor(ThemeData theme) {
  final colors = theme.appColors;
  final authTheme = theme.extension<AppAuthVisualTheme>();
  final isDark = theme.brightness == Brightness.dark;

  return authTheme?.glassSurfaceColor ??
      colors.surface.withValues(alpha: isDark ? 0.66 : 0.82);
}

Color _resolveHeroGlassBorderColor(ThemeData theme) {
  final authTheme = theme.extension<AppAuthVisualTheme>();
  final colors = theme.appColors;
  final isDark = theme.brightness == Brightness.dark;

  return authTheme?.glassBorderColor ??
      colors.onDark.withValues(alpha: isDark ? 0.16 : 0.10);
}

Color _resolveHeroGlassPrimaryTextColor(ThemeData theme) {
  final colors = theme.appColors;
  final isDark = theme.brightness == Brightness.dark;
  return isDark ? colors.onDark : colors.textPrimary;
}

Color _resolveHeroGlassSecondaryTextColor(ThemeData theme) {
  final colors = theme.appColors;
  final isDark = theme.brightness == Brightness.dark;
  return isDark ? colors.onDark.withValues(alpha: 0.76) : colors.textSecondary;
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: selected
          ? colors.danger.withValues(alpha: isDark ? 0.26 : 0.16)
          : _resolveHeroGlassSurfaceColor(theme),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 18,
            color: selected
                ? colors.onDark
                : _resolveHeroGlassSecondaryTextColor(theme),
          ),
        ),
      ),
    );
  }
}

class _HeroInfoBubble extends StatelessWidget {
  const _HeroInfoBubble({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.borderColor,
    required this.labelColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color backgroundColor;
  final Color borderColor;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: appText.micro.copyWith(color: labelColor, height: 1.1),
          ),
          Text(
            value,
            style: appText.bodyStrong.copyWith(color: valueColor, height: 1.1),
          ),
        ],
      ),
    );
  }
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: context.appTextTheme.micro.copyWith(color: foregroundColor),
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
              (useNumericValueStyle ? appText.numericBody : appText.bodyStrong)
                  .copyWith(color: valueColor ?? colors.textPrimary),
        ),
      ],
    );
  }
}
