import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../../../auth/data/datasources/auth_local_data_source.dart';

class PhoneVerificationSnapshot {
  const PhoneVerificationSnapshot({
    required this.verified,
    this.verifiedPhone,
    this.updatedAtIso,
  });

  const PhoneVerificationSnapshot.empty() : this(verified: false);

  final bool verified;
  final String? verifiedPhone;
  final String? updatedAtIso;
}

abstract class SettingsTwoFactorLocalDataSource {
  Future<PhoneVerificationSnapshot> readPhoneVerificationSnapshot();
  Future<void> writePhoneVerificationSnapshot({required String phone});
  Future<void> syncPhoneVerificationSnapshot({
    required bool verified,
    String? phone,
  });
  Future<void> clearPhoneVerificationSnapshot();
}

class SettingsTwoFactorLocalDataSourceImpl
    implements SettingsTwoFactorLocalDataSource {
  SettingsTwoFactorLocalDataSourceImpl({
    required LargeDataStore largeDataStore,
    required AuthLocalDataSource authLocalDataSource,
  }) : _largeDataStore = largeDataStore,
       _authLocalDataSource = authLocalDataSource;

  static const String _storagePrefix = 'settings.two_factor.phone';

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<void> clearPhoneVerificationSnapshot() async {
    final storageKey = await _resolveStorageKey();
    if (storageKey == null) {
      return;
    }
    try {
      await _largeDataStore.delete(storageKey);
    } catch (_) {
      // Best effort only.
    }
  }

  @override
  Future<PhoneVerificationSnapshot> readPhoneVerificationSnapshot() async {
    final storageKey = await _resolveStorageKey();
    if (storageKey == null) {
      return const PhoneVerificationSnapshot.empty();
    }

    try {
      final raw = await _largeDataStore.get<dynamic>(storageKey);
      final payload = _toJsonMap(raw);
      if (payload.isEmpty) {
        return const PhoneVerificationSnapshot.empty();
      }
      return PhoneVerificationSnapshot(
        verified:
            payload['verified'] == true ||
            payload['verified']?.toString().trim() == '1',
        verifiedPhone: payload['verifiedPhone']?.toString(),
        updatedAtIso: payload['updatedAt']?.toString(),
      );
    } catch (_) {
      return const PhoneVerificationSnapshot.empty();
    }
  }

  @override
  Future<void> writePhoneVerificationSnapshot({required String phone}) async {
    final storageKey = await _resolveStorageKey();
    final normalizedPhone = phone.trim();
    if (storageKey == null || normalizedPhone.isEmpty) {
      return;
    }

    final payload = <String, dynamic>{
      'verified': true,
      'verifiedPhone': normalizedPhone,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _largeDataStore.put<String>(storageKey, jsonEncode(payload));
    } catch (_) {
      // Best effort only.
    }
  }

  @override
  Future<void> syncPhoneVerificationSnapshot({
    required bool verified,
    String? phone,
  }) async {
    if (!verified) {
      await clearPhoneVerificationSnapshot();
      return;
    }

    final storageKey = await _resolveStorageKey();
    if (storageKey == null) {
      return;
    }

    final existing = await readPhoneVerificationSnapshot();
    final normalizedPhone = phone?.trim();
    final payload = <String, dynamic>{
      'verified': true,
      if (normalizedPhone != null && normalizedPhone.isNotEmpty)
        'verifiedPhone': normalizedPhone
      else if ((existing.verifiedPhone?.trim().isNotEmpty ?? false))
        'verifiedPhone': existing.verifiedPhone!.trim(),
      if ((existing.updatedAtIso?.trim().isNotEmpty ?? false))
        'updatedAt': existing.updatedAtIso!.trim(),
    };

    try {
      await _largeDataStore.put<String>(storageKey, jsonEncode(payload));
    } catch (_) {
      // Best effort only.
    }
  }

  Future<String?> _resolveStorageKey() async {
    final user = await _authLocalDataSource.readCurrentUser();
    if (user == null) {
      return null;
    }

    final scope =
        user.userId?.toString() ??
        user.memberId?.toString() ??
        user.username.trim();
    final normalized = scope.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return '$_storagePrefix.$normalized';
  }

  Map<String, dynamic> _toJsonMap(dynamic raw) {
    if (raw == null) {
      return <String, dynamic>{};
    }
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String) {
      final text = raw.trim();
      if (text.isEmpty) {
        return <String, dynamic>{};
      }
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return <String, dynamic>{};
      }
    }
    return <String, dynamic>{};
  }
}
