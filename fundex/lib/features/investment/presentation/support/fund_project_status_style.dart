import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

typedef FundStatusColors = ({Color background, Color foreground});

const _endedGray = Color(0xFF979797);

FundStatusColors fundProjectStatusColors(BuildContext context, int? status) {
  final colors = context.appColors;
  return switch (status) {
    0 => (
      background: AppColorTokens.brandBaseCream,
      foreground: AppColorTokens.brandPurple,
    ),
    1 => (
      background: AppColorTokens.brandPurple,
      foreground: AppColorTokens.brandWhite,
    ),
    4 => (
      background: AppColorTokens.brandNavy,
      foreground: AppColorTokens.brandWhite,
    ),
    // The API also distinguishes successful completion of recruitment (7).
    3 ||
    5 ||
    7 => (background: _endedGray, foreground: AppColorTokens.brandWhite),
    2 => (background: colors.dangerSubtle, foreground: colors.dangerForeground),
    _ => (background: colors.surfaceAlt, foreground: colors.textSecondary),
  };
}

String fundProjectStatusLabel(AppLocalizations l10n, int? status) =>
    switch (status) {
      0 => l10n.fundListStatusUpcoming,
      1 => l10n.fundListStatusOpen,
      2 => l10n.fundListStatusFailed,
      3 => l10n.fundListStatusClosed,
      4 => l10n.fundListStatusOperating,
      5 => l10n.fundListStatusOperatingEnded,
      7 => l10n.fundListStatusCompleted,
      _ => l10n.fundListStatusUnknown,
    };
