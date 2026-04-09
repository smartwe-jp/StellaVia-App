import 'dart:async';

import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

enum AppNoticePosition { top, bottom }

class AppNotice {
  const AppNotice._();

  static GlobalKey<OverlayState>? _hostOverlayKey;
  static OverlayEntry? _activeEntry;
  static Timer? _dismissTimer;

  static void bindHostOverlayKey(GlobalKey<OverlayState> key) {
    _hostOverlayKey = key;
  }

  static void show(
    BuildContext context, {
    required String message,
    AppNoticePosition position = AppNoticePosition.top,
    Duration duration = const Duration(seconds: 2),
    bool clearPrevious = true,
    SnackBarAction? action,
  }) {
    final overlay = _resolveOverlay(context);
    if (overlay == null) {
      return;
    }

    if (clearPrevious) {
      dismissCurrent();
    }

    final mediaQuery =
        MediaQuery.maybeOf(overlay.context) ?? MediaQuery.maybeOf(context);
    final topInset = (mediaQuery?.viewPadding.top ?? 0) + 60;
    final bottomInset = (mediaQuery?.viewPadding.bottom ?? 0) + 60;
    final alignment = position == AppNoticePosition.top
        ? Alignment.topCenter
        : Alignment.bottomCenter;

    final entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  position == AppNoticePosition.top ? topInset : 0,
                  20,
                  position == AppNoticePosition.bottom ? bottomInset : 0,
                ),
                child: IgnorePointer(
                  ignoring: false,
                  child: _NoticeCard(message: message, action: action),
                ),
              ),
            ),
          ),
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
    _dismissTimer = Timer(duration, dismissCurrent);
  }

  static OverlayState? _resolveOverlay(BuildContext context) {
    final hostOverlay = _hostOverlayKey?.currentState;
    if (hostOverlay != null && hostOverlay.mounted) {
      return hostOverlay;
    }
    return Overlay.maybeOf(context, rootOverlay: true);
  }

  static void dismissCurrent() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _activeEntry?.remove();
    _activeEntry = null;
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.message, this.action});

  final String message;
  final SnackBarAction? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.brandPrimaryBright,
          borderRadius: BorderRadius.circular(12),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3),
          //     blurRadius: 14,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: appText.sectionTitle.copyWith(color: colors.onDark),
              ),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  action!.onPressed();
                  AppNotice.dismissCurrent();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colors.primarySubtle,
                  visualDensity: const VisualDensity(
                    horizontal: -2,
                    vertical: -2,
                  ),
                ),
                child: Text(
                  action!.label,
                  style: appText.bodyStrong.copyWith(
                    color: colors.primarySubtle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
