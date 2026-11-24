import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class FundProjectWebContent extends StatefulWidget {
  const FundProjectWebContent({
    super.key,
    required this.uri,
    this.onNavigationVisibilityChanged,
  });

  final Uri uri;
  final ValueChanged<bool>? onNavigationVisibilityChanged;

  @override
  State<FundProjectWebContent> createState() => _FundProjectWebContentState();
}

class _FundProjectWebContentState extends State<FundProjectWebContent> {
  final _controller = WebViewController();
  double _scrollAnchor = 0;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    await _controller.setOnScrollPositionChange((position) {
      if (!mounted) return;
      final y = position.y.clamp(0, double.infinity).toDouble();
      final delta = y - _scrollAnchor;
      if (y <= 8 || delta.abs() >= 12) {
        widget.onNavigationVisibilityChanged?.call(y <= 8 || delta < 0);
        _scrollAnchor = y;
      }
    });
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (!request.isMainFrame ||
              (uri?.scheme == 'https' &&
                  uri?.host == widget.uri.host &&
                  uri?.port == widget.uri.port &&
                  uri?.path == widget.uri.path)) {
            return NavigationDecision.navigate;
          }
          if (mounted && uri != null && uri.isScheme('https')) {
            unawaited(
              openAppWebViewer<void>(
                context,
                url: request.url,
                texts: AppWebViewerTexts(
                  pageTitle: uri.host,
                  loadingLabel: context.l10n.webViewerLoadingLabel,
                  loadFailedLabel: context.l10n.webViewerLoadFailedLabel,
                  retryLabel: context.l10n.fundListRetry,
                ),
              ),
            );
          }
          return NavigationDecision.prevent;
        },
        onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame == true) _showError();
        },
        onHttpError: (error) {
          if (error.request?.uri == widget.uri) _showError();
        },
      ),
    );
    if (mounted) await _load();
  }

  void _showError() {
    if (mounted) setState(() => _failed = true);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      await _controller.loadRequest(widget.uri);
    } catch (_) {
      _showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        WebViewWidget(controller: _controller),
        if (_failed || _loading)
          ColoredBox(
            color: context.appColors.surface,
            child: Center(
              child: _failed
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(context.l10n.webViewerLoadFailedLabel),
                        TextButton(
                          onPressed: _load,
                          child: Text(context.l10n.fundListRetry),
                        ),
                      ],
                    )
                  : const AppLoadingIndicator(),
            ),
          ),
      ],
    );
  }
}
