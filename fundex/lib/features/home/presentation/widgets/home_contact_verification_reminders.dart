import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';

class HomeContactVerificationReminders extends ConsumerWidget {
  const HomeContactVerificationReminders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailVerified = ref
        .watch(settingsEmailVerifiedProvider)
        .asData
        ?.value;
    final status = ref
        .watch(settingsRemoteVerificationStatusProvider)
        .asData
        ?.value;
    final l = context.l10n;
    final reminders = [
      if (emailVerified == false)
        FundReminderData(
          leading: const Icon(Icons.alternate_email_rounded, size: 30),
          title: l.homeReminderEmailVerificationTitle,
          message: l.homeReminderEmailVerificationBody,
          onTap: () => context.push('/profile/settings/two-factor/email'),
        ),
      if (status?.isPhoneVerified == false)
        FundReminderData(
          leading: const Icon(Icons.smartphone_rounded, size: 30),
          title: l.homeReminderPhoneVerificationTitle,
          message: l.homeReminderPhoneVerificationBody,
          onTap: () => context.push('/profile/settings/two-factor/phone'),
        ),
    ];
    if (reminders.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FundReminderFeed(items: reminders),
    );
  }
}
