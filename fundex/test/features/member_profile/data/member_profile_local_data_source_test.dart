import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';
import 'package:fundex/features/member_profile/data/datasources/member_profile_local_data_source.dart';
import 'package:fundex/features/member_profile/data/models/member_profile_details_dto.dart';

class _InMemoryLargeDataStore implements LargeDataStore {
  final Map<String, dynamic> _values = <String, dynamic>{};

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<T?> get<T>(String key) async {
    final value = _values[key];
    if (value == null) {
      return null;
    }
    return value as T;
  }

  @override
  Future<void> put<T>(String key, T value) async {
    _values[key] = value;
  }
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  _FakeAuthLocalDataSource({this.currentUser});

  AuthUserDto? currentUser;
  String? lastSignedOutAccount;

  @override
  Future<void> clearCurrentUser() async {
    currentUser = null;
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async => currentUser;

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    currentUser = user;
  }

  @override
  Future<void> clearLastSignedOutAccount() async {
    lastSignedOutAccount = null;
  }

  @override
  Future<String?> readLastSignedOutAccount() async => lastSignedOutAccount;

  @override
  Future<void> saveLastSignedOutAccount(String account) async {
    lastSignedOutAccount = account;
  }
}

void main() {
  group('MemberProfileLocalDataSourceImpl', () {
    test('saves and restores profile details from local store', () async {
      final store = _InMemoryLargeDataStore();
      final authLocal = _FakeAuthLocalDataSource(
        currentUser: const AuthUserDto(username: 'u100', userId: 100),
      );
      final source = MemberProfileLocalDataSourceImpl(store, authLocal);

      await source.saveProfile(
        MemberProfileDetailsDto(
          familyName: 'Hou',
          givenName: 'Aaron',
          nameKanji: '侯 阿龙',
          katakana: 'コウ アーロン',
          address: 'Tokyo Chiyoda 1-1',
          birthday: '1994-02-10',
          zipCode: '1000001',
          prefectureCode: 'tokyo',
          cityAddress: 'Chiyoda 1-1',
          phoneIntlCode: '81',
          phone: '09012345678',
          email: 'aaron@example.com',
          occupationCode: 'employee',
          annualIncomeCode: '5_10m',
          financialAssetsCode: '5_10m',
          investmentExperienceCodes: const <String>['stocks', 'bonds'],
          investmentPurposeCode: 'growth',
          fundSourceCode: 'ok',
          riskToleranceCode: 'accept_loss',
          ekycDocumentType: 'drivers_license',
          idDocumentPhotoPath: '/tmp/id.jpg',
          idDocumentObliquePhotoPath: '/tmp/angle.jpg',
          selfiePhotoPath: '/tmp/selfie.jpg',
          bankName: 'MUFG',
          branchBankName: 'Marunouchi',
          bankNumber: '1234567',
          bankAccountType: 'ordinary',
          bankAccountOwnerName: 'AARON HOU',
          electronicDeliveryConsent: true,
          antiSocialForcesConsent: true,
          privacyPolicyConsent: true,
          lastEditingStep: 5,
          completedAt: DateTime.utc(2026, 3, 4),
          lastUpdatedAt: DateTime.utc(2026, 2, 25),
        ),
      );

      final restored = await source.readProfile();
      expect(restored, isNotNull);
      expect(restored?.familyName, 'Hou');
      expect(restored?.givenName, 'Aaron');
      expect(restored?.nameKanji, '侯 阿龙');
      expect(restored?.katakana, 'コウ アーロン');
      expect(restored?.birthday, '1994-02-10');
      expect(restored?.zipCode, '1000001');
      expect(restored?.prefectureCode, 'tokyo');
      expect(restored?.cityAddress, 'Chiyoda 1-1');
      expect(restored?.phoneIntlCode, '81');
      expect(restored?.phone, '09012345678');
      expect(restored?.email, 'aaron@example.com');
      expect(restored?.occupationCode, 'employee');
      expect(restored?.investmentExperienceCodes, const <String>[
        'stocks',
        'bonds',
      ]);
      expect(restored?.ekycDocumentType, 'drivers_license');
      expect(restored?.idDocumentPhotoPath, '/tmp/id.jpg');
      expect(restored?.idDocumentObliquePhotoPath, '/tmp/angle.jpg');
      expect(restored?.selfiePhotoPath, '/tmp/selfie.jpg');
      expect(restored?.bankName, 'MUFG');
      expect(restored?.bankAccountOwnerName, 'AARON HOU');
      expect(restored?.electronicDeliveryConsent, isTrue);
      expect(restored?.lastEditingStep, 5);
      expect(restored?.completedAt, DateTime.utc(2026, 3, 4));
    });

    test('clearProfile removes cached details', () async {
      final store = _InMemoryLargeDataStore();
      final authLocal = _FakeAuthLocalDataSource(
        currentUser: const AuthUserDto(username: 'u100', userId: 100),
      );
      final source = MemberProfileLocalDataSourceImpl(store, authLocal);
      await source.saveProfile(
        const MemberProfileDetailsDto(familyName: 'Hou'),
      );

      await source.clearProfile();

      expect(await source.readProfile(), isNull);
    });

    test('isolates cached profile by user id', () async {
      final store = _InMemoryLargeDataStore();
      final authLocal = _FakeAuthLocalDataSource(
        currentUser: const AuthUserDto(username: 'u100', userId: 100),
      );
      final source = MemberProfileLocalDataSourceImpl(store, authLocal);

      await source.saveProfile(
        const MemberProfileDetailsDto(familyName: 'User100'),
      );

      authLocal.currentUser = const AuthUserDto(username: 'u200', userId: 200);
      expect(await source.readProfile(), isNull);

      await source.saveProfile(
        const MemberProfileDetailsDto(familyName: 'User200'),
      );
      final user200Profile = await source.readProfile();
      expect(user200Profile?.familyName, 'User200');

      authLocal.currentUser = const AuthUserDto(username: 'u100', userId: 100);
      final user100Profile = await source.readProfile();
      expect(user100Profile?.familyName, 'User100');
    });
  });
}
