import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

enum AppCardVariant { outlined, elevated, subtle, filled }

/// Surface primitive only. Domain-specific contents belong to feature widgets.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.outlined,
    this.padding = const EdgeInsets.all(UiTokens.spacing16),
    this.onTap,
    this.semanticLabel,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(UiTokens.radius16),
    ),
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Theme-derived surface overrides; content and business variants stay in features.
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: variant == AppCardVariant.outlined
          ? BorderSide(color: borderColor ?? colors.border, width: borderWidth)
          : BorderSide.none,
    );
    return Semantics(
      label: semanticLabel,
      button: onTap == null ? null : true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
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
          color:
              backgroundColor ??
              (variant == AppCardVariant.subtle
                  ? colors.surfaceAlt
                  : colors.surface),
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
