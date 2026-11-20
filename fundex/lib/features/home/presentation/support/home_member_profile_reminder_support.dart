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
