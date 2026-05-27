import 'app_flavor.dart';

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.appName,
    required this.memberApiBaseUrl,
    required this.hotelApiBaseUrl,
    required this.oaApiBaseUrl,
    required this.veritransTokenApiBaseUrl,
    required this.veritransTokenApiKey,
    required this.enableHttpLog,
  });

  final AppFlavor flavor;
  final String appName;
  final String memberApiBaseUrl;
  final String hotelApiBaseUrl;
  final String oaApiBaseUrl;
  final String veritransTokenApiBaseUrl;
  final String veritransTokenApiKey;
  final bool enableHttpLog;

  bool get isProduction => flavor == AppFlavor.prod;

  AppEnvironment copyWith({
    AppFlavor? flavor,
    String? appName,
    String? memberApiBaseUrl,
    String? hotelApiBaseUrl,
    String? oaApiBaseUrl,
    String? veritransTokenApiBaseUrl,
    String? veritransTokenApiKey,
    bool? enableHttpLog,
  }) {
    return AppEnvironment(
      flavor: flavor ?? this.flavor,
      appName: appName ?? this.appName,
      memberApiBaseUrl: memberApiBaseUrl ?? this.memberApiBaseUrl,
      hotelApiBaseUrl: hotelApiBaseUrl ?? this.hotelApiBaseUrl,
      oaApiBaseUrl: oaApiBaseUrl ?? this.oaApiBaseUrl,
      veritransTokenApiBaseUrl:
          veritransTokenApiBaseUrl ?? this.veritransTokenApiBaseUrl,
      veritransTokenApiKey: veritransTokenApiKey ?? this.veritransTokenApiKey,
      enableHttpLog: enableHttpLog ?? this.enableHttpLog,
    );
  }
}

class EnvironmentFactory {
  const EnvironmentFactory._();

  static AppEnvironment fromFlavor(
    AppFlavor flavor, {
    String? memberApiBaseUrlOverride,
    String? hotelApiBaseUrlOverride,
    String? oaApiBaseUrlOverride,
    String? veritransTokenApiBaseUrlOverride,
    String? veritransTokenApiKeyOverride,
    bool? enableHttpLogOverride,
  }) {
    final defaults = _defaults(flavor);
    return defaults.copyWith(
      memberApiBaseUrl: _pickUrl(
        override: memberApiBaseUrlOverride,
        fallback: defaults.memberApiBaseUrl,
      ),
      hotelApiBaseUrl: _pickUrl(
        override: hotelApiBaseUrlOverride,
        fallback: defaults.hotelApiBaseUrl,
      ),
      oaApiBaseUrl: _pickUrl(
        override: oaApiBaseUrlOverride,
        fallback: defaults.oaApiBaseUrl,
      ),
      veritransTokenApiBaseUrl: _pickUrl(
        override: veritransTokenApiBaseUrlOverride,
        fallback: defaults.veritransTokenApiBaseUrl,
      ),
      veritransTokenApiKey: _pickValue(
        override: veritransTokenApiKeyOverride,
        fallback: defaults.veritransTokenApiKey,
      ),
      enableHttpLog: enableHttpLogOverride ?? defaults.enableHttpLog,
    );
  }

  static AppEnvironment _defaults(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return const AppEnvironment(
          flavor: AppFlavor.dev,
          appName: 'StellaVia Dev',
          memberApiBaseUrl: 'https://testoa.gutingjun.com/api',
          hotelApiBaseUrl: 'https://hotel-sit.gutingjun.com/api',
          oaApiBaseUrl: 'https://testoa.gutingjun.com/api',
          veritransTokenApiBaseUrl: 'https://api3.veritrans.co.jp',
          veritransTokenApiKey: '',
          enableHttpLog: true,
        );
      case AppFlavor.staging:
        return const AppEnvironment(
          flavor: AppFlavor.staging,
          appName: 'StellaVia Staging',
          memberApiBaseUrl: 'https://testoa.gutingjun.com/api',
          hotelApiBaseUrl: 'https://hotel-sit.gutingjun.com/api',
          oaApiBaseUrl: 'https://testoa.gutingjun.com/api',
          veritransTokenApiBaseUrl: 'https://api3.veritrans.co.jp',
          veritransTokenApiKey: '',
          enableHttpLog: true,
        );
      case AppFlavor.prod:
        return const AppEnvironment(
          flavor: AppFlavor.prod,
          appName: 'StellaVia',
          memberApiBaseUrl: 'https://stellavia.co.jp/api',
          hotelApiBaseUrl: 'https://hotel.gutingjun.com/api',
          oaApiBaseUrl: 'https://stellavia.co.jp/api',
          veritransTokenApiBaseUrl: 'https://api3.veritrans.co.jp',
          veritransTokenApiKey: '',
          enableHttpLog: false,
        );
    }
  }

  static String _pickUrl({
    required String? override,
    required String fallback,
  }) {
    return _pickValue(override: override, fallback: fallback);
  }

  static String _pickValue({
    required String? override,
    required String fallback,
  }) {
    final value = override?.trim();
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return value;
  }
}
