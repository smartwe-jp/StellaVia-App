import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/app_auth_failure_handler.dart';
import '../auth/persistent_token_store.dart';
import '../config/environment_provider.dart';
import '../observability/app_observability_providers.dart';
import '../storage/app_storage_providers.dart';
import 'app_observability_interceptor.dart';
import 'app_network_connectivity_providers.dart';

enum AppApiCluster { oa, member, hotel }

class AppNetworkAuthFailureSignal extends StateNotifier<int> {
  AppNetworkAuthFailureSignal() : super(0);

  void notifyFailure() {
    state = state + 1;
  }
}

final appNetworkAuthFailureSignalProvider =
    StateNotifierProvider<AppNetworkAuthFailureSignal, int>((ref) {
      return AppNetworkAuthFailureSignal();
    });

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return PersistentTokenStore(ref.watch(secureKeyValueStorageProvider));
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  final baseUrl = ref.watch(oaApiBaseUrlProvider);
  return EndpointTokenRefresher.oauth2(
    Dio(BaseOptions(baseUrl: baseUrl)),
    refreshPath: AuthApiPaths.oauthToken,
    basicAuthorization: AuthApiDefaults.oauthClientAuthorization,
  );
});

final authFailureHandlerProvider = Provider<AuthFailureHandler>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final messageController = ref.watch(appUiMessageProvider.notifier);
  final authFailureSignal = ref.watch(
    appNetworkAuthFailureSignalProvider.notifier,
  );

  return AppAuthFailureHandler(
    logger: logger,
    onSignedOut: () async {
      authFailureSignal.notifyFailure();
    },
    reportErrorMessage: messageController.showError,
  );
});

final appApiClusterBaseUrlProvider = Provider.family<String, AppApiCluster>((
  ref,
  cluster,
) {
  return switch (cluster) {
    AppApiCluster.oa => ref.watch(oaApiBaseUrlProvider),
    AppApiCluster.member => ref.watch(memberApiBaseUrlProvider),
    AppApiCluster.hotel => ref.watch(hotelApiBaseUrlProvider),
  };
});

final coreHttpClientByClusterProvider =
    Provider.family<CoreHttpClient, AppApiCluster>((ref, cluster) {
      const enableHttpResponseLog = bool.fromEnvironment(
        'ENABLE_HTTP_RESPONSE_LOG',
        defaultValue: true,
      );
      final baseUrl = ref.watch(appApiClusterBaseUrlProvider(cluster));
      final environment = ref.watch(appEnvironmentProvider);
      final logger = ref.watch(appLoggerProvider);
      final messageController = ref.watch(appUiMessageProvider.notifier);
      final networkAccessState = ref.watch(
        appNetworkAccessStateProvider.notifier,
      );

      final client = CoreHttpClient(
        baseUrl: baseUrl,
        tokenStore: ref.watch(tokenStoreProvider),
        tokenRefresher: ref.watch(tokenRefresherProvider),
        authFailureHandler: ref.watch(authFailureHandlerProvider),
      );

      client.dio.interceptors.add(
        AppObservabilityInterceptor(
          logger: logger,
          reportErrorMessage: messageController.showError,
          markNetworkAccessDenied: networkAccessState.markDenied,
          clearNetworkAccessDenied: networkAccessState.clear,
          includeHttpPayloadLog: environment.enableHttpLog,
          includeHttpResponseLog: enableHttpResponseLog,
        ),
      );

      if (environment.enableHttpLog) {
        client.dio.interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: enableHttpResponseLog,
            logPrint: (Object value) => _logLongHttpDebug(logger, value),
          ),
        );
      }

      return client;
    });

final oaCoreHttpClientProvider = Provider<CoreHttpClient>((ref) {
  return ref.watch(coreHttpClientByClusterProvider(AppApiCluster.oa));
});

final memberCoreHttpClientProvider = Provider<CoreHttpClient>((ref) {
  return ref.watch(coreHttpClientByClusterProvider(AppApiCluster.member));
});

final hotelCoreHttpClientProvider = Provider<CoreHttpClient>((ref) {
  return ref.watch(coreHttpClientByClusterProvider(AppApiCluster.hotel));
});

final apiClusterRouterProvider = Provider<ApiClusterRouter>((ref) {
  return ApiClusterRouter.fromClients(
    oaClient: ref.watch(oaCoreHttpClientProvider),
    memberClient: ref.watch(memberCoreHttpClientProvider),
    hotelClient: ref.watch(hotelCoreHttpClientProvider),
  );
});

void _logLongHttpDebug(AppLogger logger, Object value) {
  final text = value.toString();
  const chunkSize = 800;
  if (text.length <= chunkSize) {
    logger.debug(text);
    return;
  }

  final totalChunks = (text.length + chunkSize - 1) ~/ chunkSize;
  for (var offset = 0, chunk = 1; offset < text.length; offset += chunkSize) {
    final end = offset + chunkSize > text.length
        ? text.length
        : offset + chunkSize;
    logger.debug(
      '[HTTP log chunk $chunk/$totalChunks] ${text.substring(offset, end)}',
    );
    chunk += 1;
  }
}
