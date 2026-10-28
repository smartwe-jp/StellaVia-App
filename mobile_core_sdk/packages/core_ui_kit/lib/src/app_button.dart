import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

enum AppButtonVariant { primary, secondary, text }

/// Business-agnostic action. Labels and loading announcements are localized by
/// the caller; native Material buttons provide keyboard/focus/tap semantics.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.loadingLabel,
    this.fullWidth = true,
    this.minHeight = UiTokens.controlHeight,
    this.loadingIndicatorSize = 18,
    this.style,
  }) : assert(label != null || child != null),
       assert(minHeight > 0);

  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final String? loadingLabel;
  final bool fullWidth;
  final double minHeight;
  final double loadingIndicatorSize;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = variant == AppButtonVariant.primary
        ? theme.colorScheme.onPrimary
        : theme.appTextTheme.link.color!;
    final baseStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, minHeight)),
      // Loading blocks submission but keeps its action identity visible.
      backgroundColor: isLoading && variant == AppButtonVariant.primary
          ? WidgetStatePropertyAll(theme.colorScheme.primary)
          : null,
      foregroundColor: isLoading ? WidgetStatePropertyAll(foreground) : null,
    ).merge(style);
    final content = isLoading
        ? Semantics(
            label: loadingLabel ?? label,
            liveRegion: true,
            child: SizedBox.square(
              dimension: loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: style?.foregroundColor?.resolve({}) ?? foreground,
              ),
            ),
          )
        : child ?? Text(label!, textAlign: TextAlign.center);
    final callback = isLoading ? null : onPressed;
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: callback,
        style: baseStyle,
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        style: baseStyle,
        child: content,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: callback,
        style: baseStyle,
        child: content,
      ),
    };
    return SizedBox(width: fullWidth ? double.infinity : null, child: button);
  }
}
