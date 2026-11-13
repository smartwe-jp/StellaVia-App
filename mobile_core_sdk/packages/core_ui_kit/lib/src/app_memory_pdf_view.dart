import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

/// Displays private PDFs from memory without writing a shared file.
class AppMemoryPdfView extends StatefulWidget {
  const AppMemoryPdfView({
    super.key,
    required this.load,
    required this.errorLabel,
    required this.retryLabel,
    this.onLoaded,
  });
  final Future<Uint8List> Function() load;
  final String errorLabel, retryLabel;
  final VoidCallback? onLoaded;
  @override
  State<AppMemoryPdfView> createState() => _PdfState();
}

class _PdfState extends State<AppMemoryPdfView> {
  PdfDocument? document;
  PdfController? controller;
  bool failed = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final next = await PdfDocument.openData(await widget.load());
      if (!mounted) {
        await next.close();
        return;
      }
      document = next;
      setState(() => controller = PdfController(document: Future.value(next)));
    } catch (_) {
      if (mounted) setState(() => failed = true);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    document?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (failed) {
      return Center(
        child: TextButton(
          onPressed: () {
            setState(() => failed = false);
            load();
          },
          child: Text('${widget.errorLabel} ${widget.retryLabel}'),
        ),
      );
    }
    final pdf = controller;
    if (pdf == null) return const Center(child: CircularProgressIndicator());
    return PdfView(
      controller: pdf,
      scrollDirection: Axis.vertical,
      onDocumentLoaded: (_) => widget.onLoaded?.call(),
    );
  }
}
