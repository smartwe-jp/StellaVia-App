import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/discussion_board_draft_image_store.dart';
import '../../data/datasources/discussion_board_draft_local_data_source.dart';
import '../../data/datasources/discussion_board_local_data_source.dart';
import '../../data/datasources/discussion_board_remote_data_source.dart';
import '../../data/repositories/discussion_board_repository_impl.dart';
import '../../domain/entities/discussion_board_draft.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../../domain/repositories/discussion_board_repository.dart';
import '../../domain/usecases/delete_discussion_comment_usecase.dart';
import '../../domain/usecases/load_discussion_threads_usecase.dart';
import '../../domain/usecases/submit_discussion_post_usecase.dart';
import '../../domain/usecases/submit_discussion_reply_usecase.dart';
import '../../domain/usecases/upload_discussion_image_usecase.dart';
import '../controllers/discussion_board_controller.dart';
import '../state/discussion_board_state.dart';

final discussionBoardRemoteDataSourceProvider =
    Provider<DiscussionBoardRemoteDataSource>((ref) {
      return DiscussionBoardRemoteDataSourceImpl(
        ref.watch(oaCoreHttpClientProvider),
      );
    });

final discussionBoardDraftLocalDataSourceProvider =
    Provider<DiscussionBoardDraftLocalDataSource>((ref) {
      return DiscussionBoardDraftLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
        ref.watch(authLocalDataSourceProvider),
      );
    });

final discussionBoardDraftsProvider =
    FutureProvider.autoDispose<List<DiscussionBoardDraft>>((ref) {
      return ref
          .watch(discussionBoardDraftLocalDataSourceProvider)
          .readDrafts();
    });

final discussionBoardDraftImageStoreProvider =
    Provider<DiscussionBoardDraftImageStore>((ref) {
      return const DiscussionBoardDraftImageStore();
    });

final discussionBoardLocalDataSourceProvider = Provider.family
    .autoDispose<DiscussionBoardLocalDataSource, int?>((ref, projectId) {
      return DiscussionBoardLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
        ref.watch(authLocalDataSourceProvider),
        projectId: projectId,
      );
    });

final discussionBoardRepositoryProvider = Provider.family
    .autoDispose<DiscussionBoardRepository, int?>((ref, projectId) {
      return DiscussionBoardRepositoryImpl(
        remote: ref.watch(discussionBoardRemoteDataSourceProvider),
        local: ref.watch(discussionBoardLocalDataSourceProvider(projectId)),
        projectId: projectId,
      );
    });

final discussionBoardPreviewThreadsProvider = FutureProvider.autoDispose
    .family<List<DiscussionThread>, int?>((ref, projectId) async {
      final repository = ref.watch(
        discussionBoardRepositoryProvider(projectId),
      );
      return repository.loadThreads(page: 1, limit: 50);
    });

final discussionBoardControllerProvider = StateNotifierProvider.autoDispose
    .family<DiscussionBoardController, DiscussionBoardState, int?>((
      ref,
      projectId,
    ) {
      final repository = ref.watch(
        discussionBoardRepositoryProvider(projectId),
      );
      return DiscussionBoardController(
        LoadDiscussionThreadsUseCase(repository),
        SubmitDiscussionPostUseCase(repository),
        SubmitDiscussionReplyUseCase(repository),
        DeleteDiscussionCommentUseCase(repository),
        UploadDiscussionImageUseCase(repository),
      );
    });
