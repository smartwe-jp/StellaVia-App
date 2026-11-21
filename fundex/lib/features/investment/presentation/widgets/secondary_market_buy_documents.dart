import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../support/secondary_market_trade_models.dart';

String tradeDocumentTitle(AppLocalizations l10n, int type) => switch (type) {
  1 => l10n.memberProfileElectronicDeliveryItem1,
  3 => l10n.memberProfileElectronicDeliveryItem2,
  2 => l10n.secondaryMarketElectronicTradeDocument,
  _ => throw ArgumentError.value(type),
};

class SecondaryMarketBuyDocuments extends StatelessWidget {
  const SecondaryMarketBuyDocuments({
    super.key,
    required this.documents,
    required this.opened,
    required this.checked,
    required this.onOpened,
    required this.onChanged,
    required this.retry,
  });

  final List<TradeDocument> documents;
  final Set<TradeDocument> opened;
  final Set<TradeDocument> checked;
  final ValueChanged<TradeDocument> onOpened;
  final void Function(TradeDocument, bool) onChanged;
  final VoidCallback retry;

  Future<void> _open(
    BuildContext context,
    TradeDocument doc,
    String title,
  ) async {
    final l = context.l10n;
    await openAppPdfViewer(
      context,
      url: doc.url,
      title: title,
      texts: AppPdfViewerTexts(
        pageTitle: l.pdfViewerPageTitle,
        openExternalTooltip: l.pdfViewerOpenExternalTooltip,
        openExternalLabel: l.pdfViewerOpenExternalLabel,
        loadingLabel: l.pdfViewerLoadingLabel,
        loadFailedLabel: l.pdfViewerLoadFailedLabel,
        retryLabel: l.fundListRetry,
        invalidUrlNotice: l.pdfViewerInvalidUrlNotice,
        openExternalFailedNotice: l.pdfViewerOpenExternalFailedNotice,
      ),
    );
    if (context.mounted) onOpened(doc);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.secondaryMarketBuyAgreementSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(l.lotteryApplyStep2Description),
          for (final type in tradeDocumentTypes) ...[
            const SizedBox(height: 12),
            Text(
              tradeDocumentTitle(l, type),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (!documents.any((doc) => doc.type == type))
              Text(l.fundDetailDocumentUnavailable),
            for (final doc in documents.where((doc) => doc.type == type))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                  value: checked.contains(doc),
                  semanticLabel: doc.name.isEmpty
                      ? tradeDocumentTitle(l, type)
                      : doc.name,
                  onChanged: opened.contains(doc)
                      ? (value) => onChanged(doc, value == true)
                      : null,
                ),
                title: Text(
                  doc.name.isEmpty ? tradeDocumentTitle(l, type) : doc.name,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _open(
                  context,
                  doc,
                  doc.name.isEmpty ? tradeDocumentTitle(l, type) : doc.name,
                ),
              ),
          ],
          if (!hasAllTradeDocumentTypes(documents))
            TextButton(onPressed: retry, child: Text(l.commonRetry)),
        ],
      ),
    );
  }
}
