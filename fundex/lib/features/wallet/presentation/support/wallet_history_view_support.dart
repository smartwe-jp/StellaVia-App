import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/wallet_account_history.dart';

enum WalletHistoryVisualType { deposit, withdraw, bonus, dividend, unknown }

bool? parseWalletHistoryInflowFlag(String? inOut) {
  final value = inOut?.trim();
  if (value == null || value.isEmpty) {
    return null;
  }
  final normalized = value.toLowerCase();
  if (value == '收' ||
      value == '収' ||
      normalized == 'in' ||
      normalized == 'income') {
    return true;
  }
  if (value == '支' ||
      value == '出' ||
      normalized == 'out' ||
      normalized == 'expense') {
    return false;
  }
  return null;
}

WalletHistoryVisualType resolveWalletHistoryVisualType(
  WalletAccountHistory item,
) {
  final isIncome = parseWalletHistoryInflowFlag(item.inOut);
  final text = <String?>[
    item.tradeType,
    item.typeName,
    item.remark,
  ].whereType<String>().join(' ').toLowerCase();

  final isBonus =
      text.contains('bonus') || text.contains('ボーナス') || text.contains('特典');
  if (isBonus) {
    return WalletHistoryVisualType.bonus;
  }

  final isDividend =
      text.contains('dividend') ||
      text.contains('benefit') ||
      text.contains('分配');
  if (isDividend) {
    return WalletHistoryVisualType.dividend;
  }

  if (isIncome == true) {
    return WalletHistoryVisualType.deposit;
  }
  if (isIncome == false) {
    return WalletHistoryVisualType.withdraw;
  }
  return WalletHistoryVisualType.unknown;
}

String resolveWalletHistoryDisplayTitle(
  AppLocalizations l10n,
  WalletAccountHistory item,
) {
  final remark = item.remark?.trim() ?? '';
  if (remark.isNotEmpty) {
    return remark;
  }

  final isIncome = parseWalletHistoryInflowFlag(item.inOut);
  if (isIncome == null) {
    return l10n.walletHistoryUnknownType;
  }
  return isIncome
      ? l10n.walletHistoryFilterDeposit
      : l10n.walletHistoryFilterWithdraw;
}

String formatWalletHistoryAmountText({
  required WalletAccountHistory item,
  required NumberFormat formatter,
}) {
  final amount = item.amount ?? item.money;
  if (amount == null) {
    return '--';
  }
  final value = amount.abs();
  final isIncome = parseWalletHistoryInflowFlag(item.inOut);
  final sign = isIncome == null ? '' : (isIncome ? '+' : '-');
  return '$sign${formatter.format(value)}';
}

String formatWalletHistoryDateText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '--';
  }
  final parsed = parseWalletHistoryDate(value);
  if (parsed == null) {
    return value;
  }
  return DateFormat('yyyy/MM/dd').format(parsed);
}

Color resolveWalletHistoryAmountColor(
  BuildContext context,
  WalletAccountHistory item,
) {
  final colors = Theme.of(context).appColors;
  final visualType = resolveWalletHistoryVisualType(item);
  return switch (visualType) {
    WalletHistoryVisualType.withdraw => colors.danger,
    WalletHistoryVisualType.deposit ||
    WalletHistoryVisualType.bonus ||
    WalletHistoryVisualType.dividend => colors.successForeground,
    WalletHistoryVisualType.unknown => colors.textSecondary,
  };
}

Color resolveWalletHistoryIndicatorColor(
  BuildContext context,
  WalletAccountHistory item,
) {
  final colors = Theme.of(context).appColors;
  final visualType = resolveWalletHistoryVisualType(item);
  return switch (visualType) {
    WalletHistoryVisualType.withdraw => colors.danger,
    WalletHistoryVisualType.deposit => colors.successForeground,
    WalletHistoryVisualType.bonus ||
    WalletHistoryVisualType.dividend => colors.highlightGold,
    WalletHistoryVisualType.unknown => colors.textSecondary.withValues(
      alpha: 0.55,
    ),
  };
}

DateTime? parseWalletHistoryDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  final normalized = raw.trim().replaceAll(' ', 'T');
  return DateTime.tryParse(normalized);
}

int compareWalletHistoryByDateDesc(
  WalletAccountHistory left,
  WalletAccountHistory right,
) {
  final leftDate = parseWalletHistoryDate(left.tradeTime ?? left.createTime);
  final rightDate = parseWalletHistoryDate(right.tradeTime ?? right.createTime);

  if (leftDate == null && rightDate == null) {
    return 0;
  }
  if (leftDate == null) {
    return 1;
  }
  if (rightDate == null) {
    return -1;
  }
  return rightDate.compareTo(leftDate);
}
