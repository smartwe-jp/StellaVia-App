import '../../domain/repositories/verification_entry_repository.dart';

enum CorporateStage {
  submitted,
  originalMail,
  review,
  companyMail,
  receipt,
  finalCheck,
}

class CorporateProgress {
  const CorporateProgress(
    this.current, {
    this.complete = false,
    this.actionRequired = false,
    this.message,
  });
  final CorporateStage current;
  final bool complete, actionRequired;
  final String? message;

  static CorporateAuditEvent? latestNotice(List<CorporateAuditEvent> history) {
    CorporateAuditEvent? latest;
    for (final event in history) {
      if (event.createdAt == null || (event.customerMessage ?? '').isEmpty) {
        continue;
      }
      if (latest == null || event.createdAt!.isAfter(latest.createdAt!)) {
        latest = event;
      }
    }
    return latest;
  }

  static CorporateProgress? fromEntry(VerificationEntry entry) {
    final mail = entry.userOps.contains('CUSTOMER_MAILED'),
        receive = entry.userOps.contains('RECEIVED');
    return switch (entry.status) {
      'SUBMITTED' => CorporateProgress(
        mail ? CorporateStage.originalMail : CorporateStage.submitted,
        actionRequired: mail,
      ),
      'CUSTOMER_MAILED' ||
      'APPROVED' => const CorporateProgress(CorporateStage.review),
      'ADMIN_MAILED' || 'MAILED' => CorporateProgress(
        receive ? CorporateStage.receipt : CorporateStage.companyMail,
        actionRequired: receive,
      ),
      'RECEIVED' => const CorporateProgress(CorporateStage.finalCheck),
      'CONFIRMED' => const CorporateProgress(
        CorporateStage.finalCheck,
        complete: true,
      ),
      'REJECTED' => _rejection(entry.auditLogs),
      _ => null,
    };
  }

  static CorporateProgress _rejection(List<CorporateAuditEvent> history) {
    final events = history
        .where(
          (e) => const {'SUBMITTED', 'APPROVED', 'REJECTED'}.contains(e.action),
        )
        .toList();
    if (events.every((e) => e.createdAt != null)) {
      events.sort((a, b) {
        final cmp = a.createdAt!.compareTo(b.createdAt!);
        return cmp != 0 ? cmp : (a.id ?? 0).compareTo(b.id ?? 0);
      });
    } else if (events.every((e) => e.id != null)) {
      events.sort((a, b) => a.id!.compareTo(b.id!));
    }
    bool approved = false;
    CorporateProgress? rejected;
    for (final e in events) {
      switch (e.action) {
        case 'SUBMITTED':
          approved = false;
          rejected = null;
        case 'APPROVED':
          approved = true;
        case 'REJECTED':
          rejected = CorporateProgress(
            approved ? CorporateStage.finalCheck : CorporateStage.review,
            message: e.customerMessage,
          );
      }
    }
    return rejected ??
        CorporateProgress(
          approved ? CorporateStage.finalCheck : CorporateStage.review,
        );
  }
}
