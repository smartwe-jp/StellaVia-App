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

typedef AppWebViewerResultMatcher<T> = T? Function(Uri uri);
typedef AppWebViewerExitGuard = Future<bool> Function(BuildContext context);

Future<T?> openAppWebViewer<T>(
  BuildContext context, {
  required String url,
  String? title,
  AppWebViewerTexts texts = const AppWebViewerTexts(),
  bool useRootNavigator = true,
  AppWebViewerResultMatcher<T>? onPageFinishedResult,
  AppWebViewerExitGuard? onExitRequested,
}) async {
  final normalizedUrl = url.trim();
  final uri = Uri.tryParse(normalizedUrl);
  if (uri == null || (!uri.isScheme('https') && !uri.isScheme('http'))) {
    AppNotice.show(context, message: texts.invalidUrlNotice);
    return null;
  }

  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push<T>(
    MaterialPageRoute<T>(
      builder: (BuildContext context) => AppWebViewerPage<T>(
        pageUri: uri,
        title: title?.trim().isNotEmpty == true
            ? title!.trim()
            : texts.pageTitle,
        texts: texts,
        onPageFinishedResult: onPageFinishedResult,
        onExitRequested: onExitRequested,
      ),
      settings: const RouteSettings(name: 'app_web_viewer'),
    ),
  );
}

class AppWebViewerPage<T> extends StatefulWidget {
  const AppWebViewerPage({
    super.key,
    required this.pageUri,
    required this.title,
    this.texts = const AppWebViewerTexts(),
    this.onPageFinishedResult,
    this.onExitRequested,
  });

  final Uri pageUri;
  final String title;
  final AppWebViewerTexts texts;
  final AppWebViewerResultMatcher<T>? onPageFinishedResult;
  final AppWebViewerExitGuard? onExitRequested;

  @override
  State<AppWebViewerPage<T>> createState() => _AppWebViewerPageState<T>();
}

class _AppWebViewerPageState<T> extends State<AppWebViewerPage<T>> {
  late final WebViewController _controller;

  bool _hasMainFrameError = false;
  bool _pageLoaded = false;
  bool _allowRoutePop = false;
  bool _isHandlingExit = false;
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
          onPageFinished: (String url) {
            if (!mounted) {
              return;
            }
            final matcher = widget.onPageFinishedResult;
            if (matcher != null) {
              final uri = Uri.tryParse(url);
              final result = uri == null ? null : matcher(uri);
              if (result != null) {
                _allowRoutePop = true;
                Navigator.of(context).pop<T>(result);
                return;
              }
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

  Future<void> _handleExitRequest() async {
    if (_isHandlingExit) {
      return;
    }
    final guard = widget.onExitRequested;
    if (guard == null) {
      _allowRoutePop = true;
      if (mounted) {
        Navigator.of(context).pop<T>();
      }
      return;
    }
    _isHandlingExit = true;
    final shouldExit = await guard(context);
    _isHandlingExit = false;
    if (!mounted || !shouldExit) {
      return;
    }
    _allowRoutePop = true;
    Navigator.of(context).pop<T>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return PopScope<T>(
      canPop: widget.onExitRequested == null || _allowRoutePop,
      onPopInvokedWithResult: (bool didPop, T? result) {
        if (!didPop) {
          unawaited(_handleExitRequest());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
            Text(message, textAlign: TextAlign.center, style: appText.body),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
