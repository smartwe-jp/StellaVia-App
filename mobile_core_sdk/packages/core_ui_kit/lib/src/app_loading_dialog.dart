import 'dart:async';

import 'package:flutter/material.dart';

import 'app_loading_indicator.dart';
import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class AppLoadingDialogHandle {
  AppLoadingDialogHandle._(this._entry);

  final OverlayEntry _entry;
  Timer? _timer;
  bool _dismissed = false;

  void dismiss() {
    if (_dismissed) {
      return;
    }
    _dismissed = true;
    _timer?.cancel();
    _entry.remove();
  }
}

class AppLoadingDialog {
  const AppLoadingDialog._();

  static AppLoadingDialogHandle show(
    BuildContext context, {
    String? message,
    Duration? timeout = const Duration(seconds: 300), // 5 minutes
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AppLoadingDialogView(message: message),
    );
    overlay.insert(entry);
    final handle = AppLoadingDialogHandle._(entry);
    if (timeout != null) {
      handle._timer = Timer(timeout, handle.dismiss);
    }
    return handle;
  }

  static Future<T> run<T>(
    BuildContext context,
    Future<T> Function() task, {
    String? message,
    Duration? timeout,
  }) async {
    final handle = show(context, message: message, timeout: timeout);
    try {
      return await task();
    } finally {
      handle.dismiss();
    }
  }
}

class _AppLoadingDialogView extends StatelessWidget {
  const _AppLoadingDialogView({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final text = message?.trim() ?? '';
    final barrierAlpha = theme.brightness == Brightness.dark ? 0.58 : 0.28;
    return Positioned.fill(
      child: Material(
        color: colors.scrim.withValues(alpha: barrierAlpha),
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 22, 24, text.isEmpty ? 22 : 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const AppLoadingIndicator(),
                  if (text.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
