import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppPdfViewerTexts {
  const AppPdfViewerTexts({
    this.pageTitle = 'PDF',
    this.openExternalTooltip = 'Open externally',
    this.openExternalLabel = 'Open externally',
    this.loadingLabel = 'Loading PDF...',
    this.loadFailedLabel = 'Failed to load PDF.',
    this.retryLabel = 'Retry',
    this.invalidUrlNotice = 'Invalid PDF URL.',
    this.openExternalFailedNotice = 'Unable to open the PDF.',
  });

  final String pageTitle;
  final String openExternalTooltip;
  final String openExternalLabel;
  final String loadingLabel;
  final String loadFailedLabel;
  final String retryLabel;
  final String invalidUrlNotice;
  final String openExternalFailedNotice;
}

Future<void> openAppPdfViewer(
  BuildContext context, {
  required String url,
  String? title,
  AppPdfViewerTexts texts = const AppPdfViewerTexts(),
  bool useRootNavigator = true,
  bool useGoogleDocsViewerOnAndroid = true,
}) async {
  debugPrint('Opening PDF viewer for URL: $url');
  final normalizedUrl = url.trim();
  final uri = Uri.tryParse(normalizedUrl);
  if (uri == null || (!uri.isScheme('https') && !uri.isScheme('http'))) {
    AppNotice.show(context, message: texts.invalidUrlNotice);
    return;
  }

  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  await navigator.push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => AppPdfViewerPage(
        pdfUri: uri,
        title: title?.trim().isNotEmpty == true
            ? title!.trim()
            : texts.pageTitle,
        texts: texts,
        useGoogleDocsViewerOnAndroid: useGoogleDocsViewerOnAndroid,
      ),
      settings: const RouteSettings(name: 'app_pdf_viewer'),
    ),
  );
}

class AppPdfViewerPage extends StatefulWidget {
  const AppPdfViewerPage({
    super.key,
    required this.pdfUri,
    required this.title,
    this.texts = const AppPdfViewerTexts(),
    this.useGoogleDocsViewerOnAndroid = true,
  });

  final Uri pdfUri;
  final String title;
  final AppPdfViewerTexts texts;
  final bool useGoogleDocsViewerOnAndroid;

  @override
  State<AppPdfViewerPage> createState() => _AppPdfViewerPageState();
}

class _AppPdfViewerPageState extends State<AppPdfViewerPage> {
  late final WebViewController _controller;

  bool _hasMainFrameError = false;
  bool _pageLoaded = false;
  int _progress = 0;

  Uri get _displayUri {
    if (kIsWeb) {
      return widget.pdfUri;
    }
    if (widget.useGoogleDocsViewerOnAndroid &&
        defaultTargetPlatform == TargetPlatform.android) {
      return Uri.parse(
        'https://docs.google.com/gview?embedded=1&url=${Uri.encodeComponent(widget.pdfUri.toString())}',
      );
    }
    return widget.pdfUri;
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!mounted) {
              return;
            }
            setState(() {
              _progress = progress.clamp(0, 100);
            });
          },
          onPageStarted: (_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _hasMainFrameError = false;
              _pageLoaded = false;
              _progress = _progress == 0 ? 5 : _progress;
            });
          },
          onPageFinished: (_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _hasMainFrameError = false;
              _pageLoaded = true;
              _progress = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame != true || !mounted) {
              return;
            }
            setState(() {
              _hasMainFrameError = true;
              _pageLoaded = false;
              _progress = 0;
            });
          },
        ),
      );
    unawaited(_controller.loadRequest(_displayUri));
  }

  Future<void> _reload() async {
    setState(() {
      _hasMainFrameError = false;
      _pageLoaded = false;
      _progress = 0;
    });
    await _controller.loadRequest(_displayUri);
  }

  Future<void> _openExternally() async {
    final opened = await launchUrl(
      widget.pdfUri,
      mode: LaunchMode.externalApplication,
    );
    if (opened || !mounted) {
      return;
    }
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(widget.texts.openExternalFailedNotice)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          IconButton(
            onPressed: _openExternally,
            tooltip: widget.texts.openExternalTooltip,
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (_hasMainFrameError)
            _PdfLoadErrorPanel(
              message: widget.texts.loadFailedLabel,
              retryLabel: widget.texts.retryLabel,
              openExternalLabel: widget.texts.openExternalLabel,
              onRetry: _reload,
              onOpenExternal: _openExternally,
            )
          else
            WebViewWidget(controller: _controller),
          if (!_hasMainFrameError && !_pageLoaded)
            Container(
              color: Colors.white.withValues(alpha: 0.94),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 12),
                  Text(widget.texts.loadingLabel),
                ],
              ),
            ),
          if (!_hasMainFrameError && _progress > 0 && _progress < 100)
            Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(
                value: _progress / 100,
                minHeight: 2,
              ),
            ),
        ],
      ),
    );
  }
}

class _PdfLoadErrorPanel extends StatelessWidget {
  const _PdfLoadErrorPanel({
    required this.message,
    required this.retryLabel,
    required this.openExternalLabel,
    required this.onRetry,
    required this.onOpenExternal,
  });

  final String message;
  final String retryLabel;
  final String openExternalLabel;
  final VoidCallback onRetry;
  final VoidCallback onOpenExternal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.picture_as_pdf_outlined,
              color: Theme.of(context).colorScheme.error,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: <Widget>[
                OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
                ElevatedButton(
                  onPressed: onOpenExternal,
                  child: Text(openExternalLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
