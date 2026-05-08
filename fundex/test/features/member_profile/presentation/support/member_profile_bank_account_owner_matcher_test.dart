import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_details.dart';
import 'package:fundex/features/member_profile/presentation/support/member_profile_bank_account_owner_matcher.dart';

void main() {
  group('isBankAccountOwnerNameMatchedToVerifiedName', () {
    const profile = MemberProfileDetails(
      familyName: '山田',
      givenName: '太郎',
      familyNameKana: 'ヤマダ',
      givenNameKana: 'タロウ',
      familyNameEn: 'Yamada',
      givenNameEn: 'Taro',
      nameKanji: '山田 太郎',
      katakana: 'ヤマダ タロウ',
    );

    test('matches when account holder contains the verified name', () {
      expect(
        isBankAccountOwnerNameMatchedToVerifiedName(
          accountHolderName: '株式会社 山田太郎',
          profile: profile,
          authUser: null,
        ),
        isTrue,
      );
    });

    test('matches reversed family and given name order', () {
      expect(
        isBankAccountOwnerNameMatchedToVerifiedName(
          accountHolderName: 'taro yamada',
          profile: profile,
          authUser: null,
        ),
        isTrue,
      );
    });

    test('ignores spaces, case, and half-width katakana', () {
      expect(
        isBankAccountOwnerNameMatchedToVerifiedName(
          accountHolderName: 'ﾔﾏﾀﾞ ﾀﾛｳ',
          profile: profile,
          authUser: null,
        ),
        isTrue,
      );
    });

    test('treats hiragana and katakana as equivalent', () {
      expect(
        isBankAccountOwnerNameMatchedToVerifiedName(
          accountHolderName: 'やまだ たろう',
          profile: profile,
          authUser: null,
        ),
        isTrue,
      );
    });

    test('uses auth user as fallback source', () {
      expect(
        isBankAccountOwnerNameMatchedToVerifiedName(
          accountHolderName: 'HANAKO SUZUKI',
          profile: null,
          authUser: const AuthUser(
            username: 'user',
            lastNameEn: 'Suzuki',
            firstNameEn: 'Hanako',
          ),
        ),
        isTrue,
      );
    });

    test('rejects unrelated account holder names', () {
      expect(
        isBankAccountOwnerNameMatchedToVerifiedName(
          accountHolderName: '佐藤花子',
          profile: profile,
          authUser: null,
        ),
        isFalse,
      );
    });
  });
}
