import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'app_notice.dart';
import 'app_theme_extensions.dart';

enum FundFavoriteButtonStyle { card, overlay }

class FundFavoriteButton extends StatelessWidget {
  const FundFavoriteButton({
    super.key,
    required this.selected,
    this.onTap,
    this.style = FundFavoriteButtonStyle.card,
    this.size = 34,
    this.iconSize = 18,
    this.tooltip,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.selectedBackgroundColor,
    this.backgroundColor,
    this.selectedToastMessage,
    this.unselectedToastMessage,
  });

  final bool selected;
  final VoidCallback? onTap;
  final FundFavoriteButtonStyle style;
  final double size;
  final double iconSize;
  final String? tooltip;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final Color? selectedBackgroundColor;
  final Color? backgroundColor;
  final String? selectedToastMessage;
  final String? unselectedToastMessage;

  bool get _isOverlayStyle => style == FundFavoriteButtonStyle.overlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final blurSigma = _isOverlayStyle ? 8.0 : 4.0;
    final effectiveBackgroundColor = selected
        ? (selectedBackgroundColor ?? _resolveSelectedBackgroundColor(colors))
        : (backgroundColor ?? _resolveBackgroundColor(colors));
    final effectiveIconColor = selected
        ? (selectedIconColor ?? _resolveSelectedIconColor(colors))
        : (unselectedIconColor ?? _resolveUnselectedIconColor(colors));
    final borderColor = _resolveBorderColor(colors);

    final button = SizedBox(
      width: size,
      height: size,
      child: Material(
        color: effectiveBackgroundColor,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap == null
              ? null
              : () {
                  onTap!();
                  final message = selected
                      ? unselectedToastMessage
                      : selectedToastMessage;
                  if (message == null || message.trim().isEmpty) {
                    return;
                  }
                  AppNotice.show(context, message: message.trim());
                },
          child: Center(
            child: Icon(
              Icons.star_rounded,
              size: iconSize,
              color: effectiveIconColor,
            ),
          ),
        ),
      ),
    );

    final decoratedButton = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          child: button,
        ),
      ),
    );

    if (tooltip == null || tooltip!.trim().isEmpty) {
      return decoratedButton;
    }
    return Tooltip(message: tooltip, child: decoratedButton);
  }

  Color _resolveBackgroundColor(AppSemanticColorTheme colors) {
    if (_isOverlayStyle) {
      return colors.scrim.withValues(alpha: 0.40);
    }
    return colors.onDark.withValues(alpha: 0.85);
  }

  Color _resolveSelectedBackgroundColor(AppSemanticColorTheme colors) {
    if (_isOverlayStyle) {
      return colors.scrim.withValues(alpha: 0.40);
    }
    return colors.warningSubtle;
  }

  Color _resolveUnselectedIconColor(AppSemanticColorTheme colors) {
    if (_isOverlayStyle) {
      return colors.onDark.withValues(alpha: 0.94);
    }
    return colors.textTertiary;
  }

  Color _resolveSelectedIconColor(AppSemanticColorTheme colors) {
    if (_isOverlayStyle) {
      return colors.onDark;
    }
    return colors.warning;
  }

  Color _resolveBorderColor(AppSemanticColorTheme colors) {
    if (_isOverlayStyle) {
      return colors.onDark.withValues(alpha: 0.10);
    }
    return colors.onDark.withValues(alpha: 0.22);
  }
}
