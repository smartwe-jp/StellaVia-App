import 'dart:io';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_section_support.dart';
import '../widgets/mypage_active_fund_detail_sections.dart';

class MyPageActiveFundDetailPage extends ConsumerWidget {
  const MyPageActiveFundDetailPage({
    super.key,
    required this.projectId,
    this.seedRecords = const <MyPageInvestmentRecord>[],
  });

  final String projectId;
  final List<MyPageInvestmentRecord> seedRecords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '¥',
      decimalDigits: 0,
    );

    final benefitAsync = ref.watch(myPageProjectBenefitProvider(projectId));
    final fallbackRecords = ref
        .watch(myPageInvestmentListProvider)
        .asData
        ?.value;
    final records = _resolveRecords(
      projectId,
      seed: seedRecords,
      fallback: fallbackRecords ?? const <MyPageInvestmentRecord>[],
    );
    final summary = _ActiveFundSummary.fromRecords(records);
    final benefitData = benefitAsync.asData?.value;
    final projectName = benefitData?.projectName?.trim().isNotEmpty == true
        ? benefitData!.projectName!.trim()
        : summary.projectName.isNotEmpty
        ? summary.projectName
        : projectId;
    final statusLabel = resolveProjectStatusLabel(l10n, summary.projectStatus);
    //final canShowResale = summary.projectStatus == 4;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.myPageActiveFundDetailTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),

      // bottomNavigationBar:
      // canShowResale ?
      // SafeArea(
      //         top: false,
      //         child: Container(
      //           padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      //           child:
      //           PrimaryCtaButton(
      //             label: l10n.myPageResaleTabOrder,
      //             onPressed: summary.processId == null
      //                 ? null
      //                 : () => context.push(
      //                     '/my/secondary-market/sell',
      //                     extra: MyPageSecondaryMarketSellSeed(
      //                       projectId: projectId,
      //                       projectName: projectName,
      //                       fromProcessId: summary.processId!,
      //                       availableUnits: summary.investNumRemaining ?? 0,
      //                       investorCode: summary.investorCode,
      //                       earningRatio: summary.earningRatio,
      //                     ),
      //                   ),
      //             backgroundColor: colors.danger,
      //             shadowColor: colors.danger.withValues(alpha: 0.5),
      //             horizontalPadding: 0,
      //             threeSideShadow: true,
      //           ))):
      //           null,
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref, projectId: projectId),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: <Widget>[
            ActiveFundOverviewHeroCard(
              title: projectName,
              onTitleTap: () => context.push('/funds/$projectId'),
              titleColor: colors.primary,
              statusLabel: statusLabel,
              statusBackgroundColor: colors.primarySubtle,
              statusForegroundColor: colors.primaryAlt,
              totalBenefitLabel: l10n.myPageActiveFundTotalBenefitLabel,
              totalBenefitValue: formatCurrency(
                benefitData?.balanceTotal ?? summary.earnings,
                formatter,
              ),
              totalHistoricalBenefitLabel:
                  l10n.myPageAccumulatedDistributionLabel,
              totalHistoricalBenefitValue: formatCurrency(
                benefitData?.balanceTotalHistorical ?? summary.earnings,
                formatter,
              ),
              primaryMetrics: <ActiveFundOverviewMetricData>[
                ActiveFundOverviewMetricData(
                  label: l10n.myPageInvestmentAmountLabel,
                  value: formatCurrency(summary.investMoney, formatter),
                ),
                ActiveFundOverviewMetricData(
                  label: l10n.myPageActiveFundValidInvestmentAmountLabel,
                  value: formatCurrency(summary.investMoneyValid, formatter),
                ),
              ],
              secondaryMetrics: <ActiveFundOverviewMetricData>[
                ActiveFundOverviewMetricData(
                  label: l10n.myPageActiveFundInvestUnitsLabel,
                  value: _formatCount(summary.investNum),
                ),
                ActiveFundOverviewMetricData(
                  label: l10n.myPageActiveFundValidUnitsLabel,
                  value: _formatCount(summary.investNumValid),
                ),
                ActiveFundOverviewMetricData(
                  label: l10n.myPageActiveFundRemainingUnitsLabel,
                  value: _formatCount(summary.investNumRemaining),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ActiveFundInfoCard(
              title: l10n.myPageActiveFundMetaTitle,
              rows: <ActiveFundInfoRowData>[
                ActiveFundInfoRowData(
                  label: l10n.myPageActiveFundProcessIdLabel,
                  value: summary.processId ?? '--',
                ),
                ActiveFundInfoRowData(
                  label: l10n.myPageActiveFundInvestorCodeLabel,
                  value: summary.investorCode ?? '--',
                  emphasized: true,
                ),
                ActiveFundInfoRowData(
                  label: l10n.myPageActiveFundAppliedAtLabel,
                  value:
                      formatDateTimeOrNull(summary.createTime) ??
                      l10n.myPageResultAnnouncementTbd,
                ),
                ActiveFundInfoRowData(
                  label: l10n.myPageActiveFundWithdrawnAtLabel,
                  value:
                      formatDateTimeOrNull(summary.withdrawalTime) ??
                      l10n.myPageResultAnnouncementTbd,
                ),
              ],
            ),
            const SizedBox(height: 14),

            Text(
              l10n.myPageActiveFundBenefitHistoryTitle,
              style: appText.sectionTitle,
            ),
            const SizedBox(height: 8),
            benefitAsync.when(
              data: (benefit) {
                final details = [...benefit.details]
                  ..sort((a, b) => (b.seq ?? 0).compareTo(a.seq ?? 0));
                if (details.isEmpty) {
                  return _StateCard(
                    message: l10n.myPageActiveFundBenefitEmptyState,
                  );
                }
                return Column(
                  children: details
                      .map(
                        (detail) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ActiveFundBenefitHistoryCard(
                            title: _resolveBenefitCardTitle(
                              l10n,
                              detail,
                              localeTag: localeTag,
                            ),
                            benefitLabel:
                                l10n.myPageActiveFundBenefitAmountLabel,
                            benefitValue: formatCurrency(
                              detail.benefit,
                              formatter,
                            ),
                            taxLabel: l10n.myPageActiveFundTaxLabel,
                            taxValue: formatCurrency(detail.tax, formatter),
                            netLabel: l10n.myPageActiveFundNetBenefitLabel,
                            netValue: formatCurrency(
                              _resolveNetBenefit(detail),
                              formatter,
                            ),
                            footnote: detail.remark,
                            action: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                OutlinedButton(
                                  onPressed:
                                      detail.id != null &&
                                          detail.id!.trim().isNotEmpty
                                      ? () => _openBenefitReport(
                                          context,
                                          ref,
                                          benefitId: detail.id!,
                                          title:
                                              l10n.myPageActiveFundReportTitle,
                                        )
                                      : null,
                                  style: _detailOutlineButtonStyle(
                                    context,
                                    borderColor: colors.highlightGold,
                                    foregroundColor: colors.highlightGold,
                                  ),
                                  child: Text(
                                    l10n.myPageActiveFundReportAction,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (detail.withdrawalTime == null)
                                OutlinedButton(
                                  onPressed:
                                      detail.withdrawalTime == null &&
                                          detail.id != null &&
                                          detail.id!.trim().isNotEmpty
                                      ? () => _confirmBenefitWithdrawal(
                                          context,
                                          ref,
                                          projectId: projectId,
                                          benefitId: detail.id!,
                                        )
                                      : null,
                                  style: _detailOutlineButtonStyle(
                                    context,
                                    borderColor: colors.primary,
                                    foregroundColor: colors.primary,
                                  ),
                                  child: Text(
                                    detail.withdrawalTime == null
                                        ? l10n.myPageActiveFundWithdrawAction
                                        : l10n.myPageActiveFundWithdrawDone,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (_, __) => _StateCard(
                message: l10n.myPageActiveFundBenefitLoadError,
                actionLabel: l10n.fundListRetry,
                onActionTap: () =>
                    ref.invalidate(myPageProjectBenefitProvider(projectId)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _openBenefitReport(
  BuildContext context,
  WidgetRef ref, {
  required String benefitId,
  required String title,
}) async {
  final l10n = context.l10n;
  try {
    final pdfBytes =
        (await ref
                .read(downloadMyPageBenefitReportUseCaseProvider)
                .call(benefitId: benefitId))
            .toList(growable: false);
    if (!context.mounted) {
      return;
    }
    if (pdfBytes.isEmpty) {
      AppNotice.show(
        context,
        message: l10n.myPageActiveFundReportUnavailableNotice,
      );
      return;
    }

    final tempDir = await Directory.systemTemp.createTemp(
      'fundex_benefit_report_',
    );
    final file = File('${tempDir.path}/benefit_report.pdf');
    await file.writeAsBytes(pdfBytes, flush: true);
    if (!context.mounted) {
      return;
    }

    final viewerTexts = AppPdfViewerTexts(
      pageTitle: l10n.pdfViewerPageTitle,
      openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
      openExternalLabel: l10n.pdfViewerOpenExternalLabel,
      shareTooltip: l10n.pdfViewerShareTooltip,
      shareLabel: l10n.pdfViewerShareLabel,
      loadingLabel: l10n.pdfViewerLoadingLabel,
      loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
      retryLabel: l10n.fundListRetry,
      invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
      openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
      shareFailedNotice: l10n.pdfViewerShareFailedNotice,
    );
    await openAppPdfViewerFile(
      context,
      filePath: file.path,
      title: title,
      texts: viewerTexts,
    );
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: resolveAppRequestErrorMessage(
        error,
        l10n.myPageActiveFundReportUnavailableNotice,
      ),
    );
  }
}

Future<void> _refresh(WidgetRef ref, {required String projectId}) async {
  ref.invalidate(myPageInvestmentListProvider);
  ref.invalidate(myPageProjectBenefitProvider(projectId));
  await Future.wait<void>(<Future<void>>[
    ref.refresh(myPageInvestmentListProvider.future).then((_) {}),
    ref.refresh(myPageProjectBenefitProvider(projectId).future).then((_) {}),
  ]);
}

Future<void> _confirmBenefitWithdrawal(
  BuildContext context,
  WidgetRef ref, {
  required String projectId,
  required String benefitId,
}) async {
  final shouldSubmit = await AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: context.l10n.myPageActiveFundWithdrawConfirmTitle,
    message: context.l10n.myPageActiveFundWithdrawConfirmBody,
    actions: <AppDialogAction<bool>>[
      AppDialogAction<bool>(
        label: context.l10n.walletBankSettingsCancelAction,
        value: false,
      ),
      AppDialogAction<bool>(
        label: context.l10n.myPageActiveFundWithdrawConfirmAction,
        value: true,
        isDestructive: true,
      ),
    ],
  );
  if (shouldSubmit != true || !context.mounted) {
    return;
  }

  final allowed = await ensureRealPersonVerifiedAndAuthorizeSensitiveAction(
    context,
    ref,
    faceVerificationTitle:
        context.l10n.walletWithdrawRequiresFaceVerificationTitle,
    faceVerificationMessage:
        context.l10n.walletWithdrawRequiresFaceVerificationMessage,
  );
  if (!context.mounted || !allowed) {
    return;
  }

  try {
    await ref
        .read(submitMyPageBenefitWithdrawalUseCaseProvider)
        .call(benefitId: benefitId);
    if (!context.mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: context.l10n.myPageActiveFundWithdrawSuccess,
    );
    await _refresh(ref, projectId: projectId);
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: resolveAppRequestErrorMessage(
        error,
        context.l10n.myPageActiveFundWithdrawFailure,
      ),
    );
  }
}

List<MyPageInvestmentRecord> _resolveRecords(
  String projectId, {
  required List<MyPageInvestmentRecord> seed,
  required List<MyPageInvestmentRecord> fallback,
}) {
  final source = seed.isNotEmpty ? seed : fallback;
  return source
      .where((record) => record.projectId == projectId)
      .toList(growable: false);
}

String _formatCount(num? value) {
  if (value == null) {
    return '--';
  }
  return NumberFormat.decimalPattern().format(value);
}

num? _resolveNetBenefit(MyPageBenefitDetail detail) {
  if (detail.benefit == null && detail.tax == null) {
    return null;
  }
  return (detail.benefit ?? 0) - (detail.tax ?? 0);
}

String _resolveBenefitCardTitle(
  AppLocalizations l10n,
  MyPageBenefitDetail detail, {
  required String localeTag,
}) {
  final start = formatDateOrNull(detail.benefitPeriodStartDate);
  final end = formatDateOrNull(detail.benefitPeriodEndDate);
  if (start != null && end != null) {
    return l10n.myPageActiveFundBenefitPeriodRange(start, end);
  }
  if (detail.seq != null) {
    return l10n.myPageActiveFundBenefitSeq(detail.seq!);
  }
  final create = parseApiDate(detail.createTime);
  if (create != null) {
    return DateFormat('yyyy/MM/dd', localeTag).format(create);
  }
  return l10n.myPageActiveFundBenefitHistoryTitle;
}

ButtonStyle _detailOutlineButtonStyle(
  BuildContext context, {
  required Color borderColor,
  required Color foregroundColor,
}) {
  final appText = Theme.of(context).appTextTheme;
  return OutlinedButton.styleFrom(
    foregroundColor: foregroundColor,
    side: BorderSide(color: borderColor, width: 1.4),
    visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: const Size(0, 0),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: appText.chip,
  );
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.message, this.actionLabel, this.onActionTap});

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
            if (actionLabel != null && onActionTap != null) ...<Widget>[
              const SizedBox(height: 8),
              OutlinedButton(onPressed: onActionTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActiveFundSummary {
  const _ActiveFundSummary({
    required this.projectName,
    required this.projectStatus,
    required this.processId,
    required this.investorCode,
    required this.earningRatio,
    required this.createTime,
    required this.withdrawalTime,
    required this.investMoney,
    required this.investMoneyValid,
    required this.earnings,
    required this.investNum,
    required this.investNumValid,
    required this.investNumRemaining,
  });

  final String projectName;
  final int? projectStatus;
  final String? processId;
  final String? investorCode;
  final double? earningRatio;
  final String? createTime;
  final String? withdrawalTime;
  final num? investMoney;
  final num? investMoneyValid;
  final num? earnings;
  final int? investNum;
  final int? investNumValid;
  final int? investNumRemaining;

  factory _ActiveFundSummary.fromRecords(List<MyPageInvestmentRecord> records) {
    if (records.isEmpty) {
      return const _ActiveFundSummary(
        projectName: '',
        projectStatus: null,
        processId: null,
        investorCode: null,
        earningRatio: null,
        createTime: null,
        withdrawalTime: null,
        investMoney: null,
        investMoneyValid: null,
        earnings: null,
        investNum: null,
        investNumValid: null,
        investNumRemaining: null,
      );
    }

    final sorted = [...records]
      ..sort((a, b) => compareByDateDesc(a.createTime, b.createTime));
    final latest = sorted.first;

    num sumInvestMoney = 0;
    num sumInvestMoneyValid = 0;
    num sumEarnings = 0;
    int sumInvestNum = 0;
    int sumInvestNumValid = 0;
    int sumInvestNumRemaining = 0;
    for (final item in records) {
      sumInvestMoney += item.investMoney ?? 0;
      sumInvestMoneyValid += item.investMoneyValid ?? 0;
      sumEarnings += item.earnings ?? 0;
      sumInvestNum += item.investNum ?? 0;
      sumInvestNumValid += item.investNumValid ?? 0;
      sumInvestNumRemaining += item.investNumRemaining ?? 0;
    }

    return _ActiveFundSummary(
      projectName: latest.projectName,
      projectStatus: latest.projectStatus,
      processId: latest.processId,
      investorCode: latest.investorCode,
      earningRatio: latest.earningRadio ?? latest.investorType?.earningsRadio,
      createTime: latest.createTime,
      withdrawalTime: latest.withdrawalTime,
      investMoney: sumInvestMoney,
      investMoneyValid: sumInvestMoneyValid,
      earnings: sumEarnings,
      investNum: sumInvestNum,
      investNumValid: sumInvestNumValid,
      investNumRemaining: sumInvestNumRemaining,
    );
  }
}
