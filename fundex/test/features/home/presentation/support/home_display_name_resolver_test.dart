import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/home/presentation/support/home_display_name_resolver.dart';

void main() {
  group('resolveHomeDisplayName', () {
    test('uses firstName for japanese display name', () {
      final result = resolveHomeDisplayName(
        locale: const Locale('ja'),
        user: const AuthUser(username: 'demo', firstName: '刁', lastName: '文阳'),
      );

      expect(result, '刁さん');
    });

    test('uses firstName for chinese display name', () {
      final result = resolveHomeDisplayName(
        locale: const Locale('zh'),
        user: const AuthUser(username: 'demo', firstName: '刁', lastName: '文阳'),
      );

      expect(result, '刁');
    });

    test('uses firstNameEn first for english display name', () {
      final result = resolveHomeDisplayName(
        locale: const Locale('en'),
        user: const AuthUser(
          username: 'demo',
          firstName: '刁',
          lastName: '文阳',
          firstNameEn: 'Diao',
          lastNameEn: 'Wenyang',
        ),
      );

      expect(result, 'Diao');
    });
  });
}
