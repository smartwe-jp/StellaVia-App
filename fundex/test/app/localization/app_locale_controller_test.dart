import 'package:core_storage/core_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/localization/app_locale_providers.dart';

void main() {
  group('AppLocaleController', () {
    test('restores persisted locale from storage', () async {
      final storage = InMemoryKeyValueStorage();
      await storage.write('app_locale', 'en');

      final controller = AppLocaleController(storage);
      await controller.ready;

      expect(controller.state, AppLanguage.en);
      controller.dispose();
    });

    test('setLanguage persists and clears locale setting', () async {
      final storage = InMemoryKeyValueStorage();
      final controller = AppLocaleController(storage);
      await controller.ready;

      await controller.setLanguage(AppLanguage.zh);
      expect(controller.state, AppLanguage.zh);
      expect(await storage.read('app_locale'), 'zh');

      await controller.setLanguage(AppLanguage.zhHant);
      expect(controller.state, AppLanguage.zhHant);
      expect(await storage.read('app_locale'), 'zh_Hant');

      await controller.setLanguage(AppLanguage.system);
      expect(controller.state, AppLanguage.system);
      expect(await storage.read('app_locale'), isNull);
      controller.dispose();
    });
  });

  group('resolveAppApiLanguageTag', () {
    test('maps supported app languages to API tags', () {
      expect(resolveAppApiLanguageTag(AppLanguage.ja), 'ja');
      expect(resolveAppApiLanguageTag(AppLanguage.en), 'en');
      expect(resolveAppApiLanguageTag(AppLanguage.zh), 'zh-Hans');
      expect(resolveAppApiLanguageTag(AppLanguage.zhHant), 'zh-Hant');
    });

    test('maps system Chinese locales by script and region', () {
      expect(
        resolveAppApiLanguageTag(
          AppLanguage.system,
          systemLocale: const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
          ),
        ),
        'zh-Hant',
      );
      expect(
        resolveAppApiLanguageTag(
          AppLanguage.system,
          systemLocale: const Locale('zh', 'CN'),
        ),
        'zh-Hans',
      );
      expect(
        resolveAppApiLanguageTag(
          AppLanguage.system,
          systemLocale: const Locale('zh', 'TW'),
        ),
        'zh-Hant',
      );
    });
  });
}
