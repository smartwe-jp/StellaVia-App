import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebViewerTexts {
  const AppWebViewerTexts({
    this.pageTitle = 'Web',
    this.loadingLabel = 'Loading page...',
    this.loadFailedLabel = 'Failed to load page.',
    this.retryLabel = 'Retry',
    this.invalidUrlNotice = 'Invalid page URL.',
  });

  final String pageTitle;
  final String loadingLabel;
  final String loadFailedLabel;
  final String retryLabel;
  final String invalidUrlNotice;
}

Future<void> openAppWebViewer(
  BuildContext context, {
  required String url,
  String? title,
  AppWebViewerTexts texts = const AppWebViewerTexts(),
  bool useRootNavigator = true,
}) async {
  final normalizedUrl = url.trim();
  final uri = Uri.tryParse(normalizedUrl);
  if (uri == null || (!uri.isScheme('https') && !uri.isScheme('http'))) {
    AppNotice.show(context, message: texts.invalidUrlNotice);
    return;
  }

  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  await navigator.push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => AppWebViewerPage(
        pageUri: uri,
        title: title?.trim().isNotEmpty == true
            ? title!.trim()
            : texts.pageTitle,
        texts: texts,
      ),
      settings: const RouteSettings(name: 'app_web_viewer'),
    ),
  );
}

class AppWebViewerPage extends StatefulWidget {
  const AppWebViewerPage({
    super.key,
    required this.pageUri,
    required this.title,
    this.texts = const AppWebViewerTexts(),
  });

  final Uri pageUri;
  final String title;
  final AppWebViewerTexts texts;

  @override
  State<AppWebViewerPage> createState() => _AppWebViewerPageState();
}

class _AppWebViewerPageState extends State<AppWebViewerPage> {
  late final WebViewController _controller;

  bool _hasMainFrameError = false;
  bool _pageLoaded = false;
  int _progress = 0;
  Color? _lastAppliedBackgroundColor;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
    unawaited(_controller.loadRequest(widget.pageUri));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final backgroundColor = Theme.of(context).appColors.surface;
    if (_lastAppliedBackgroundColor == backgroundColor) {
      return;
    }
    _lastAppliedBackgroundColor = backgroundColor;
    unawaited(_controller.setBackgroundColor(backgroundColor));
  }

  Future<void> _reload() async {
    setState(() {
      _hasMainFrameError = false;
      _pageLoaded = false;
      _progress = 0;
    });
    await _controller.loadRequest(widget.pageUri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Stack(
        children: <Widget>[
          if (_hasMainFrameError)
            _WebLoadErrorPanel(
              message: widget.texts.loadFailedLabel,
              retryLabel: widget.texts.retryLabel,
              onRetry: _reload,
            )
          else
            WebViewWidget(controller: _controller),
          if (!_hasMainFrameError && !_pageLoaded)
            Container(
              color: colors.surface.withValues(alpha: 0.94),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 12),
                  Text(widget.texts.loadingLabel, style: appText.body),
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

class _WebLoadErrorPanel extends StatelessWidget {
  const _WebLoadErrorPanel({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: appText.body,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
