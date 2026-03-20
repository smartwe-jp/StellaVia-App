import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../../../auth/data/datasources/auth_local_data_source.dart';

abstract class FundProjectFavoritesLocalDataSource {
  Future<Set<String>> readFavoriteProjectIds();
  Future<void> saveFavoriteProjectIds(Set<String> projectIds);
}

class FundProjectFavoritesLocalDataSourceImpl
    implements FundProjectFavoritesLocalDataSource {
  FundProjectFavoritesLocalDataSourceImpl(
    this._largeDataStore,
    this._authLocal,
  );

  static const String _storageKeyPrefix = 'investment.favorite_project_ids';

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocal;

  @override
  Future<Set<String>> readFavoriteProjectIds() async {
    final storageKey = await _resolveStorageKey();
    try {
      final raw = await _largeDataStore.get<dynamic>(storageKey);
      return _decodeIds(raw);
    } catch (_) {
      return <String>{};
    }
  }

  @override
  Future<void> saveFavoriteProjectIds(Set<String> projectIds) async {
    final storageKey = await _resolveStorageKey();
    final normalized =
        projectIds
            .map((String id) => id.trim())
            .where((String id) => id.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    await _largeDataStore.put<String>(storageKey, jsonEncode(normalized));
  }

  Future<String> _resolveStorageKey() async {
    final user = await _authLocal.readCurrentUser();
    final candidates = <String>[
      user?.memberId?.toString() ?? '',
      user?.userId?.toString() ?? '',
      user?.id ?? '',
      user?.username ?? '',
    ];
    for (final candidate in candidates) {
      final normalized = candidate.trim();
      if (normalized.isNotEmpty) {
        return '$_storageKeyPrefix.$normalized';
      }
    }
    return '$_storageKeyPrefix.guest';
  }

  Set<String> _decodeIds(dynamic raw) {
    if (raw == null) {
      return <String>{};
    }

    if (raw is String) {
      final normalized = raw.trim();
      if (normalized.isEmpty) {
        return <String>{};
      }
      try {
        final decoded = jsonDecode(normalized);
        return _decodeIds(decoded);
      } catch (_) {
        return <String>{};
      }
    }

    if (raw is List) {
      return raw
          .map<String?>((dynamic value) {
            final normalized = value?.toString().trim();
            if (normalized == null || normalized.isEmpty) {
              return null;
            }
            return normalized;
          })
          .whereType<String>()
          .toSet();
    }

    return <String>{};
  }
}
