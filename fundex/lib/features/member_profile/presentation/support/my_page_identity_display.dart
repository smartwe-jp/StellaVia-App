import 'package:flutter/widgets.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/support/home_display_name_resolver.dart';
import '../providers/member_profile_providers.dart';

String myPageDisplayName(Locale locale, MemberBasicProfile profile) {
  final english = locale.languageCode == 'en';
  final parts = english
      ? [profile.givenNameEn, profile.familyNameEn]
      : [profile.familyName, profile.givenName];
  final name = parts
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join(' ');
  if (name.isEmpty) {
    return resolveHomeDisplayName(locale: locale, profile: profile);
  }
  return switch ((locale.languageCode, profile.sex)) {
    ('ja', _) => '$name さん',
    ('zh', 0) => '$name 女士',
    ('zh', 1) => '$name 先生',
    ('en', 0) => 'Ms. $name',
    ('en', 1) => 'Mr. $name',
    _ => name,
  };
}

(String, AppBadgeTone)? myPageVerificationBadge(
  AppLocalizations l10n,
  int? status,
  String? email,
) => switch (status) {
  0 => (
    email?.trim().isNotEmpty == true
        ? l10n.memberProfileOverviewStatusIncomplete
        : l10n.memberProfileOverviewStatusEmailUnbound,
    AppBadgeTone.warning,
  ),
  1 => (l10n.memberProfileOverviewStatusUnverified, AppBadgeTone.warning),
  2 || 5 => (l10n.memberProfileOverviewStatusPending, AppBadgeTone.warning),
  3 => (l10n.memberProfileOverviewStatusFailed, AppBadgeTone.danger),
  4 => (l10n.memberProfileOverviewStatusVerified, AppBadgeTone.success),
  _ => null,
};
