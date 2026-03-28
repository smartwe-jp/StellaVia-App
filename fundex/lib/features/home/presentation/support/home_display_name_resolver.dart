import 'dart:ui';

import '../../../member_profile/presentation/providers/member_profile_providers.dart';

String resolveHomeDisplayName({
  required Locale locale,
  required MemberBasicProfile? profile,
}) {
  final languageCode = locale.languageCode.toLowerCase();

  return switch (languageCode) {
    'ja' => _resolveJapaneseDisplayName(profile),
    'zh' => _resolveChineseDisplayName(profile),
    'en' => _resolveEnglishDisplayName(profile),
    _ => _resolveGenericDisplayName(profile),
  };
}

String _resolveJapaneseDisplayName(MemberBasicProfile? profile) {
  final baseName =
      _firstNonBlank(<String?>[
        profile?.familyName,
        profile?.givenName,
        profile?.givenNameKana,
        profile?.username,
        profile?.email,
        profile?.phone,
      ]) ??
      'StellaVia';

  return '$baseNameさん';
}

String _resolveChineseDisplayName(MemberBasicProfile? profile) {
  final baseName =
      _firstNonBlank(<String?>[
        profile?.familyName,
        profile?.givenName,
        profile?.username,
        profile?.email,
        profile?.phone,
      ]) ??
      'StellaVia';

  return switch (_resolveGender(profile?.sex)) {
    _Gender.female => '$baseName女士',
    _Gender.male => '$baseName先生',
    _Gender.unknown => baseName,
  };
}

String _resolveEnglishDisplayName(MemberBasicProfile? profile) {
  final baseName =
      _firstNonBlank(<String?>[

        profile?.familyNameEn,
        profile?.familyName,
        profile?.givenNameEn,
        profile?.givenName,
        profile?.username,
        profile?.email,
        profile?.phone,
      ]) ??
      'StellaVia';

  return switch (_resolveGender(profile?.sex)) {
    _Gender.female => 'Ms. $baseName',
    _Gender.male => 'Mr. $baseName',
    _Gender.unknown => baseName,
  };
}

String _resolveGenericDisplayName(MemberBasicProfile? profile) {
  return _firstNonBlank(<String?>[
        profile?.familyName,
        profile?.givenName,
        profile?.username,
        profile?.email,
        profile?.phone,
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
    0 => _Gender.female,
    _ => _Gender.unknown,
  };
}

enum _Gender { male, female, unknown }
