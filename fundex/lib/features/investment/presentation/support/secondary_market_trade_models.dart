import '../../../member_profile/domain/entities/mypage_models.dart';

class SecondaryMarketBuySeed {
  const SecondaryMarketBuySeed({
    required this.orderId,
    required this.projectId,
    required this.projectName,
    required this.availableUnits,
    required this.unitPrice,
    this.investorCode,
    this.earningRatio,
    this.pdfDocuments = const <MyPagePdfDocument>[],
  });

  final String orderId;
  final String projectId;
  final String projectName;
  final int availableUnits;
  final int unitPrice;
  final String? investorCode;
  final double? earningRatio;
  final List<MyPagePdfDocument> pdfDocuments;
}

class SecondaryMarketBuyDraft {
  const SecondaryMarketBuyDraft({
    required this.orderId,
    required this.projectId,
    required this.projectName,
    required this.availableUnits,
    required this.buyNum,
    required this.unitPrice,
    this.investorCode,
    this.earningRatio,
    this.feeRate = 0.0165,
    this.agreed = false,
    this.sampleDocumentUrl,
  });

  final String orderId;
  final String projectId;
  final String projectName;
  final int availableUnits;
  final int buyNum;
  final int unitPrice;
  final String? investorCode;
  final double? earningRatio;
  final double feeRate;
  final bool agreed;
  final String? sampleDocumentUrl;

  num get totalAmount => buyNum * unitPrice;

  num get feeAmount => totalAmount * feeRate;

  num get paymentAmount => totalAmount + feeAmount;
}
