import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../providers/verification_entry_provider.dart';

bool shouldPresentMemberProfileEntry(VerificationEntry entry) =>
    switch (entry.kind) {
      VerificationEntryKind.personal => false,
      VerificationEntryKind.choice => true,
      VerificationEntryKind.corporate => entry.status != 'CONFIRMED',
    };

Future<void> openMemberProfileEntry(
  BuildContext context,
  WidgetRef ref,
) async {
  // Keep this fresh result alive through navigation, including errors/retries.
  ref.invalidate(verificationEntryProvider);
  final subscription = ref.listenManual(verificationEntryProvider, (_, __) {});
  try {
    var present = false;
    try {
      final entry = await ref.read(verificationEntryProvider.future);
      present = shouldPresentMemberProfileEntry(entry);
    } catch (_) {
      // The entry page owns the localized error and retry UI.
    }
    if (!context.mounted) return;
    await context.push('/member-profile/edit', extra: present);
  } finally {
    subscription.close();
  }
}
