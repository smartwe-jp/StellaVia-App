import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

enum AppCardVariant { outlined, elevated, subtle }

/// Surface primitive only. Domain-specific contents belong to feature widgets.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.outlined,
    this.padding = const EdgeInsets.all(UiTokens.spacing16),
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      side: variant == AppCardVariant.outlined
          ? BorderSide(color: colors.border)
          : BorderSide.none,
    );
    return Semantics(
      label: semanticLabel,
      button: onTap == null ? null : true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          boxShadow: variant == AppCardVariant.elevated
              ? [
                  BoxShadow(
                    color: colors.brandPrimaryDark.withValues(alpha: .08),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: variant == AppCardVariant.subtle
              ? colors.surfaceAlt
              : colors.surface,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: shape,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
