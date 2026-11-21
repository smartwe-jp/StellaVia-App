import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/support/member_profile_edit_step.dart';

void main() {
  group('MemberProfileEditStep', () {
    test('document upload leads to face verification, bank and consent', () {
      expect(
        MemberProfileEditStep.ekyc.next,
        MemberProfileEditStep.realPersonAuth,
      );
      expect(
        memberProfileEditStepFromRouteValue('real-person-auth'),
        MemberProfileEditStep.realPersonAuth,
      );
      expect(
        MemberProfileEditStep.realPersonAuth.next,
        MemberProfileEditStep.bankAccount,
      );
      expect(
        MemberProfileEditStep.bankAccount.next,
        MemberProfileEditStep.consent,
      );
    });

    test('excludes bank account from overview steps', () {
      expect(
        memberProfileOverviewSteps,
        isNot(contains(MemberProfileEditStep.bankAccount)),
      );
      expect(MemberProfileEditStep.bankAccount.appearsInOverview, isFalse);
    });
  });
}
