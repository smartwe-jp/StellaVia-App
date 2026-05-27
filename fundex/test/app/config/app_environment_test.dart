import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/config/app_environment.dart';
import 'package:fundex/app/config/app_flavor.dart';

void main() {
  group('EnvironmentFactory', () {
    test('builds dev defaults', () {
      final env = EnvironmentFactory.fromFlavor(AppFlavor.dev);

      expect(env.flavor, AppFlavor.dev);
      expect(env.appName, 'StellaVia Dev');
      expect(env.memberApiBaseUrl, 'https://testoa.gutingjun.com/api');
      expect(env.hotelApiBaseUrl, 'https://hotel-sit.gutingjun.com/api');
      expect(env.oaApiBaseUrl, 'https://testoa.gutingjun.com/api');
      expect(env.veritransTokenApiBaseUrl, 'https://api3.veritrans.co.jp');
      expect(env.veritransTokenApiKey, isEmpty);
      expect(env.enableHttpLog, isTrue);
    });

    test('builds staging defaults', () {
      final env = EnvironmentFactory.fromFlavor(AppFlavor.staging);

      expect(env.flavor, AppFlavor.staging);
      expect(env.appName, 'StellaVia Staging');
      expect(env.memberApiBaseUrl, 'https://testoa.gutingjun.com/api');
      expect(env.hotelApiBaseUrl, 'https://hotel-sit.gutingjun.com/api');
      expect(env.oaApiBaseUrl, 'https://testoa.gutingjun.com/api');
      expect(env.veritransTokenApiBaseUrl, 'https://api3.veritrans.co.jp');
      expect(env.veritransTokenApiKey, isEmpty);
      expect(env.enableHttpLog, isTrue);
    });

    test('builds prod defaults', () {
      final env = EnvironmentFactory.fromFlavor(AppFlavor.prod);

      expect(env.flavor, AppFlavor.prod);
      expect(env.appName, 'StellaVia');
      expect(env.memberApiBaseUrl, 'https://stellavia.co.jp/api');
      expect(env.hotelApiBaseUrl, 'https://hotel.gutingjun.com/api');
      expect(env.oaApiBaseUrl, 'https://stellavia.co.jp/api');
      expect(env.veritransTokenApiBaseUrl, 'https://api3.veritrans.co.jp');
      expect(env.veritransTokenApiKey, isEmpty);
      expect(env.enableHttpLog, isFalse);
    });

    test('applies overrides when provided', () {
      final env = EnvironmentFactory.fromFlavor(
        AppFlavor.staging,
        memberApiBaseUrlOverride: 'https://custom.example.com',
        hotelApiBaseUrlOverride: 'https://hotel.custom.example.com',
        oaApiBaseUrlOverride: 'https://oa.custom.example.com',
        veritransTokenApiBaseUrlOverride:
            'https://veritrans.custom.example.com',
        veritransTokenApiKeyOverride: 'token-key',
        enableHttpLogOverride: false,
      );

      expect(env.memberApiBaseUrl, 'https://custom.example.com');
      expect(env.hotelApiBaseUrl, 'https://hotel.custom.example.com');
      expect(env.oaApiBaseUrl, 'https://oa.custom.example.com');
      expect(
        env.veritransTokenApiBaseUrl,
        'https://veritrans.custom.example.com',
      );
      expect(env.veritransTokenApiKey, 'token-key');
      expect(env.enableHttpLog, isFalse);
    });
  });

  group('parseAppFlavor', () {
    test('parses known values', () {
      expect(parseAppFlavor('dev'), AppFlavor.dev);
      expect(parseAppFlavor('staging'), AppFlavor.staging);
      expect(parseAppFlavor('prod'), AppFlavor.prod);
      expect(parseAppFlavor('production'), AppFlavor.prod);
    });

    test('falls back to dev for unknown values', () {
      expect(parseAppFlavor('x'), AppFlavor.dev);
    });
  });
}
