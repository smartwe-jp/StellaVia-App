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
      if (!current.canCorrect ||
          current.applicationId != draft.sourceApplicationId) {
        throw StateError('Application is no longer editable');
      }
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
      case 'individual':
      case null:
        return VerificationEntry(
          user.status == 1
              ? VerificationEntryKind.choice
              : VerificationEntryKind.personal,
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
