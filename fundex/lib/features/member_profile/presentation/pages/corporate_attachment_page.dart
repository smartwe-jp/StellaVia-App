import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_documents.dart';
import '../providers/verification_entry_provider.dart';

class CorporateAttachmentPage extends ConsumerWidget {
  const CorporateAttachmentPage({super.key, required this.file});
  final CorporateAttachment file;
  static void open(BuildContext context, CorporateAttachment file) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CorporateAttachmentPage(file: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = corporateAttachmentProvider(file.url), l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(file.filename)),
      body: SafeArea(
        child: ref
            .watch(provider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(provider),
                  child: Text('${l.uiErrorRequestFailed}　${l.commonRetry}'),
                ),
              ),
              data: (bytes) {
                final pdf =
                    bytes.length >= 5 &&
                    String.fromCharCodes(bytes.take(5)) == '%PDF-';
                if (pdf) {
                  return AppMemoryPdfView(
                    load: () async => bytes,
                    errorLabel: l.pdfViewerLoadFailedLabel,
                    retryLabel: l.commonRetry,
                  );
                }
                return Center(
                  child: InteractiveViewer(
                    maxScale: 5,
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.contain,
                      semanticLabel: file.filename,
                      errorBuilder: (_, _, _) =>
                          Text(l.imageViewerLoadFailedLabel),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
