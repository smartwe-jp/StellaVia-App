import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/mappers/member_profile_api_payload_mapper.dart';
import 'package:fundex/features/member_profile/data/mappers/member_profile_current_user_payload_mapper.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_details.dart';

void main() {
  group('member profile name mapping', () {
    test(
      'reads server lastNameEn as family roman name and firstNameEn as given roman name',
      () {
        final profile =
            MemberProfileCurrentUserPayloadMapper.toEntity(<String, dynamic>{
              'email': 'user@example.com',
              'firstName': '刁',
              'lastName': '文阳',
              'firstNameEn': 'Wenyang',
              'lastNameEn': 'Diao',
            });

        expect(profile, isNotNull);
        expect(profile!.familyName, '刁');
        expect(profile.givenName, '文阳');
        expect(profile.familyNameEn, 'Diao');
        expect(profile.givenNameEn, 'Wenyang');
      },
    );

    test('writes family name into firstName and given name into lastName', () {
      final payload = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
        profile: const MemberProfileDetails(
          familyName: '刁',
          givenName: '文阳',
          familyNameEn: 'Diao',
          givenNameEn: 'Wenyang',
        ),
      );

      final baseInfo = payload['baseInfo'] as Map<String, dynamic>;
      expect(baseInfo['firstName'], '刁');
      expect(baseInfo['lastName'], '文阳');
      expect(baseInfo['firstNameEn'], 'Wenyang');
      expect(baseInfo['lastNameEn'], 'Diao');
    });
  });
}
