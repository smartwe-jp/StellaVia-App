import 'package:core_storage/core_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_storage_providers.dart';

const _localeStorageKey = 'app_locale';

enum AppLanguage {
  system(null),
  zh('zh'),
  zhHant('zh', 'Hant'),
  en('en'),
  ja('ja');

  const AppLanguage(this.languageCode, [this.scriptCode]);

  final String? languageCode;
  final String? scriptCode;

  String get nativeLabel {
    return switch (this) {
      AppLanguage.system => 'System',
      AppLanguage.zh => '简体中文',
      AppLanguage.zhHant => '繁體中文',
      AppLanguage.en => 'English',
      AppLanguage.ja => '日本語',
    };
  }

  String? get storageCode {
    final code = languageCode;
    if (code == null) {
      return null;
    }
    final script = scriptCode;
    if (script == null || script.isEmpty) {
      return code;
    }
    return '${code}_$script';
  }

  Locale? toLocale() {
    final code = languageCode;
    if (code == null) {
      return null;
    }
    return Locale.fromSubtags(languageCode: code, scriptCode: scriptCode);
  }

  static AppLanguage fromLanguageCode(String? code) {
    if (code == null || code.isEmpty) {
      return AppLanguage.system;
    }
    for (final candidate in values) {
      if (candidate.storageCode == code) {
        return candidate;
      }
    }
    if (code == 'zh-Hant' || code == 'zh_TW' || code == 'zh-HK') {
      return AppLanguage.zhHant;
    }
    if (code == 'zh-Hans' || code == 'zh_CN') {
      return AppLanguage.zh;
    }
    return AppLanguage.system;
  }
}

String resolveAppApiLanguageTag(AppLanguage language, {Locale? systemLocale}) {
  final locale =
      language.toLocale() ??
      systemLocale ??
      WidgetsBinding.instance.platformDispatcher.locale;
  return resolveApiLanguageTagForLocale(locale);
}

String resolveApiLanguageTagForLocale(Locale locale) {
  return switch (locale.languageCode.toLowerCase()) {
    'ja' => 'ja',
    'zh' => _isTraditionalChineseLocale(locale) ? 'zh-Hant' : 'zh-Hans',
    _ => 'en',
  };
}

bool _isTraditionalChineseLocale(Locale locale) {
  final scriptCode = locale.scriptCode?.toLowerCase();
  if (scriptCode == 'hant') {
    return true;
  }
  if (scriptCode == 'hans') {
    return false;
  }
  final countryCode = locale.countryCode?.toUpperCase();
  return countryCode == 'TW' || countryCode == 'HK' || countryCode == 'MO';
}

class AppLocaleController extends StateNotifier<AppLanguage> {
  AppLocaleController(this._storage) : super(AppLanguage.system) {
    _restoreFuture = _restore();
  }

  final KeyValueStorage _storage;
  late final Future<void> _restoreFuture;

  Future<void> get ready => _restoreFuture;

  Future<void> _restore() async {
    final languageCode = await _storage.read(_localeStorageKey);
    if (!mounted) {
      return;
    }
    state = AppLanguage.fromLanguageCode(languageCode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _restoreFuture;
    if (!mounted) {
      return;
    }
    state = language;
    final storageCode = language.storageCode;
    if (storageCode == null) {
      await _storage.remove(_localeStorageKey);
      return;
    }
    await _storage.write(_localeStorageKey, storageCode);
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLocaleController, AppLanguage>((ref) {
      return AppLocaleController(ref.watch(sharedPrefsStorageProvider));
    });

final appLocaleProvider = Provider<Locale?>((ref) {
  return ref.watch(appLanguageProvider).toLocale();
});

final appEffectiveLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(appLocaleProvider) ??
      WidgetsBinding.instance.platformDispatcher.locale;
});

final appApiLanguageTagProvider = Provider<String>((ref) {
  return resolveAppApiLanguageTag(ref.watch(appLanguageProvider));
});
