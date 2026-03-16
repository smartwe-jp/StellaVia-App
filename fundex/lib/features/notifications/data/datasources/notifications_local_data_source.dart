import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../../../auth/data/datasources/auth_local_data_source.dart';

abstract class NotificationsLocalDataSource {
  Future<Set<int>> readReadNoticeIds();
  Future<void> markNoticeRead(int noticeId);
  Future<void> markNoticesRead(Iterable<int> noticeIds);
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  NotificationsLocalDataSourceImpl(this._largeDataStore, this._authLocal);

  static const String _storageKeyPrefix = 'notifications.read_ids';

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocal;

  @override
  Future<Set<int>> readReadNoticeIds() async {
    final storageKey = await _resolveStorageKey();
    try {
      final raw = await _largeDataStore.get<dynamic>(storageKey);
      return _decodeIds(raw);
    } catch (_) {
      return <int>{};
    }
  }

  @override
  Future<void> markNoticeRead(int noticeId) async {
    if (noticeId <= 0) {
      return;
    }
    final readIds = await readReadNoticeIds();
    if (readIds.contains(noticeId)) {
      return;
    }
    readIds.add(noticeId);
    await _persistReadIds(readIds);
  }

  @override
  Future<void> markNoticesRead(Iterable<int> noticeIds) async {
    final normalized = noticeIds.where((int id) => id > 0).toSet();
    if (normalized.isEmpty) {
      return;
    }

    final readIds = await readReadNoticeIds()
      ..addAll(normalized);
    await _persistReadIds(readIds);
  }

  Future<void> _persistReadIds(Set<int> ids) async {
    final storageKey = await _resolveStorageKey();
    final sorted = ids.toList()..sort();
    await _largeDataStore.put<String>(storageKey, jsonEncode(sorted));
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

  Set<int> _decodeIds(dynamic raw) {
    if (raw == null) {
      return <int>{};
    }

    if (raw is String) {
      final normalized = raw.trim();
      if (normalized.isEmpty) {
        return <int>{};
      }
      try {
        final decoded = jsonDecode(normalized);
        return _decodeIds(decoded);
      } catch (_) {
        return <int>{};
      }
    }

    if (raw is List) {
      return raw
          .map<int?>((dynamic value) {
            if (value is int) {
              return value;
            }
            if (value is num) {
              return value.toInt();
            }
            return int.tryParse(value.toString());
          })
          .whereType<int>()
          .where((int id) => id > 0)
          .toSet();
    }

    return <int>{};
  }
}
