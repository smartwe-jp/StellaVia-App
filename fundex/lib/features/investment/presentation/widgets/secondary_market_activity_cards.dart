import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/support/mypage_section_support.dart';
import '../../../member_profile/presentation/support/host_fund_management.dart';
import '../../../member_profile/presentation/widgets/host_fund_bank_sheet.dart';
import '../support/secondary_market_status.dart';
import '../support/secondary_market_marketplace_presenter.dart';
import 'secondary_market_contract_actions.dart';

String _price(BuildContext context, num? value) => value == null
    ? '—'
    : NumberFormat.currency(
        locale: Localizations.localeOf(context).toLanguageTag(),
        symbol: '¥',
        decimalDigits: 0,
      ).format(value);

class SecondaryMarketApplicationCard extends StatelessWidget {
  const SecondaryMarketApplicationCard({
    super.key,
    required this.record,
    this.seller = false,
    this.showPayment = false,
    this.showApplicationTime = true,
    this.onContract,
    this.onTap,
    this.onCancel,
  });
  final MyPageApplyRecord record;
  final bool seller, showPayment, showApplicationTime;
  final ValueChanged<bool>? onContract;
  final VoidCallback? onTap, onCancel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = context.appTextTheme;
    final reviewing = isSecondaryContractUnderReview(record);
    final number = '${l.secondaryMarketProcessId}  ${record.processId ?? '—'}';
    final project = record.projectName.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              title: seller || project.isEmpty ? number : project,
              badge: reviewing
                  ? l.secondaryBuyerContractReview
                  : secondaryApplicationStatus(l, record.status),
              tone: reviewing || record.status == 2
                  ? AppBadgeTone.warning
                  : AppBadgeTone.neutral,
            ),
            if (!seller && project.isNotEmpty) Text(number, style: t.meta),
            if (!seller) ...[
              const SizedBox(height: 8),
              _Metrics(
                first: l.homeEstimatedYieldLabel,
                value: applyYield(record, l),
                second: l.hostManageFundPeriod,
                quantity: applicationPeriod(record, l),
                compact: true,
              ),
            ],
            _Metrics(
              first: seller
                  ? l.secondaryMarketBuyTotalAmountLabel
                  : l.hostManageFundApplyAmount,
              value: _price(context, record.applyMoney),
              second: seller
                  ? l.secondaryMarketBuyUnitsLabel
                  : l.hostManageFundApplyUnits,
              quantity: '${record.applyNum ?? 0} ${l.myPageResaleUnitsSuffix}',
            ),
            if (showApplicationTime)
              if (formatDateTimeOrNull(record.applyTime) case final time?)
                _Timestamp(label: l.myPageApplySubmittedAtLabel, time: time),
            if (onTap != null) ...[
              const Divider(),
              Row(
                children: [
                  if (hasSecondaryContract(record))
                    if (secondaryContractStatusLabel(l, record.ecStatus)
                        case final status?)
                      Expanded(
                        child: Text(
                          '${l.secondaryMarketContract} · $status',
                          style: t.meta.copyWith(color: t.link.color),
                        ),
                      ),
                  const Spacer(),
                  Text(
                    hasSecondaryContract(record)
                        ? l.secondaryContractProcedure
                        : l.secondaryMarketApplicationDetail,
                    style: t.link,
                  ),
                  Icon(Icons.chevron_right_rounded, color: t.link.color),
                ],
              ),
            ],
            if (onContract != null)
              SecondaryMarketContractActions(
                record: record,
                seller: seller,
                showPayment: showPayment,
                onOpen: onContract!,
              ),
            if (showPayment && !seller && record.status == 2 ||
                onCancel != null) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  if (showPayment && !seller && record.status == 2)
                    OutlinedButton(
                      onPressed: () => AppBottomSheet.showAdaptive(
                        context: context,
                        useRootNavigator: true,
                        builder: (_) =>
                            HostFundBankSheet(projectId: record.projectId),
                      ),
                      child: Text(l.hostManageFundBankConfirm),
                    ),
                  if (onCancel != null)
                    OutlinedButton(
                      onPressed: onCancel,
                      child: Text(l.secondaryMarketCancelApplication),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SecondaryMarketListingCard extends StatelessWidget {
  const SecondaryMarketListingCard({
    super.key,
    required this.record,
    required this.onTap,
    this.onCancel,
  });
  final MyPageOrderInquiryRecord record;
  final VoidCallback? onTap, onCancel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final active = record.status?.toUpperCase() == 'VALID';
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            title: record.projectName,
            badge: active
                ? l.secondaryMarketListingValid
                : l.secondaryMarketListingInvalid,
            tone: active ? AppBadgeTone.subtle : AppBadgeTone.neutral,
          ),
          _Metrics(
            first: l.myPageResaleUnitPriceLabel,
            value: _price(context, record.price),
            second: l.secondaryMarketSoldUnitsLabel,
            quantity:
                '${record.soldNum ?? 0} / ${record.sellNum ?? 0} ${l.myPageResaleUnitsSuffix}',
          ),
          _ExpectedYield(record.investorType?.earningsRadio),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l.secondaryListingNumber}  ${record.id ?? '—'}',
                  style: context.appTextTheme.meta,
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: context.appColors.textSecondary,
                ),
            ],
          ),
          if (formatDateTimeOrNull(record.createTime) case final time?)
            _Timestamp(label: l.secondaryListedAt, time: time),
          if (onCancel != null) ...[
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                label: l.secondaryMarketCancelListing,
                variant: AppButtonVariant.secondary,
                fullWidth: false,
                minHeight: UiTokens.controlHeight * 0.7,
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  foregroundColor: context.appTextTheme.link.color,
                  side: BorderSide(color: context.appTextTheme.link.color!),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Timestamp extends StatelessWidget {
  const _Timestamp({required this.label, required this.time});
  final String label, time;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text('$label  $time', style: context.appTextTheme.meta),
  );
}

class _ExpectedYield extends StatelessWidget {
  const _ExpectedYield(this.ratio);
  final double? ratio;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          context.l10n.homeEstimatedYieldLabel,
          style: context.appTextTheme.caption,
        ),
        Text(
          formatSecondaryMarketRatio(ratio),
          style: context.appTextTheme.numericBody,
        ),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.badge, required this.tone});
  final String title, badge;
  final AppBadgeTone tone;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Text(title, style: context.appTextTheme.cardTitle)),
      const SizedBox(width: 10),
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .4,
        ),
        child: AppStatusBadge(label: badge, tone: tone),
      ),
    ],
  );
}

class _Metrics extends StatelessWidget {
  const _Metrics({
    required this.first,
    required this.value,
    required this.second,
    required this.quantity,
    this.compact = false,
  });
  final String first, value, second, quantity;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final t = context.appTextTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(first, style: t.caption),
                Text(value, style: compact ? t.numericBody : t.numericTitle),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(second, style: t.caption),
                Text(quantity, style: t.numericBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
