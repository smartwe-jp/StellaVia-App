import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../providers/wallet_providers.dart';
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
              data: (project) =>
                  _DepositDetailBody(record: record, project: project),
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

class _DepositDetailBody extends StatelessWidget {
  const _DepositDetailBody({required this.record, required this.project});

  final MyPageApplyRecord record;
  final FundProject project;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bank = project.liveJapanBank;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: <Widget>[
        DepositProjectCard(record: record),
        const SizedBox(height: 16),
        if (bank == null)
          DepositLoadState(
            icon: Icons.account_balance_outlined,
            message: l10n.walletProjectDepositAccountUnavailableMessage,
          )
        else
          _ProjectDepositBankCard(
            bank: bank,
            title: l10n.walletProjectDepositAccountTitle,
          ),
      ],
    );
  }
}

class _ProjectDepositBankCard extends StatelessWidget {
  const _ProjectDepositBankCard({required this.bank, required this.title});

  final FundProjectLiveJapanBank bank;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: appText.sectionTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 16),
            _CopyableBankInfoRow(
              label: l10n.walletBankNameLabel,
              value: bank.bankName,
              copyLabel: l10n.lotteryApplyCopyAction,
            ),
            _CopyableBankInfoRow(
              label: l10n.walletBranchNameLabel,
              value: bank.branchBankName,
              copyLabel: l10n.lotteryApplyCopyAction,
            ),
            _CopyableBankInfoRow(
              label: l10n.walletAccountNumberLabel,
              value: bank.bankNumber,
              copyLabel: l10n.lotteryApplyCopyAction,
            ),
            _CopyableBankInfoRow(
              label: l10n.walletAccountHolderLabel,
              value: bank.bankAccountOwnerName,
              copyLabel: null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CopyableBankInfoRow extends StatelessWidget {
  const _CopyableBankInfoRow({
    required this.label,
    required this.value,
    required this.copyLabel,
  });

  final String label;
  final String? value;
  final String? copyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final hasValue = value != null && value!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 92,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                label,
                style: appText.caption.copyWith(color: colors.textSecondary),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  hasValue ? value! : '--',
                  style: appText.bodyStrong.copyWith(color: colors.textPrimary),
                ),
                if (copyLabel != null && hasValue) ...<Widget>[
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: value!));
                      if (context.mounted) {
                        AppNotice.show(
                          context,
                          message: l10n.lotteryApplyCopyDoneToast,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colors.primary,
                    ),
                    child: Text(copyLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
