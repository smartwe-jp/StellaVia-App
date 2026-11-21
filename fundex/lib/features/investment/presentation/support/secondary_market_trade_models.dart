import '../../domain/entities/fund_project.dart';

class SecondaryMarketBuySeed {
  const SecondaryMarketBuySeed({
    required this.orderId,
    required this.projectId,
    required this.projectName,
    required this.availableUnits,
    required this.unitPrice,
    this.investorCode,
    this.earningRatio,
  });

  final String orderId;
  final String projectId;
  final String projectName;
  final int availableUnits;
  final int unitPrice;
  final String? investorCode;
  final double? earningRatio;
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
    required this.confirmedDocuments,
  });

  final String orderId;
  final String projectId;
  final String projectName;
  final int availableUnits;
  final int buyNum;
  final int unitPrice;
  final String? investorCode;
  final double? earningRatio;
  final List<TradeDocument> confirmedDocuments;

  num get totalAmount => buyNum * unitPrice;
}

typedef TradeDocument = ({int type, String url, String name, String version});

const tradeDocumentTypes = [1, 3, 2];

List<TradeDocument> requiredTradeDocuments(
  List<FundProjectPdfDocument> groups,
) {
  final documents = <TradeDocument>{};
  for (final type in tradeDocumentTypes) {
    for (final group in groups.where((group) => group.type == type)) {
      for (final file in group.urls) {
        final url = file.url?.trim() ?? '';
        final uri = Uri.tryParse(url);
        if (uri == null ||
            !uri.hasAuthority ||
            uri.host.isEmpty ||
            !(uri.isScheme('https') || uri.isScheme('http'))) {
          continue;
        }
        documents.add((
          type: type,
          url: url,
          name: file.name?.trim() ?? '',
          version: file.createTime ?? '',
        ));
      }
    }
  }
  return documents.toList(growable: false);
}

bool hasAllTradeDocumentTypes(List<TradeDocument> documents) =>
    tradeDocumentTypes.every(
      (type) => documents.any((doc) => doc.type == type),
    );
