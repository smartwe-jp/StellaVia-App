import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../network/app_network_providers.dart';
import '../observability/app_observability_providers.dart';
import '../push/app_push_runtime_provider.dart';
import 'push_token_sync_adapters.dart';

final pushDeviceRegistrationApiClientProvider =
    Provider<PushDeviceRegistrationApiClient>((ref) {
      final router = ref.watch(apiClusterRouterProvider);
      return PushDeviceRegistrationApiClient(dioForPath: router.dioForPath);
    });

final pushTokenSyncServiceProvider = Provider<PushTokenSyncService>((ref) {
  final pushRuntime = ref.watch(appPushRuntimeProvider);
  final service = PushTokenSyncService(
    apiClient: ref.watch(pushDeviceRegistrationApiClientProvider),
    logger: AppPushTokenSyncLogger(
      ref.watch(appLoggerProvider),
      providerName: pushRuntime.providerName,
    ),
    appVersionResolver: resolvePushSyncAppVersion,
    deviceTypeResolver: resolvePushSyncDeviceType,
  );
  ref.onDispose(service.dispose);
  return service;
});

final pushTokenSyncBootstrapProvider = Provider<void>((ref) {
  final service = ref.watch(pushTokenSyncServiceProvider);
  final pushRuntime = ref.watch(appPushRuntimeProvider);

  void updateAuth(AsyncValue<bool> authState) {
    service.updateAuthentication(authState.asData?.value ?? false);
  }

  updateAuth(ref.read(isAuthenticatedProvider));

  ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
    updateAuth(next);
  });

  final tokenSubscription = pushRuntime.tokenStream.listen(
    service.enqueueToken,
    onError: (Object error, StackTrace stackTrace) {
      final logger = ref.read(appLoggerProvider);
      logger.error(
        'Push token stream listener failure.',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
  ref.onDispose(tokenSubscription.cancel);

  final latestToken = pushRuntime.latestToken;
  if (latestToken != null && latestToken.trim().isNotEmpty) {
    unawaited(
      Future<void>.microtask(() {
        service.enqueueToken(latestToken);
      }),
    );
  }
});
