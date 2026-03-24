import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavigationBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.decoration,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 64,
    this.horizontalPadding = 20,
    this.bottomSpacing = 0,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Decoration? decoration;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double horizontalPadding;
  final double bottomSpacing;

  @override
  Size get preferredSize =>
      Size.fromHeight(height + bottomSpacing + 1 + kToolbarHeight * 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveDecoration =
        decoration ??
        (backgroundColor != null
            ? BoxDecoration(color: backgroundColor)
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? <Color>[
                          Color.alphaBlend(
                            colors.brandPrimaryDark.withValues(alpha: 0.28),
                            colors.surface,
                          ),
                          Color.alphaBlend(
                            colors.brandPrimaryBright.withValues(alpha: 0.18),
                            colors.surfaceAlt,
                          ),
                        ]
                      : <Color>[colors.heroStart, colors.heroMiddle],
                ),
              ));
    final inferredForegroundColor =
        foregroundColor ?? (isDark ? colors.textPrimary : colors.onDark);

    return DecoratedBox(
      decoration: effectiveDecoration,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                0,
              ),
              child: SizedBox(
                height: height,
                child: Row(
                  children: <Widget>[
                    leading ?? const SizedBox.square(dimension: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: appText.pageTitle.copyWith(
                          color: inferredForegroundColor,
                        ),
                      ),
                    ),
                    if (trailing != null) ...<Widget>[
                      const SizedBox(width: 12),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ),
            if (bottomSpacing > 0) SizedBox(height: bottomSpacing),
            Container(
              height: 1,
              width: double.infinity,
              color: colors.borderSoft,
            ),
          ],
        ),
      ),
    );
  }
}

class AppNavigationIconButton extends StatelessWidget {
  const AppNavigationIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 32,
    this.borderRadius = 8,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final effectiveBackgroundColor =
        backgroundColor ?? colors.onDark.withValues(alpha: 0.15);
    final effectiveForegroundColor = foregroundColor ?? colors.onDark;
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Icon(icon, size: 18, color: effectiveForegroundColor),
        ),
      ),
    );
  }
}
