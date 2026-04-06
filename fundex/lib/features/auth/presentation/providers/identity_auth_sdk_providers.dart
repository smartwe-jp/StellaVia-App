import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../data/adapters/auth_identity_auth_state_store.dart';
import '../../data/adapters/baidu_face_liveness_collector.dart';
import 'auth_providers.dart';

final identityAuthFeatureEnabledProvider = Provider<bool>((ref) {
  return const bool.fromEnvironment(
    'ENABLE_IDENTITY_AUTH',
    defaultValue: true,
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
  if (kIsWeb) {
    return null;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android => _resolveAndroidBaiduFaceLicenseId(),
    TargetPlatform.iOS => _resolveIosBaiduFaceLicenseId(),
    _ => null,
  };
});

final identityAuthBiometricAuthenticatorProvider =
    Provider<DeviceBiometricAuthenticator?>((ref) {
      return const _BaiduOnlyBiometricAuthenticator();
    });

final identityAuthLivenessCollectorProvider = Provider<LivenessCollector?>((
  ref,
) {
  final licenseId = ref.watch(baiduFaceLicenseIdProvider);
  if (licenseId == null) {
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
    markDeviceBiometricEnabledOnSuccess: false,
  );
});

class _BaiduOnlyBiometricAuthenticator implements DeviceBiometricAuthenticator {
  const _BaiduOnlyBiometricAuthenticator();

  @override
  Future<DeviceBiometricResult> authenticate() async {
    return DeviceBiometricResult.unavailable;
  }
}

String? _resolveAndroidBaiduFaceLicenseId() {
  const androidValue = String.fromEnvironment(
    'BAIDU_FACE_LICENSE_ID_ANDROID',
    defaultValue: '',
  );
  final normalizedAndroid = androidValue.trim();
  if (normalizedAndroid.isNotEmpty) {
    return normalizedAndroid;
  }

  const sharedValue = String.fromEnvironment(
    'BAIDU_FACE_LICENSE_ID',
    defaultValue: '',
  );
  final normalizedShared = sharedValue.trim();
  if (normalizedShared.isNotEmpty) {
    return normalizedShared;
  }

  return 'fund-stellavia-face-android';
}

String? _resolveIosBaiduFaceLicenseId() {
  const iosValue = String.fromEnvironment(
    'BAIDU_FACE_LICENSE_ID_IOS',
    defaultValue: '',
  );
  final normalizedIos = iosValue.trim();
  if (normalizedIos.isNotEmpty) {
    return normalizedIos;
  }

  const sharedValue = String.fromEnvironment(
    'BAIDU_FACE_LICENSE_ID',
    defaultValue: '',
  );
  final normalizedShared = sharedValue.trim();
  if (normalizedShared.isNotEmpty) {
    return normalizedShared;
  }

  return 'fund-stellavia-face-ios';
}
