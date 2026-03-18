import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/wallet_withdraw_record.dart';

class WalletWithdrawStatusPresentation {
  const WalletWithdrawStatusPresentation({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
}

String resolveWithdrawTypeLabel(AppLocalizations l10n, int? withdrawType) {
  return switch (withdrawType) {
    0 => l10n.walletWithdrawRecordTypeBankTransfer,
    1 => l10n.walletWithdrawRecordTypeCash,
    2 => l10n.walletWithdrawRecordTypeGentlePay,
    _ => l10n.walletWithdrawRecordTypeBankTransfer,
  };
}

WalletWithdrawStatusPresentation resolveWithdrawStatusPresentation(
  AppLocalizations l10n,
  WalletWithdrawRecord record,
) {
  final payStatus = record.payStatus;
  final status = record.status;
  final isPending = payStatus == 0 || status == 0;
  if (isPending) {
    return WalletWithdrawStatusPresentation(
      label: l10n.walletWithdrawRecordStatusPending,
      backgroundColor: const Color(0xFFFFF4E5),
      foregroundColor: const Color(0xFFB45309),
    );
  }

  final isDone = payStatus == 1 || status == 1;
  if (isDone) {
    return WalletWithdrawStatusPresentation(
      label: l10n.walletWithdrawRecordStatusDone,
      backgroundColor: const Color(0xFFE8F5E9),
      foregroundColor: const Color(0xFF2E7D32),
    );
  }

  return WalletWithdrawStatusPresentation(
    label: l10n.walletWithdrawRecordStatusUnknown,
    backgroundColor: const Color(0xFFE2E8F0),
    foregroundColor: AppColorTokens.fundexTextSecondary,
  );
}

String formatWalletDateTime(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '--';
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return value;
  }
  final y = parsed.year.toString().padLeft(4, '0');
  final m = parsed.month.toString().padLeft(2, '0');
  final d = parsed.day.toString().padLeft(2, '0');
  final h = parsed.hour.toString().padLeft(2, '0');
  final min = parsed.minute.toString().padLeft(2, '0');
  return '$y/$m/$d $h:$min';
}

String formatWalletCurrency(NumberFormat formatter, num? value) {
  if (value == null) {
    return '--';
  }
  return formatter.format(value);
}

String formatWalletMaskedBankNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '--';
  }
  final digits = value.replaceAll(RegExp(r'\s+'), '');
  if (digits.length <= 4) {
    return digits;
  }
  final tail = digits.substring(digits.length - 4);
  return '**** $tail';
}
