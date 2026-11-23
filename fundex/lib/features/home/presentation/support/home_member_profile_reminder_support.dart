import '../../../member_profile/domain/repositories/verification_entry_repository.dart';

bool shouldShowHomeMemberProfileReminder(VerificationEntry entry) =>
    switch (entry.kind) {
      VerificationEntryKind.choice => true,
      VerificationEntryKind.personal =>
        entry.personalStatus == 0 || entry.personalStatus == 3,
      VerificationEntryKind.corporate => const <String?>{
        null,
        '',
        'DRAFT',
        'REJECTED',
        'EXPIRED',
      }.contains(entry.status),
    };

bool hasCompletedHomeIdentityVerification(VerificationEntry? entry) =>
    switch (entry?.kind) {
      VerificationEntryKind.personal => entry?.personalStatus == 4,
      VerificationEntryKind.corporate => entry?.status == 'CONFIRMED',
      VerificationEntryKind.choice || null => false,
    };
