import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/navigation/app_root_route_refresh_scope.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../providers/wallet_providers.dart';

class DepositListPage extends ConsumerWidget {
  const DepositListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncRecords = ref.watch(walletPendingDepositListProvider);

    return AppRootRouteRefreshScope(
      onRefresh: (WidgetRef ref) async {
        ref.invalidate(walletPendingDepositListProvider);
        final _ = await ref.refresh(walletPendingDepositListProvider.future);
      },
      child: Scaffold(
        appBar: AppNavigationBar(
          title: l10n.walletDepositTitle,
          height: 52,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),
        body: asyncRecords.when(
          data: (records) => _DepositListBody(records: records),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, __) => DepositLoadState(
            icon: Icons.wifi_off_rounded,
            message: resolveAppRequestErrorMessage(
              error,
              l10n.walletDataLoadError,
            ),
            actionLabel: l10n.fundListRetry,
            onTapAction: () => ref.invalidate(walletPendingDepositListProvider),
          ),
        ),
      ),
    );
  }
}

class _DepositListBody extends StatelessWidget {
  const _DepositListBody({required this.records});

  final List<MyPageApplyRecord> records;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (records.isEmpty) {
      return DepositLoadState(
        icon: Icons.account_balance_wallet_outlined,
        message: l10n.walletPendingDepositEmptyMessage,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: records.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final record = records[index];
        return DepositProjectCard(
          record: record,
          onTap: record.projectId == null || record.projectId!.isEmpty
              ? null
              : () => context.push(
                  '/wallet/deposit/${Uri.encodeComponent(record.projectId!)}',
                  extra: record,
                ),
        );
      },
    );
  }
}

class DepositProjectCard extends StatelessWidget {
  const DepositProjectCard({super.key, required this.record, this.onTap});

  final MyPageApplyRecord record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );
    final unitCount = resolveDepositUnits(record);
    final depositAmount = resolveDepositAmount(record);
    final unitPrice = resolveDepositUnitPrice(record);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              record.projectName,
              style: appText.cardTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 14),
            _DepositInfoRow(
              label: l10n.lotteryApplyStep1UnitCountLabel,
              value: unitCount == null
                  ? '--'
                  : '$unitCount${l10n.lotteryApplyStep1UnitSuffix}',
            ),
            const SizedBox(height: 10),
            _DepositInfoRow(
              label: l10n.lotteryApplyStep1UnitPriceLabel,
              value: unitPrice == null ? '--' : currency.format(unitPrice),
            ),
            const SizedBox(height: 10),
            _DepositInfoRow(
              label: l10n.lotteryApplyDepositAmountLabel,
              value: depositAmount == null
                  ? '--'
                  : currency.format(depositAmount),
              emphasize: true,
            ),
            if (onTap != null) ...<Widget>[
              const SizedBox(height: 16),
              PrimaryCtaButton(
                label: l10n.myPageDepositAction,
                onPressed: onTap,
                horizontalPadding: 0,
                backgroundColor: colors.highlightGold,
                shadowColor: colors.highlightGold.withValues(alpha: 0.22),
                textStyle: appText.button.copyWith(
                  color: colors.brandPrimaryDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DepositInfoRow extends StatelessWidget {
  const _DepositInfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: appText.caption.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          textAlign: TextAlign.end,
          style: (emphasize ? appText.numericTitle : appText.bodyStrong)
              .copyWith(color: emphasize ? colors.primary : colors.textPrimary),
        ),
      ],
    );
  }
}

class DepositLoadState extends StatelessWidget {
  const DepositLoadState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onTapAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onTapAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 28, color: colors.textSecondary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
            if (actionLabel != null && onTapAction != null) ...<Widget>[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onTapAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

int? resolveDepositUnits(MyPageApplyRecord record) {
  return record.passNum ?? record.applyNum ?? record.investNum;
}

num? resolveDepositAmount(MyPageApplyRecord record) {
  return record.passMoney ?? record.applyMoney ?? record.investMoney;
}

num? resolveDepositUnitPrice(MyPageApplyRecord record) {
  final units = resolveDepositUnits(record);
  final amount = resolveDepositAmount(record);
  if (units == null || units <= 0 || amount == null) {
    return null;
  }
  return amount / units;
}
