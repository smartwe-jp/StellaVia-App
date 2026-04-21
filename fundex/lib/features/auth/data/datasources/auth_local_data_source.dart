import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../models/auth_user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCurrentUser(AuthUserDto user);
  Future<AuthUserDto?> readCurrentUser();
  Future<void> clearCurrentUser();
  Future<void> saveLastSignedOutAccount(String account);
  Future<String?> readLastSignedOutAccount();
  Future<void> clearLastSignedOutAccount();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._largeDataStore);

  static const String _currentUserKey = 'auth.current_user';
  static const String _lastSignedOutAccountKey = 'auth.last_signed_out_account';

  final LargeDataStore _largeDataStore;

  @override
  Future<void> clearCurrentUser() async {
    try {
      await _largeDataStore.delete(_currentUserKey);
    } catch (_) {
      // Do not block auth flows when Hive is unavailable in tests/edge cases.
    }
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async {
    try {
      final rawValue = await _largeDataStore.get<dynamic>(_currentUserKey);
      if (rawValue == null) {
        return null;
      }

      if (rawValue is String) {
        if (rawValue.trim().isEmpty) {
          return null;
        }
        final decoded = jsonDecode(rawValue);
        if (decoded is Map<String, dynamic>) {
          return AuthUserDto.fromJson(decoded);
        }
        if (decoded is Map) {
          return AuthUserDto.fromJson(Map<String, dynamic>.from(decoded));
        }
        return null;
      }

      if (rawValue is Map<String, dynamic>) {
        return AuthUserDto.fromJson(rawValue);
      }
      if (rawValue is Map) {
        return AuthUserDto.fromJson(Map<String, dynamic>.from(rawValue));
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    try {
      final existingUser = await readCurrentUser();
      final normalizedUser =
          (user.avatar?.trim().isNotEmpty ?? false) ||
              !(existingUser?.avatar?.trim().isNotEmpty ?? false)
          ? user
          : user.copyWith(avatar: existingUser!.avatar);
      await _largeDataStore.put<String>(
        _currentUserKey,
        jsonEncode(normalizedUser.toJson()),
      );
    } catch (_) {
      // Token login should not fail when local profile cache write fails.
    }
  }

  @override
  Future<void> saveLastSignedOutAccount(String account) async {
    final normalized = account.trim();
    if (normalized.isEmpty) {
      return;
    }
    try {
      await _largeDataStore.put<String>(_lastSignedOutAccountKey, normalized);
    } catch (_) {
      // Keep logout flow available even when local cache write fails.
    }
  }

  @override
  Future<String?> readLastSignedOutAccount() async {
    try {
      final rawValue = await _largeDataStore.get<dynamic>(
        _lastSignedOutAccountKey,
      );
      if (rawValue is String) {
        final normalized = rawValue.trim();
        return normalized.isEmpty ? null : normalized;
      }
      if (rawValue == null) {
        return null;
      }
      final normalized = rawValue.toString().trim();
      return normalized.isEmpty ? null : normalized;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearLastSignedOutAccount() async {
    try {
      await _largeDataStore.delete(_lastSignedOutAccountKey);
    } catch (_) {
      // Keep auth flows available even when local cache cleanup fails.
    }
  }
}
