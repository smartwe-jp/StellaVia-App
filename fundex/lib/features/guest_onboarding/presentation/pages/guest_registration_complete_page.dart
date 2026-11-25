import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../widgets/guest_account_layout.dart';

class GuestRegistrationCompletePage extends StatelessWidget {
  const GuestRegistrationCompletePage({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = Theme.of(context).textTheme;
    final colors = context.appColors;
    return GuestAccountLayout(
      title: l.registerSuccessTitle,
      children: [
        const Spacer(),
        const SizedBox(height: 24),
        Text(
          l.guestCreatedEyebrow,
          style: text.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l.guestGuideCreated,
          style: text.headlineSmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l.guestNextSteps,
          style: text.bodyLarge?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 16),
        GuestAccountPanel(
          children: [
            Text(
              l.guestVerifyRequired,
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l.guestGuideVerifyIntro,
              style: text.bodyMedium?.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(height: 24),
        GuestAccountButton(
          l.guestGuideVerify,
          onTap: () => context.go('/home/verification'),
        ),
        const SizedBox(height: 8),
        GuestAccountLink(l.guestGuideLater, onTap: () => context.go('/funds')),
      ],
    );
  }
}
