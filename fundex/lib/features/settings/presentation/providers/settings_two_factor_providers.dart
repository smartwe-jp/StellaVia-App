import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/firebase/push_token_sync_adapters.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../../../app/push/app_push_runtime_provider.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/data/adapters/auth_identity_auth_state_store.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/identity_auth_sdk_providers.dart';
import '../../data/datasources/settings_two_factor_local_data_source.dart';
import '../../data/datasources/settings_two_factor_remote_data_source.dart';

final settingsTwoFactorLocalDataSourceProvider =
    Provider<SettingsTwoFactorLocalDataSource>((ref) {
      return SettingsTwoFactorLocalDataSourceImpl(
        largeDataStore: ref.watch(largeDataStoreProvider),
        authLocalDataSource: ref.watch(authLocalDataSourceProvider),
      );
    });

final settingsTwoFactorRemoteDataSourceProvider =
    Provider<SettingsTwoFactorRemoteDataSource>((ref) {
      return SettingsTwoFactorRemoteDataSourceImpl(
        ref.watch(oaCoreHttpClientProvider),
        memberClient: ref.watch(memberCoreHttpClientProvider),
        clusterRouter: ref.watch(apiClusterRouterProvider),
      );
    });

final settingsPhoneVerificationSnapshotProvider =
    FutureProvider.autoDispose<PhoneVerificationSnapshot>((ref) async {
      ref.watch(authSessionProvider);
      await ref
          .watch(settingsRemoteVerificationStatusProvider.future)
          .catchError((Object _) => null);
      await ref.watch(currentAuthUserProvider.future).catchError((Object _) {
        return null;
      });
      return ref
          .watch(settingsTwoFactorLocalDataSourceProvider)
          .readPhoneVerificationSnapshot();
    });

final settingsRemoteVerificationStatusProvider =
    FutureProvider.autoDispose<AuthMemberLoginIndexDto?>((ref) async {
      ref.watch(authSessionProvider);
      final user = await ref.watch(currentAuthUserProvider.future).catchError((
        Object _,
      ) {
        return null;
      });
      if (user == null) {
        return null;
      }

      try {
        final pushRuntime = ref.watch(appPushRuntimeProvider);
        final deviceId = pushRuntime.latestToken?.trim() ?? '';
        if (deviceId.isEmpty) {
          return null;
        }
        final version = await resolvePushSyncAppVersion();
        final deviceType = resolvePushSyncDeviceType();
        final remoteStatus = await ref
            .watch(settingsTwoFactorRemoteDataSourceProvider)
            .fetchMemberLoginIndexStatus(
              deviceId: deviceId,
              deviceType: deviceType,
              version: version,
            );
        if (remoteStatus == null) {
          return null;
        }

        final phone = _resolvePhone(user);
        await ref
            .read(settingsTwoFactorLocalDataSourceProvider)
            .syncPhoneVerificationSnapshot(
              verified: remoteStatus.isPhoneVerified,
              phone: phone.isEmpty ? null : phone,
            );

        final store = ref.read(identityAuthStateStoreProvider);
        if (store is AuthIdentityAuthStateStore) {
          await store.syncRemoteSnapshot(
            IdentityAuthSnapshot(
              realPersonVerified: remoteStatus.isRealPersonVerified,
              currentDeviceBiometricEnabled:
                  remoteStatus.isCurrentDeviceVerified,
            ),
          );
        }

        return remoteStatus;
      } catch (_) {
        return null;
      }
    });

final settingsPhoneVerifiedProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final user = await ref.watch(currentAuthUserProvider.future).catchError((
    Object _,
  ) {
    return null;
  });
  if (user == null) {
    return false;
  }

  final remoteStatus = await ref
      .watch(settingsRemoteVerificationStatusProvider.future)
      .catchError((Object _) {
        return null;
      });
  if (remoteStatus != null) {
    return remoteStatus.isPhoneVerified;
  }

  final snapshot = await ref.watch(
    settingsPhoneVerificationSnapshotProvider.future,
  );
  return snapshot.verified;
});

final settingsEmailVerifiedProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final user = await ref.watch(currentAuthUserProvider.future).catchError((
    Object _,
  ) {
    return null;
  });
  if (user == null) {
    return false;
  }

  final currentEmail = user.email?.trim() ?? '';
  if (currentEmail.isNotEmpty) {
    return true;
  }

  final remoteStatus = await ref
      .watch(settingsRemoteVerificationStatusProvider.future)
      .catchError((Object _) {
        return null;
      });
  if (remoteStatus != null) {
    final remoteEmail = remoteStatus.email?.trim() ?? '';
    if (remoteStatus.isEmailVerified || remoteEmail.isNotEmpty) {
      return true;
    }
    return false;
  }

  final emailBindingStatus = user.status;
  if (emailBindingStatus != null) {
    return emailBindingStatus != 0;
  }

  return (user.checkEmailTime?.trim().isNotEmpty ?? false);
});

final settingsVerifiedEmailProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  final user = await ref.watch(currentAuthUserProvider.future).catchError((
    Object _,
  ) {
    return null;
  });
  if (user == null) {
    return null;
  }

  final remoteStatus = await ref
      .watch(settingsRemoteVerificationStatusProvider.future)
      .catchError((Object _) {
        return null;
      });
  final remoteEmail = remoteStatus?.email?.trim() ?? '';
  if (remoteEmail.isNotEmpty) {
    return remoteEmail;
  }

  final currentEmail = user.email?.trim() ?? '';
  return currentEmail.isEmpty ? null : currentEmail;
});

final settingsEmailVerificationUpdatedAtProvider =
    FutureProvider.autoDispose<DateTime?>((ref) async {
      final user = await ref.watch(currentAuthUserProvider.future).catchError((
        Object _,
      ) {
        return null;
      });
      if (user == null) {
        return null;
      }

      final raw = user.checkEmailTime?.trim() ?? '';
      if (raw.isEmpty) {
        return null;
      }
      return DateTime.tryParse(raw)?.toLocal();
    });

final settingsVerifiedPhoneNumberProvider = FutureProvider.autoDispose<String?>(
  (ref) async {
    final user = await ref.watch(currentAuthUserProvider.future).catchError((
      Object _,
    ) {
      return null;
    });
    if (user == null) {
      return null;
    }

    final snapshot = await ref.watch(
      settingsPhoneVerificationSnapshotProvider.future,
    );
    final localPhone = snapshot.verifiedPhone?.trim() ?? '';
    if (localPhone.isNotEmpty) {
      return localPhone;
    }

    final remoteStatus = await ref
        .watch(settingsRemoteVerificationStatusProvider.future)
        .catchError((Object _) {
          return null;
        });
    final currentPhone = _resolvePhone(user);
    if (remoteStatus?.isPhoneVerified == true) {
      return currentPhone.isEmpty ? null : currentPhone;
    }
    if (snapshot.verified && currentPhone.isNotEmpty) {
      return currentPhone;
    }
    return null;
  },
);

final settingsPhoneVerificationUpdatedAtProvider =
    FutureProvider.autoDispose<DateTime?>((ref) async {
      await ref
          .watch(settingsRemoteVerificationStatusProvider.future)
          .catchError((Object _) => null);
      final snapshot = await ref.watch(
        settingsPhoneVerificationSnapshotProvider.future,
      );
      final raw = snapshot.updatedAtIso?.trim() ?? '';
      if (raw.isEmpty) {
        return null;
      }
      return DateTime.tryParse(raw)?.toLocal();
    });

final settingsRealPersonVerifiedProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  ref.watch(authSessionProvider);
  final remoteStatus = await ref
      .watch(settingsRemoteVerificationStatusProvider.future)
      .catchError((Object _) {
        return null;
      });
  if (remoteStatus != null) {
    return remoteStatus.isRealPersonVerified;
  }

  await ref.watch(currentAuthUserProvider.future).catchError((Object _) {
    return null;
  });
  final snapshot = await ref
      .watch(identityAuthStateStoreProvider)
      .readSnapshot();
  return snapshot.realPersonVerified;
});

final settingsRealPersonVerificationUpdatedAtProvider =
    FutureProvider.autoDispose<DateTime?>((ref) async {
      ref.watch(authSessionProvider);
      await ref
          .watch(settingsRemoteVerificationStatusProvider.future)
          .catchError((Object _) => null);
      await ref.watch(currentAuthUserProvider.future).catchError((Object _) {
        return null;
      });
      final store = ref.watch(identityAuthStateStoreProvider);
      if (store is! AuthIdentityAuthStateStore) {
        return null;
      }
      return store.readLastUpdatedAt();
    });

String _resolvePhone(AuthUser user) {
  final mobile = user.mobile?.trim() ?? '';
  if (mobile.isNotEmpty) {
    return mobile;
  }
  return user.phone?.trim() ?? '';
}
