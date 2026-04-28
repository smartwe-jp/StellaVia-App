import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppCopyButton extends StatelessWidget {
  const AppCopyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.textStyle,
    this.leading,
    this.trailing,
    this.iconSpacing = 4,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final Widget? leading;
  final Widget? trailing;
  final double iconSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isEnabled = onPressed != null;
    final enabledForeground =
        foregroundColor ?? textStyle?.color ?? colors.primary;
    final effectiveForeground = isEnabled
        ? enabledForeground
        : (disabledForegroundColor ??
              enabledForeground.withValues(alpha: 0.44));
    final effectiveBackground = isEnabled
        ? (backgroundColor ?? colors.primarySubtle)
        : (disabledBackgroundColor ??
              (backgroundColor ?? colors.primarySubtle).withValues(
                alpha: 0.56,
              ));
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(7);
    final effectiveTextStyle = appText.meta
        .copyWith(fontWeight: FontWeight.w700)
        .merge(textStyle)
        .copyWith(color: effectiveForeground);
    final effectiveIconSize = (effectiveTextStyle.fontSize ?? 12) + 2;
    final borderColor = this.borderColor ?? colors.primarySoft;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (leading != null) ...<Widget>[
          leading!,
          SizedBox(width: iconSpacing),
        ],
        Text(label, style: effectiveTextStyle),
        if (trailing != null) ...<Widget>[
          SizedBox(width: iconSpacing),
          trailing!,
        ],
      ],
    );
    final shape = RoundedRectangleBorder(
      borderRadius: effectiveBorderRadius,
      side: BorderSide(color: borderColor),
    );

    return Semantics(
      button: true,
      enabled: isEnabled,
      child: Material(
        color: effectiveBackground,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: Padding(
            padding: padding,
            child: IconTheme.merge(
              data: IconThemeData(
                color: effectiveForeground,
                size: effectiveIconSize,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
