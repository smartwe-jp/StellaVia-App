import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/support/member_profile_edit_step.dart';

void main() {
  group('MemberProfileEditStep', () {
    test('shows real-person auth in overview steps', () {
      expect(
        memberProfileOverviewSteps,
        contains(MemberProfileEditStep.realPersonAuth),
      );
      expect(MemberProfileEditStep.realPersonAuth.appearsInOverview, isTrue);
    });
  });
}
