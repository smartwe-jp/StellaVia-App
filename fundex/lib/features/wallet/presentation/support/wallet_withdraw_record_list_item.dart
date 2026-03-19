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
  });

  final WalletWithdrawRecord record;
  final NumberFormat formatter;
  final bool showPaidTime;

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
    );
  }
}
