import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/support/upload_image_optimizer.dart';
import 'package:fundex/features/discussion_board/domain/entities/discussion_board_models.dart';
import 'package:fundex/features/discussion_board/domain/repositories/discussion_board_repository.dart';
import 'package:fundex/features/discussion_board/domain/usecases/delete_discussion_comment_usecase.dart';
import 'package:fundex/features/discussion_board/domain/usecases/load_discussion_threads_usecase.dart';
import 'package:fundex/features/discussion_board/domain/usecases/submit_discussion_post_usecase.dart';
import 'package:fundex/features/discussion_board/domain/usecases/submit_discussion_reply_usecase.dart';
import 'package:fundex/features/discussion_board/domain/usecases/upload_discussion_image_usecase.dart';
import 'package:fundex/features/discussion_board/presentation/controllers/discussion_board_controller.dart';

class _FakeDiscussionBoardRepository implements DiscussionBoardRepository {
  List<String>? lastSubmittedImageUrls;
  final uploadedFilePaths = <String>[];

  @override
  Future<List<DiscussionThread>> loadThreads({
    int page = 1,
    int limit = 50,
  }) async {
    return const <DiscussionThread>[];
  }

  @override
  Future<List<DiscussionThread>> submitPost({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    List<String> imageUrls = const <String>[],
    String? fallbackAvatarUrl,
    int? linkedProjectId,
    String? linkedProjectName,
  }) async {
    lastSubmittedImageUrls = imageUrls;
    return const <DiscussionThread>[];
  }

  @override
  Future<List<DiscussionThread>> submitReply({
    required String threadId,
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    List<String> imageUrls = const <String>[],
    int? linkedProjectId,
  }) async {
    lastSubmittedImageUrls = imageUrls;
    return const <DiscussionThread>[];
  }

  @override
  Future<List<String>> uploadImages({required List<String> filePaths}) async {
    uploadedFilePaths.addAll(filePaths);
    return filePaths
        .map(
          (String filePath) =>
              'https://cdn.example.com/${filePath.split('/').last}',
        )
        .toList(growable: false);
  }

  @override
  Future<List<DiscussionThread>> deleteComment({required String commentId}) {
    return Future<List<DiscussionThread>>.value(const <DiscussionThread>[]);
  }
}

class _FakeUploadImageOptimizer extends UploadImageOptimizer {
  _FakeUploadImageOptimizer(this.optimizedBySource);

  final Map<String, String> optimizedBySource;
  final optimizedSourcePaths = <String>[];

  @override
  Future<String> ensureWithinUploadLimit(String sourcePath) async {
    optimizedSourcePaths.add(sourcePath);
    return optimizedBySource[sourcePath] ?? sourcePath;
  }
}

void main() {
  group('DiscussionBoardController', () {
    test(
      'submitPost uploads local image files before sending comment',
      () async {
        final tempDirectory = await Directory.systemTemp.createTemp(
          'discussion_board_controller_test_',
        );
        addTearDown(() async {
          if (await tempDirectory.exists()) {
            await tempDirectory.delete(recursive: true);
          }
        });
        final imageA = File('${tempDirectory.path}/a.png')
          ..writeAsBytesSync(<int>[1, 2, 3]);
        final imageB = File('${tempDirectory.path}/b.png')
          ..writeAsBytesSync(<int>[4, 5, 6]);
        final optimizedA = '${tempDirectory.path}/optimized-a.jpg';
        final optimizedB = '${tempDirectory.path}/optimized-b.jpg';
        final repository = _FakeDiscussionBoardRepository();
        final optimizer = _FakeUploadImageOptimizer(<String, String>{
          imageA.path: optimizedA,
          imageB.path: optimizedB,
        });
        final controller = DiscussionBoardController(
          LoadDiscussionThreadsUseCase(repository),
          SubmitDiscussionPostUseCase(repository),
          SubmitDiscussionReplyUseCase(repository),
          DeleteDiscussionCommentUseCase(repository),
          UploadDiscussionImageUseCase(repository),
          imageOptimizer: optimizer,
        );
        addTearDown(controller.dispose);

        controller.updateComposerText('post with images');
        final submitted = await controller.submitPost(
          nowLabel: 'now',
          fallbackName: 'user',
          fallbackHandle: 'usr***@',
          fallbackBadgeLabel: 'badge',
          imageUrls: const <String>['https://cdn.example.com/existing.jpg'],
          imageFilePaths: <String>[imageA.path, imageB.path],
        );

        expect(submitted, isTrue);
        expect(optimizer.optimizedSourcePaths, <String>[
          imageA.path,
          imageB.path,
        ]);
        expect(repository.uploadedFilePaths, <String>[optimizedA, optimizedB]);
        expect(repository.lastSubmittedImageUrls, <String>[
          'https://cdn.example.com/existing.jpg',
          'https://cdn.example.com/optimized-a.jpg',
          'https://cdn.example.com/optimized-b.jpg',
        ]);
      },
    );
  });
}
