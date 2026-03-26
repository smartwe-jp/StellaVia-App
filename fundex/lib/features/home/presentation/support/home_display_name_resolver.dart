import 'dart:ui';

import '../../../auth/domain/entities/auth_user.dart';

String resolveHomeDisplayName({
  required Locale locale,
  required AuthUser? user,
}) {
  final languageCode = locale.languageCode.toLowerCase();

  return switch (languageCode) {
    'ja' => _resolveJapaneseDisplayName(user),
    'zh' => _resolveChineseDisplayName(user),
    'en' => _resolveEnglishDisplayName(user),
    _ => _resolveGenericDisplayName(user),
  };
}

String _resolveJapaneseDisplayName(AuthUser? user) {
  final baseName =
      _firstNonBlank(<String?>[
        user?.firstName,
        user?.katakana,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'StellaVia';

  return '$baseNameさん';
}

String _resolveChineseDisplayName(AuthUser? user) {
  final baseName =
      _firstNonBlank(<String?>[
        user?.firstName,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'StellaVia';

  return switch (_resolveGender(user?.sex)) {
    _Gender.female => '$baseName女士',
    _Gender.male => '$baseName先生',
    _Gender.unknown => baseName,
  };
}

String _resolveEnglishDisplayName(AuthUser? user) {
  final baseName =
      _firstNonBlank(<String?>[
        user?.firstNameEn,
        user?.firstName,
        user?.lastNameEn,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'StellaVia';

  return switch (_resolveGender(user?.sex)) {
    _Gender.female => 'Ms. $baseName',
    _Gender.male => 'Mr. $baseName',
    _Gender.unknown => baseName,
  };
}

String _resolveGenericDisplayName(AuthUser? user) {
  return _firstNonBlank(<String?>[
        user?.firstName,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'StellaVia';
}

String? _firstNonBlank(List<String?> candidates) {
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

_Gender _resolveGender(int? sex) {
  return switch (sex) {
    1 => _Gender.male,
    2 => _Gender.female,
    _ => _Gender.unknown,
  };
}

enum _Gender { male, female, unknown }
