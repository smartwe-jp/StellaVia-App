import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/support/fund_project_gain_type_label.dart';
import '../../../investment/presentation/support/fund_project_yield_display.dart';

FundFeaturedFundCardData buildHomeFeaturedFundCardData(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final status = project.projectStatus;
  final statusTag = _buildStatusTag(context, status);
  final methodTag = _buildMethodTag(context, project.gainType);
  final metadata = _buildFeaturedMetadata(context, project);

  return FundFeaturedFundCardData(
    title: project.projectName,
    annualYield: resolveFundProjectYieldDisplay(project),
    metadata: metadata,
    progress: _normalizeProgress(project.achievementRate),
    progressLabel: _buildProgressLabel(context, project, currencyFormatter),
    tags: <FundFeaturedFundTagData>[
      statusTag,
      if (methodTag != null) methodTag,
    ],
    artworkGradientColors: _featuredArtworkGradientColors(context, status),
    imageUrls: project.photos,
    onTap: () => context.push('/funds/${project.id}'),
  );
}

FundFeaturedFundTagData _buildStatusTag(BuildContext context, int? status) {
  final palette = _resolveFeaturedStatusPalette(context, status);
  switch (status) {
    case 7:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusCompleted,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 5:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOperatingEnded,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 1:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOpen,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 0:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusUpcoming,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 4:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusOperating,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 3:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusClosed,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    case 2:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusFailed,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
    default:
      return FundFeaturedFundTagData(
        label: context.l10n.fundListStatusUnknown,
        backgroundColor: palette.tagBackgroundColor,
        foregroundColor: palette.tagForegroundColor,
      );
  }
}

FundFeaturedFundTagData? _buildMethodTag(
  BuildContext context,
  String? gainType,
) {
  final label = resolveFundProjectGainTypeLabel(context, gainType).trim();
  if (label.isEmpty) {
    return null;
  }
  return FundFeaturedFundTagData(
    label: label,
    backgroundColor: Theme.of(context).appColors.onDark.withValues(alpha: 0.14),
    foregroundColor: Theme.of(context).appColors.onDark.withValues(alpha: 0.92),
  );
}

List<Color> _featuredArtworkGradientColors(BuildContext context, int? status) {
  return _resolveFeaturedStatusPalette(context, status).gradientColors;
}

_FeaturedFundStatusPalette _resolveFeaturedStatusPalette(
  BuildContext context,
  int? status,
) {
  final colors = Theme.of(context).appColors;

  switch (status) {
    case 4:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.infoForeground, colors.primary],
        tagBackgroundColor: colors.infoSubtle,
        tagForegroundColor: colors.infoForeground,
      );
    case 5:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
        tagBackgroundColor: colors.surfaceAlt,
        tagForegroundColor: colors.textSecondary,
      );
    case 1:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.brandPrimaryDark, colors.primary],
        tagBackgroundColor: colors.highlightGold,
        tagForegroundColor: colors.onDark,
      );
    case 0:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.brandPrimaryDark, colors.primary],
        tagBackgroundColor: colors.surface,
        tagForegroundColor: colors.primary,
      );
    case 3:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
        tagBackgroundColor: colors.surfaceAlt,
        tagForegroundColor: colors.textSecondary,
      );
    case 7:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.primaryAlt, colors.primary],
        tagBackgroundColor: colors.primarySubtle,
        tagForegroundColor: colors.primary,
      );
    case 2:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.dangerForeground, colors.danger],
        tagBackgroundColor: colors.dangerSubtle,
        tagForegroundColor: colors.dangerForeground,
      );
    default:
      return _FeaturedFundStatusPalette(
        gradientColors: <Color>[colors.heroMiddle, colors.heroEnd],
        tagBackgroundColor: colors.surfaceAlt,
        tagForegroundColor: colors.textSecondary,
      );
  }
}

class _FeaturedFundStatusPalette {
  const _FeaturedFundStatusPalette({
    required this.gradientColors,
    required this.tagBackgroundColor,
    required this.tagForegroundColor,
  });

  final List<Color> gradientColors;
  final Color tagBackgroundColor;
  final Color tagForegroundColor;
}

String _buildFeaturedMetadata(BuildContext context, FundProject project) {
  final company = project.operatingCompany?.trim();
  if (company != null && company.isNotEmpty) {
    return company;
  }
  final period = project.investmentPeriod?.trim();
  if (period != null && period.isNotEmpty) {
    return period;
  }
  return _resolveStatusLabel(context, project.projectStatus);
}

String _buildProgressLabel(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  if (project.projectStatus == 0) {
    final openDate =
        _parseDateTime(project.offeringStartDatetime) ??
        _parseDateTime(project.scheduledStartDate);
    if (openDate != null) {
      return context.l10n.fundListOpenStartAt(
        _formatDateForLocale(openDate, Localizations.localeOf(context)),
      );
    }
  }

  final amount = _formatCurrency(
    project.currentlySubscribed ?? project.amountApplication,
    currencyFormatter,
  );
  return context.l10n.fundListAppliedAmount(
    amount,
    _formatProgressPercent(project.achievementRate),
  );
}

String _resolveStatusLabel(BuildContext context, int? status) {
  final l10n = context.l10n;
  switch (status) {
    case 4:
      return l10n.fundListStatusOperating;
    case 5:
      return l10n.fundListStatusOperatingEnded;
    case 1:
      return l10n.fundListStatusOpen;
    case 0:
      return l10n.fundListStatusUpcoming;
    case 3:
      return l10n.fundListStatusClosed;
    case 7:
      return l10n.fundListStatusCompleted;
    case 2:
      return l10n.fundListStatusFailed;
    default:
      return l10n.fundListStatusUnknown;
  }
}

double _normalizeProgress(double? ratio) {
  if (ratio == null) {
    return 0;
  }
  if (ratio < 0) {
    return 0;
  }
  return ratio > 1 ? ratio / 100 : ratio;
}

String _formatProgressPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio * 100;
  final truncated = (percentage * 100).truncate() / 100;
  return '${truncated.toStringAsFixed(2)}%';
}

String _formatCurrency(int? amount, NumberFormat formatter) {
  if (amount == null) {
    return '-';
  }
  return formatter.format(amount);
}

DateTime? _parseDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  final normalized = raw.trim().replaceAll(' ', 'T');
  return DateTime.tryParse(normalized);
}

String _formatDateForLocale(DateTime value, Locale locale) {
  final languageCode = locale.languageCode;
  if (languageCode == 'ja') {
    return DateFormat.yMMMMd('ja').format(value);
  }
  if (languageCode == 'zh') {
    return DateFormat.yMd('zh').format(value);
  }
  return DateFormat.yMMMd(locale.toLanguageTag()).format(value);
}
