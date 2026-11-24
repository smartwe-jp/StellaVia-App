import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/domain/repositories/verification_entry_repository.dart';
import '../../../member_profile/presentation/providers/verification_entry_provider.dart';
import '../../../member_profile/presentation/pages/corporate_verification_modal.dart';
import '../../../member_profile/presentation/support/member_profile_entry_navigation.dart';
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
  Future<VerificationEntry?> refreshEntry() async {
    try {
      return await ref.refresh(homeVerificationReminderProvider.future);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.uiErrorRequestFailed)),
        );
      }
      return null;
    }
  }

  Future<void> open() async {
    if (opening) return;
    opening = true;
    try {
      var entry = await refreshEntry();
      if (!mounted || entry == null) return;
      _InvestorType? selectedType;
      if (entry.kind == VerificationEntryKind.choice) {
        final choice = await Navigator.of(context, rootNavigator: true)
            .push<_InvestorType>(
              MaterialPageRoute<_InvestorType>(
                fullscreenDialog: true,
                builder: (context) => InvestorChoice(
                  onPersonal: () =>
                      Navigator.pop(context, _InvestorType.personal),
                  onCorporate: () =>
                      Navigator.pop(context, _InvestorType.corporate),
                ),
              ),
            );
        if (!mounted || choice == null) return;
        final latest = await refreshEntry();
        if (!mounted || latest == null) return;
        entry = latest;
        selectedType = choice;
      }
      if (entry.kind == VerificationEntryKind.corporate) {
        ref.invalidate(verificationEntryProvider);
        await context.push(
          '/member-profile/edit',
          extra: shouldPresentMemberProfileEntry(entry),
        );
      } else if (entry.kind == VerificationEntryKind.choice &&
          selectedType == _InvestorType.corporate) {
        await openCorporateVerification(context, entry);
      } else {
        await context.push('/member-profile/onboarding?start=first');
      }
      if (mounted) ref.invalidate(homeVerificationReminderProvider);
    } finally {
      opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(homeVerificationReminderProvider).valueOrNull;
    if (entry == null) return const SizedBox.shrink();
    if (!shouldShowHomeMemberProfileReminder(entry)) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FundReminderCard(
        data: FundReminderData(
          leading: const Icon(Icons.badge_outlined),
          title: l.homeReminderProfileTitle,
          message: l.homeReminderProfileBody,
          onTap: open,
        ),
      ),
    );
  }
}
