import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/wallet_withdraw_record.dart';
import 'wallet_withdraw_record_presenter.dart';
import 'wallet_withdraw_record_widgets.dart';

class WalletWithdrawRecordListItem extends StatelessWidget {
  const WalletWithdrawRecordListItem({
    super.key,
    required this.record,
    required this.formatter,
    required this.showPaidTime,
    this.onCancel,
    this.isCancelling = false,
  });

  final WalletWithdrawRecord record;
  final NumberFormat formatter;
  final bool showPaidTime;
  final VoidCallback? onCancel;
  final bool isCancelling;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = resolveWithdrawStatusPresentation(
      l10n,
      record,
      Theme.of(context).appColors,
    );

    final rows = <WalletWithdrawRecordDetailRow>[
      WalletWithdrawRecordDetailRow(
        label: l10n.walletWithdrawRecordApplyTimeLabel,
        value: formatWalletDateTime(record.applyTime ?? record.createTime),
      ),
      WalletWithdrawRecordDetailRow(
        label: l10n.walletWithdrawRecordFeeLabel,
        value: formatWalletCurrency(formatter, record.cost),
      ),
      WalletWithdrawRecordDetailRow(
        label: l10n.walletWithdrawRecordBankNumberLabel,
        value: formatWalletMaskedBankNumber(record.bankNumber),
      ),
    ];

    final booked = record.bookDate;
    if (booked != null && booked.trim().isNotEmpty) {
      rows.add(
        WalletWithdrawRecordDetailRow(
          label: l10n.walletWithdrawRecordBookedTimeLabel,
          value: formatWalletDateTime(booked),
        ),
      );
    }
    if (showPaidTime) {
      rows.add(
        WalletWithdrawRecordDetailRow(
          label: l10n.walletWithdrawRecordPaidTimeLabel,
          value: formatWalletDateTime(record.payTime ?? record.updateTime),
        ),
      );
    }

    return WalletWithdrawRecordCard(
      typeLabel: resolveWithdrawTypeLabel(l10n, record.withdrawType),
      statusLabel: status.label,
      statusBackgroundColor: status.backgroundColor,
      statusForegroundColor: status.foregroundColor,
      amountText: formatWalletCurrency(formatter, record.amount),
      details: rows,
      note: record.remark,
      headerAction: _buildHeaderAction(context),
    );
  }

  Widget? _buildHeaderAction(BuildContext context) {
    if (record.payStatus != 0 || onCancel == null) {
      return null;
    }
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return OutlinedButton(
      onPressed: isCancelling ? null : onCancel,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.danger,
        side: BorderSide(color: colors.dangerBorder),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: isCancelling
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colors.danger),
              ),
            )
          : Text(
              context.l10n.walletWithdrawCancelAction,
              style: appText.micro.copyWith(color: colors.danger),
            ),
    );
  }
}
