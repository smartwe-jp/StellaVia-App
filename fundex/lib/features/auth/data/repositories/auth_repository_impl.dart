import 'package:core_network/core_network.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_session_dto.dart';
import '../models/auth_user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required TokenStore tokenStore,
  }) : _remote = remote,
       _local = local,
       _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final TokenStore _tokenStore;

  Future<void> _syncCurrentUserCacheBestEffort() async {
    try {
      final user = await _remote.fetchCurrentUser();
      if (user == null) {
        return;
      }
      await _local.saveCurrentUser(user);
    } catch (_) {
      // Keep auth flow available even when user sync fails transiently.
    }
  }

  Future<void> _clearPersistedAuth() async {
    try {
      final user = await _local.readCurrentUser();
      final lastAccount = _resolveLastAuthAccount(user);
      if (lastAccount != null) {
        await _local.saveLastSignedOutAccount(lastAccount);
      }
    } catch (_) {
      // Best effort only.
    }
    await _tokenStore.clear();
    try {
      await _local.clearCurrentUser();
    } catch (_) {
      // User cache should not block auth recovery/logout.
    }
  }

  String? _resolveLastAuthAccount(AuthUserDto? user) {
    if (user == null) {
      return null;
    }
    final email = user.email?.trim() ?? '';
    if (email.isNotEmpty) {
      return email;
    }
    final mobile = user.mobile?.trim() ?? '';
    if (mobile.isNotEmpty) {
      return mobile;
    }
    final phone = user.phone?.trim() ?? '';
    if (phone.isNotEmpty) {
      return phone;
    }
    final username = user.username.trim();
    if (username.isNotEmpty) {
      return username;
    }
    return null;
  }

  @override
  Future<void> sendLoginCode({required String account, String? intlCode}) {
    return _remote.sendLoginCode(account: account, intlCode: intlCode);
  }

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) {
    return _remote.sendRegisterCode(account: account, intlCode: intlCode);
  }

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    final result = await _remote.loginWithCode(
      account: account,
      code: code,
      intlCode: intlCode,
    );
    await _tokenStore.save(
      TokenPair(
        accessToken: result.session.accessToken,
        refreshToken: result.session.refreshToken,
      ),
    );
    var user = result.user;
    try {
      final fetchedUser = await _remote.fetchCurrentUser();
      user = fetchedUser ?? user;
    } catch (_) {
      if (user == null) {
        await _clearPersistedAuth();
        rethrow;
      }
    }
    if (user != null) {
      try {
        await _local.saveCurrentUser(user);
      } catch (_) {
        // Token login should succeed even when user cache persistence fails.
      }
    }
    return result.session.toEntity();
  }

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {
    await _remote.registerApply(
      account: account,
      code: code,
      intlCode: intlCode,
      contact: contact,
    );

    final accessToken = await _tokenStore.readAccessToken();
    if (accessToken != null && accessToken.trim().isNotEmpty) {
      await _syncCurrentUserCacheBestEffort();
    }
  }

  @override
  Future<bool> restoreSession() async {
    final accessToken = await _tokenStore.readAccessToken();
    if (accessToken != null && accessToken.trim().isNotEmpty) {
      final refreshToken = await _tokenStore.readRefreshToken();
      if (refreshToken == null || refreshToken.trim().isEmpty) {
        await _clearPersistedAuth();
        return false;
      }
      return true;
    }

    return refreshSession();
  }

  @override
  Future<bool> refreshSession() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      await _clearPersistedAuth();
      return false;
    }

    try {
      final dto = await _remote.refreshSession(refreshToken: refreshToken);
      if (dto == null) {
        await _clearPersistedAuth();
        return false;
      }
      await _tokenStore.save(
        TokenPair(accessToken: dto.accessToken, refreshToken: dto.refreshToken),
      );
      await _syncCurrentUserCacheBestEffort();
      return true;
    } catch (_) {
      await _clearPersistedAuth();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    final accessToken = await _tokenStore.readAccessToken();
    try {
      if (accessToken != null && accessToken.trim().isNotEmpty) {
        await _remote.logout(accessToken: accessToken);
      }
    } catch (_) {
      // Always clear local auth state even when remote revoke fails.
    } finally {
      await _clearPersistedAuth();
    }
  }
}
