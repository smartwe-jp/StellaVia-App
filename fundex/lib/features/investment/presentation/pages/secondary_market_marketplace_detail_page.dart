import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../support/secondary_market_marketplace_presenter.dart';
import '../support/secondary_market_trade_support.dart';
import '../widgets/secondary_market_marketplace_detail_sections.dart';

class SecondaryMarketMarketplaceDetailPage extends ConsumerWidget {
  const SecondaryMarketMarketplaceDetailPage({
    super.key,
    required this.orderId,
    this.initialRecord,
  });

  final String orderId;
  final MyPageOrderInquiryRecord? initialRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final asyncMarketplace = ref.watch(secondaryMarketMarketplaceListProvider);
    final record = initialRecord ?? _findRecord(asyncMarketplace.asData?.value);

    return Scaffold(
      appBar: AppNavigationBar(
        title: l10n.homeFreeMarketTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      bottomNavigationBar: record == null
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: PrimaryCtaButton(
                  label: l10n.secondaryMarketBuyAction,
                  onPressed: canBuySecondaryMarketRecord(record)
                      ? () => context.push(
                          '/free-market/${record.id}/buy',
                          extra: buildSecondaryMarketBuySeed(record),
                        )
                      : null,
                  backgroundColor: colors.primary,
                  shadowColor: colors.primary.withValues(alpha: 0.45),
                  horizontalPadding: 0,
                  threeSideShadow: true,
                ),
              ),
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(secondaryMarketMarketplaceListProvider);
          await ref
              .refresh(secondaryMarketMarketplaceListProvider.future)
              .then((_) {});
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: <Widget>[
            if (asyncMarketplace.isLoading && record == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            else if (record == null)
              SecondaryMarketMarketplaceStateCard(
                message: asyncMarketplace.hasError
                    ? l10n.secondaryMarketDetailLoadError
                    : l10n.secondaryMarketDetailUnavailable,
                actionLabel: l10n.fundListRetry,
                onActionTap: () {
                  ref.invalidate(secondaryMarketMarketplaceListProvider);
                },
              )
            else ...<Widget>[
              SecondaryMarketDetailHeroCard(
                marketLabel: l10n.homeFreeMarketTitle,
                title: record.projectName,
                statusLabel: l10n.homeFreeMarketStatusListed,
                statusBackgroundColor: colors.warningSubtle,
                statusForegroundColor: colors.warningAction,
                investorTypeLabel: buildSecondaryMarketInvestorTypeDisplay(
                  record,
                ),
                unitPriceLabel: formatter.format(record.price ?? 0),
                unitPriceCaption: l10n.secondaryMarketPricePerUnitCaption,
                remainingUnitsLabel:
                    '${formatSecondaryMarketRemainingUnits(record)}${l10n.myPageResaleUnitsSuffix}',
                remainingUnitsCaption: l10n.secondaryMarketRemainingUnitsLabel,
                listedUnitsLabel:
                    '${l10n.secondaryMarketSellUnitsLabel}\n${record.sellNum ?? 0}${l10n.myPageResaleUnitsSuffix}',
                soldUnitsLabel:
                    '${l10n.secondaryMarketSoldUnitsLabel}\n${record.soldNum ?? 0}${l10n.myPageResaleUnitsSuffix}',
                completionRateLabel:
                    '${l10n.secondaryMarketCompletionRateLabel}\n${formatSecondaryMarketCompletionRate(record)}',
                orderTimeLabel:
                    formatSecondaryMarketDateTime(record.createTime) ??
                    l10n.myPageResultAnnouncementTbd,
              ),
              const SizedBox(height: 14),
              SecondaryMarketDetailSectionCard(
                title: l10n.secondaryMarketOverviewTitle,
                child: Column(
                  children: <Widget>[
                    SecondaryMarketDetailInfoRow(
                      label: l10n.secondaryMarketOrderTimeLabel,
                      value:
                          formatSecondaryMarketDateTime(record.createTime) ??
                          l10n.myPageResultAnnouncementTbd,
                    ),
                    const Divider(height: 1),
                    SecondaryMarketDetailInfoRow(
                      label: l10n.secondaryMarketUpdateTimeLabel,
                      value:
                          formatSecondaryMarketDateTime(record.updateTime) ??
                          l10n.myPageResultAnnouncementTbd,
                    ),
                    const Divider(height: 1),
                    SecondaryMarketDetailInfoRow(
                      label: l10n.secondaryMarketInvestorTypeLabel,
                      value: buildSecondaryMarketInvestorTypeDisplay(record),
                    ),
                    const Divider(height: 1),
                    SecondaryMarketDetailInfoRow(
                      label: l10n.secondaryMarketOrderIdLabel,
                      value: record.id ?? '--',
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 14),
              // SecondaryMarketDetailSectionCard(
              //   title: l10n.secondaryMarketActivityTitle,
              //   child: SecondaryMarketDetailActivityGrid(
              //     applicationCount:
              //         '${l10n.secondaryMarketApplicationsCountLabel} ${countSecondaryMarketApplications(record)}件',
              //     dealCount:
              //         '${l10n.secondaryMarketDealsCountLabel} ${countSecondaryMarketDeals(record)}件',
              //     latestApplication:
              //         '${l10n.secondaryMarketLatestApplicationLabel}  ${resolveLatestSecondaryMarketApplicationTime(record) ?? l10n.myPageResultAnnouncementTbd}',
              //     latestDeal:
              //         '${l10n.secondaryMarketLatestDealLabel}  ${resolveLatestSecondaryMarketDealTime(record) ?? l10n.myPageResultAnnouncementTbd}',
              //   ),
              // ),
              if (record.pdfDocuments.isNotEmpty) ...<Widget>[
                const SizedBox(height: 14),
                SecondaryMarketDetailSectionCard(
                  title: l10n.secondaryMarketDocumentsTitle,
                  child: SecondaryMarketDetailDocumentsList(
                    items: record.pdfDocuments
                        .map(
                          (item) => SecondaryMarketDetailDocumentItemData(
                            title: item.description ?? '--',
                            subtitle: _firstValidDocumentUrl(item) == null
                                ? l10n.secondaryMarketDocumentPending
                                : l10n.secondaryMarketDocumentOpenAction,
                            available: _firstValidDocumentUrl(item) != null,
                            onTap: _firstValidDocumentUrl(item) == null
                                ? null
                                : () => _openDocument(
                                    context,
                                    title:
                                        item.description ??
                                        l10n.secondaryMarketDocumentsTitle,
                                    url: _firstValidDocumentUrl(item)!,
                                  ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ],
              if (remainingUnitsForSecondaryMarketRecord(record) <=
                  0) ...<Widget>[
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l10n.secondaryMarketDetailSoldOutMessage,
                    style: appText.bodyMuted.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  MyPageOrderInquiryRecord? _findRecord(
    List<MyPageOrderInquiryRecord>? records,
  ) {
    if (records == null) {
      return null;
    }
    for (final record in records) {
      if (record.id == orderId) {
        return record;
      }
    }
    return null;
  }

  static String? _firstValidDocumentUrl(MyPagePdfDocument document) {
    for (final url in document.urls) {
      final value = url.url?.trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static void _openDocument(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    final l10n = context.l10n;
    openAppPdfViewer(
      context,
      url: url,
      title: title,
      texts: AppPdfViewerTexts(
        pageTitle: l10n.pdfViewerPageTitle,
        openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
        openExternalLabel: l10n.pdfViewerOpenExternalLabel,
        loadingLabel: l10n.pdfViewerLoadingLabel,
        loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
        retryLabel: l10n.fundListRetry,
        invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
        openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
      ),
    );
  }
}
