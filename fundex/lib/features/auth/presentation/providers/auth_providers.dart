import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/auth_user_dto.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register_account_usecase.dart';
import '../../domain/usecases/login_with_code_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/send_register_code_usecase.dart';
import '../../domain/usecases/send_login_code_usecase.dart';
import '../controllers/auth_controller.dart';
import '../state/auth_state.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.watch(largeDataStoreProvider));
});

final currentAuthUserProvider = FutureProvider<AuthUser?>((ref) async {
  ref.watch(authSessionProvider);
  final cachedUser = await ref
      .watch(authLocalDataSourceProvider)
      .readCurrentUser();
  return cachedUser?.toEntity();
});

class AuthSessionController extends StateNotifier<AsyncValue<bool>> {
  AuthSessionController(
    this._tokenStore,
    this._tokenRefresher,
    this._authLocal, {
    Future<AuthUserDto?> Function()? fetchCurrentUser,
  }) : _fetchCurrentUser = fetchCurrentUser,
       super(const AsyncValue.loading()) {
    unawaited(refresh());
  }

  final TokenStore _tokenStore;
  final TokenRefresher _tokenRefresher;
  final AuthLocalDataSource _authLocal;
  final Future<AuthUserDto?> Function()? _fetchCurrentUser;

  Future<void> _clearPersistedAuth() async {
    await _tokenStore.clear();
    try {
      await _authLocal.clearCurrentUser();
    } catch (_) {
      // Hive may be unavailable in lightweight test environments.
    }
  }

  Future<void> _syncCurrentUserCacheBestEffort() async {
    final fetchCurrentUser = _fetchCurrentUser;
    if (fetchCurrentUser == null) {
      return;
    }

    try {
      final user = await fetchCurrentUser();
      if (user == null) {
        return;
      }
      await _authLocal.saveCurrentUser(user);
    } catch (_) {
      // Do not block auth state restoration when user sync fails.
    }
  }

  Future<void> refresh() async {
    try {
      final accessToken = await _tokenStore.readAccessToken();
      final refreshToken = await _tokenStore.readRefreshToken();
      if (accessToken != null && accessToken.trim().isNotEmpty) {
        if (refreshToken == null || refreshToken.trim().isEmpty) {
          await _clearPersistedAuth();
          state = const AsyncValue.data(false);
          return;
        }
        await _syncCurrentUserCacheBestEffort();
        state = const AsyncValue.data(true);
        return;
      }

      if (refreshToken == null || refreshToken.trim().isEmpty) {
        await _clearPersistedAuth();
        state = const AsyncValue.data(false);
        return;
      }

      final refreshedPair = await _tokenRefresher.refresh(refreshToken);
      if (refreshedPair == null) {
        await _clearPersistedAuth();
        state = const AsyncValue.data(false);
        return;
      }

      await _tokenStore.save(refreshedPair);
      await _syncCurrentUserCacheBestEffort();
      state = const AsyncValue.data(true);
    } catch (_) {
      await _clearPersistedAuth();
      state = const AsyncValue.data(false);
    }
  }

  void markAuthenticated() {
    state = const AsyncValue.data(true);
  }

  Future<void> markUnauthenticated() async {
    state = const AsyncValue.data(false);
    try {
      await _authLocal.clearCurrentUser();
    } catch (_) {
      // Hive may be unavailable in lightweight test environments.
    }
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionController, AsyncValue<bool>>((ref) {
      final baseUrl = ref.watch(oaApiBaseUrlProvider);
      final authUserSyncRemote = AuthRemoteDataSourceImpl(
        CoreHttpClient(
          baseUrl: baseUrl,
          tokenStore: ref.watch(tokenStoreProvider),
          tokenRefresher: ref.watch(tokenRefresherProvider),
          authFailureHandler: const NoopAuthFailureHandler(),
        ),
      );
      return AuthSessionController(
        ref.watch(tokenStoreProvider),
        ref.watch(tokenRefresherProvider),
        ref.watch(authLocalDataSourceProvider),
        fetchCurrentUser: authUserSyncRemote.fetchCurrentUser,
      );
    });

final isAuthenticatedProvider = Provider<AsyncValue<bool>>((ref) {
  return ref.watch(authSessionProvider);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    ref.watch(oaCoreHttpClientProvider),
    memberClient: ref.watch(memberCoreHttpClientProvider),
    clusterRouter: ref.watch(apiClusterRouterProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    local: ref.watch(authLocalDataSourceProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

final sendLoginCodeUseCaseProvider = Provider<SendLoginCodeUseCase>((ref) {
  return SendLoginCodeUseCase(ref.watch(authRepositoryProvider));
});

final sendRegisterCodeUseCaseProvider = Provider<SendRegisterCodeUseCase>((
  ref,
) {
  return SendRegisterCodeUseCase(ref.watch(authRepositoryProvider));
});

final loginWithCodeUseCaseProvider = Provider<LoginWithCodeUseCase>((ref) {
  return LoginWithCodeUseCase(ref.watch(authRepositoryProvider));
});

final registerAccountUseCaseProvider = Provider<RegisterAccountUseCase>((ref) {
  return RegisterAccountUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.watch(sendLoginCodeUseCaseProvider),
      ref.watch(loginWithCodeUseCaseProvider),
    );
  },
);
