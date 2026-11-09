import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../investment/presentation/support/fund_project_status_style.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/support/fund_project_gain_type_label.dart';
import '../../../investment/presentation/support/fund_project_yield_display.dart';

FundFeaturedFundCardData buildHomeFeaturedFundCardData(
  BuildContext context,
  FundProject project,
) {
  final status = project.projectStatus;
  final statusTag = _buildStatusTag(context, status);
  final methodTag = _buildMethodTag(context, project.gainType);
  final metadata = _buildFeaturedMetadata(context, project);
  final locale = Localizations.localeOf(context);
  return FundFeaturedFundCardData(
    title: project.projectName,
    annualYield: resolveFundProjectYieldDisplay(project),
    periodValue: resolvePeriodValue(project),
    minimumInvestmentValue: resolveMinimumInvestmentText(
      context,
      project,
      locale,
    ),
    metadata: metadata,
    progress: _normalizeProgress(project.achievementRate),
    daysRemaining: _buildDaysRemainingLabel(context, project.daysRemaining),
    actionLabel: status == 1
        ? context.l10n.homeFeaturedFundApplyAction
        : context.l10n.homeFeaturedFundViewDetailAction,
    actionTone: status == 1
        ? FundFeaturedFundActionTone.apply
        : FundFeaturedFundActionTone.details,
    progressLabel: _formatProgressPercent(project.achievementRate),
    tags: <FundFeaturedFundTagData>[
      statusTag,
      if (methodTag != null) methodTag,
    ],
    artworkGradientColors: _featuredArtworkGradientColors(context, status),
    imageUrls: project.photos,
    onTap: () => context.push('/funds/${project.id}'),
  );
}

String _buildDaysRemainingLabel(BuildContext context, int? daysRemaining) {
  if (daysRemaining == 0) {
    return '';
  }
  return context.l10n.homeFeaturedFundRemainingDays(
    daysRemaining?.toString() ?? context.l10n.fundDetailUnknownValue,
  );
}

FundFeaturedFundTagData _buildStatusTag(BuildContext context, int? status) {
  final colors = fundProjectStatusColors(context, status);
  return FundFeaturedFundTagData(
    label: fundProjectStatusLabel(context.l10n, status),
    backgroundColor: colors.background,
    foregroundColor: colors.foreground,
  );
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
    backgroundColor: Theme.of(
      context,
    ).appColors.textPrimary.withValues(alpha: 0.68),
    foregroundColor: Theme.of(context).appColors.onDark.withValues(alpha: 0.92),
  );
}

List<Color> _featuredArtworkGradientColors(BuildContext context, int? status) {
  final colors = context.appColors;
  return switch (status) {
    4 => [colors.infoForeground, colors.primary],
    0 || 1 => [colors.brandPrimaryDark, colors.primary],
    7 => [colors.primaryAlt, colors.primary],
    2 => [colors.dangerForeground, colors.danger],
    _ => [colors.heroMiddle, colors.heroEnd],
  };
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
  return fundProjectStatusLabel(context.l10n, project.projectStatus);
}

double _normalizeProgress(double? ratio) {
  if (ratio == null) {
    return 0;
  }
  return ratio.clamp(0, 1).toDouble();
}

String _formatProgressPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio * 100;
  final truncated = (percentage * 100).truncate() / 100;
  final formatted = truncated
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'\.?0+$'), '');
  return '$formatted%';
}
