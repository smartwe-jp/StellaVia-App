import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../domain/usecases/delete_discussion_comment_usecase.dart';
import '../../domain/usecases/load_discussion_threads_usecase.dart';
import '../../domain/usecases/submit_discussion_post_usecase.dart';
import '../../domain/usecases/submit_discussion_reply_usecase.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../state/discussion_board_state.dart';

class DiscussionBoardController extends StateNotifier<DiscussionBoardState> {
  DiscussionBoardController(
    this._loadUseCase,
    this._submitPostUseCase,
    this._submitReplyUseCase,
    this._deleteCommentUseCase,
  ) : super(const DiscussionBoardState.initial()) {
    unawaited(loadThreads());
  }

  final LoadDiscussionThreadsUseCase _loadUseCase;
  final SubmitDiscussionPostUseCase _submitPostUseCase;
  final SubmitDiscussionReplyUseCase _submitReplyUseCase;
  final DeleteDiscussionCommentUseCase _deleteCommentUseCase;
  static const int _defaultPageLimit = 50;

  Future<void> loadThreads({bool refresh = false}) async {
    if (refresh) {
      if (state.isLoading || state.isRefreshing) {
        return;
      }
      state = state.copyWith(isRefreshing: true, clearError: true);
    } else {
      state = state.copyWith(
        isLoading: true,
        isRefreshing: false,
        isLoadingMore: false,
        clearError: true,
      );
    }

    try {
      final threads = await _loadUseCase.call(
        page: 1,
        limit: _defaultPageLimit,
      );
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        threads: threads,
        currentPage: 1,
        hasMore: threads.isNotEmpty,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
    }
  }

  Future<void> refreshThreads() {
    return loadThreads(refresh: true);
  }

  Future<void> loadMoreThreads() async {
    if (state.isLoading ||
        state.isRefreshing ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final nextPage = state.currentPage + 1;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final nextPageThreads = await _loadUseCase.call(
        page: nextPage,
        limit: _defaultPageLimit,
      );
      if (nextPageThreads.isEmpty) {
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: false,
          clearError: true,
        );
        return;
      }

      final mergedThreads = _mergeThreadsById(state.threads, nextPageThreads);
      state = state.copyWith(
        threads: mergedThreads,
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: true,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
    }
  }

  void updateComposerText(String text) {
    state = state.copyWith(composerText: text);
  }

  void toggleReplies(String threadId) {
    final next = Set<String>.from(state.expandedThreadIds);
    if (next.contains(threadId)) {
      next.remove(threadId);
    } else {
      next.add(threadId);
    }
    state = state.copyWith(expandedThreadIds: next);
  }

  void updateReplyDraft(String threadId, String text) {
    final drafts = Map<String, String>.from(state.replyDrafts);
    drafts[threadId] = text;
    state = state.copyWith(replyDrafts: drafts);
  }

  Future<bool> submitPost({
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    String? fallbackAvatarUrl,
    int? linkedProjectId,
    String? linkedProjectName,
  }) async {
    final content = state.composerText.trim();
    if (content.isEmpty || state.isPosting) {
      return false;
    }

    state = state.copyWith(isPosting: true, clearError: true);
    try {
      final threads = await _submitPostUseCase.call(
        content: content,
        nowLabel: nowLabel,
        fallbackName: fallbackName,
        fallbackHandle: fallbackHandle,
        fallbackBadgeLabel: fallbackBadgeLabel,
        fallbackAvatarUrl: fallbackAvatarUrl,
        linkedProjectId: linkedProjectId,
        linkedProjectName: linkedProjectName,
      );
      state = state.copyWith(
        isPosting: false,
        composerText: '',
        threads: threads,
        currentPage: 1,
        hasMore: threads.isNotEmpty,
        clearError: true,
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
      return false;
    }
  }

  Future<bool> submitReply(
    String threadId, {
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final draft = (state.replyDrafts[threadId] ?? '').trim();
    if (draft.isEmpty || state.replySubmittingThreadIds.contains(threadId)) {
      return false;
    }

    final submitting = Set<String>.from(state.replySubmittingThreadIds)
      ..add(threadId);
    state = state.copyWith(
      replySubmittingThreadIds: submitting,
      clearError: true,
    );

    try {
      final threads = await _submitReplyUseCase.call(
        threadId: threadId,
        content: draft,
        nowLabel: nowLabel,
        fallbackName: fallbackName,
        fallbackHandle: fallbackHandle,
        fallbackBadgeLabel: fallbackBadgeLabel,
      );

      final nextDrafts = Map<String, String>.from(state.replyDrafts)
        ..[threadId] = '';
      final nextSubmitting = Set<String>.from(state.replySubmittingThreadIds)
        ..remove(threadId);
      state = state.copyWith(
        threads: threads,
        currentPage: 1,
        hasMore: threads.isNotEmpty,
        replyDrafts: nextDrafts,
        replySubmittingThreadIds: nextSubmitting,
        clearError: true,
      );
      return true;
    } catch (error) {
      final nextSubmitting = Set<String>.from(state.replySubmittingThreadIds)
        ..remove(threadId);
      state = state.copyWith(
        replySubmittingThreadIds: nextSubmitting,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
      return false;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    final normalized = commentId.trim();
    if (normalized.isEmpty || state.deletingCommentIds.contains(normalized)) {
      return false;
    }

    final deleting = Set<String>.from(state.deletingCommentIds)
      ..add(normalized);
    state = state.copyWith(deletingCommentIds: deleting, clearError: true);

    try {
      final threads = await _deleteCommentUseCase.call(commentId: normalized);
      final nextDeleting = Set<String>.from(state.deletingCommentIds)
        ..remove(normalized);
      state = state.copyWith(
        threads: threads,
        currentPage: 1,
        hasMore: threads.isNotEmpty,
        deletingCommentIds: nextDeleting,
        clearError: true,
      );
      return true;
    } catch (error) {
      final nextDeleting = Set<String>.from(state.deletingCommentIds)
        ..remove(normalized);
      state = state.copyWith(
        deletingCommentIds: nextDeleting,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(clearError: true);
  }

  List<DiscussionThread> _mergeThreadsById(
    List<DiscussionThread> current,
    List<DiscussionThread> incoming,
  ) {
    final mergedById = <String, DiscussionThread>{
      for (final thread in current) thread.id: thread,
    };

    for (final thread in incoming) {
      final existing = mergedById[thread.id];
      if (existing == null) {
        mergedById[thread.id] = thread;
        continue;
      }
      mergedById[thread.id] = _mergeThread(existing, thread);
    }

    final mergedList = mergedById.values.toList(growable: false)
      ..sort(_sortThreadByCreatedAtDesc);
    return mergedList;
  }

  DiscussionThread _mergeThread(
    DiscussionThread existing,
    DiscussionThread incoming,
  ) {
    final mergedReplies = _mergeRepliesById(existing.replies, incoming.replies);
    return existing.copyWith(
      author: incoming.author.displayName.trim().isNotEmpty
          ? incoming.author
          : existing.author,
      timeLabel: incoming.timeLabel.trim().isNotEmpty
          ? incoming.timeLabel
          : existing.timeLabel,
      body: incoming.body.trim().isNotEmpty ? incoming.body : existing.body,
      createdAtIso: incoming.createdAtIso.trim().isNotEmpty
          ? incoming.createdAtIso
          : existing.createdAtIso,
      fundReferenceLabel:
          incoming.fundReferenceLabel ?? existing.fundReferenceLabel,
      fundReferenceId: incoming.fundReferenceId ?? existing.fundReferenceId,
      replies: mergedReplies,
      commentCount: mergedReplies.length,
    );
  }

  List<DiscussionReply> _mergeRepliesById(
    List<DiscussionReply> current,
    List<DiscussionReply> incoming,
  ) {
    final mergedById = <String, DiscussionReply>{
      for (final reply in current) reply.id: reply,
    };

    for (final reply in incoming) {
      mergedById[reply.id] = reply;
    }

    final merged = mergedById.values.toList(growable: false)
      ..sort(_sortReplyByCreatedAtAsc);
    return merged;
  }

  int _sortThreadByCreatedAtDesc(
    DiscussionThread left,
    DiscussionThread right,
  ) {
    final leftAt = _parseTimestamp(left.createdAtIso);
    final rightAt = _parseTimestamp(right.createdAtIso);
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

  int _sortReplyByCreatedAtAsc(DiscussionReply left, DiscussionReply right) {
    final leftAt = _parseTimestamp(left.createdAtIso);
    final rightAt = _parseTimestamp(right.createdAtIso);
    if (leftAt == null && rightAt == null) {
      return left.id.compareTo(right.id);
    }
    if (leftAt == null) {
      return -1;
    }
    if (rightAt == null) {
      return 1;
    }
    return leftAt.compareTo(rightAt);
  }

  DateTime? _parseTimestamp(String text) {
    return DateTime.tryParse(text)?.toUtc();
  }

  void handleUserChange(String previousUserId, String newUserId) {
    if (previousUserId != newUserId) {
      loadThreads();
    }
  }

  void handleAuthChange(bool previousAuth, bool newAuth) {
    if (previousAuth != newAuth) {
      loadThreads();
    }
  }
}
