import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../data/adapters/auth_identity_auth_state_store.dart';
import '../../data/adapters/baidu_face_liveness_collector.dart';
import '../../data/adapters/system_device_biometric_authenticator.dart';
import 'auth_providers.dart';

final identityAuthFeatureEnabledProvider = Provider<bool>((ref) {
  return const bool.fromEnvironment(
    'ENABLE_IDENTITY_AUTH',
    defaultValue: false,
  );
});

final identityAuthFlowPolicyProvider = Provider<IdentityAuthFlowPolicy>((ref) {
  return const IdentityAuthFlowPolicy();
});

final identityAuthFlowProvider = Provider<IdentityAuthFlow>((ref) {
  return IdentityAuthFlow(policy: ref.watch(identityAuthFlowPolicyProvider));
});

final realPersonEndpointsProvider = Provider<RealPersonEndpoints>((ref) {
  return const RealPersonEndpoints();
});

final realPersonApiGatewayProvider = Provider<RealPersonGateway>((ref) {
  return RealPersonApiClient(
    client: ref.watch(memberCoreHttpClientProvider),
    endpoints: ref.watch(realPersonEndpointsProvider),
  );
});

final identityAuthStateStoreProvider = Provider<IdentityAuthStateStore>((ref) {
  return AuthIdentityAuthStateStore(
    largeDataStore: ref.watch(largeDataStoreProvider),
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final baiduFaceLicenseIdProvider = Provider<String?>((ref) {
  // const value = String.fromEnvironment(
  //   'BAIDU_FACE_LICENSE_ID',
  //   defaultValue: '',
  // );
  // final normalized = value.trim();
  // if (normalized.isNotEmpty) {
  //   return normalized;
  // }

  if (kIsWeb) {
    return null;
  }

  // Backward-compatible fallback used in legacy FUNDEX-family apps.
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'stellavia-googleplay-face-android',
    TargetPlatform.iOS => 'fund-stellavia-face-ios',
    _ => null,
  };
});

final identityAuthBiometricAuthenticatorProvider =
    Provider<DeviceBiometricAuthenticator?>((ref) {
  return SystemDeviceBiometricAuthenticator(
    localizedReason: _resolveBiometricReason(
      ref.watch(appLanguageProvider),
    ),
  );
});

final identityAuthLivenessCollectorProvider = Provider<LivenessCollector?>((
  ref,
) {
  final licenseId = ref.watch(baiduFaceLicenseIdProvider);
  if (licenseId == null || licenseId.trim().isEmpty) {
    return null;
  }
  return BaiduFaceLivenessCollector(licenseId: licenseId);
});

final identityAuthCoordinatorProvider = Provider<IdentityAuthCoordinator>((
  ref,
) {
  return IdentityAuthCoordinator(
    apiGateway: ref.watch(realPersonApiGatewayProvider),
    stateStore: ref.watch(identityAuthStateStoreProvider),
    biometricAuthenticator: ref.watch(
      identityAuthBiometricAuthenticatorProvider,
    ),
    livenessCollector: ref.watch(identityAuthLivenessCollectorProvider),
    flow: ref.watch(identityAuthFlowProvider),
  );
});

String _resolveBiometricReason(AppLanguage language) {
  return switch (language) {
    AppLanguage.ja => '続行するために生体認証を行ってください。',
    AppLanguage.en => 'Authenticate with Face ID or Touch ID to continue.',
    AppLanguage.zh || AppLanguage.zhHant => '请使用面容 ID 或触控 ID 以继续操作。',
    AppLanguage.system => 'Authenticate with Face ID or Touch ID to continue.',
  };
}
