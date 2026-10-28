import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'app_typography_tokens.dart';
import 'ui_tokens.dart';

/// Compact section heading with optional action; no feature navigation logic.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.leading,
    this.actionLabel,
    this.onActionTap,
  });
  final String title;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (leading != null) ...[
        leading!,
        const SizedBox(width: UiTokens.spacing8),
      ],
      Expanded(
        child: Semantics(
          header: true,
          child: Text(title, style: context.appTextTheme.sectionTitle),
        ),
      ),
      if (actionLabel != null) ...[
        const SizedBox(width: UiTokens.spacing8),
        Flexible(
          fit: FlexFit.tight,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, UiTokens.controlHeight),
              ),
              child: Text(actionLabel!, textAlign: TextAlign.end),
            ),
          ),
        ),
      ],
    ],
  );
}

/// Brand/editorial heading. Regular app sections use AppSectionHeader instead.
class AppBrandHeading extends StatelessWidget {
  const AppBrandHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.inverse = false,
  });
  final String eyebrow, title;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    final foreground = inverse
        ? context.appColors.onDark
        : context.appTextTheme.link.color!;
    return Semantics(
      header: true,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              eyebrow,
              textAlign: TextAlign.center,
              style: AppTypographyTokens.numericStyle(
                size: 30,
                weight: FontWeight.w500,
                color: foreground,
                height: 1.1,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: UiTokens.spacing12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.appTextTheme.sectionTitle.copyWith(
                color: foreground,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
