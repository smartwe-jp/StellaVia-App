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
        'https://stellavia.co.jp/terms_conditions.ja.pdf',
      );
      expect(
        traditional.termsConditionsUrl,
        'https://stellavia.co.jp/terms_conditions.ja.pdf',
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
        'https://stellavia.co.jp/terms_conditions.ja.pdf',
      );
    });

    test(
      'every UI language opens the same five Japanese policy PDFs',
      () async {
        for (final locale in [
          'ja-JP',
          'en-US',
          'zh-CN',
          'zh-Hant-HK',
          'fr-FR',
        ]) {
          final content = await SettingsOperatingCompanyContent.load(locale);
          const base = 'https://stellavia.co.jp/';
          expect(content.termsConditionsUrl, '${base}terms_conditions.ja.pdf');
          expect(
            content.electronicInformationUrl,
            '${base}electronic_information.ja.pdf',
          );
          expect(
            content.personalInformationUrl,
            '${base}personal_information.ja.pdf',
          );
          expect(content.antiSocialRuleUrl, '${base}antisocialrule.ja.pdf');
          expect(content.links.map((link) => link.url), [
            content.termsConditionsUrl,
            content.electronicInformationUrl,
            content.personalInformationUrl,
            '${base}solicitation_policy.ja.pdf',
            content.antiSocialRuleUrl,
          ]);
        }
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
