import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_details.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_region.dart';
import 'package:fundex/features/member_profile/domain/repositories/member_profile_repository.dart';
import 'package:fundex/features/member_profile/domain/usecases/is_member_profile_completed_usecase.dart';

class _FakeMemberProfileRepository implements MemberProfileRepository {
  _FakeMemberProfileRepository({this.profile});

  MemberProfileDetails? profile;

  @override
  Future<void> clearOnboardingDraft() async {}

  @override
  Future<void> clearLocalProfile() async {
    profile = null;
  }

  @override
  Future<MemberProfileDetails?> readLocalProfile() async => profile;

  @override
  Future<MemberProfileDetails?> readOnboardingDraft() async => null;

  @override
  Future<void> saveLocalProfile(MemberProfileDetails profile) async {
    this.profile = profile;
  }

  @override
  Future<void> saveOnboardingDraft(MemberProfileDetails profile) async {}

  @override
  Future<void> syncLocalProfileFromRemote() async {}

  @override
  Future<List<MemberProfileRegion>> fetchRegionsByZip({
    required String zip,
  }) async {
    return const <MemberProfileRegion>[];
  }

  @override
  Future<void> submitProfile(MemberProfileDetails profile) async {
    this.profile = profile;
  }

  @override
  Future<String> uploadProfilePhoto({
    required String filePath,
    required bool isSelfie,
  }) async {
    return filePath;
  }

  @override
  Future<String> uploadAvatar({required String filePath}) async {
    return filePath;
  }
}

void main() {
  group('IsMemberProfileCompletedUseCase', () {
    test('returns false when no profile exists', () async {
      final repository = _FakeMemberProfileRepository();
      final useCase = IsMemberProfileCompletedUseCase(repository);

      expect(await useCase.call(), isFalse);
    });

    test('returns false for incomplete profile', () async {
      final repository = _FakeMemberProfileRepository(
        profile: const MemberProfileDetails(
          familyName: 'Hou',
          givenName: 'Aaron',
          address: 'Tokyo',
          phone: '09012345678',
          email: '',
        ),
      );
      final useCase = IsMemberProfileCompletedUseCase(repository);

      expect(await useCase.call(), isFalse);
    });

    test('returns false for legacy-only completed profile', () async {
      final repository = _FakeMemberProfileRepository(
        profile: const MemberProfileDetails(
          familyName: 'Hou',
          givenName: 'Aaron',
          address: 'Tokyo',
          phoneIntlCode: '81',
          phone: '09012345678',
          email: 'aaron@example.com',
          idDocumentPhotoPath: '/tmp/id.jpg',
        ),
      );
      final useCase = IsMemberProfileCompletedUseCase(repository);

      expect(await useCase.call(), isFalse);
    });

    test(
      'returns true for completed 5-step edit profile without bank',
      () async {
        final repository = _FakeMemberProfileRepository(
          profile: const MemberProfileDetails(
            nameKanji: '田中 太郎',
            katakana: 'タナカ タロウ',
            familyNameEn: 'TANAKA',
            givenNameEn: 'TARO',
            birthday: '1994-02-10',
            sex: 1,
            taxcountry: '日本',
            zipCode: '1000001',
            prefectureCode: 'tokyo',
            cityAddress: '千代田区丸の内1-1-1',
            address: '東京都 千代田区丸の内1-1-1',
            phoneIntlCode: '81',
            phone: '09012345678',
            email: 'taro@example.com',
            occupationCode: 'employee',
            annualIncomeCode: '5_10m',
            financialAssetsCode: '5_10m',
            investmentExperienceCodes: <String>['stocks'],
            investmentPurposeCode: 'growth',
            fundSourceCode: 'ok',
            riskToleranceCode: 'accept_loss',
            ekycDocumentType: 'drivers_license',
            idDocumentPhotoPath: '/tmp/front.jpg',
            selfiePhotoPath: '/tmp/selfie.jpg',
            electronicDeliveryConsent: true,
            antiSocialForcesConsent: true,
            privacyPolicyConsent: true,
          ),
        );
        final useCase = IsMemberProfileCompletedUseCase(repository);

        expect(await useCase.call(), isTrue);
      },
    );

    test('tracks 5-step progress count from the new edit flow', () {
      const profile = MemberProfileDetails(
        nameKanji: '田中 太郎',
        katakana: 'タナカ タロウ',
        familyNameEn: 'TANAKA',
        givenNameEn: 'TARO',
        birthday: '1994-02-10',
        sex: 1,
        taxcountry: '日本',
        zipCode: '1000001',
        prefectureCode: 'tokyo',
        cityAddress: '千代田区丸の内1-1-1',
        phone: '09012345678',
        occupationCode: 'employee',
        annualIncomeCode: '5_10m',
        financialAssetsCode: '5_10m',
        investmentPurposeCode: 'growth',
        fundSourceCode: 'ok',
        riskToleranceCode: 'accept_loss',
      );

      expect(profile.completedFlowStepCount, 3);
      expect(profile.currentFlowStepIndex, 3);
      expect(profile.isEditFlowComplete, isFalse);
    });
  });
}
