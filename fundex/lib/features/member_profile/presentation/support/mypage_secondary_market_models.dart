import 'mypage_section_support.dart';

class MyPageSecondaryMarketSellSeed {
  const MyPageSecondaryMarketSellSeed({
    required this.projectId,
    required this.projectName,
    required this.fromProcessId,
    required this.availableUnits,
    this.initialUnitPrice,
    this.investorCode,
    this.earningRatio,
  });

  final String projectId;
  final String projectName;
  final String fromProcessId;
  final int availableUnits;
  final int? initialUnitPrice;
  final String? investorCode;
  final double? earningRatio;
}

class MyPageSecondaryMarketSellDraft {
  const MyPageSecondaryMarketSellDraft({
    required this.projectId,
    required this.projectName,
    required this.fromProcessId,
    required this.availableUnits,
    required this.sellNum,
    required this.price,
    this.investorCode,
    this.earningRatio,
    this.feeRate = 0.0165,
    this.agreed = false,
  });

  final String projectId;
  final String projectName;
  final String fromProcessId;
  final int availableUnits;
  final int sellNum;
  final int price;
  final String? investorCode;
  final double? earningRatio;
  final double feeRate;
  final bool agreed;

  num get totalAmount => sellNum * price;

  num get feeAmount => totalAmount * feeRate;

  num get netAmount => totalAmount - feeAmount;
}

/// Keep the sale attached to the exact record used to open the detail page.
MyPageSecondaryMarketSellSeed? buildDisplayedRecordSellSeed(
  MyPageActiveFundDetailSeed? record,
) {
  if (record == null || record.processId?.trim().isNotEmpty != true) {
    return null;
  }
  return MyPageSecondaryMarketSellSeed(
    projectId: record.projectId,
    projectName: record.projectName,
    fromProcessId: record.processId!,
    availableUnits: record.investNumRemaining ?? 0,
    investorCode: record.investorCode,
    earningRatio: record.earningRatio,
  );
}
