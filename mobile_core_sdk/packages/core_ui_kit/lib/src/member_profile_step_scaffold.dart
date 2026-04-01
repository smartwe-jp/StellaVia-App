import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'member_profile_form_widgets.dart';

class MemberProfileEditStepScaffold extends StatelessWidget {
  const MemberProfileEditStepScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
    required this.primaryButtonLabel,
    this.onPrimaryPressed,
    this.showSkip = false,
    this.skipLabel,
    this.onSkip,
    this.primaryButtonEnabled = true,
  });

  final String title;
  final String description;
  final Widget child;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;
  final String primaryButtonLabel;
  final VoidCallback? onPrimaryPressed;
  final bool showSkip;
  final String? skipLabel;
  final VoidCallback? onSkip;
  final bool primaryButtonEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: appText.pageTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: appText.helper.copyWith(
              color: colors.textSecondary.withValues(alpha: 0.92),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 20),
          if (secondaryButtonLabel != null) ...<Widget>[
            MemberProfileOutlineButton(
              label: secondaryButtonLabel!,
              onPressed: onSecondaryPressed,
            ),
            const SizedBox(height: 12),
          ],
          MemberProfilePrimaryButton(
            label: primaryButtonLabel,
            onPressed: primaryButtonEnabled ? onPrimaryPressed : null,
          ),
          if (showSkip) ...<Widget>[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  skipLabel ?? '',
                  style: appText.bodyStrong.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
