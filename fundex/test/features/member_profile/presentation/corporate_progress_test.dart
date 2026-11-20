import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/support/corporate_progress.dart';

void main() {
  CorporateProgress? progress(
    String status, {
    Set<String> ops = const {},
    List<CorporateAuditEvent> logs = const [],
  }) => CorporateProgress.fromEntry(
    VerificationEntry(
      VerificationEntryKind.corporate,
      status: status,
      userOps: ops,
      auditLogs: logs,
    ),
  );
  test('maps server status and permitted user operations independently', () {
    expect(progress('SUBMITTED')!.current, CorporateStage.submitted);
    expect(
      progress('SUBMITTED', ops: {'CUSTOMER_MAILED'})!.current,
      CorporateStage.originalMail,
    );
    for (final s in ['CUSTOMER_MAILED', 'APPROVED']) {
      expect(progress(s)!.current, CorporateStage.review);
      expect(progress(s)!.complete, false);
    }
    for (final s in ['MAILED', 'ADMIN_MAILED']) {
      expect(progress(s)!.current, CorporateStage.companyMail);
      final p = progress(s, ops: {'RECEIVED'})!;
      expect(p.current, CorporateStage.receipt);
      expect(p.actionRequired, true);
    }
    expect(progress('RECEIVED')!.current, CorporateStage.finalCheck);
    expect(progress('RECEIVED')!.complete, false);
    expect(progress('CONFIRMED')!.complete, true);
    for (final s in ['', 'DRAFT', 'EXPIRED', 'other']) {
      expect(progress(s), isNull);
    }
  });
  test(
    'rejection is placed at the failed review in the current application round',
    () {
      final old = CorporateAuditEvent(
        'APPROVED',
        createdAt: DateTime.utc(2025),
      );
      final start = CorporateAuditEvent(
        'SUBMITTED',
        createdAt: DateTime.utc(2026, 1),
      );
      final ok = CorporateAuditEvent(
        'APPROVED',
        createdAt: DateTime.utc(2026, 2),
      );
      final no = CorporateAuditEvent(
        'REJECTED',
        createdAt: DateTime.utc(2026, 3),
        customerMessage: 'reason',
      );
      expect(
        progress('REJECTED', logs: [no, old, start])!.current,
        CorporateStage.review,
      );
      final p = progress('REJECTED', logs: [no, start, old, ok])!;
      expect(p.current, CorporateStage.finalCheck);
      expect(p.message, 'reason');
      expect(p.complete, false);
    },
  );
}
