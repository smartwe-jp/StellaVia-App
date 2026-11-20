import '../entities/corporate_form_draft.dart';

enum VerificationEntryKind { personal, choice, corporate }

enum CorporateMailAction {
  sent('CUSTOMER_MAILED'),
  received('RECEIVED');

  const CorporateMailAction(this.code);
  final String code;
}

class CorporateAuditEvent {
  const CorporateAuditEvent(
    this.action, {
    this.createdAt,
    this.customerMessage,
    this.id,
  });
  final String action;
  final DateTime? createdAt;
  final String? customerMessage;
  final int? id;
}

class VerificationEntry {
  const VerificationEntry(
    this.kind, {
    this.companyName,
    this.personalStatus,
    this.submittedForm,
    this.status,
    this.hasRegisteredBank = false,
    this.applicationId,
    this.userOps = const {},
    this.auditLogs = const [],
  });
  final VerificationEntryKind kind;
  final int? personalStatus;
  final CorporateFormDraft? submittedForm;
  bool get canCorrect =>
      kind == VerificationEntryKind.corporate &&
      const {
        'DRAFT',
        'SUBMITTED',
        'EXPIRED',
        'REJECTED',
        'CONFIRMED',
      }.contains(status);
  final String? companyName;
  final String? status;
  final int? applicationId;
  final bool hasRegisteredBank;
  final Set<String> userOps;
  final List<CorporateAuditEvent> auditLogs;
  bool get isCorrection =>
      hasRegisteredBank ||
      const {'SUBMITTED', 'REJECTED', 'EXPIRED', 'CONFIRMED'}.contains(status);
}

abstract interface class VerificationEntryRepository {
  Future<VerificationEntry> load({bool afterSubmission = false});
  Future<void> review({
    required int id,
    required CorporateMailAction action,
    required String message,
  });
  Future<void> submit(
    CorporateFormDraft draft, {
    required bool antiSocial,
    required bool mail,
  });
}
