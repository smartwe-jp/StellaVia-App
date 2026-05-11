import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../settings/presentation/providers/settings_content_providers.dart';
import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_favorite_providers.dart';
import '../providers/fund_project_providers.dart';
import '../support/fund_detail_static_content.dart';
import '../support/fund_project_gain_type_label.dart';
import '../support/fund_project_detail_structured_data.dart';
import '../support/fund_project_detail_view_data.dart';
import '../widgets/fund_project_detail_comments_section.dart';
import '../widgets/fund_project_detail_documents_section.dart';
import '../widgets/fund_project_detail_scaffold.dart';
import '../widgets/fund_project_detail_tabs_section.dart';
import '../widgets/fund_project_detail_title_block.dart';
import '../widgets/fund_project_detail_video_player.dart';
import '../widgets/fund_project_detail_yield_highlight_card.dart';

class FundProjectDetailPage extends ConsumerStatefulWidget {
  const FundProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  ConsumerState<FundProjectDetailPage> createState() =>
      _FundProjectDetailPageState();
}

class _FundProjectDetailPageState extends ConsumerState<FundProjectDetailPage> {
  int _selectedDetailTabIndex = 0;
  final GlobalKey _gainTypeDescriptionSectionKey = GlobalKey();
  bool _didRequestInitialRefresh = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRequestInitialRefresh) {
      return;
    }
    _didRequestInitialRefresh = true;
    _refreshInitialDetailData();
  }

  void _refreshInitialDetailData() {
    final projectId = widget.projectId;
    ref.invalidate(fundProjectDetailProvider(projectId));
    ref.invalidate(fundProjectApplyDetailProvider(projectId));
  }

  Future<void> _showFundApplyVerificationRequiredDialog() {
    final l10n = context.l10n;
    return AppDialogs.showAdaptiveAlert<void>(
      context: context,
      title: l10n.fundApplyVerificationRequiredTitle,
      message: l10n.fundApplyVerificationRequiredMessage,
      actions: <AppDialogAction<void>>[
        AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
      ],
    );
  }

  Future<void> _handleLotteryApplyTap(
    String projectId, {
    required bool isAuthenticated,
  }) async {
    if (!isAuthenticated) {
      context.push('/login');
      return;
    }
    var isFundApplyVerified = false;
    try {
      await refreshMemberProfileVerificationState(ref);
      isFundApplyVerified = await ref.read(isFundApplyVerifiedProvider.future);
    } catch (_) {
      isFundApplyVerified = false;
    }
    if (!mounted) {
      return;
    }
    if (!isFundApplyVerified) {
      await _showFundApplyVerificationRequiredDialog();
      return;
    }
    context.push('/funds/$projectId/lottery-apply');
  }

  Future<void> _openImageViewer(
    BuildContext context,
    List<String> imageUrls,
    int initialIndex,
  ) {
    return openAppImageViewer(
      context,
      initialIndex: initialIndex,
      items: imageUrls
          .map((String url) => AppImageViewerItem(source: url))
          .toList(growable: false),
      texts: AppImageViewerTexts(
        loadingLabel: context.l10n.imageViewerLoadingLabel,
        loadFailedLabel: context.l10n.imageViewerLoadFailedLabel,
        retryLabel: context.l10n.imageViewerRetryLabel,
        invalidSourceNotice: context.l10n.imageViewerInvalidSourceNotice,
        closeTooltip: context.l10n.imageViewerCloseTooltip,
      ),
    );
  }

  Future<void> _scrollToGainTypeDescription() async {
    final targetContext = _gainTypeDescriptionSectionKey.currentContext;
    if (targetContext == null) {
      return;
    }
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectId = widget.projectId;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final detailAsync = ref.watch(fundProjectDetailProvider(projectId));
    final applyDetailAsync = ref.watch(
      fundProjectApplyDetailProvider(projectId),
    );
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final favoriteProjectIds = ref.watch(
      fundProjectFavoritesControllerProvider,
    );
    final favoriteAddedMessage = context.l10n.favoriteAddedToast;
    final favoriteRemovedMessage = context.l10n.favoriteRemovedToast;

    return detailAsync.when(
      loading: () => const FundProjectDetailScaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (Object error, StackTrace stackTrace) => FundProjectDetailScaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  context.l10n.fundListLoadError,
                  textAlign: TextAlign.center,
                  style: appText.bodyMuted.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing12),
                OutlinedButton(
                  onPressed: () {
                    ref.invalidate(fundProjectDetailProvider(projectId));
                    ref.invalidate(fundProjectApplyDetailProvider(projectId));
                  },
                  child: Text(context.l10n.fundListRetry),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (FundProject project) {
        if (applyDetailAsync.isLoading) {
          return const FundProjectDetailScaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (applyDetailAsync.hasError || !applyDetailAsync.hasValue) {
          return FundProjectDetailScaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      context.l10n.fundListLoadError,
                      textAlign: TextAlign.center,
                      style: appText.bodyMuted.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing12),
                    OutlinedButton(
                      onPressed: () {
                        ref.invalidate(fundProjectDetailProvider(projectId));
                        ref.invalidate(
                          fundProjectApplyDetailProvider(projectId),
                        );
                      },
                      child: Text(context.l10n.fundListRetry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final favoriteProjectId = project.id.trim().isEmpty
            ? projectId.trim()
            : project.id.trim();
        final isFavorite = favoriteProjectIds.contains(favoriteProjectId);
        final normalizedPhotoUrls = project.photos
            .map((String url) => url.trim())
            .where((String url) => url.isNotEmpty)
            .toList(growable: false);
        final locale = Localizations.localeOf(context);
        final int? discussionProjectId = int.tryParse(projectId);
        final staticContentAsync = ref.watch(
          fundDetailStaticContentProvider(locale.toLanguageTag()),
        );
        final operatingCompanyContentAsync = ref.watch(
          settingsOperatingCompanyContentProvider(locale.toLanguageTag()),
        );
        final staticContent = staticContentAsync.asData?.value;
        final operatingCompanyContent =
            operatingCompanyContentAsync.asData?.value;
        final structuredDetail = FundProjectDetailStructuredData.fromMap(
          project.detailData,
        );
        final viewData = FundProjectDetailViewDataBuilder.build(
          context: context,
          project: project,
          operatingCompanyContent: operatingCompanyContent,
        );
        final gainTypeLabel = resolveFundProjectGainTypeLabel(
          context,
          project.gainType,
        );
        final hasGainType = (project.gainType?.trim().isNotEmpty ?? false);
        final subordinatedRatio = _normalizeFundDetailText(
          project.subordinatedRatio,
        );
        final gainTypeExplanationItems = _buildGainTypeExplanationItems(
          context,
        );
        final infoItems = <FundDetailInfoItemData>[
          ...viewData.infoItems,
          if (subordinatedRatio != null)
            FundDetailInfoItemData(
              label: context.l10n.fundDetailSubordinatedRatioLabel,
              value: subordinatedRatio,
            ),
          if (hasGainType)
            FundDetailInfoItemData(
              label: context.l10n.fundDetailGainTypeTitle,
              value: gainTypeLabel,
              onTap: _scrollToGainTypeDescription,
            ),
        ];
        final descriptionText = _normalizeFundDetailText(project.description);
        final featuresText = _normalizeFundDetailText(project.features);
        final videoLink = _normalizeFundVideoLink(project.videoLink);
        final isDirectPlayableVideoLink =
            videoLink != null && isFundProjectDirectPlayableVideoUrl(videoLink);
        final isYoutubeVideoLink =
            videoLink != null && isFundProjectYoutubeVideoUrl(videoLink);

        return FundProjectDetailScaffold(
          actionBar: FundDetailStickyActionBar(
            label: viewData.actionLabel,
            enabled: viewData.actionEnabled,
            onTap: () => _handleLotteryApplyTap(
              projectId,
              isAuthenticated: isAuthenticated,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              FundDetailHeroHeader(
                gradientColors: viewData.heroGradientColors,
                badges: viewData.heroBadges,
                imageUrls: normalizedPhotoUrls,
                onImageTap: (int index) =>
                    _openImageViewer(context, normalizedPhotoUrls, index),
                onBackTap: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/funds');
                },
                isFavorite: isFavorite,
                onFavoriteTap: () {
                  ref
                      .read(fundProjectFavoritesControllerProvider.notifier)
                      .toggleFavorite(favoriteProjectId);
                },
                favoriteAddedMessage: favoriteAddedMessage,
                favoriteRemovedMessage: favoriteRemovedMessage,
              ),
              Container(
                color: colors.surface,
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FundProjectDetailTitleBlock(project: project),
                          if (featuresText != null) ...<Widget>[
                            const SizedBox(height: UiTokens.spacing16),
                            FundDetailContentCard(
                              child: Text(
                                featuresText,
                                style: appText.bodySemi.copyWith(
                                  color: colors.highlightGold,
                                  height: 1.7,
                                ),
                              ),
                            ),
                          ],

                          if (descriptionText != null) ...<Widget>[
                            const SizedBox(height: UiTokens.spacing12),
                            FundDetailDisclosureList(
                              items: <FundDetailDisclosureItemData>[
                                FundDetailDisclosureItemData(
                                  title: context
                                      .l10n
                                      .fundDetailProductSummaryTitle,
                                  body: descriptionText,
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: UiTokens.spacing12),
                          FundProjectDetailYieldHighlightCard(
                            label: context
                                .l10n
                                .fundDetailPlannedDistributionRateLabel,
                            value: viewData.yieldDisplay,
                            disclaimer: context.l10n.fundDetailYieldDisclaimer,
                          ),
                        ],
                      ),
                    ),
                    if (infoItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      FundDetailSection(
                        title: context.l10n.fundDetailKeyFactsTitle,
                        child: FundDetailInfoTable(items: infoItems),
                      ),
                    ],
                    if (viewData.distributionItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      FundDetailSection(
                        title: context.l10n.fundDetailDistributionInfoTitle,
                        child: FundDetailInfoTable(
                          items: viewData.distributionItems,
                          columns: 1,
                        ),
                      ),
                    ],
                    if (viewData.contractScheduleItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      FundDetailSection(
                        title: context.l10n.fundDetailScheduleTitle,
                        child: FundDetailInfoTable(
                          items: viewData.contractScheduleItems,
                        ),
                      ),
                    ],
                    if (project.achievementRate != null) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _FundDetailAchievementBanner(
                          label: context.l10n.fundDetailAchievementRateLabel,
                          value: _formatAchievementRate(
                            project.achievementRate,
                          ),
                          achievementRate: project.achievementRate,
                        ),
                      ),
                    ],
                    if (videoLink != null) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      if (isDirectPlayableVideoLink)
                        FundDetailSection(
                          title: context.l10n.fundDetailReferenceVideoTitle,
                          child: FundProjectDetailVideoPlayer(
                            videoUrl: videoLink,
                          ),
                        )
                      else if (isYoutubeVideoLink)
                        FundDetailSection(
                          title: context.l10n.fundDetailReferenceVideoTitle,
                          child: FundProjectDetailYoutubePlayer(
                            videoUrl: videoLink,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: FundProjectDetailExternalVideoLinkRow(
                            videoUrl: videoLink,
                          ),
                        ),
                    ],
                    const SizedBox(height: UiTokens.spacing16),
                    FundProjectDetailTabsSection(
                      selectedIndex: _selectedDetailTabIndex,
                      onTabChanged: (int index) {
                        if (_selectedDetailTabIndex == index) {
                          return;
                        }
                        setState(() {
                          _selectedDetailTabIndex = index;
                        });
                      },
                      structuredData: structuredDetail,
                      emptyPlaceholder: FundDetailInfoTable(
                        items: viewData.propertyItems,
                      ),
                    ),
                    if (staticContent != null) ...<Widget>[
                      const SizedBox(height: 18),
                      if (hasGainType) ...<Widget>[
                        KeyedSubtree(
                          key: _gainTypeDescriptionSectionKey,
                          child: FundDetailSection(
                            title:
                                context.l10n.fundDetailGainTypeDescriptionTitle,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (
                                  var index = 0;
                                  index < gainTypeExplanationItems.length;
                                  index++
                                ) ...<Widget>[
                                  _FundDetailGainTypeExplanationCard(
                                    item: gainTypeExplanationItems[index],
                                  ),
                                  if (index <
                                      gainTypeExplanationItems.length - 1)
                                    const SizedBox(height: UiTokens.spacing8),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                      FundDetailSection(
                        title: staticContent.riskSection.title,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // FundDetailContentCard(
                            //   backgroundColor: colors.dangerSoft,
                            //   borderColor: colors.dangerBorder,
                            //   child: Text(
                            //     staticContent.riskSection.warning,
                            //     style: appText.bodyStrong.copyWith(
                            //       color: colors.dangerForeground,
                            //       height: 1.6,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: UiTokens.spacing8),
                            FundDetailDisclosureList(
                              items: staticContent.riskSection.items
                                  .map(
                                    (FundDetailRiskItem item) =>
                                        FundDetailDisclosureItemData(
                                          title: item.title,
                                          body: item.body,
                                        ),
                                  )
                                  .toList(growable: false),
                            ),
                            if (staticContent
                                .riskSection
                                .footnotes
                                .isNotEmpty) ...<Widget>[
                              const SizedBox(height: UiTokens.spacing8),
                              Text(
                                staticContent.riskSection.footnotes.join('\n'),
                                style: appText.meta.copyWith(
                                  color: colors.textTertiary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (viewData.contractOverviewItems.isNotEmpty ||
                        staticContent != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailContractOverviewTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: UiTokens.spacing8,
                          children: <Widget>[
                            // if (viewData.contractOverviewItems.isNotEmpty)
                            //   FundDetailInfoTable(
                            //     items: viewData.contractOverviewItems,
                            //   ),
                            if (staticContent != null) ...<Widget>[
                              if (viewData.contractOverviewItems.isNotEmpty)
                                const SizedBox(height: UiTokens.spacing8),
                              for (
                                var index = 0;
                                index < staticContent.legalSections.length;
                                index++
                              ) ...<Widget>[
                                if (staticContent
                                    .legalSections[index]
                                    .rows
                                    .isNotEmpty)
                                  FundDetailKeyValueCard(
                                    title: staticContent
                                        .legalSections[index]
                                        .title,
                                    rows: staticContent
                                        .legalSections[index]
                                        .rows
                                        .map(
                                          (FundDetailLegalRow row) =>
                                              FundDetailKeyValueRowData(
                                                label: row.label,
                                                value: row.value,
                                              ),
                                        )
                                        .toList(growable: false),
                                  )
                                else
                                  FundDetailTextCard(
                                    title: staticContent
                                        .legalSections[index]
                                        .title,
                                    body:
                                        staticContent
                                            .legalSections[index]
                                            .body ??
                                        '',
                                  ),
                                if (index <
                                    staticContent.legalSections.length - 1)
                                  const SizedBox(height: UiTokens.spacing8),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (viewData.operatorItems.isNotEmpty ||
                        viewData.operatorMetaText != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailOperatorInfoTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (viewData.operatorItems.isNotEmpty)
                              FundDetailInfoTable(
                                items: viewData.operatorItems,
                              ),
                            if (viewData.operatorMetaText != null) ...<Widget>[
                              if (viewData.operatorItems.isNotEmpty)
                                const SizedBox(height: UiTokens.spacing8),
                              Text(
                                viewData.operatorMetaText!,
                                style: appText.caption.copyWith(
                                  color: colors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (viewData.documentGroups.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailDocumentsTitle,
                        child: FundProjectDetailDocumentsSection(
                          groups: viewData.documentGroups,
                        ),
                      ),
                    ],
                    if (isAuthenticated) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailCommentsTitle,
                        child: FundProjectDetailCommentsSection(
                          projectId: discussionProjectId,
                          onViewMoreTap: () => context.go('/discussion-board'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 86),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FundDetailGainTypeExplanationItem {
  const _FundDetailGainTypeExplanationItem({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

List<_FundDetailGainTypeExplanationItem> _buildGainTypeExplanationItems(
  BuildContext context,
) {
  final l10n = context.l10n;
  return <_FundDetailGainTypeExplanationItem>[
    _FundDetailGainTypeExplanationItem(
      title: l10n.fundDetailGainTypeIncomeGainTitle,
      body: l10n.fundDetailGainTypeIncomeGainBody,
    ),
    _FundDetailGainTypeExplanationItem(
      title: l10n.fundDetailGainTypeCapitalGainTitle,
      body: l10n.fundDetailGainTypeCapitalGainBody,
    ),
    _FundDetailGainTypeExplanationItem(
      title: l10n.fundDetailGainTypeMixedTitle,
      body: l10n.fundDetailGainTypeMixedBody,
    ),
  ];
}

class _FundDetailGainTypeExplanationCard extends StatelessWidget {
  const _FundDetailGainTypeExplanationCard({required this.item});

  final _FundDetailGainTypeExplanationItem item;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;
    return FundDetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.title,
            style: appText.bodyStrong.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(
            item.body,
            style: appText.body.copyWith(
              color: colors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _FundDetailAchievementBanner extends StatelessWidget {
  const _FundDetailAchievementBanner({
    required this.label,
    required this.value,
    required this.achievementRate,
  });

  final String label;
  final String value;
  final double? achievementRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final palette = _resolveAchievementBannerPalette(
      colors: colors,
      achievementRate: achievementRate,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: palette.gradientColors,
        ),
        border: Border.all(color: palette.borderColor),
        borderRadius: BorderRadius.circular(UiTokens.radius12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.chip.copyWith(color: palette.foregroundColor),
            ),
          ),
          Text(
            value,
            style: appText.numericTitle.copyWith(
              color: palette.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBannerPalette {
  const _AchievementBannerPalette({
    required this.gradientColors,
    required this.foregroundColor,
    required this.borderColor,
  });

  final List<Color> gradientColors;
  final Color foregroundColor;
  final Color borderColor;
}

_AchievementBannerPalette _resolveAchievementBannerPalette({
  required AppSemanticColorTheme colors,
  required double? achievementRate,
}) {
  final normalizedValue = (achievementRate ?? 0).clamp(0, 1).toDouble();
  final trackColor = colors.surfaceAlt;
  final visibility =
      0.36 + (0.64 * Curves.easeOutCubic.transform(normalizedValue));
  final blueShift = _resolveAchievementBlueShift(normalizedValue);
  final shiftedGradientColors = <Color>[
    Color.lerp(colors.brandPrimaryDark, colors.primary, blueShift * 0.58) ??
        colors.brandPrimaryDark,
    Color.lerp(colors.primary, colors.primaryAlt, blueShift) ?? colors.primary,
  ];
  final effectiveGradientColors = shiftedGradientColors
      .map((Color color) => Color.lerp(trackColor, color, visibility) ?? color)
      .toList(growable: false);
  final foregroundColor = normalizedValue >= 0.62
      ? colors.onDark
      : colors.textPrimary;
  final borderColor =
      Color.lerp(colors.border, effectiveGradientColors.last, 0.42) ??
      colors.border;

  return _AchievementBannerPalette(
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

String? _normalizeFundDetailText(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    null;
  }
  return text;
}

String? _normalizeFundVideoLink(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

String _formatAchievementRate(double? value) {
  if (value == null || value <= 0) {
    return '--';
  }
  final percentage = value * 100;
  final truncated = (percentage * 100).truncate() / 100;
  return '${truncated.toStringAsFixed(2)}%';
}
