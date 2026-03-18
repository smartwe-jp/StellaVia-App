import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_secondary_market_models.dart';
import '../support/mypage_section_support.dart';

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
    final canShowResale = summary.projectStatus == 4;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPageActiveFundDetailTitle)),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref, projectId: projectId),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: <Widget>[
            FundMyPageProjectCard(
              title: projectName,
              trailing: _StatusBadge(
                label: statusLabel,
                backgroundColor: AppColorTokens.fundexVioletLight,
                foregroundColor: AppColorTokens.fundexViolet,
              ),
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageInvestmentAmountLabel,
                  value: formatCurrency(summary.investMoney, formatter),
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundValidInvestmentAmountLabel,
                  value: formatCurrency(summary.investMoneyValid, formatter),
                ),
                FundLabeledValue(
                  label: l10n.myPageAccumulatedDistributionLabel,
                  value: formatCurrency(summary.earnings, formatter),
                  valueColor: AppColorTokens.fundexSuccess,
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundInvestUnitsLabel,
                  value: _formatCount(summary.investNum),
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundValidUnitsLabel,
                  value: _formatCount(summary.investNumValid),
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundRemainingUnitsLabel,
                  value: _formatCount(summary.investNumRemaining),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FundMyPageProjectCard(
              title: l10n.myPageActiveFundMetaTitle,
              rows: <FundLabeledValue>[
                FundLabeledValue(
                  label: l10n.myPageActiveFundProcessIdLabel,
                  value: summary.processId ?? '--',
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundInvestorCodeLabel,
                  value: summary.investorCode ?? '--',
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundAppliedAtLabel,
                  value:
                      formatDateTimeOrNull(summary.createTime) ??
                      l10n.myPageResultAnnouncementTbd,
                ),
                FundLabeledValue(
                  label: l10n.myPageActiveFundWithdrawnAtLabel,
                  value:
                      formatDateTimeOrNull(summary.withdrawalTime) ??
                      l10n.myPageResultAnnouncementTbd,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _TotalBenefitCard(
              title: l10n.myPageActiveFundTotalBenefitLabel,
              value: formatCurrency(
                benefitData?.balanceTotal ?? summary.earnings,
                formatter,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.myPageActiveFundBenefitHistoryTitle,
              style:
                  (Theme.of(context).textTheme.titleMedium ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexText,
                        fontWeight: FontWeight.w800,
                      ),
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
                          child: FundMyPageProjectCard(
                            title: _resolveBenefitCardTitle(
                              l10n,
                              detail,
                              localeTag: localeTag,
                            ),
                            rows: <FundLabeledValue>[
                              FundLabeledValue(
                                label: l10n.myPageActiveFundBenefitAmountLabel,
                                value: formatCurrency(
                                  detail.benefit,
                                  formatter,
                                ),
                              ),
                              FundLabeledValue(
                                label: l10n.myPageActiveFundTaxLabel,
                                value: formatCurrency(detail.tax, formatter),
                              ),
                              FundLabeledValue(
                                label: l10n.myPageActiveFundNetBenefitLabel,
                                value: formatCurrency(
                                  _resolveNetBenefit(detail),
                                  formatter,
                                ),
                                valueColor: AppColorTokens.fundexSuccess,
                              ),
                            ],
                            footnote: detail.remark,
                            footer: OutlinedButton(
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
                                borderColor: AppColorTokens.fundexAccent,
                                foregroundColor: AppColorTokens.fundexAccent,
                              ),
                              child: Text(
                                detail.withdrawalTime == null
                                    ? l10n.myPageActiveFundWithdrawAction
                                    : l10n.myPageActiveFundWithdrawDone,
                              ),
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
            if (canShowResale) ...<Widget>[
              const SizedBox(height: 12),
              PrimaryCtaButton(
                label: l10n.myPageActiveFundResaleAction,
                onPressed: summary.processId == null
                    ? null
                    : () => context.push(
                        '/my/secondary-market/sell',
                        extra: MyPageSecondaryMarketSellSeed(
                          projectId: projectId,
                          projectName: projectName,
                          fromProcessId: summary.processId!,
                          availableUnits: summary.investNumRemaining ?? 0,
                          investorCode: summary.investorCode,
                          earningRatio: summary.earningRatio,
                        ),
                      ),
                backgroundColor: AppColorTokens.fundexDanger,
                shadowColor: AppColorTokens.fundexDanger.withValues(alpha: 0.5),
                horizontalPadding: 0,
                threeSideShadow: true,
              ),
            ],
          ],
        ),
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

  final allowed = await ensureSensitiveActionAuthorized(context, ref);
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
      message: context.l10n.myPageActiveFundWithdrawFailure,
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

ButtonStyle _detailOutlineButtonStyle({
  required Color borderColor,
  required Color foregroundColor,
}) {
  return OutlinedButton.styleFrom(
    foregroundColor: foregroundColor,
    side: BorderSide(color: borderColor, width: 1.4),
    visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: const Size(0, 0),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
            .copyWith(
              color: foregroundColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _TotalBenefitCard extends StatelessWidget {
  const _TotalBenefitCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3F3),
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: const Color(0xFFF6CACA)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style:
                  (Theme.of(context).textTheme.titleSmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextSecondary,
                        fontWeight: FontWeight.w700,
                      ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style:
                  (Theme.of(context).textTheme.headlineMedium ??
                          const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexDanger,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.message, this.actionLabel, this.onActionTap});

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: AppColorTokens.fundexBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(color: AppColorTokens.fundexTextSecondary),
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
