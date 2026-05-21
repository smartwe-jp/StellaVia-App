import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/auth_user_dto.dart';
import '../../domain/entities/discussion_board_draft.dart';

abstract class DiscussionBoardDraftLocalDataSource {
  Future<List<DiscussionBoardDraft>> readDrafts();
  Future<void> saveDraft(DiscussionBoardDraft draft);
  Future<void> deleteDraft(String draftId);
}

class DiscussionBoardDraftLocalDataSourceImpl
    implements DiscussionBoardDraftLocalDataSource {
  DiscussionBoardDraftLocalDataSourceImpl(
    this._largeDataStore,
    this._authLocal,
  );

  static const String _draftsKeyPrefix = 'discussion_board.drafts';
  static const int _maxDrafts = 50;

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocal;

  Future<String> _resolveStorageKey() async {
    final AuthUserDto? user = await _authLocal.readCurrentUser();
    return '$_draftsKeyPrefix.${_resolveUserStorageKey(user)}';
  }

  String _resolveUserStorageKey(AuthUserDto? user) {
    if (user == null) {
      return 'anonymous';
    }
    final int? uid = user.userId ?? user.memberId;
    if (uid != null) {
      return 'uid_$uid';
    }
    final id = user.id?.trim() ?? '';
    if (id.isNotEmpty) {
      return 'id_$id';
    }
    final accountId = user.accountId?.trim() ?? '';
    if (accountId.isNotEmpty) {
      return 'account_$accountId';
    }
    final username = user.username.trim();
    if (username.isNotEmpty) {
      return 'username_$username';
    }
    return 'anonymous';
  }

  @override
  Future<List<DiscussionBoardDraft>> readDrafts() async {
    try {
      final key = await _resolveStorageKey();
      final raw = await _largeDataStore.get<dynamic>(key);
      if (raw == null) {
        return const <DiscussionBoardDraft>[];
      }

      Object? decoded = raw;
      if (raw is String) {
        final text = raw.trim();
        if (text.isEmpty) {
          return const <DiscussionBoardDraft>[];
        }
        decoded = jsonDecode(text);
      }
      if (decoded is! List) {
        return const <DiscussionBoardDraft>[];
      }

      final drafts = decoded
          .whereType<Map>()
          .map(
            (item) =>
                DiscussionBoardDraft.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((draft) => draft.id.trim().isNotEmpty && draft.hasContent)
          .toList(growable: false);
      return drafts;
    } catch (_) {
      return const <DiscussionBoardDraft>[];
    }
  }

  @override
  Future<void> saveDraft(DiscussionBoardDraft draft) async {
    if (!draft.hasContent) {
      return;
    }
    final existing = await readDrafts();
    final next = <DiscussionBoardDraft>[
      draft,
      ...existing.where((item) => item.id != draft.id),
    ].take(_maxDrafts).toList(growable: false);
    await _saveAll(next);
  }

  @override
  Future<void> deleteDraft(String draftId) async {
    final normalized = draftId.trim();
    if (normalized.isEmpty) {
      return;
    }
    final existing = await readDrafts();
    await _saveAll(
      existing.where((item) => item.id != normalized).toList(growable: false),
    );
  }

  Future<void> _saveAll(List<DiscussionBoardDraft> drafts) async {
    final key = await _resolveStorageKey();
    final payload = drafts.map((item) => item.toJson()).toList(growable: false);
    await _largeDataStore.put<String>(key, jsonEncode(payload));
  }
}
