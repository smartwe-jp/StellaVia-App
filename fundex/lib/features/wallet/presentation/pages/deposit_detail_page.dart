import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_application_payment_refresh.dart';
import '../support/wallet_deposit_transfer_notice_support.dart';
import '../support/wallet_standby_purchase_dialog.dart';
import '../widgets/project_deposit_bank_card.dart';
import 'deposit_list_page.dart';

class DepositDetailPage extends ConsumerWidget {
  const DepositDetailPage({
    super.key,
    required this.projectId,
    this.initialRecord,
  });

  final String projectId;
  final MyPageApplyRecord? initialRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final recordAsync = initialRecord == null
        ? ref.watch(walletPendingDepositRecordProvider(projectId))
        : AsyncValue<MyPageApplyRecord?>.data(initialRecord);
    final projectAsync = ref.watch(fundProjectDetailProvider(projectId));

    return AppRootRouteRefreshScope(
      onRefresh: (WidgetRef ref) async {
        ref.invalidate(walletPendingDepositRecordProvider(projectId));
        ref.invalidate(fundProjectDetailProvider(projectId));
        await Future.wait<void>(<Future<void>>[
          ref.refresh(walletPendingDepositRecordProvider(projectId).future),
          ref.refresh(fundProjectDetailProvider(projectId).future),
        ]);
      },
      child: Scaffold(
        appBar: AppNavigationBar(
          title: l10n.walletDepositDetailTitle,
          height: 52,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),
        body: recordAsync.when(
          data: (record) {
            if (record == null) {
              return DepositLoadState(
                icon: Icons.info_outline_rounded,
                message: l10n.walletPendingDepositUnavailableMessage,
              );
            }
            return projectAsync.when(
              data: (project) => _DepositDetailBody(
                record: record,
                project: project,
                projectId: projectId,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, __) => DepositLoadState(
                icon: Icons.wifi_off_rounded,
                message: resolveAppRequestErrorMessage(
                  error,
                  l10n.walletDataLoadError,
                ),
                actionLabel: l10n.fundListRetry,
                onTapAction: () {
                  ref.invalidate(fundProjectDetailProvider(projectId));
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, __) => DepositLoadState(
            icon: Icons.wifi_off_rounded,
            message: resolveAppRequestErrorMessage(
              error,
              l10n.walletDataLoadError,
            ),
            actionLabel: l10n.fundListRetry,
            onTapAction: () {
              ref.invalidate(walletPendingDepositRecordProvider(projectId));
            },
          ),
        ),
      ),
    );
  }
}

class _DepositDetailBody extends ConsumerStatefulWidget {
  const _DepositDetailBody({
    required this.record,
    required this.project,
    required this.projectId,
  });

  final MyPageApplyRecord record;
  final FundProject project;
  final String projectId;

  @override
  ConsumerState<_DepositDetailBody> createState() => _DepositDetailBodyState();
}

class _DepositDetailBodyState extends ConsumerState<_DepositDetailBody> {
  bool _isReportingDeposit = false;
  bool _isPurchasingWithStandbyBalance = false;
  bool _isOperationCompleted = false;

  void _back() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/wallet/deposit');
  }

  Future<void> _reportDepositCompleted() async {
    final amount = resolveDepositAmount(widget.record)?.round();
    if (amount == null ||
        amount <= 0 ||
        _isReportingDeposit ||
        _isPurchasingWithStandbyBalance) {
      return;
    }

    setState(() {
      _isReportingDeposit = true;
    });

    try {
      await ref.read(confirmWalletPaymentUseCaseProvider).call(amount: amount);
      if (!mounted) {
        return;
      }
      setState(() {
        _isOperationCompleted = true;
      });
      AppNotice.show(
        context,
        message: context.l10n.lotteryApplyReportDepositSuccess,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.lotteryApplyReportDepositFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isReportingDeposit = false;
        });
      }
    }
  }

  Future<void> _purchaseWithStandbyBalance() async {
    final amount = resolveDepositAmount(widget.record)?.round();
    if (amount == null ||
        amount <= 0 ||
        _isPurchasingWithStandbyBalance ||
        _isReportingDeposit) {
      return;
    }
    final processId = _resolveDepositProcessId(widget.record);
    if (processId == null) {
      AppNotice.show(
        context,
        message: context.l10n.lotteryApplyStandbyPurchaseMissingProcess,
      );
      return;
    }
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final projectName = _resolveDepositProjectName(
      widget.record,
      widget.project,
    );
    final confirmed = await showWalletStandbyPurchaseConfirmDialog(
      context,
      projectName: projectName,
      amountText: formatter.format(amount),
    );
    if (!mounted || !confirmed) {
      return;
    }
    final failureMessage = context.l10n.lotteryApplyStandbyPurchaseFailure;

    setState(() {
      _isPurchasingWithStandbyBalance = true;
    });

    try {
      final succeeded = await ref
          .read(autoFundDeductionUseCaseProvider)
          .call(processId: processId);
      if (!succeeded) {
        throw StateError(failureMessage);
      }
      await refreshWalletApplicationPaymentState(
        ref,
        projectId: widget.projectId,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _isOperationCompleted = true;
      });
      AppNotice.show(
        context,
        message: context.l10n.lotteryApplyStandbyPurchaseSuccess,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.lotteryApplyStandbyPurchaseFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasingWithStandbyBalance = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final hasDepositBank =
        widget.project.liveJapanBank != null ||
        _isUsableOverseasDepositBank(widget.project.notLiveJapanBank);
    final depositAmount = resolveDepositAmount(widget.record)?.round();
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final standbyBalance =
        ref
            .watch(myPageAccountStatisticProvider)
            .asData
            ?.value
            ?.firstLevelAccountTotal ??
        0;
    final standbyShortage =
        depositAmount != null && depositAmount > standbyBalance
        ? depositAmount - standbyBalance
        : 0;
    final canPurchaseWithStandbyBalance =
        depositAmount != null &&
        depositAmount > 0 &&
        standbyBalance >= depositAmount;
    final currentUser = ref.watch(currentAuthUserProvider).valueOrNull;
    final transferNoticeAccountId = formatWalletDepositTransferNoticeAccountId(
      currentUser,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: <Widget>[
        DepositProjectCard(record: widget.record),
        const SizedBox(height: 16),
        if (!hasDepositBank)
          DepositLoadState(
            icon: Icons.account_balance_outlined,
            message: l10n.walletProjectDepositAccountUnavailableMessage,
          )
        else
          ProjectDepositBankCard(
            liveJapanBank: widget.project.liveJapanBank,
            notLiveJapanBank: widget.project.notLiveJapanBank,
            texts: _buildProjectDepositBankCardTexts(
              context,
              transferNoticeAccountId: transferNoticeAccountId,
            ),
          ),
        const SizedBox(height: 20),
        if (_isOperationCompleted)
          OutlinedButton(
            onPressed: _back,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(color: colors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.lotteryApplyDepositReportBackAction,
              style: appText.button.copyWith(color: colors.primary),
            ),
          )
        else ...<Widget>[
          _StandbyBalancePaymentCard(
            balanceLabel: l10n.lotteryApplyStandbyBalanceLabel,
            balanceValue: formatter.format(standbyBalance),
            purchaseButtonLabel: l10n.lotteryApplyStandbyPurchaseAction,
            shortageLabel: l10n.lotteryApplyStandbyShortageLabel,
            shortageValue: standbyShortage > 0
                ? formatter.format(standbyShortage)
                : null,
            canPurchase: canPurchaseWithStandbyBalance && !_isReportingDeposit,
            isLoading: _isPurchasingWithStandbyBalance,
            onPurchase: _purchaseWithStandbyBalance,
          ),
          const SizedBox(height: 16),
          PrimaryCtaButton(
            label: l10n.lotteryApplyReportDepositAction,
            onPressed: depositAmount == null || depositAmount <= 0
                ? null
                : _reportDepositCompleted,
            isLoading: _isReportingDeposit,
            horizontalPadding: 0,
            backgroundColor: colors.primary,
            shadowColor: colors.primary.withValues(alpha: 0.34),
          ),
        ],
      ],
    );
  }
}

String? _resolveDepositProcessId(MyPageApplyRecord record) {
  final processId = record.processId?.trim();
  if (processId != null && processId.isNotEmpty) {
    return processId;
  }
  final fallback = record.fromProcessId?.trim();
  if (fallback == null || fallback.isEmpty) {
    return null;
  }
  return fallback;
}

String _resolveDepositProjectName(
  MyPageApplyRecord record,
  FundProject project,
) {
  final recordName = record.projectName.trim();
  if (recordName.isNotEmpty) {
    return recordName;
  }
  final projectName = project.projectName.trim();
  return projectName.isEmpty ? '--' : projectName;
}

bool _isUsableOverseasDepositBank(FundProjectLiveJapanBank? bank) {
  return (bank?.bankName?.trim().isNotEmpty ?? false) &&
      (bank?.bankNumber?.trim().isNotEmpty ?? false);
}

ProjectDepositBankCardTexts _buildProjectDepositBankCardTexts(
  BuildContext context, {
  required String transferNoticeAccountId,
}) {
  final l10n = context.l10n;
  return ProjectDepositBankCardTexts(
    domesticTitle: l10n.walletProjectDepositAccountTitle,
    overseasTitle: l10n.walletProjectOverseasDepositAccountTitle,
    domesticSegmentLabel: l10n.walletProjectDomesticDepositSegment,
    overseasSegmentLabel: l10n.walletProjectOverseasDepositSegment,
    copyLabel: l10n.lotteryApplyCopyAction,
    copyDoneMessage: l10n.lotteryApplyCopyDoneToast,
    bankInfoSectionTitle: l10n.walletProjectDepositBankInfoSection,
    recipientInfoSectionTitle: l10n.walletProjectDepositRecipientInfoSection,
    bankNameLabel: l10n.walletBankNameLabel,
    swiftCodeLabel: l10n.walletProjectDepositSwiftCodeLabel,
    branchNameLabel: l10n.walletBranchNameLabel,
    branchAddressLabel: l10n.walletProjectDepositBranchAddressLabel,
    bankCountryLabel: l10n.walletBankSettingsBankCountryLabel,
    accountNumberLabel: l10n.walletAccountNumberLabel,
    accountHolderLabel: l10n.walletAccountHolderLabel,
    accountHolderAddressLabel:
        l10n.walletProjectDepositAccountHolderAddressLabel,
    transferNotice: l10n.walletDepositTransferNotice(transferNoticeAccountId),
    transferName: transferNoticeAccountId,
    transferNameCopyButtonLabel: l10n.walletDepositTransferNameCopyAction,
  );
}

class _StandbyBalancePaymentCard extends StatelessWidget {
  const _StandbyBalancePaymentCard({
    required this.balanceLabel,
    required this.balanceValue,
    required this.purchaseButtonLabel,
    required this.shortageLabel,
    required this.shortageValue,
    required this.canPurchase,
    required this.isLoading,
    required this.onPurchase,
  });

  final String balanceLabel;
  final String balanceValue;
  final String purchaseButtonLabel;
  final String shortageLabel;
  final String? shortageValue;
  final bool canPurchase;
  final bool isLoading;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final shortageText = shortageValue == null
        ? null
        : '$shortageLabel $shortageValue';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    balanceLabel,
                    style: appText.caption.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (shortageText != null) ...<Widget>[
                  const SizedBox(width: 12),
                  _StandbyShortageBadge(label: shortageText),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              balanceValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appText.numericTitle.copyWith(
                color: colors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            if (canPurchase) ...<Widget>[
              const SizedBox(height: 14),
              PrimaryCtaButton(
                label: purchaseButtonLabel,
                onPressed: isLoading ? null : onPurchase,
                isLoading: isLoading,
                height: 48,
                horizontalPadding: 0,
                backgroundColor: colors.highlightGold,
                shadowColor: colors.highlightGold.withValues(alpha: 0.22),
                textStyle: appText.button.copyWith(color: colors.onDark),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StandbyShortageBadge extends StatelessWidget {
  const _StandbyShortageBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.dangerSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.dangerBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: appText.caption.copyWith(
            color: colors.dangerForeground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
