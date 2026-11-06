import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../support/secondary_market_card_mapper.dart';

class SecondaryMarketMarketplaceCard extends StatelessWidget {
  const SecondaryMarketMarketplaceCard({
    super.key,
    required this.record,
    required this.onTap,
    this.width = double.infinity,
  });
  final MyPageOrderInquiryRecord record;
  final VoidCallback onTap;
  final double width;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FundSecondaryMarketCard(
      width: width,
      data: buildSecondaryMarketCardData(
        context,
        record,
        NumberFormat.currency(symbol: '¥', decimalDigits: 0),
        onTap,
      ),
      actionLabel: l.secondaryMarketBuyAction,
      yieldLabel: l.homeEstimatedYieldLabel,
      soldUnitsTitle: l.homeFreeMarketSoldUnitsLabel,
      unitPriceTitle: l.homeFreeMarketUnitPriceLabel,
    );
  }
}
