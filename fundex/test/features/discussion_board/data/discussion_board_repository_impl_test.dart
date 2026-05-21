import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/discussion_board/data/datasources/discussion_board_local_data_source.dart';
import 'package:fundex/features/discussion_board/data/datasources/discussion_board_remote_data_source.dart';
import 'package:fundex/features/discussion_board/data/models/discussion_comment_dto.dart';
import 'package:fundex/features/discussion_board/data/repositories/discussion_board_repository_impl.dart';
import 'package:fundex/features/discussion_board/domain/entities/discussion_board_models.dart';

class _FakeDiscussionBoardRemoteDataSource
    implements DiscussionBoardRemoteDataSource {
  List<DiscussionCommentDto> fetchResult = const <DiscussionCommentDto>[];
  Object? fetchError;
  Object? sendError;
  Object? uploadError;
  Object? deleteError;
  int fetchCallCount = 0;
  int sendCallCount = 0;
  int uploadCallCount = 0;
  int deleteCallCount = 0;
  int? lastFetchStartPage;
  int? lastFetchLimit;
  int? lastFetchProjectId;
  int? lastSendParentId;
  int? lastSendProjectId;
  String? lastSendContent;
  List<String>? lastSendImageUrls;
  List<String>? lastUploadFilePaths;
  int? lastDeletedCommentId;

  @override
  Future<void> deleteComment({required int commentId}) async {
    if (deleteError != null) {
      throw deleteError!;
    }
    deleteCallCount += 1;
    lastDeletedCommentId = commentId;
  }

  @override
  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  }) async {
    fetchCallCount += 1;
    lastFetchStartPage = startPage;
    lastFetchLimit = limit;
    lastFetchProjectId = projectId;
    if (fetchError != null) {
      throw fetchError!;
    }
    return fetchResult;
  }

  @override
  Future<void> sendComment({
    required String content,
    List<String> imageUrls = const <String>[],
    int? parentId,
    int? projectId,
  }) async {
    if (sendError != null) {
      throw sendError!;
    }
    sendCallCount += 1;
    lastSendContent = content;
    lastSendImageUrls = imageUrls;
    lastSendParentId = parentId;
    lastSendProjectId = projectId;
  }

  @override
  Future<List<String>> uploadImages({required List<String> filePaths}) async {
    if (uploadError != null) {
      throw uploadError!;
    }
    uploadCallCount += 1;
    lastUploadFilePaths = filePaths;
    return filePaths
        .map((String path) => 'https://cdn.example.com/${path.split('/').last}')
        .toList(growable: false);
  }
}

class _FakeDiscussionBoardLocalDataSource
    implements DiscussionBoardLocalDataSource {
  List<DiscussionThread> storage = const <DiscussionThread>[];

  @override
  Future<void> clearThreads() async {
    storage = const <DiscussionThread>[];
  }

  @override
  Future<List<DiscussionThread>> readThreads() async {
    return storage;
  }

  @override
  Future<void> saveThreads(List<DiscussionThread> threads) async {
    storage = threads;
  }
}

void main() {
  group('DiscussionBoardRepositoryImpl', () {
    test('loadThreads maps remote flat rows into thread and replies', () async {
      final remote = _FakeDiscussionBoardRemoteDataSource()
        ..fetchResult = <DiscussionCommentDto>[
          const DiscussionCommentDto(
            id: 101,
            userId: 1001,
            username: '佐藤',
            avatar: 'https://cdn.example.com/avatar-root.png',
            content: '主贴内容',
            imageUrls: <String>['https://cdn.example.com/root.png'],
            createTime: '2026-03-12T08:00:00Z',
            projectId: 123,
            projectName: 'プレミアムレジデンス赤坂',
          ),
          const DiscussionCommentDto(
            id: 102,
            userId: 1002,
            username: '高橋',
            avatar: 'https://cdn.example.com/avatar-reply.png',
            content: '回复内容',
            imageUrls: <String>['https://cdn.example.com/reply.png'],
            createTime: '2026-03-12T08:30:00Z',
            projectId: 123,
            projectName: 'プレミアムレジデンス赤坂',
            quote: DiscussionQuoteDto(
              id: 101,
              username: '佐藤',
              avatar: 'https://cdn.example.com/avatar-root.png',
              content: '主贴内容',
              imageUrls: <String>['https://cdn.example.com/quote.png'],
              createTime: '2026-03-12T08:00:00Z',
            ),
          ),
        ];
      final local = _FakeDiscussionBoardLocalDataSource();
      final repository = DiscussionBoardRepositoryImpl(
        remote: remote,
        local: local,
      );

      final threads = await repository.loadThreads();

      expect(threads, hasLength(1));
      expect(threads.first.id, '101');
      expect(
        threads.first.author.avatarUrl,
        'https://cdn.example.com/avatar-root.png',
      );
      expect(threads.first.commentCount, 1);
      expect(threads.first.imageUrls, <String>[
        'https://cdn.example.com/root.png',
      ]);
      expect(threads.first.replies, hasLength(1));
      expect(threads.first.replies.first.id, '102');
      expect(threads.first.replies.first.imageUrls, <String>[
        'https://cdn.example.com/reply.png',
      ]);
      expect(threads.first.replies.first.quote?.imageUrls, <String>[
        'https://cdn.example.com/quote.png',
      ]);
      expect(
        threads.first.replies.first.author.avatarUrl,
        'https://cdn.example.com/avatar-reply.png',
      );
      expect(threads.first.fundReferenceLabel, 'プレミアムレジデンス赤坂 →');
      expect(local.storage, hasLength(1));
    });

    test('submitPost does not write local cache when send API fails', () async {
      final remote = _FakeDiscussionBoardRemoteDataSource()
        ..sendError = StateError('send failed');
      const cachedThread = DiscussionThread(
        id: '101',
        author: DiscussionAuthor(
          id: 'u1',
          displayName: '投資家**',
          accountHandle: 'usr***@',
          avatarText: '投',
          avatarGradientColorValues: <int>[0xFF6366F1, 0xFF8B5CF6],
          badge: DiscussionAuthorBadge(
            label: '',
            backgroundColorValue: 0,
            foregroundColorValue: 0,
          ),
        ),
        timeLabel: '2026/03/12 10:00',
        body: 'cached',
        createdAtIso: '2026-03-12T01:00:00Z',
        commentCount: 0,
        replies: <DiscussionReply>[],
      );
      final local = _FakeDiscussionBoardLocalDataSource()
        ..storage = <DiscussionThread>[cachedThread];
      final repository = DiscussionBoardRepositoryImpl(
        remote: remote,
        local: local,
      );

      await expectLater(
        repository.submitPost(
          content: 'new post',
          nowLabel: 'just now',
          fallbackName: 'fallback',
          fallbackHandle: 'usr***@',
          fallbackBadgeLabel: 'badge',
        ),
        throwsA(isA<StateError>()),
      );

      expect(local.storage, hasLength(1));
      expect(local.storage.first.id, '101');
      expect(local.storage.first.body, 'cached');
    });

    test(
      'submitReply does not write local cache when send API fails',
      () async {
        final remote = _FakeDiscussionBoardRemoteDataSource()
          ..sendError = StateError('send failed');
        const cachedThread = DiscussionThread(
          id: '101',
          author: DiscussionAuthor(
            id: 'u1',
            displayName: '投資家**',
            accountHandle: 'usr***@',
            avatarText: '投',
            avatarGradientColorValues: <int>[0xFF6366F1, 0xFF8B5CF6],
            badge: DiscussionAuthorBadge(
              label: '',
              backgroundColorValue: 0,
              foregroundColorValue: 0,
            ),
          ),
          timeLabel: '2026/03/12 10:00',
          body: 'cached',
          createdAtIso: '2026-03-12T01:00:00Z',
          commentCount: 0,
          replies: <DiscussionReply>[],
        );
        final local = _FakeDiscussionBoardLocalDataSource()
          ..storage = <DiscussionThread>[cachedThread];
        final repository = DiscussionBoardRepositoryImpl(
          remote: remote,
          local: local,
        );

        await expectLater(
          repository.submitReply(
            threadId: '101',
            content: 'new reply',
            nowLabel: 'just now',
            fallbackName: 'fallback',
            fallbackHandle: 'usr***@',
            fallbackBadgeLabel: 'badge',
          ),
          throwsA(isA<StateError>()),
        );

        expect(local.storage, hasLength(1));
        expect(local.storage.first.id, '101');
        expect(local.storage.first.replies, isEmpty);
      },
    );

    test(
      'project-scoped load should pass projectId and skip mock seed',
      () async {
        final remote = _FakeDiscussionBoardRemoteDataSource()
          ..fetchError = StateError('network failed');
        final local = _FakeDiscussionBoardLocalDataSource();
        final repository = DiscussionBoardRepositoryImpl(
          remote: remote,
          local: local,
          projectId: 456,
        );

        final threads = await repository.loadThreads();

        expect(remote.fetchCallCount, 1);
        expect(remote.lastFetchProjectId, 456);
        expect(threads, isEmpty);
        expect(local.storage, isEmpty);
      },
    );

    test('project-scoped submit should pass projectId to send API', () async {
      final remote = _FakeDiscussionBoardRemoteDataSource()
        ..fetchResult = const <DiscussionCommentDto>[];
      final local = _FakeDiscussionBoardLocalDataSource();
      final repository = DiscussionBoardRepositoryImpl(
        remote: remote,
        local: local,
        projectId: 789,
      );

      await repository.submitPost(
        content: ' scoped post ',
        nowLabel: 'just now',
        fallbackName: 'fallback',
        fallbackHandle: 'usr***@',
        fallbackBadgeLabel: 'badge',
      );

      expect(remote.sendCallCount, 1);
      expect(remote.lastSendProjectId, 789);
      expect(remote.lastSendParentId, isNull);
      expect(remote.lastSendContent, 'scoped post');
      expect(remote.lastSendImageUrls, isEmpty);
    });

    test('submitPost should pass image URLs to send API', () async {
      final remote = _FakeDiscussionBoardRemoteDataSource()
        ..fetchResult = const <DiscussionCommentDto>[];
      final local = _FakeDiscussionBoardLocalDataSource();
      final repository = DiscussionBoardRepositoryImpl(
        remote: remote,
        local: local,
        projectId: 789,
      );

      await repository.submitPost(
        content: 'post with image',
        nowLabel: 'just now',
        fallbackName: 'fallback',
        fallbackHandle: 'usr***@',
        fallbackBadgeLabel: 'badge',
        imageUrls: const <String>['https://cdn.example.com/comment.png'],
      );

      expect(remote.sendCallCount, 1);
      expect(remote.lastSendImageUrls, <String>[
        'https://cdn.example.com/comment.png',
      ]);
      expect(local.storage.first.imageUrls, <String>[
        'https://cdn.example.com/comment.png',
      ]);
    });

    test('uploadImages delegates to remote image upload', () async {
      final remote = _FakeDiscussionBoardRemoteDataSource();
      final local = _FakeDiscussionBoardLocalDataSource();
      final repository = DiscussionBoardRepositoryImpl(
        remote: remote,
        local: local,
      );

      final urls = await repository.uploadImages(
        filePaths: const <String>['/tmp/comment-a.jpg', '/tmp/comment-b.jpg'],
      );

      expect(urls, <String>[
        'https://cdn.example.com/comment-a.jpg',
        'https://cdn.example.com/comment-b.jpg',
      ]);
      expect(remote.uploadCallCount, 1);
      expect(remote.lastUploadFilePaths, <String>[
        '/tmp/comment-a.jpg',
        '/tmp/comment-b.jpg',
      ]);
    });

    test(
      'submitPost should create optimistic thread when refresh does not return new row',
      () async {
        final remote = _FakeDiscussionBoardRemoteDataSource()
          ..fetchResult = const <DiscussionCommentDto>[];
        final local = _FakeDiscussionBoardLocalDataSource();
        final repository = DiscussionBoardRepositoryImpl(
          remote: remote,
          local: local,
          projectId: 123,
        );

        final threads = await repository.submitPost(
          content: 'new optimistic post',
          nowLabel: 'just now',
          fallbackName: 'fallback user',
          fallbackHandle: 'usr***@',
          fallbackBadgeLabel: 'badge',
        );

        expect(remote.sendCallCount, 1);
        expect(remote.fetchCallCount, greaterThanOrEqualTo(1));
        expect(threads, isNotEmpty);
        expect(threads.first.body, 'new optimistic post');
        expect(local.storage, isNotEmpty);
        expect(local.storage.first.body, 'new optimistic post');
      },
    );

    test(
      'deleteComment does not write local cache when delete API fails',
      () async {
        final remote = _FakeDiscussionBoardRemoteDataSource()
          ..deleteError = StateError('delete failed');
        const cachedThread = DiscussionThread(
          id: '101',
          author: DiscussionAuthor(
            id: 'u1',
            displayName: '投資家**',
            accountHandle: 'usr***@',
            avatarText: '投',
            avatarGradientColorValues: <int>[0xFF6366F1, 0xFF8B5CF6],
            badge: DiscussionAuthorBadge(
              label: '',
              backgroundColorValue: 0,
              foregroundColorValue: 0,
            ),
          ),
          timeLabel: '2026/03/12 10:00',
          body: 'cached',
          createdAtIso: '2026-03-12T01:00:00Z',
          commentCount: 0,
          replies: <DiscussionReply>[],
        );
        final local = _FakeDiscussionBoardLocalDataSource()
          ..storage = <DiscussionThread>[cachedThread];
        final repository = DiscussionBoardRepositoryImpl(
          remote: remote,
          local: local,
        );

        await expectLater(
          repository.deleteComment(commentId: '101'),
          throwsA(isA<StateError>()),
        );

        expect(local.storage, hasLength(1));
        expect(local.storage.first.id, '101');
        expect(local.storage.first.body, 'cached');
      },
    );
  });
}
