import 'dart:convert';

import '../mappers/corporate_detail_mapper.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../mappers/corporate_submission_mapper.dart';
import 'package:company_api_runtime/company_api_runtime.dart';
import '../../domain/repositories/verification_entry_repository.dart';

class VerificationEntryRepositoryImpl implements VerificationEntryRepository {
  const VerificationEntryRepositoryImpl(this.auth, this.member);
  final AuthApiClient auth;
  final MemberProfileApiClient member;

  @override
  Future<void> review({
    required int id,
    required CorporateMailAction action,
    required String message,
  }) => member.reviewCorporate(
    id: id,
    reviewOp: action.code,
    customerMessage: message,
  );

  @override
  Future<void> submit(
    CorporateFormDraft draft, {
    required bool antiSocial,
    required bool mail,
  }) async {
    final payload = corporateSubmission(
      draft,
      antiSocial: antiSocial,
      mail: mail,
    );
    if (draft.isCorrection) {
      final VerificationEntry current;
      try {
        current = await _corporateDetail();
      } catch (_) {
        throw StateError('Unable to verify correction eligibility');
      }
      if (current.applicationId == null ||
          !current.canCorrect ||
          current.applicationId != draft.sourceApplicationId) {
        throw StateError('Application is no longer editable');
      }
      try {
        await member.submitCorporate(payload);
      } on StateError {
        rethrow; // Explicit rejection from the API envelope.
      } catch (_) {
        throw _PendingCorrection(current, payload);
      }
      return;
    }
    await member.submitCorporate(payload);
  }

  @override
  Future<VerificationEntry> load({bool afterSubmission = false}) async {
    if (afterSubmission) return _corporateDetail();
    final payload = await auth.fetchCurrentUserPayload();
    if (payload.isEmpty) {
      throw const FormatException('Missing member information');
    }
    final user = AuthUserDto.fromJson(payload);
    switch (user.applicantType) {
      case 'corporate':
        return _corporateDetail();
      case 'personal':
        return VerificationEntry(
          user.status == 1
              ? VerificationEntryKind.choice
              : VerificationEntryKind.personal,
          personalStatus: user.status,
        );
      case 'individual':
      case null:
        return VerificationEntry(
          VerificationEntryKind.personal,
          personalStatus: user.status,
        );
      default:
        throw const FormatException('Unknown applicant type');
    }
  }

  Future<VerificationEntry> _corporateDetail() async {
    final detail = await member.fetchCorporateDetail();
    return VerificationEntry(
      VerificationEntryKind.corporate,
      applicationId: detail.applicationId,
      submittedForm: detail.company.isEmpty && detail.applicationId == null
          ? null
          : corporateDetailForm(detail),
      companyName: detail.companyName,
      status: detail.verificationStatus,
      hasRegisteredBank: detail.hasRegisteredBank,
      userOps: detail.userOps,
      auditLogs: [
        for (final e in detail.auditLogs)
          CorporateAuditEvent(
            e.action,
            createdAt: e.createdAt,
            customerMessage: e.customerMessage,
            id: e.id,
          ),
      ],
    );
  }
}

class _PendingCorrection implements UnconfirmedCorporateCorrection {
  const _PendingCorrection(this.before, this.payload);
  final VerificationEntry before;
  final Map<String, dynamic> payload;

  @override
  bool confirmedBy(VerificationEntry detail) {
    final form = detail.submittedForm;
    if (form == null ||
        detail.applicationId != before.applicationId ||
        before.auditLogs.isEmpty) {
      return false;
    }
    // A status transition or an administrator's review does not identify a submission.
    final newSubmission = detail.auditLogs.any(
      (event) =>
          event.action == 'SUBMITTED' &&
          before.auditLogs.every((old) {
            if (event.id != null && old.id != null) return event.id! > old.id!;
            return event.createdAt != null &&
                old.createdAt != null &&
                event.createdAt!.isAfter(old.createdAt!);
          }),
    );
    if (!newSubmission) return false;
    try {
      // Both maps use the same submission mapper, including active files and owners.
      final received = corporateSubmission(
        form.copyForEditing(correction: true),
        antiSocial: true,
        mail: true,
      );
      return jsonEncode(received) == jsonEncode(payload);
    } on StateError {
      return false; // Incomplete detail cannot establish which edits were received.
    }
  }
}
