import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../support/settings_operating_company_content.dart';

final settingsOperatingCompanyContentProvider =
    FutureProvider.family<SettingsOperatingCompanyContent, String>((
      ref,
      String localeTag,
    ) async {
      return SettingsOperatingCompanyContent.load(localeTag);
    });

final settingsAppVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  final version = info.version.trim();
  final buildNumber = info.buildNumber.trim();
  if (version.isNotEmpty && buildNumber.isNotEmpty) {
    return '$version($buildNumber)';
  }
  if (version.isNotEmpty) {
    return version;
  }
  if (buildNumber.isNotEmpty) {
    return '0.0.0($buildNumber)';
  }
  return '0.0.0';
});
