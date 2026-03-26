import 'app_flavor.dart';

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.appName,
    required this.memberApiBaseUrl,
    required this.hotelApiBaseUrl,
    required this.oaApiBaseUrl,
    required this.enableHttpLog,
  });

  final AppFlavor flavor;
  final String appName;
  final String memberApiBaseUrl;
  final String hotelApiBaseUrl;
  final String oaApiBaseUrl;
  final bool enableHttpLog;

  bool get isProduction => flavor == AppFlavor.prod;

  AppEnvironment copyWith({
    AppFlavor? flavor,
    String? appName,
    String? memberApiBaseUrl,
    String? hotelApiBaseUrl,
    String? oaApiBaseUrl,
    bool? enableHttpLog,
  }) {
    return AppEnvironment(
      flavor: flavor ?? this.flavor,
      appName: appName ?? this.appName,
      memberApiBaseUrl: memberApiBaseUrl ?? this.memberApiBaseUrl,
      hotelApiBaseUrl: hotelApiBaseUrl ?? this.hotelApiBaseUrl,
      oaApiBaseUrl: oaApiBaseUrl ?? this.oaApiBaseUrl,
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
      enableHttpLog: enableHttpLogOverride ?? defaults.enableHttpLog,
    );
  }

  static AppEnvironment _defaults(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return const AppEnvironment(
          flavor: AppFlavor.dev,
          appName: 'StellaVia Dev',
          memberApiBaseUrl: 'https://sit-new.gutingjun.com/api',
          hotelApiBaseUrl: 'https://hotel-sit.gutingjun.com/api',
          oaApiBaseUrl: 'https://testoa.gutingjun.com/api',
          enableHttpLog: true,
        );
      case AppFlavor.staging:
        return const AppEnvironment(
          flavor: AppFlavor.staging,
          appName: 'StellaVia Staging',
          memberApiBaseUrl: 'https://sit-new.gutingjun.com/api',
          hotelApiBaseUrl: 'https://hotel-sit.gutingjun.com/api',
          oaApiBaseUrl: 'https://testoa.gutingjun.com/api',
          enableHttpLog: true,
        );
      case AppFlavor.prod:
        return const AppEnvironment(
          flavor: AppFlavor.prod,
          appName: 'StellaVia',
          memberApiBaseUrl: 'https://stellavia.co.jp/api',
          hotelApiBaseUrl: 'https://hotel.gutingjun.com/api',
          oaApiBaseUrl: 'https://stellavia.co.jp/api',
          enableHttpLog: false,
        );
    }
  }

  static String _pickUrl({
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
