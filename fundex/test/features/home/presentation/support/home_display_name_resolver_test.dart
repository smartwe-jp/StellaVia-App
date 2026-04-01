import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/home/presentation/support/home_display_name_resolver.dart';
import 'package:fundex/features/member_profile/presentation/providers/member_profile_providers.dart';

void main() {
  group('resolveHomeDisplayName', () {
    test('uses family name for japanese display name', () {
      final result = resolveHomeDisplayName(
        locale: const Locale('ja'),
        profile: const MemberBasicProfile(
          familyName: '刁',
          givenName: '文阳',
          familyNameKana: '',
          givenNameKana: '',
          familyNameEn: '',
          givenNameEn: '',
          username: 'demo',
          email: '',
          phone: '',
          sex: null,
        ),
      );

      expect(result, '刁さん');
    });

    test('uses family name for chinese display name', () {
      final result = resolveHomeDisplayName(
        locale: const Locale('zh'),
        profile: const MemberBasicProfile(
          familyName: '刁',
          givenName: '文阳',
          familyNameKana: '',
          givenNameKana: '',
          familyNameEn: '',
          givenNameEn: '',
          username: 'demo',
          email: '',
          phone: '',
          sex: null,
        ),
      );

      expect(result, '刁');
    });

    test('uses familyNameEn first for english display name', () {
      final result = resolveHomeDisplayName(
        locale: const Locale('en'),
        profile: const MemberBasicProfile(
          familyName: '刁',
          givenName: '文阳',
          familyNameKana: '',
          givenNameKana: '',
          familyNameEn: 'Diao',
          givenNameEn: 'Wenyang',
          username: 'demo',
          email: '',
          phone: '',
          sex: null,
        ),
      );

      expect(result, 'Diao');
    });
  });
}
