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
  AppSemanticColorTheme colors,
) {
  final status = record.payStatus ?? record.status;
  if (status != null) {
    return switch (status) {
      0 => WalletWithdrawStatusPresentation(
        label: l10n.walletWithdrawRecordStatusUnpaid,
        backgroundColor: colors.warningSubtle,
        foregroundColor: colors.warningForeground,
      ),
      1 => WalletWithdrawStatusPresentation(
        label: l10n.walletWithdrawRecordStatusPaid,
        backgroundColor: colors.successSubtle,
        foregroundColor: colors.successForeground,
      ),
      2 => WalletWithdrawStatusPresentation(
        label: l10n.walletWithdrawRecordStatusFailedUnconfirmed,
        backgroundColor: colors.dangerSubtle,
        foregroundColor: colors.dangerForeground,
      ),
      3 => WalletWithdrawStatusPresentation(
        label: l10n.walletWithdrawRecordStatusFailedConfirmed,
        backgroundColor: colors.dangerSoft,
        foregroundColor: colors.dangerForeground,
      ),
      4 => WalletWithdrawStatusPresentation(
        label: l10n.walletWithdrawRecordStatusRevoked,
        backgroundColor: colors.surfaceAlt,
        foregroundColor: colors.textSecondary,
      ),
      _ => WalletWithdrawStatusPresentation(
        label: l10n.walletWithdrawRecordStatusUnknown,
        backgroundColor: colors.surfaceAlt,
        foregroundColor: colors.textSecondary,
      ),
    };
  }

  return WalletWithdrawStatusPresentation(
    label: l10n.walletWithdrawRecordStatusUnknown,
    backgroundColor: colors.surfaceAlt,
    foregroundColor: colors.textSecondary,
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
