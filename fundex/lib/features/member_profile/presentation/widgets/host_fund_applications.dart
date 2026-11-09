import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/mypage_models.dart';
import '../providers/host_fund_management_providers.dart';
import '../providers/mypage_providers.dart';
import '../support/host_fund_management.dart';
import '../support/mypage_withdraw_action.dart';
import 'host_fund_content.dart';
import 'host_fund_bank_sheet.dart';

class HostFundApplications extends ConsumerStatefulWidget {
  const HostFundApplications({super.key, required this.pending});
  final bool pending;
  @override
  ConsumerState<HostFundApplications> createState() => _ApplicationsState();
}

class _ApplicationsState extends ConsumerState<HostFundApplications> {
  int page = 1;
  String? cancelling;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final query = (status: widget.pending ? 2 : 0, page: page);
    final provider = hostFundApplicationsProvider(query);
    return HostFundContent(
      state: ref.watch(provider),
      retry: () => ref.invalidate(provider),
      builder: (data) {
        final pages = (data.total / 10).ceil();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (data.rows.isEmpty)
              HostFundEmpty(
                widget.pending
                    ? l.hostManageFundEmptyPending
                    : l.hostManageFundEmptyApplying,
              ),
            for (final record in data.rows)
              _ApplicationCard(
                record: record,
                pending: widget.pending,
                cancel: cancelling != null ? null : () => _cancel(record),
              ),
            if (pages > 1 || page > 1)
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  TextButton(
                    onPressed: page > 1 ? () => setState(() => page--) : null,
                    child: Text(l.myPageMilesHistoryPrev),
                  ),
                  Text('$page / ${pages == 0 ? 1 : pages}'),
                  TextButton(
                    onPressed: page < pages
                        ? () => setState(() => page++)
                        : null,
                    child: Text(l.myPageMilesHistoryNext),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Future<void> _cancel(MyPageApplyRecord record) async {
    final id = record.processId;
    if (id == null || id.isEmpty || cancelling != null) return;
    setState(() => cancelling = id);
    try {
      await confirmAndSubmitMyPageWithdraw(
        context,
        ref,
        processId: id,
        confirmBody: context.l10n.myPageWithdrawApplyConfirmBody,
        onSuccessRefresh: () async {
          if (!mounted) return;
          ref.invalidate(hostFundApplicationsProvider);
          ref.invalidate(myPageHomeApplySectionProvider);
          ref.invalidate(myPagePendingApplyListProvider);
          ref.invalidate(myPageApplyListProvider);
          setState(() => page = 1);
        },
      );
    } finally {
      if (mounted) setState(() => cancelling = null);
    }
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({
    required this.record,
    required this.pending,
    required this.cancel,
  });
  final MyPageApplyRecord record;
  final bool pending;
  final VoidCallback? cancel;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        locale = Localizations.localeOf(context).toLanguageTag();
    final raw = record.period?.trim() ?? '';
    final period = raw.isEmpty
        ? fundPeriod(record.startDate, record.endDate)
        : num.tryParse(raw) == null
        ? raw
        : '$raw ${l.hostManageFundMonthUnit}';
    final id = record.projectId?.trim();
    return FundMyPageProjectCard(
      title: record.projectName,
      accentColor: context.appColors.primary,
      onTap: id == null || id.isEmpty
          ? null
          : () => context.push('/funds/${Uri.encodeComponent(id)}'),
      rows: [
        if (!pending) ...[
          FundLabeledValue(
            label: l.hostManageFundYield,
            value: applyYield(record, l),
          ),
          FundLabeledValue(
            label: l.hostManageFundPeriod,
            value: period.isEmpty ? '—' : period,
          ),
        ],
        FundLabeledValue(
          label: l.hostManageFundApplyUnits,
          value:
              '${fundMoney(record.applyNum, locale)} ${l.lotteryApplyStep1UnitSuffix}',
        ),
        FundLabeledValue(
          label: l.hostManageFundApplyAmount,
          value:
              '${fundMoney(record.applyMoney, locale)} ${l.myPageChartYenUnit}',
        ),
        if (pending)
          FundLabeledValue(
            label: l.hostManageFundDepositDue,
            value: fundDate(
              record.transferDeadline ?? record.paymentExpiryDate,
            ),
          ),
      ],
      footer: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (pending)
            OutlinedButton(
              onPressed: () => AppBottomSheet.showAdaptive(
                context: context,
                useRootNavigator: true,
                builder: (_) => HostFundBankSheet(projectId: id),
              ),
              child: Text(l.hostManageFundBankConfirm),
            ),
          if ((record.status == 0 || record.status == 2) &&
              record.processId?.trim().isNotEmpty == true)
            OutlinedButton(
              onPressed: cancel,
              child: Text(l.myPageCancelRequestAction),
            ),
        ],
      ),
    );
  }
}
