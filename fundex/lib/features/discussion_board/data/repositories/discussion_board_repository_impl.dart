import 'package:intl/intl.dart';

import '../datasources/discussion_board_local_data_source.dart';
import '../datasources/discussion_board_remote_data_source.dart';
import '../models/discussion_comment_dto.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../../domain/repositories/discussion_board_repository.dart';
import '../../domain/support/discussion_avatar_palette.dart';

class DiscussionBoardRepositoryImpl implements DiscussionBoardRepository {
  DiscussionBoardRepositoryImpl({
    required DiscussionBoardRemoteDataSource remote,
    required DiscussionBoardLocalDataSource local,
    this.projectId,
  }) : _remote = remote,
       _local = local;

  final DiscussionBoardRemoteDataSource _remote;
  final DiscussionBoardLocalDataSource _local;
  final int? projectId;

  @override
  Future<List<DiscussionThread>> loadThreads({
    int page = 1,
    int limit = 50,
  }) async {
    if (page > 1) {
      return _loadRemoteThreads(page: page, limit: limit);
    }

    try {
      final remoteThreads = await _loadRemoteThreads(page: page, limit: limit);
      await _local.saveThreads(remoteThreads);
      return remoteThreads;
    } catch (_) {
      final cached = await _local.readThreads();
      if (cached.isNotEmpty) {
        return cached;
      }
      return const <DiscussionThread>[];
    }
  }

  @override
  Future<List<DiscussionThread>> submitPost({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    String? fallbackAvatarUrl,
    int? linkedProjectId,
    String? linkedProjectName,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return loadThreads();
    }
    final postedAtUtc = DateTime.now().toUtc();
    final effectiveProjectId = linkedProjectId ?? projectId;
    await _remote.sendComment(content: trimmed, projectId: effectiveProjectId);
    final refreshed = await _refreshFirstPageAfterMutation();
    if (_containsRecentlyPostedThread(
      refreshed,
      trimmed,
      postedAtUtc: postedAtUtc,
    )) {
      return refreshed;
    }

    final optimistic = _buildOptimisticThread(
      content: trimmed,
      nowLabel: nowLabel,
      fallbackName: fallbackName,
      fallbackHandle: fallbackHandle,
      fallbackBadgeLabel: fallbackBadgeLabel,
      fallbackAvatarUrl: fallbackAvatarUrl,
      linkedProjectId: effectiveProjectId,
      linkedProjectName: linkedProjectName,
      postedAtUtc: postedAtUtc,
    );
    final merged = _prependOptimisticThread(
      base: refreshed,
      optimistic: optimistic,
    );
    await _local.saveThreads(merged);
    return merged;
  }

  @override
  Future<List<DiscussionThread>> submitReply({
    required String threadId,
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return loadThreads();
    }
    final remoteParentId = int.tryParse(threadId);
    if (remoteParentId == null) {
      throw StateError('Invalid thread id.');
    }
    await _remote.sendComment(
      content: trimmed,
      parentId: remoteParentId,
      projectId: projectId,
    );
    return _refreshFirstPageAfterMutation();
  }

  @override
  Future<List<DiscussionThread>> deleteComment({
    required String commentId,
  }) async {
    final normalized = commentId.trim();
    if (normalized.isEmpty) {
      return loadThreads();
    }

    final remoteCommentId = int.tryParse(normalized);
    if (remoteCommentId == null) {
      throw StateError('Invalid comment id.');
    }

    await _remote.deleteComment(commentId: remoteCommentId);
    return _refreshFirstPageAfterMutation();
  }

  Future<List<DiscussionThread>> _loadRemoteThreads({
    required int page,
    required int limit,
  }) async {
    final rows = await _remote.fetchCommentPage(
      startPage: page,
      limit: limit,
      projectId: projectId,
    );
    return _mapRemoteRowsToThreads(rows);
  }

  Future<List<DiscussionThread>> _refreshFirstPageAfterMutation() async {
    try {
      final refreshed = await _loadRemoteThreads(page: 1, limit: 50);
      await _local.saveThreads(refreshed);
      return refreshed;
    } catch (_) {
      final cached = await _local.readThreads();
      return cached;
    }
  }

  List<DiscussionThread> _mapRemoteRowsToThreads(
    List<DiscussionCommentDto> rows,
  ) {
    if (rows.isEmpty) {
      return const <DiscussionThread>[];
    }

    final byId = <int, DiscussionCommentDto>{
      for (final row in rows)
        if (row.id != null) row.id!: row,
    };

    final roots = rows.where((row) => row.quote == null).toList(growable: false)
      ..sort(_sortCommentByCreatedAtDesc);
    final rootIds = roots
        .map((DiscussionCommentDto row) => row.id)
        .whereType<int>()
        .toSet();

    final repliesByRoot = <int, List<DiscussionCommentDto>>{};
    final syntheticRoots = <int, DiscussionQuoteDto>{};
    final orphanRows = <DiscussionCommentDto>[];

    for (final row in rows) {
      if (row.quote == null) {
        continue;
      }
      final rootId = _resolveRootId(row, byId);
      if (rootId == null || !rootIds.contains(rootId)) {
        final quote = row.quote;
        final syntheticRootId = quote?.id;
        if (quote == null || syntheticRootId == null) {
          orphanRows.add(row);
          continue;
        }
        syntheticRoots.putIfAbsent(syntheticRootId, () => quote);
        repliesByRoot
            .putIfAbsent(syntheticRootId, () => <DiscussionCommentDto>[])
            .add(row);
        continue;
      }
      repliesByRoot
          .putIfAbsent(rootId, () => <DiscussionCommentDto>[])
          .add(row);
    }

    for (final replies in repliesByRoot.values) {
      replies.sort(_sortCommentByCreatedAtAsc);
    }

    final threads = roots
        .map((DiscussionCommentDto root) {
          final replies =
              repliesByRoot[root.id] ?? const <DiscussionCommentDto>[];
          final mappedReplies = replies
              .map(_mapReplyFromComment)
              .toList(growable: false);
          return DiscussionThread(
            id: (root.id ?? '').toString(),
            author: _mapAuthor(root),
            timeLabel: _formatTimeLabel(root.createTime),
            body: root.content,
            createdAtIso: _normalizeCreatedAt(root.createTime),
            commentCount: mappedReplies.length,
            replies: mappedReplies,
            fundReferenceLabel: _buildFundReferenceLabel(root),
            fundReferenceId: root.projectId?.toString(),
          );
        })
        .toList(growable: true);

    if (syntheticRoots.isNotEmpty) {
      final syntheticThreads =
          syntheticRoots.entries
              .where((entry) => !rootIds.contains(entry.key))
              .map((entry) {
                final quote = entry.value;
                final replies =
                    repliesByRoot[entry.key] ?? const <DiscussionCommentDto>[];
                final mappedReplies = replies
                    .map(_mapReplyFromComment)
                    .toList(growable: false);
                return DiscussionThread(
                  id: entry.key.toString(),
                  author: _mapQuoteAuthor(quote, entry.key),
                  timeLabel: _formatTimeLabel(quote.createTime),
                  body: quote.content,
                  createdAtIso: _normalizeCreatedAt(quote.createTime),
                  commentCount: mappedReplies.length,
                  replies: mappedReplies,
                );
              })
              .toList(growable: false)
            ..sort(_sortThreadByCreatedAtDesc);
      threads.addAll(syntheticThreads);
    }

    if (orphanRows.isNotEmpty) {
      orphanRows.sort(_sortCommentByCreatedAtDesc);
      threads.addAll(
        orphanRows.map((DiscussionCommentDto row) {
          return DiscussionThread(
            id: (row.id ?? 'orphan_${row.createTime}').toString(),
            author: _mapAuthor(row),
            timeLabel: _formatTimeLabel(row.createTime),
            body: row.content,
            createdAtIso: _normalizeCreatedAt(row.createTime),
            commentCount: 0,
            replies: const <DiscussionReply>[],
            fundReferenceLabel: _buildFundReferenceLabel(row),
            fundReferenceId: row.projectId?.toString(),
          );
        }),
      );
    }

    return threads;
  }

  int _sortThreadByCreatedAtDesc(
    DiscussionThread left,
    DiscussionThread right,
  ) {
    final leftAt = _parseCreatedAt(left.createdAtIso);
    final rightAt = _parseCreatedAt(right.createdAtIso);
    if (leftAt == null && rightAt == null) {
      return right.id.compareTo(left.id);
    }
    if (leftAt == null) {
      return 1;
    }
    if (rightAt == null) {
      return -1;
    }
    return rightAt.compareTo(leftAt);
  }

  DiscussionReply _mapReplyFromComment(DiscussionCommentDto row) {
    final quote = row.quote;
    return DiscussionReply(
      id: (row.id ?? '').toString(),
      author: _mapAuthor(row),
      timeLabel: _formatTimeLabel(row.createTime),
      body: row.content,
      createdAtIso: _normalizeCreatedAt(row.createTime),
      quote: quote == null
          ? null
          : DiscussionQuote(sourceText: quote.username, body: quote.content),
    );
  }

  DiscussionAuthor _mapAuthor(DiscussionCommentDto row) {
    final username = row.username.trim();
    final displayName = _maskUserName(username, 'User**');
    final avatarText = _firstVisibleCharacter(displayName);
    final colorValues = _avatarGradientForUser(row.userId ?? row.id);
    return DiscussionAuthor(
      id: (row.userId ?? row.id ?? '').toString(),
      displayName: displayName,
      accountHandle: _buildMaskedHandle(row.userId),
      avatarUrl: _normalizeAvatarUrl(row.avatar),
      avatarText: avatarText,
      avatarGradientColorValues: colorValues,
      badge: const DiscussionAuthorBadge(
        label: '',
        backgroundColorValue: 0x00000000,
        foregroundColorValue: 0x00000000,
      ),
    );
  }

  DiscussionAuthor _mapQuoteAuthor(DiscussionQuoteDto quote, int seed) {
    final displayName = _maskUserName(quote.username, 'User**');
    final avatarText = _firstVisibleCharacter(displayName);
    return DiscussionAuthor(
      id: 'quote_$seed',
      displayName: displayName,
      accountHandle: '',
      avatarUrl: _normalizeAvatarUrl(quote.avatar),
      avatarText: avatarText,
      avatarGradientColorValues: _avatarGradientForUser(seed),
      badge: const DiscussionAuthorBadge(
        label: '',
        backgroundColorValue: 0x00000000,
        foregroundColorValue: 0x00000000,
      ),
    );
  }

  String? _buildFundReferenceLabel(DiscussionCommentDto row) {
    final name = row.projectName.trim();
    if (name.isEmpty) {
      return null;
    }
    return '$name →';
  }

  String _formatTimeLabel(String rawTime) {
    final parsed = DateTime.tryParse(rawTime);
    if (parsed == null) {
      return rawTime;
    }
    final local = parsed.toLocal();
    return DateFormat('yyyy/MM/dd HH:mm').format(local);
  }

  String _normalizeCreatedAt(String rawTime) {
    final parsed = DateTime.tryParse(rawTime);
    if (parsed == null) {
      return rawTime;
    }
    return parsed.toUtc().toIso8601String();
  }

  int _sortCommentByCreatedAtDesc(
    DiscussionCommentDto left,
    DiscussionCommentDto right,
  ) {
    final leftAt = _parseCreatedAt(left.createTime);
    final rightAt = _parseCreatedAt(right.createTime);
    if (leftAt == null && rightAt == null) {
      return (right.id ?? 0).compareTo(left.id ?? 0);
    }
    if (leftAt == null) {
      return 1;
    }
    if (rightAt == null) {
      return -1;
    }
    return rightAt.compareTo(leftAt);
  }

  int _sortCommentByCreatedAtAsc(
    DiscussionCommentDto left,
    DiscussionCommentDto right,
  ) {
    final leftAt = _parseCreatedAt(left.createTime);
    final rightAt = _parseCreatedAt(right.createTime);
    if (leftAt == null && rightAt == null) {
      return (left.id ?? 0).compareTo(right.id ?? 0);
    }
    if (leftAt == null) {
      return -1;
    }
    if (rightAt == null) {
      return 1;
    }
    return leftAt.compareTo(rightAt);
  }

  DateTime? _parseCreatedAt(String rawTime) {
    return DateTime.tryParse(rawTime)?.toUtc();
  }

  int? _resolveRootId(
    DiscussionCommentDto row,
    Map<int, DiscussionCommentDto> byId,
  ) {
    var parentId = row.quote?.id;
    final visited = <int>{};
    while (parentId != null) {
      if (!visited.add(parentId)) {
        return null;
      }
      final parent = byId[parentId];
      if (parent == null) {
        return null;
      }
      if (parent.quote == null) {
        return parent.id;
      }
      parentId = parent.quote?.id;
    }
    return null;
  }

  List<int> _avatarGradientForUser(int? userSeed) {
    return discussionAvatarGradientForSeed(userSeed);
  }

  String _buildMaskedHandle(int? userId) {
    if (userId == null) {
      return 'usr***@';
    }
    final raw = userId.toString();
    final visible = raw.length <= 3 ? raw : raw.substring(0, 3);
    return '$visible***@';
  }

  String _maskUserName(String username, String fallbackName) {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      return fallbackName;
    }
    if (normalized.contains('*')) {
      return normalized;
    }
    final first = _firstVisibleCharacter(normalized);
    return '$first**';
  }

  String _firstVisibleCharacter(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'U';
    }
    return String.fromCharCode(trimmed.runes.first);
  }

  String? _normalizeAvatarUrl(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  bool _containsRecentlyPostedThread(
    List<DiscussionThread> threads,
    String body, {
    required DateTime postedAtUtc,
  }) {
    final normalized = body.trim();
    if (normalized.isEmpty) {
      return false;
    }
    return threads.any((DiscussionThread thread) {
      if (thread.body.trim() != normalized) {
        return false;
      }
      final createdAt = _parseCreatedAt(thread.createdAtIso);
      if (createdAt == null) {
        return true;
      }
      final diff = createdAt.difference(postedAtUtc).abs();
      return diff <= const Duration(minutes: 3);
    });
  }

  List<DiscussionThread> _prependOptimisticThread({
    required List<DiscussionThread> base,
    required DiscussionThread optimistic,
  }) {
    if (_containsRecentlyPostedThread(
      base,
      optimistic.body,
      postedAtUtc:
          _parseCreatedAt(optimistic.createdAtIso) ?? DateTime.now().toUtc(),
    )) {
      return base;
    }
    final merged = <DiscussionThread>[optimistic, ...base];
    merged.sort(_sortThreadByCreatedAtDesc);
    return merged;
  }

  DiscussionThread _buildOptimisticThread({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    String? fallbackAvatarUrl,
    required int? linkedProjectId,
    required String? linkedProjectName,
    required DateTime postedAtUtc,
  }) {
    final authorName = fallbackName.trim().isEmpty
        ? 'User**'
        : fallbackName.trim();
    return DiscussionThread(
      id: 'local_${postedAtUtc.microsecondsSinceEpoch}',
      author: DiscussionAuthor(
        id: 'local_author',
        displayName: authorName,
        accountHandle: fallbackHandle,
        avatarUrl: _normalizeAvatarUrl(fallbackAvatarUrl),
        avatarText: _firstVisibleCharacter(authorName),
        avatarGradientColorValues: discussionAvatarGradientForSeed(null),
        badge: DiscussionAuthorBadge(
          label: fallbackBadgeLabel,
          backgroundColorValue: fallbackBadgeLabel.trim().isEmpty
              ? 0x00000000
              : 0xFFEDE9FE,
          foregroundColorValue: fallbackBadgeLabel.trim().isEmpty
              ? 0x00000000
              : 0xFF7C3AED,
        ),
      ),
      timeLabel: nowLabel,
      body: content,
      createdAtIso: postedAtUtc.toIso8601String(),
      commentCount: 0,
      replies: const <DiscussionReply>[],
      fundReferenceLabel: _buildLinkedFundReferenceLabel(linkedProjectName),
      fundReferenceId: linkedProjectId?.toString(),
    );
  }

  String? _buildLinkedFundReferenceLabel(String? projectName) {
    final trimmed = projectName?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return '$trimmed →';
  }
}
