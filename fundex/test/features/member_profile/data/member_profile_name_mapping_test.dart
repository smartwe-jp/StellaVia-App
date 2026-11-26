import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/mappers/member_profile_api_payload_mapper.dart';
import 'package:fundex/features/member_profile/data/mappers/member_profile_current_user_payload_mapper.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_details.dart';

void main() {
  test(
    'country fields round trip independently and skipped bank is omitted',
    () {
      final profile = MemberProfileCurrentUserPayloadMapper.toEntity({
        'baseInfo': {'nationality': '中国', 'taxcountry': '日本'},
      })!;
      final request = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
        profile: profile.copyWith(skipBankAccount: true, bankName: 'partial'),
      );
      final base = request['baseInfo'] as Map<String, dynamic>;
      expect(base['nationality'], '中国');
      expect(base['taxcountry'], '日本');
      expect(base.containsKey('bank'), isFalse);
    },
  );
  test('saves employer and industry in their respective API sections', () {
    final profile = MemberProfileCurrentUserPayloadMapper.toEntity({
      'baseInfo': {'employer': 'ACME'},
      'suitabilityInfo': {'industry': 'IT'},
    })!;
    final request = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
      profile: profile,
    );
    expect(request['baseInfo']['employer'], 'ACME');
    expect(request['suitabilityRequest']['industry'], 'IT');
  });
  test('sends a cleared employer', () {
    final profile = MemberProfileCurrentUserPayloadMapper.toEntity({
      'baseInfo': {'employer': 'ACME'},
    })!;
    final request = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
      profile: profile.copyWith(employer: '  '),
    );
    expect(request['baseInfo']['employer'], '');
  });
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

  group('member profile document image mapping', () {
    test('round trips three independent document photos', () {
      const photos = {
        'documentType': 11,
        'documentFrontImage': 'https://example.com/front.jpg',
        'documentObliqueImage': 'https://example.com/angle.jpg',
        'documentBackImage': 'https://example.com/back.jpg',
      };
      final profile = MemberProfileCurrentUserPayloadMapper.toEntity({
        'identityInfo': photos,
      })!;
      final request = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
        profile: profile,
        documentFrontImage: profile.idDocumentPhotoPath,
        documentObliqueImage: profile.idDocumentObliquePhotoPath,
        documentBackImage: profile.idDocumentBackPhotoPath,
      );
      expect(request['identityVerification'], photos);
    });

    test('uses front image as back image for My Number documents', () {
      final payload = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
        profile: const MemberProfileDetails(ekycDocumentType: 'my_number'),
        documentFrontImage: 'https://example.com/front.jpg',
      );

      final identityVerification =
          payload['identityVerification'] as Map<String, dynamic>;
      expect(identityVerification['documentType'], 12);
      expect(
        identityVerification['documentFrontImage'],
        'https://example.com/front.jpg',
      );
      expect(
        identityVerification['documentBackImage'],
        'https://example.com/front.jpg',
      );
    });

    test('does not default back image for two-sided documents', () {
      final payload = MemberProfileApiPayloadMapper.toSaveMemberInfoRequest(
        profile: const MemberProfileDetails(
          ekycDocumentType: 'drivers_license',
        ),
        documentFrontImage: 'https://example.com/front.jpg',
      );

      expect(payload.containsKey('identityVerification'), isFalse);
    });
  });
}
