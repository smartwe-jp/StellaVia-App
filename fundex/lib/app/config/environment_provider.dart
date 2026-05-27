import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_environment.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw UnimplementedError(
    'appEnvironmentProvider must be overridden from bootstrap().',
  );
});

final memberApiBaseUrlProvider = Provider<String>((ref) {
  return ref.watch(appEnvironmentProvider).memberApiBaseUrl;
});

final hotelApiBaseUrlProvider = Provider<String>((ref) {
  return ref.watch(appEnvironmentProvider).hotelApiBaseUrl;
});

final oaApiBaseUrlProvider = Provider<String>((ref) {
  return ref.watch(appEnvironmentProvider).oaApiBaseUrl;
});

final veritransTokenApiBaseUrlProvider = Provider<String>((ref) {
  return ref.watch(appEnvironmentProvider).veritransTokenApiBaseUrl;
});

final veritransTokenApiKeyProvider = Provider<String>((ref) {
  return ref.watch(appEnvironmentProvider).veritransTokenApiKey;
});
