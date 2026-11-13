import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';

import 'secondary_market_marketplace_presenter.dart';

FundSecondaryMarketCardData buildSecondaryMarketCardData(
  BuildContext context,
  MyPageOrderInquiryRecord record,
  NumberFormat formatter,
  VoidCallback onTap,
) {
  final theme = Theme.of(context);
  final colors = theme.appColors;
  final investorCode = record.investorType?.investorCode?.trim();
  final sellNum = record.sellNum ?? 0;
  final soldNum = record.soldNum ?? 0;
  final progress = sellNum <= 0 ? 0.0 : soldNum / sellNum;

  return FundSecondaryMarketCardData(
    title: record.projectName,
    statusLabel: context.l10n.homeFreeMarketStatusListed,
    statusBackgroundColor: colors.primary,
    statusForegroundColor: colors.onDark,
    annualYield: formatSecondaryMarketRatio(record.investorType?.earningsRadio),
    investorTypeLabel: investorCode != null && investorCode.isNotEmpty
        ? investorCode
        : '--',
    soldUnitsLabel:
        '${soldNum.toString()} / ${sellNum.toString()}${context.l10n.myPageResaleUnitsSuffix}',
    unitPriceLabel: formatter.format(record.price ?? 0),
    progress: progress.clamp(0, 1),
    onTap: (record.id == null || record.id!.trim().isEmpty) ? null : onTap,
  );
}
