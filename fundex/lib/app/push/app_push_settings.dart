import 'package:flutter/foundation.dart';

import 'app_push_provider.dart';

class AliyunPushCredentials {
  const AliyunPushCredentials({
    required this.androidAppKey,
    required this.androidAppSecret,
    required this.iosAppKey,
    required this.iosAppSecret,
  });

  final String androidAppKey;
  final String androidAppSecret;
  final String iosAppKey;
  final String iosAppSecret;

  String? get currentPlatformAppKey {
    if (kIsWeb) {
      return null;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => androidAppKey,
      TargetPlatform.iOS => iosAppKey,
      _ => null,
    };
  }

  String? get currentPlatformAppSecret {
    if (kIsWeb) {
      return null;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => androidAppSecret,
      TargetPlatform.iOS => iosAppSecret,
      _ => null,
    };
  }
}

class AppPushSettings {
  const AppPushSettings({
    required this.provider,
    required this.aliyunCredentials,
  });

  final AppPushProvider provider;
  final AliyunPushCredentials aliyunCredentials;

  static AppPushSettings fromDartDefine() {
    const providerRaw = String.fromEnvironment(
      'PUSH_PROVIDER',
      defaultValue: 'aliyun',
    );
    const aliyunAndroidAppKey = String.fromEnvironment(
      'ALIYUN_PUSH_ANDROID_APP_KEY',
      defaultValue: '',
    );
    const aliyunAndroidAppSecret = String.fromEnvironment(
      'ALIYUN_PUSH_ANDROID_APP_SECRET',
      defaultValue: '',
    );
    const aliyunIosAppKey = String.fromEnvironment(
      'ALIYUN_PUSH_IOS_APP_KEY',
      defaultValue: '',
    );
    const aliyunIosAppSecret = String.fromEnvironment(
      'ALIYUN_PUSH_IOS_APP_SECRET',
      defaultValue: '',
    );

    return AppPushSettings(
      provider: parseAppPushProvider(providerRaw),
      aliyunCredentials: const AliyunPushCredentials(
        androidAppKey: aliyunAndroidAppKey,
        androidAppSecret: aliyunAndroidAppSecret,
        iosAppKey: aliyunIosAppKey,
        iosAppSecret: aliyunIosAppSecret,
      ),
    );
  }
}
