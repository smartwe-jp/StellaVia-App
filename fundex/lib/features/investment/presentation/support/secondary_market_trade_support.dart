import '../../../member_profile/domain/entities/mypage_models.dart';
import 'secondary_market_trade_models.dart';

SecondaryMarketBuySeed buildSecondaryMarketBuySeed(
  MyPageOrderInquiryRecord record,
) {
  return SecondaryMarketBuySeed(
    orderId: record.id ?? '',
    projectId: record.projectId ?? record.investorType?.projectId ?? '',
    projectName: record.projectName,
    availableUnits: remainingUnitsForSecondaryMarketRecord(record),
    unitPrice: (record.price ?? 0).toInt(),
    investorCode: record.investorType?.investorCode,
    earningRatio: record.investorType?.earningsRadio,
    pdfDocuments: record.pdfDocuments,
  );
}

bool canBuySecondaryMarketRecord(MyPageOrderInquiryRecord record) {
  return (record.id?.trim().isNotEmpty ?? false) &&
      remainingUnitsForSecondaryMarketRecord(record) > 0;
}

int remainingUnitsForSecondaryMarketRecord(MyPageOrderInquiryRecord record) {
  final sell = record.sellNum ?? 0;
  final sold = record.soldNum ?? 0;
  final remaining = sell - sold;
  return remaining < 0 ? 0 : remaining;
}
