import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

/// Visual tones, deliberately not fund/order/member status codes.
enum AppBadgeTone {
  neutral,
  primary,
  accent,
  subtle,
  inverse,
  success,
  warning,
  danger,
}

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
    this.showDot = false,
  });

  final String label;
  final AppBadgeTone tone;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final (background, foreground) = switch (tone) {
      AppBadgeTone.neutral => (c.surfaceAlt, c.textSecondary),
      AppBadgeTone.primary => (c.primary, c.onDark),
      AppBadgeTone.accent => (c.primaryAlt, c.onDark),
      AppBadgeTone.subtle => (
        c.primarySubtle,
        context.appTextTheme.link.color!,
      ),
      AppBadgeTone.inverse => (c.brandPrimaryDark, c.onDark),
      AppBadgeTone.success => (c.successSoft, c.successForeground),
      AppBadgeTone.warning => (c.warningSoft, c.warningForeground),
      AppBadgeTone.danger => (c.dangerSoft, c.dangerForeground),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UiTokens.spacing8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(UiTokens.radius4),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            if (showDot)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: foreground,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 6),
                  ),
                ),
              ),
            TextSpan(text: label),
          ],
        ),
        style: context.appTextTheme.chip.copyWith(color: foreground),
        semanticsLabel: label,
      ),
    );
  }
}
