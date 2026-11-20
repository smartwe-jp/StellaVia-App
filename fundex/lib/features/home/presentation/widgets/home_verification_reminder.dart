import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/domain/repositories/verification_entry_repository.dart';
import '../../../member_profile/presentation/providers/verification_entry_provider.dart';
import '../../../member_profile/presentation/widgets/verification_entry_content.dart';
import '../support/home_member_profile_reminder_support.dart';

final homeVerificationReminderProvider =
    FutureProvider.autoDispose<VerificationEntry>((ref) {
      ref.watch(authSessionProvider);
      return ref.watch(verificationEntryRepositoryProvider).load();
    });

enum _InvestorType { personal, corporate }

class HomeVerificationReminder extends ConsumerStatefulWidget {
  const HomeVerificationReminder({super.key});
  @override
  ConsumerState<HomeVerificationReminder> createState() =>
      _HomeVerificationReminderState();
}

class _HomeVerificationReminderState
    extends ConsumerState<HomeVerificationReminder> {
  bool opening = false;
  Future<void> open(VerificationEntry entry) async {
    if (opening) return;
    opening = true;
    try {
      if (entry.kind == VerificationEntryKind.choice) {
        final l = context.l10n;
        final choice = await AppDialogs.showAdaptiveAlert<_InvestorType>(
          context: context,
          title: l.investorTypeTitle,
          actions: [
            AppDialogAction(
              label: l.personalInvestor,
              value: _InvestorType.personal,
            ),
            AppDialogAction(
              label: l.corporateInvestor,
              value: _InvestorType.corporate,
            ),
            AppDialogAction(label: l.commonCancel),
          ],
        );
        if (!mounted || choice == null) return;
        final VerificationEntry latest;
        try {
          latest = await ref.refresh(homeVerificationReminderProvider.future);
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.uiErrorRequestFailed)),
            );
          }
          return;
        }
        if (!mounted) return;
        if (latest.kind == VerificationEntryKind.choice) {
          if (choice == _InvestorType.corporate) {
            await CorporateEntryContent.openPreparation(context);
          } else {
            await context.push('/member-profile/onboarding');
          }
        } else {
          await context.push('/member-profile/edit');
        }
      } else {
        await context.push('/member-profile/edit');
      }
      if (mounted) ref.invalidate(homeVerificationReminderProvider);
    } finally {
      opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(homeVerificationReminderProvider).valueOrNull;
    // if (entry == null || !shouldShowHomeMemberProfileReminder(entry)) {
    //   return const SizedBox.shrink();
    // }
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FundReminderCard(
        data: FundReminderData(
          leading: const Icon(Icons.badge_outlined),
          title: l.homeReminderProfileTitle,
          message: l.homeReminderProfileBody,
          onTap: () => open(entry!),
        ),
      ),
    );
  }
}
