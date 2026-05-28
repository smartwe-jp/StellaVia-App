import 'dart:async';
import 'dart:collection';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../home/presentation/support/home_display_name_resolver.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/support/profile_document_image_picker.dart';
import '../../domain/entities/discussion_board_draft.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../providers/discussion_board_providers.dart';
import '../state/discussion_board_state.dart';
import '../support/discussion_board_time_label.dart';
import '../widgets/kizunark_comment_composer_widgets.dart';
import '../widgets/kizunark_composer_fund_picker_sheet.dart';
import '../widgets/kizunark_draft_list_page.dart';
import '../widgets/kizunark_thread_detail_page.dart';

class DiscussionBoardTabPage extends ConsumerStatefulWidget {
  const DiscussionBoardTabPage({super.key});

  @override
  ConsumerState<DiscussionBoardTabPage> createState() =>
      _DiscussionBoardTabPageState();
}

enum _DiscussionSendJobKind { post, reply }

class _PendingDiscussionSendJob {
  const _PendingDiscussionSendJob.post({
    required this.draftId,
    required this.content,
    required this.imageFilePaths,
    required this.selectedFund,
  }) : kind = _DiscussionSendJobKind.post,
       thread = null;

  const _PendingDiscussionSendJob.reply({
    required this.draftId,
    required this.content,
    required this.imageFilePaths,
    required DiscussionThread this.thread,
  }) : kind = _DiscussionSendJobKind.reply,
       selectedFund = null;

  final _DiscussionSendJobKind kind;
  final String draftId;
  final String content;
  final List<String> imageFilePaths;
  final SelectedComposerFund? selectedFund;
  final DiscussionThread? thread;
}

class _DiscussionBoardTabPageState
    extends ConsumerState<DiscussionBoardTabPage> {
  static const double _headerPostActionThreshold = 84;

  late final TextEditingController _composerController;
  late final ScrollController _scrollController;
  late final MainShellScrollControllerRegistry _scrollControllerRegistry;
  final Map<String, TextEditingController> _replyControllers =
      <String, TextEditingController>{};
  final Queue<_PendingDiscussionSendJob> _sendQueue =
      Queue<_PendingDiscussionSendJob>();
  SelectedComposerFund? _selectedPostComposerFund;
  bool _isProcessingSendQueue = false;
  bool _showHeaderPostAction = false;

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _scrollControllerRegistry = ref.read(
      mainShellScrollControllerRegistryProvider,
    );
    _scrollControllerRegistry.attach(2, _scrollController);
  }

  @override
  void dispose() {
    _scrollControllerRegistry.detach(2, _scrollController);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _composerController.dispose();
    for (final controller in _replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final shouldShowHeaderPostAction =
        position.pixels > _headerPostActionThreshold;
    if (shouldShowHeaderPostAction != _showHeaderPostAction && mounted) {
      setState(() {
        _showHeaderPostAction = shouldShowHeaderPostAction;
      });
    }
    if (position.pixels < position.maxScrollExtent - 140) {
      return;
    }
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .loadMoreThreads();
  }

  TextEditingController _replyControllerFor(String threadId) {
    return _replyControllers.putIfAbsent(threadId, TextEditingController.new);
  }

  String _resolveCurrentUserId(AuthUser? user) {
    final candidates = <String>[
      user?.userId?.toString() ?? '',
      user?.memberId?.toString() ?? '',
      user?.id ?? '',
      user?.accountId ?? '',
      user?.username ?? '',
    ];
    for (final candidate in candidates) {
      final text = candidate.trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  int? _resolveCurrentUserAvatarSeed(AuthUser? user) {
    if (user?.userId != null) {
      return user!.userId;
    }
    if (user?.memberId != null) {
      return user!.memberId;
    }
    final normalized =
        user?.id?.trim() ?? user?.accountId?.trim() ?? user?.username ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    return normalized.hashCode;
  }

  Future<bool> _submitPostWithImages({
    required bool isAuthenticated,
    required List<String> imageFilePaths,
  }) async {
    final l10n = context.l10n;
    if (!isAuthenticated) {
      AppNotice.show(context, message: l10n.kizunarkLoginRequiredToPost);
      return false;
    }
    final content = _composerController.text.trim();
    if (content.isEmpty) {
      return false;
    }
    final job = _PendingDiscussionSendJob.post(
      draftId: _newDraftId('post'),
      content: content,
      imageFilePaths: List<String>.of(imageFilePaths),
      selectedFund: _selectedPostComposerFund,
    );
    _enqueueSendJob(job);
    _composerController.clear();
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .updateComposerText('');
    if (mounted) {
      setState(() {
        _selectedPostComposerFund = null;
      });
    }
    return true;
  }

  Future<bool> _sendPostJob(
    _PendingDiscussionSendJob job, {
    required int generation,
  }) async {
    final l10n = context.l10n;
    final controller = ref.read(
      discussionBoardControllerProvider(null).notifier,
    );
    final progressController = ref.read(discussionSendQueueProvider.notifier);
    progressController.updateProgress(0.04);
    final submitted = await controller.submitPost(
      nowLabel: l10n.kizunarkJustNow,
      fallbackName: l10n.kizunarkFallbackDisplayName,
      fallbackHandle: l10n.kizunarkFallbackHandle,
      fallbackBadgeLabel: l10n.kizunarkInvestorBadge,
      fallbackAvatarUrl: ref
          .read(currentAuthUserProvider)
          .asData
          ?.value
          ?.avatar,
      linkedProjectId: int.tryParse(job.selectedFund?.projectId ?? ''),
      linkedProjectName: job.selectedFund?.projectName,
      imageFilePaths: job.imageFilePaths,
      onProgress: (double progress) {
        if (_isSendGenerationActive(generation)) {
          progressController.updateProgress(progress);
        }
      },
      contentOverride: job.content,
    );
    if (!_isSendGenerationActive(generation)) {
      return false;
    }
    if (submitted && mounted) {
      await _deleteSavedDraft(job.draftId);
      if (!mounted) {
        return true;
      }
      AppNotice.show(context, message: l10n.kizunarkPostSuccessNotice);
      return true;
    }
    if (!mounted) {
      return false;
    }
    await _savePostDraftData(
      content: job.content,
      imageFilePaths: job.imageFilePaths,
      selectedFund: job.selectedFund,
      draftId: job.draftId,
      clearComposer: false,
    );
    await _showSendFailureDialog(onRetry: () => _retrySendJob(job));
    return false;
  }

  Future<bool> _submitReplyWithImages(
    String threadId, {
    required bool isAuthenticated,
    required List<String> imageFilePaths,
    required DiscussionThread thread,
    required TextEditingController controller,
  }) async {
    final l10n = context.l10n;
    if (!isAuthenticated) {
      AppNotice.show(context, message: l10n.kizunarkLoginRequiredToPost);
      return false;
    }
    final content = controller.text.trim();
    if (content.isEmpty) {
      return false;
    }
    final job = _PendingDiscussionSendJob.reply(
      draftId: _newDraftId('reply_${thread.id}'),
      content: content,
      imageFilePaths: List<String>.of(imageFilePaths),
      thread: thread,
    );
    _enqueueSendJob(job);
    controller.clear();
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .updateReplyDraft(thread.id, '');
    return true;
  }

  Future<bool> _sendReplyJob(
    _PendingDiscussionSendJob job, {
    required int generation,
  }) async {
    final thread = job.thread;
    if (thread == null) {
      return false;
    }
    final l10n = context.l10n;
    final boardController = ref.read(
      discussionBoardControllerProvider(null).notifier,
    );
    final progressController = ref.read(discussionSendQueueProvider.notifier);
    progressController.updateProgress(0.04);
    final submitted = await boardController.submitReply(
      thread.id,
      nowLabel: l10n.kizunarkJustNow,
      fallbackName: l10n.kizunarkFallbackDisplayName,
      fallbackHandle: l10n.kizunarkFallbackHandle,
      fallbackBadgeLabel: l10n.kizunarkInvestorBadge,
      imageFilePaths: job.imageFilePaths,
      onProgress: (double progress) {
        if (_isSendGenerationActive(generation)) {
          progressController.updateProgress(progress);
        }
      },
      contentOverride: job.content,
    );
    if (!_isSendGenerationActive(generation)) {
      return false;
    }
    if (submitted && mounted) {
      await _deleteSavedDraft(job.draftId);
      if (!mounted) {
        return true;
      }
      AppNotice.show(context, message: l10n.kizunarkReplySuccessNotice);
      return true;
    }
    if (!mounted) {
      return false;
    }
    await _saveReplyDraftData(
      thread: thread,
      content: job.content,
      imageFilePaths: job.imageFilePaths,
      draftId: job.draftId,
      clearComposer: false,
    );
    await _showSendFailureDialog(onRetry: () => _retrySendJob(job));
    return false;
  }

  void _enqueueSendJob(_PendingDiscussionSendJob job) {
    _sendQueue.add(job);
    ref.read(discussionSendQueueProvider.notifier).enqueue();
    unawaited(_processSendQueue());
  }

  Future<bool> _retrySendJob(_PendingDiscussionSendJob job) async {
    _enqueueSendJob(job);
    return true;
  }

  bool _isSendGenerationActive(int generation) {
    return mounted &&
        ref.read(discussionSendQueueProvider).cancelGeneration == generation;
  }

  Future<void> _processSendQueue() async {
    if (_isProcessingSendQueue) {
      return;
    }
    _isProcessingSendQueue = true;
    try {
      while (_sendQueue.isNotEmpty && mounted) {
        final generation = ref
            .read(discussionSendQueueProvider)
            .cancelGeneration;
        final job = _sendQueue.removeFirst();
        var completed = false;
        try {
          switch (job.kind) {
            case _DiscussionSendJobKind.post:
              completed = await _sendPostJob(job, generation: generation);
            case _DiscussionSendJobKind.reply:
              completed = await _sendReplyJob(job, generation: generation);
          }
        } finally {
          if (_isSendGenerationActive(generation)) {
            final progressController = ref.read(
              discussionSendQueueProvider.notifier,
            );
            if (completed) {
              progressController.updateProgress(1);
              await Future<void>.delayed(const Duration(milliseconds: 220));
            }
            progressController.completeOne();
          }
        }
      }
    } finally {
      _isProcessingSendQueue = false;
    }
  }

  Future<void> _savePostDraft(
    List<String> imageFilePaths, {
    bool clearComposer = true,
  }) async {
    await _savePostDraftData(
      content: _composerController.text.trim(),
      imageFilePaths: imageFilePaths,
      selectedFund: _selectedPostComposerFund,
      clearComposer: clearComposer,
    );
  }

  String _newDraftId(String prefix) {
    return '${prefix}_${DateTime.now().toUtc().microsecondsSinceEpoch}';
  }

  Future<void> _deleteSavedDraft(String draftId) async {
    final normalized = draftId.trim();
    if (normalized.isEmpty) {
      return;
    }
    await ref
        .read(discussionBoardDraftLocalDataSourceProvider)
        .deleteDraft(normalized);
    ref.invalidate(discussionBoardDraftsProvider);
  }

  Future<void> _savePostDraftData({
    required String content,
    required List<String> imageFilePaths,
    required SelectedComposerFund? selectedFund,
    String? draftId,
    bool clearComposer = true,
  }) async {
    if (content.isEmpty && imageFilePaths.isEmpty) {
      return;
    }
    final now = DateTime.now().toUtc();
    final draft = DiscussionBoardDraft(
      id: draftId ?? 'post_${now.microsecondsSinceEpoch}',
      kind: DiscussionDraftKind.post,
      content: content,
      imageFilePaths: imageFilePaths,
      updatedAtIso: now.toIso8601String(),
      projectId: selectedFund?.projectId,
      projectName: selectedFund?.projectName,
    );
    await ref
        .read(discussionBoardDraftLocalDataSourceProvider)
        .saveDraft(draft);
    ref.invalidate(discussionBoardDraftsProvider);
    if (!clearComposer) {
      return;
    }
    _composerController.clear();
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .updateComposerText('');
    if (mounted) {
      setState(() {
        _selectedPostComposerFund = null;
      });
    }
  }

  Future<void> _saveReplyDraft({
    required DiscussionThread thread,
    required TextEditingController controller,
    required List<String> imageFilePaths,
    bool clearComposer = true,
  }) async {
    await _saveReplyDraftData(
      thread: thread,
      content: controller.text.trim(),
      imageFilePaths: imageFilePaths,
      clearComposer: clearComposer,
      controller: controller,
    );
  }

  Future<void> _saveReplyDraftData({
    required DiscussionThread thread,
    required String content,
    required List<String> imageFilePaths,
    String? draftId,
    bool clearComposer = true,
    TextEditingController? controller,
  }) async {
    if (content.isEmpty && imageFilePaths.isEmpty) {
      return;
    }
    final now = DateTime.now().toUtc();
    final draft = DiscussionBoardDraft(
      id: draftId ?? 'reply_${thread.id}_${now.microsecondsSinceEpoch}',
      kind: DiscussionDraftKind.reply,
      content: content,
      imageFilePaths: imageFilePaths,
      updatedAtIso: now.toIso8601String(),
      replyThreadId: thread.id,
      replyTargetName: thread.author.displayName,
      replyTargetBody: thread.body,
      replyTargetThreadJson: thread.toJson(),
    );
    await ref
        .read(discussionBoardDraftLocalDataSourceProvider)
        .saveDraft(draft);
    ref.invalidate(discussionBoardDraftsProvider);
    if (!clearComposer) {
      return;
    }
    controller?.clear();
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .updateReplyDraft(thread.id, '');
  }

  Future<DiscussionBoardDraft?> _openDraftList() {
    final colors = Theme.of(context).appColors;
    return showModalBottomSheet<DiscussionBoardDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      showDragHandle: false,
      backgroundColor: colors.surface.withValues(alpha: 0),
      builder: (BuildContext sheetContext) {
        return const FractionallySizedBox(
          heightFactor: 0.98,
          alignment: Alignment.bottomCenter,
          child: KizunarkDraftListSheet(),
        );
      },
    );
  }

  Future<void> _showSendFailureDialog({
    required Future<bool> Function() onRetry,
  }) async {
    if (!mounted) {
      return;
    }
    final retry = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: context.l10n.kizunarkSendFailedDialogTitle,
      message: context.l10n.kizunarkSendFailedDraftSavedMessage,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(
          label: context.l10n.commonOk,
          value: false,
          isDefaultAction: true,
        ),
        AppDialogAction<bool>(
          label: context.l10n.kizunarkSendFailedRetryAction,
          value: true,
        ),
      ],
    );
    if (retry == true && mounted) {
      await onRetry();
    }
  }

  Future<void> _openReplyDraft(DiscussionBoardDraft draft) async {
    final threadId = draft.replyThreadId?.trim() ?? '';
    if (threadId.isEmpty) {
      return;
    }
    final thread = _findThread(threadId) ?? _threadFromDraft(draft);
    if (thread == null) {
      if (mounted) {
        AppNotice.show(
          context,
          message: context.l10n.kizunarkDraftThreadUnavailableNotice,
        );
      }
      return;
    }
    final isAuthenticated =
        ref.read(currentAuthUserProvider).asData?.value != null;
    await _openReplyComposer(
      thread: thread,
      isAuthenticated: isAuthenticated,
      initialDraft: draft,
    );
  }

  DiscussionThread? _findThread(String threadId) {
    final normalized = threadId.trim();
    if (normalized.isEmpty) {
      return null;
    }
    final threads = ref.read(discussionBoardControllerProvider(null)).threads;
    for (final thread in threads) {
      if (thread.id == normalized) {
        return thread;
      }
    }
    return null;
  }

  DiscussionThread? _threadFromDraft(DiscussionBoardDraft draft) {
    final snapshot = draft.replyTargetThreadJson;
    if (snapshot == null) {
      return null;
    }
    final thread = DiscussionThread.fromJson(snapshot);
    return thread.id.trim().isEmpty ? null : thread;
  }

  Future<List<String>> _pickDiscussionImages(int remainingCount) async {
    if (remainingCount <= 0) {
      return const <String>[];
    }
    final result = await ref
        .read(profileDocumentImagePickerProvider)
        .pickMultipleFromGallery(limit: remainingCount);
    if (!mounted) {
      return const <String>[];
    }
    switch (result.status) {
      case ProfileDocumentImagePickStatus.success:
        final imageStore = ref.read(discussionBoardDraftImageStoreProvider);
        final persistedPaths = <String>[];
        for (final sourcePath in result.paths.take(remainingCount)) {
          final persistedPath = await imageStore.persistForDisplay(sourcePath);
          if (persistedPath != null && persistedPath.isNotEmpty) {
            persistedPaths.add(persistedPath);
          }
        }
        if (!mounted) {
          return const <String>[];
        }
        if (persistedPaths.isEmpty) {
          AppNotice.show(
            context,
            message: context.l10n.discussionAvatarPickFailed,
          );
          return const <String>[];
        }
        return persistedPaths;
      case ProfileDocumentImagePickStatus.canceled:
        return const <String>[];
      case ProfileDocumentImagePickStatus.permissionDenied:
      case ProfileDocumentImagePickStatus.permissionSettingsRequired:
        AppNotice.show(
          context,
          message: context.l10n.permissionSettingsPhotosMessage,
        );
        return const <String>[];
      case ProfileDocumentImagePickStatus.sizeLimitExceeded:
        AppNotice.show(context, message: context.l10n.profileImageSizeTooLarge);
        return const <String>[];
      case ProfileDocumentImagePickStatus.failed:
        AppNotice.show(
          context,
          message: result.errorMessage?.trim().isNotEmpty == true
              ? result.errorMessage!.trim()
              : context.l10n.discussionAvatarPickFailed,
        );
        return const <String>[];
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final l10n = context.l10n;
    final success = await ref
        .read(discussionBoardControllerProvider(null).notifier)
        .deleteComment(commentId);
    if (!mounted) {
      return;
    }
    if (!success) {
      return;
    }
    AppNotice.show(context, message: l10n.kizunarkDeleteSuccessNotice);
  }

  Future<void> _copyMessageBody(String body) async {
    final text = body.trim();
    if (text.isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }
    AppNotice.show(context, message: context.l10n.kizunarkCopySuccessNotice);
  }

  void _openLinkedFundDetail(String? projectId) {
    final normalized = projectId?.trim() ?? '';
    if (normalized.isEmpty) {
      return;
    }
    context.push('/funds/$normalized');
  }

  Future<void> _openCommentImageViewer(
    List<String> imageUrls,
    int initialIndex,
  ) {
    return openAppImageViewer(
      context,
      initialIndex: initialIndex,
      items: imageUrls
          .map((String url) => AppImageViewerItem(source: url))
          .toList(growable: false),
      texts: AppImageViewerTexts(
        loadingLabel: context.l10n.imageViewerLoadingLabel,
        loadFailedLabel: context.l10n.imageViewerLoadFailedLabel,
        retryLabel: context.l10n.imageViewerRetryLabel,
        invalidSourceNotice: context.l10n.imageViewerInvalidSourceNotice,
        closeTooltip: context.l10n.imageViewerCloseTooltip,
      ),
    );
  }

  Future<SelectedComposerFund?> _showComposerFundPicker(
    SelectedComposerFund? currentSelection,
  ) async {
    final selectedFund =
        await AppBottomSheet.showAdaptive<SelectedComposerFund>(
          context: context,
          useRootNavigator: true,
          builder: (BuildContext bottomSheetContext) {
            return KizunarkComposerFundPickerSheet(
              currentSelection: currentSelection,
            );
          },
        );
    if (!mounted || selectedFund == null) {
      return null;
    }
    return selectedFund.isClearSelection ? null : selectedFund;
  }

  Future<void> _openPostComposer({
    required bool isAuthenticated,
    required AuthUser? currentUser,
  }) async {
    if (!isAuthenticated) {
      AppNotice.show(
        context,
        message: context.l10n.kizunarkLoginRequiredToPost,
      );
      return;
    }
    final authorLabel = resolveHomeDisplayName(
      locale: Localizations.localeOf(context),
      profile: ref.read(memberBasicProfileProvider),
    );
    final hasDrafts = await ref
        .read(discussionBoardDraftsProvider.future)
        .then((List<DiscussionBoardDraft> drafts) => drafts.isNotEmpty)
        .catchError((Object _) => false);
    if (!mounted) {
      return;
    }
    await context.push<void>(
      '/discussion-board/post',
      extra: KizunarkPostComposeRouteArgs(
        child: KizunarkComposeSheet(
          title: context.l10n.kizunarkComposeSheetTitle,
          closeLabel: context.l10n.kizunarkComposeCloseAction,
          submitLabel: context.l10n.kizunarkPostAction,
          placeholder: context.l10n.kizunarkComposePlaceholder,
          currentUser: currentUser,
          avatarSeed: _resolveCurrentUserAvatarSeed(currentUser),
          authorLabel: authorLabel,
          addImageLabel: context.l10n.kizunarkAddImageAction,
          linkedFundLabel: context.l10n.kizunarkAssociateFundAction,
          imageCounterBuilder: context.l10n.kizunarkImageCounter,
          controller: _composerController,
          selectedFund: _selectedPostComposerFund,
          hasDrafts: hasDrafts,
          onPickImages: _pickDiscussionImages,
          onPickFund: () => _showComposerFundPicker(_selectedPostComposerFund),
          onOpenDrafts: _openDraftList,
          onOpenReplyDraft: _openReplyDraft,
          onSelectedFundChanged: (SelectedComposerFund? fund) {
            setState(() {
              _selectedPostComposerFund = fund;
            });
          },
          onTextChanged: ref
              .read(discussionBoardControllerProvider(null).notifier)
              .updateComposerText,
          onSaveDraft: _savePostDraft,
          onSubmit: (List<String> imageFilePaths) async {
            return _submitPostWithImages(
              isAuthenticated: isAuthenticated,
              imageFilePaths: imageFilePaths,
            );
          },
          fullPage: true,
        ),
      ),
    );
    if (mounted && _composerController.text.trim().isEmpty) {
      setState(() {
        _selectedPostComposerFund = null;
      });
    }
  }

  Future<void> _openReplyComposer({
    required DiscussionThread thread,
    required bool isAuthenticated,
    DiscussionBoardDraft? initialDraft,
  }) async {
    if (!isAuthenticated) {
      AppNotice.show(
        context,
        message: context.l10n.kizunarkLoginRequiredToPost,
      );
      return;
    }
    final replyController = _replyControllerFor(thread.id);
    final liveDraft =
        ref
            .read(discussionBoardControllerProvider(null))
            .replyDrafts[thread.id] ??
        '';
    final currentDraft = initialDraft?.content ?? liveDraft;
    if (replyController.text != currentDraft) {
      replyController.value = TextEditingValue(
        text: currentDraft,
        selection: TextSelection.collapsed(offset: currentDraft.length),
      );
    }
    if (currentDraft != liveDraft) {
      ref
          .read(discussionBoardControllerProvider(null).notifier)
          .updateReplyDraft(thread.id, currentDraft);
    }
    await context.push<void>(
      '/discussion-board/reply/${Uri.encodeComponent(thread.id)}',
      extra: KizunarkReplyComposeRouteArgs(
        child: KizunarkReplyComposeSheet(
          title: context.l10n.kizunarkReplySheetTitle,
          closeLabel: context.l10n.kizunarkComposeCloseAction,
          submitLabel: context.l10n.kizunarkReplySendAction,
          placeholder: context.l10n.kizunarkReplyPlaceholder,
          currentUser: ref.read(currentAuthUserProvider).asData?.value,
          avatarSeed: _resolveCurrentUserAvatarSeed(
            ref.read(currentAuthUserProvider).asData?.value,
          ),
          authorLabel: context.l10n.kizunarkReplyAuthorLabel(
            thread.author.displayName,
          ),
          targetLabel: context.l10n.kizunarkReplyTargetLabel,
          targetName: thread.author.displayName,
          targetBody: thread.body,
          targetAvatarUrl: thread.author.avatarUrl,
          targetAvatarGradientColorValues:
              thread.author.avatarGradientColorValues,
          targetImageUrls: thread.imageUrls,
          onTargetImageTap: (int index) =>
              _openCommentImageViewer(thread.imageUrls, index),
          addImageLabel: context.l10n.kizunarkAddImageAction,
          imageCounterBuilder: context.l10n.kizunarkImageCounter,
          controller: replyController,
          onChanged: (String value) => ref
              .read(discussionBoardControllerProvider(null).notifier)
              .updateReplyDraft(thread.id, value),
          onPickImages: _pickDiscussionImages,
          onSaveDraft: (List<String> imageFilePaths) => _saveReplyDraft(
            thread: thread,
            controller: replyController,
            imageFilePaths: imageFilePaths,
          ),
          initialImageFilePaths:
              initialDraft?.imageFilePaths ?? const <String>[],
          onSubmit: (List<String> imageFilePaths) async {
            final shouldClose = await _submitReplyWithImages(
              thread.id,
              isAuthenticated: isAuthenticated,
              imageFilePaths: imageFilePaths,
              thread: thread,
              controller: replyController,
            );
            if (shouldClose) {
              replyController.clear();
            }
            return shouldClose;
          },
          fullPage: true,
        ),
      ),
    );
  }

  Future<void> _openThreadDetail({
    required DiscussionThread thread,
    required bool isAuthenticated,
    required String currentUserId,
  }) async {
    await context.push<void>(
      '/discussion-board/thread/${Uri.encodeComponent(thread.id)}',
      extra: KizunarkThreadDetailRouteArgs(
        thread: thread,
        isAuthenticated: isAuthenticated,
        currentUserId: currentUserId,
        onOpenImageViewer: _openCommentImageViewer,
        onReply: () => _openReplyComposer(
          thread: thread,
          isAuthenticated: isAuthenticated,
        ),
        onMessageLongPress: _showMessageActionSheet,
      ),
    );
  }

  Future<void> _showMessageActionSheet({
    required String commentId,
    required String messageBody,
    required bool canDelete,
    required bool isDeleting,
  }) async {
    final l10n = context.l10n;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                _copyMessageBody(messageBody);
              },
              child: Text(l10n.kizunarkCopyAction),
            ),
            if (canDelete)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  if (isDeleting) {
                    return;
                  }
                  Navigator.of(sheetContext).pop();
                  _deleteComment(commentId);
                },
                child: Text(l10n.kizunarkDeleteAction),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: Text(l10n.kizunarkMenuCancelAction),
          ),
        );
      },
    );
  }

  Future<void> _openAvatarEditor() async {
    final uploadedUrl = await context.push<String>('/profile/avatar');
    if (!mounted || (uploadedUrl?.trim().isNotEmpty ?? false) == false) {
      return;
    }
    await ref.refresh(currentAuthUserProvider.future).catchError((Object _) {
      return null;
    });
    await ref
        .read(discussionBoardControllerProvider(null).notifier)
        .refreshThreads();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      discussionBoardControllerProvider(
        null,
      ).select((DiscussionBoardState state) => state.errorMessage),
      (previous, next) {
        if (next == null || previous == next || !mounted) {
          return;
        }
        AppNotice.show(
          context,
          message: next.trim().isNotEmpty
              ? next
              : context.l10n.uiErrorRequestFailed,
        );
        ref.read(discussionBoardControllerProvider(null).notifier).clearError();
      },
    );

    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      final previousValue = previous?.asData?.value;
      final nextValue = next.asData?.value;
      if (previousValue == nextValue) {
        return;
      }
      ref.read(discussionBoardControllerProvider(null).notifier).loadThreads();
    });

    ref.listen<AsyncValue<AuthUser?>>(currentAuthUserProvider, (
      previous,
      next,
    ) {
      final previousId = _resolveCurrentUserId(previous?.asData?.value);
      final nextId = _resolveCurrentUserId(next.asData?.value);
      if (previousId == nextId) {
        return;
      }
      ref.read(discussionBoardControllerProvider(null).notifier).loadThreads();
    });

    ref.listen<int>(
      discussionSendQueueProvider.select((state) => state.cancelGeneration),
      (previous, next) {
        if (previous == null || previous == next) {
          return;
        }
        _sendQueue.clear();
      },
    );

    final l10n = context.l10n;
    final state = ref.watch(discussionBoardControllerProvider(null));
    final controller = ref.read(
      discussionBoardControllerProvider(null).notifier,
    );
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    final currentUserId = _resolveCurrentUserId(currentUser);

    if (_composerController.text != state.composerText) {
      _composerController.value = TextEditingValue(
        text: state.composerText,
        selection: TextSelection.collapsed(offset: state.composerText.length),
      );
    }

    return Column(
      children: <Widget>[
        // MainShellChromeVisibility(
        //   child:
        KizunarkGradientHeader(
          title: l10n.mainTabKizunark,
          subtitle: l10n.kizunarkSubtitle,
          titleLightAssetPath: 'assets/images/kizunark.nav.light.png',
          titleDarkAssetPath: 'assets/images/kizunark.nav.dark.png',
          trailing: isAuthenticated
              ? _HeaderPostAction(
                  label: l10n.kizunarkPostAction,
                  isVisible: _showHeaderPostAction,
                  enabled: !state.isPosting,
                  onTap: () => _openPostComposer(
                    isAuthenticated: isAuthenticated,
                    currentUser: currentUser,
                  ),
                )
              : null,
        ),
        //),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => controller.refreshThreads(),
            child: ListView(
              key: const Key('discussion_tab_content'),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.zero,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                //   child: KizunarkNoticeBanner(
                //     label: l10n.kizunarkInvestorOnlyNotice,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: isAuthenticated
                      ? KizunarkPostEntry(
                          avatar: GestureDetector(
                            onTap: _openAvatarEditor,
                            behavior: HitTestBehavior.opaque,
                            child: AppUserAvatar(
                              avatarUrl: currentUser?.avatar,
                              avatarSeed: _resolveCurrentUserAvatarSeed(
                                currentUser,
                              ),
                              size: 36,
                              fontSize: 14,
                            ),
                          ),
                          title: l10n.kizunarkEntryTitle,
                          subtitle: l10n.kizunarkEntrySubtitle,
                          actionLabel: l10n.kizunarkPostAction,
                          enabled: !state.isPosting,
                          onTap: () => _openPostComposer(
                            isAuthenticated: isAuthenticated,
                            currentUser: currentUser,
                          ),
                        )
                      : KizunarkGuestPrompt(
                          message: l10n.kizunarkGuestLoginPrompt,
                          onLoginTap: () => context.push('/login'),
                          onRegisterTap: () =>
                              context.push('/login?openRegister=1'),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: _buildFeedSection(
                    l10n: l10n,
                    state: state,
                    isAuthenticated: isAuthenticated,
                    currentUserId: currentUserId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedSection({
    required AppLocalizations l10n,
    required DiscussionBoardState state,
    required bool isAuthenticated,
    required String currentUserId,
  }) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    if (state.isLoading && state.threads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (state.threads.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
            l10n.kizunarkEmptyState,
            textAlign: TextAlign.center,
            style: appText.bodyMuted.copyWith(
              color: colors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      );
    }

    final threadCards = state.threads
        .map<Widget>((thread) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: KizunarkPostCard(
              key: ValueKey<String>('discussion-thread-${thread.id}'),
              avatar: AppUserAvatar(
                avatarUrl: thread.author.avatarUrl,
                gradientColorValues: thread.author.avatarGradientColorValues,
                size: 32,
                fontSize: 12,
              ),
              displayName: thread.author.displayName,
              accountText: thread.author.accountHandle,
              badgeLabel: thread.author.badge.label,
              badgeBackgroundColor: Color(
                thread.author.badge.backgroundColorValue,
              ),
              badgeForegroundColor: Color(
                thread.author.badge.foregroundColorValue,
              ),
              timeLabel: buildDiscussionBoardTimeLabel(
                context,
                createdAtIso: thread.createdAtIso,
                fallbackLabel: thread.timeLabel,
              ),
              body: thread.body,
              imageUrls: thread.imageUrls,
              onImageTap: (int index) =>
                  _openCommentImageViewer(thread.imageUrls, index),
              fundReferenceChip: thread.fundReferenceLabel == null
                  ? null
                  : KizunarkFundReferenceChip(
                      label: thread.fundReferenceLabel!,
                      onTap: () =>
                          _openLinkedFundDetail(thread.fundReferenceId),
                    ),
              commentCount: thread.commentCount,
              onTap: () => _openThreadDetail(
                thread: thread,
                isAuthenticated: isAuthenticated,
                currentUserId: currentUserId,
              ),
              onToggleRepliesTap: () => _openReplyComposer(
                thread: thread,
                isAuthenticated: isAuthenticated,
              ),
              showReplies: false,
              onLongPress: () => _showMessageActionSheet(
                commentId: thread.id,
                messageBody: thread.body,
                canDelete:
                    thread.author.id == currentUserId &&
                    currentUserId.isNotEmpty,
                isDeleting: state.deletingCommentIds.contains(thread.id),
              ),
            ),
          );
        })
        .toList(growable: false);

    return Column(
      children: <Widget>[
        ...threadCards,
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}

class _HeaderPostAction extends StatelessWidget {
  const _HeaderPostAction({
    required this.label,
    required this.isVisible,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool isVisible;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      offset: isVisible ? Offset.zero : const Offset(0.2, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 140),
        opacity: isVisible ? 1 : 0,
        child: IgnorePointer(
          ignoring: !isVisible,
          child: KizunarkSendActionButton(
            label: label,
            onPressed: enabled ? onTap : null,
          ),
        ),
      ),
    );
  }
}
