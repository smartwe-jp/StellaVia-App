import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/features/settings/presentation/providers/settings_content_providers.dart';
import 'package:fundex/features/settings/presentation/support/settings_contract_default_documents.dart';
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
      expect(
        simplified.termsConditionsUrl,
        'https://stellavia.co.jp/terms_conditions.zh-hans.pdf',
      );
      expect(
        traditional.termsConditionsUrl,
        'https://stellavia.co.jp/terms_conditions.zh-hant.pdf',
      );
    });

    test('defaults to english content for unsupported locales', () async {
      final fallback = await SettingsOperatingCompanyContent.load('fr-FR');

      expect(
        fallback.licenseNumber,
        'Real Estate Specified Joint Enterprise\n'
        'Osaka Governor License No. 22',
      );
      expect(
        fallback.termsConditionsUrl,
        'https://stellavia.co.jp/terms_conditions.en.pdf',
      );
    });

    test(
      'uses localized pdf suffix while keeping document lookup available',
      () async {
        final japanese = await SettingsOperatingCompanyContent.load('ja-JP');

        expect(
          japanese.termsConditionsUrl,
          'https://stellavia.co.jp/terms_conditions.ja.pdf',
        );
        expect(
          japanese.electronicInformationUrl,
          'https://stellavia.co.jp/electronic_information.ja.pdf',
        );
        expect(
          japanese.personalInformationUrl,
          'https://stellavia.co.jp/personal_information.ja.pdf',
        );
        expect(
          japanese.antiSocialRuleUrl,
          'https://stellavia.co.jp/antisocialrule.ja.pdf',
        );
      },
    );
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

  group('settings contract default documents', () {
    test(
      'puts fixed cooling-off document before operating company links',
      () async {
        final content = await SettingsOperatingCompanyContent.load('ja-JP');

        final project = buildSettingsContractDefaultDocumentsProject(
          projectName: '運営会社',
          operatingCompanyContent: content,
        );

        expect(project.routeKey, settingsContractDefaultProjectId);
        expect(project.documents, hasLength(content.links.length + 1));
        expect(project.documents.first.description, 'クーリング・オフ通知書');
        expect(
          project.documents.first.files.single.url,
          'https://stellavia.co.jp/coolingoffpost.pdf',
        );
        expect(project.documents[1].description, content.links.first.title);
        expect(project.documents[1].files.single.url, content.links.first.url);
      },
    );
  });

  group('settingsAppVersionProvider', () {
    test('returns the installed app version with build number', () async {
      PackageInfo.setMockInitialValues(
        appName: 'fundex',
        packageName: 'com.example.fundex',
        version: '2.4.6',
        buildNumber: '12',
        buildSignature: 'test',
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        await container.read(settingsAppVersionProvider.future),
        '2.4.6(12)',
      );
    });
  });
}
