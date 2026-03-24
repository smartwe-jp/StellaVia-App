import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/features/settings/presentation/providers/settings_content_providers.dart';
import 'package:fundex/features/settings/presentation/support/settings_operating_company_content.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsOperatingCompanyContent', () {
    test('loads simplified and traditional chinese variants', () async {
      final simplified = await SettingsOperatingCompanyContent.load('zh-CN');
      final traditional = await SettingsOperatingCompanyContent.load(
        'zh-Hant-HK',
      );

      expect(simplified.business, '不动产特定共同事业、电商等业务');
      expect(traditional.business, '不動產特定共同事業、電子商務等業務');
    });

    test('defaults to english content for unsupported locales', () async {
      final fallback = await SettingsOperatingCompanyContent.load('fr-FR');

      expect(
        fallback.licenseNumber,
        'Real Estate Specified Joint Enterprise\n'
        'Osaka Governor License No. 22',
      );
    });
  });

  group('settingsOperatingCompanyContentProvider', () {
    test('returns content for each requested locale', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final english = await container.read(
        settingsOperatingCompanyContentProvider('en-US').future,
      );
      final traditional = await container.read(
        settingsOperatingCompanyContentProvider('zh-Hant-TW').future,
      );

      expect(
        english.licenseType,
        'Type I, Type II, and Electronic Transaction Operations',
      );
      expect(traditional.links.first.title, '使用條款');
    });
  });

  group('settingsAppVersionProvider', () {
    test('returns the installed app version', () async {
      PackageInfo.setMockInitialValues(
        appName: 'fundex',
        packageName: 'com.example.fundex',
        version: '2.4.6',
        buildNumber: '12',
        buildSignature: 'test',
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(await container.read(settingsAppVersionProvider.future), '2.4.6');
    });
  });
}
