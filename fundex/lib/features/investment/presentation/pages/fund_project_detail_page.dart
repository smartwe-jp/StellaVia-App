import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_providers.dart';
import '../support/fund_detail_static_content.dart';
import '../support/fund_project_detail_structured_data.dart';
import '../support/fund_project_detail_view_data.dart';
import '../widgets/fund_project_detail_comments_section.dart';
import '../widgets/fund_project_detail_documents_section.dart';
import '../widgets/fund_project_detail_scaffold.dart';
import '../widgets/fund_project_detail_tabs_section.dart';
import '../widgets/fund_project_detail_title_block.dart';
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

  Future<void> _handleLotteryApplyTap(String projectId) async {
    final allowed = await ensureSensitiveActionAuthorized(
      context,
      ref,
      identifyGroupId: projectId,
    );
    if (!mounted || !allowed) {
      return;
    }
    context.push('/funds/$projectId/lottery-apply');
  }

  @override
  Widget build(BuildContext context) {
    final projectId = widget.projectId;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final detailAsync = ref.watch(fundProjectDetailProvider(projectId));

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
                  style: (theme.textTheme.bodyMedium ?? const TextStyle())
                      .copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing12),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(fundProjectDetailProvider(projectId)),
                  child: Text(context.l10n.fundListRetry),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (FundProject project) {
        final locale = Localizations.localeOf(context);
        final int? discussionProjectId = int.tryParse(projectId);
        final staticContentAsync = ref.watch(
          fundDetailStaticContentProvider(locale.toLanguageTag()),
        );
        final staticContent = staticContentAsync.asData?.value;
        final structuredDetail = FundProjectDetailStructuredData.fromMap(
          project.detailData,
        );
        final viewData = FundProjectDetailViewDataBuilder.build(
          context: context,
          project: project,
        );

        return FundProjectDetailScaffold(
          actionBar: FundDetailStickyActionBar(
            label: viewData.actionLabel,
            enabled: viewData.actionEnabled,
            onTap: () => _handleLotteryApplyTap(projectId),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              FundDetailHeroHeader(
                gradientColors: viewData.heroGradientColors,
                badges: viewData.heroBadges,
                imageUrls: project.photos,
                onBackTap: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/funds');
                },
                onFavoriteTap: () {},
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
                          const SizedBox(height: UiTokens.spacing12),
                          FundProjectDetailYieldHighlightCard(
                            label: context
                                .l10n.fundDetailPlannedDistributionRateLabel,
                            value: viewData.yieldDisplay,
                            disclaimer: context.l10n.fundDetailYieldDisclaimer,
                          ),
                        ],
                      ),
                    ),
                    if (viewData.infoItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      FundDetailSection(
                        title: context.l10n.fundDetailKeyFactsTitle,
                        child: FundDetailInfoTable(items: viewData.infoItems),
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
                      FundDetailSection(
                        title: staticContent.riskSection.title,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FundDetailContentCard(
                              backgroundColor: colors.dangerSoft,
                              borderColor: colors.dangerBorder,
                              child: Text(
                                staticContent.riskSection.warning,
                                style: appText.bodyStrong.copyWith(
                                  color: colors.dangerForeground,
                                  fontWeight: FontWeight.w800,
                                  height: 1.6,
                                ),
                              ),
                            ),
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
                                .riskSection.footnotes.isNotEmpty) ...<Widget>[
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
                        viewData.contractScheduleItems.isNotEmpty ||
                        staticContent != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailContractOverviewTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: UiTokens.spacing8,
                          children: <Widget>[
                            if (viewData.contractOverviewItems.isNotEmpty)
                              FundDetailInfoTable(
                                items: viewData.contractOverviewItems,
                              ),
                            if (viewData.contractOverviewItems.isNotEmpty &&
                                viewData.contractScheduleItems.isNotEmpty)
                              const SizedBox(height: 1),
                            if (viewData.contractScheduleItems.isNotEmpty)
                              FundDetailInfoTable(
                                items: viewData.contractScheduleItems,
                              ),
                            if (staticContent != null) ...<Widget>[
                              if (viewData.contractOverviewItems.isNotEmpty ||
                                  viewData.contractScheduleItems.isNotEmpty)
                                const SizedBox(height: UiTokens.spacing8),
                              for (var index = 0;
                                  index < staticContent.legalSections.length;
                                  index++) ...<Widget>[
                                if (staticContent
                                    .legalSections[index].rows.isNotEmpty)
                                  FundDetailKeyValueCard(
                                    title: staticContent
                                        .legalSections[index].title,
                                    rows:
                                        staticContent.legalSections[index].rows
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
                                        .legalSections[index].title,
                                    body: staticContent
                                            .legalSections[index].body ??
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
                    const SizedBox(height: 18),
                    FundDetailSection(
                      title: context.l10n.fundDetailCommentsTitle,
                      child: FundProjectDetailCommentsSection(
                        projectId: discussionProjectId,
                        onViewMoreTap: () => context.go('/discussion-board'),
                      ),
                    ),
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

class _FundDetailAchievementBanner extends StatelessWidget {
  const _FundDetailAchievementBanner({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[colors.primary, colors.primaryAlt],
        ),
        borderRadius: BorderRadius.circular(UiTokens.radius12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.chip.copyWith(
                color: colors.brandWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: appText.numericTitle.copyWith(
              color: colors.brandWhite,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatAchievementRate(double? value) {
  if (value == null || value <= 0) {
    return '--';
  }
  final ratio = value > 1 ? value * 100 : value * 100;
  final text = ratio.toStringAsFixed(ratio.truncateToDouble() == ratio ? 0 : 1);
  return '$text%';
}
