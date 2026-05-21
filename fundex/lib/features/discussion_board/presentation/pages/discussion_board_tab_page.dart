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

class _DiscussionBoardTabPageState
    extends ConsumerState<DiscussionBoardTabPage> {
  late final TextEditingController _composerController;
  late final ScrollController _scrollController;
  late final MainShellScrollControllerRegistry _scrollControllerRegistry;
  final Map<String, TextEditingController> _replyControllers =
      <String, TextEditingController>{};
  SelectedComposerFund? _selectedComposerFund;

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

  Future<void> _submitPostWithImages({
    required bool isAuthenticated,
    required List<String> imageFilePaths,
  }) async {
    final l10n = context.l10n;
    final controller = ref.read(
      discussionBoardControllerProvider(null).notifier,
    );
    if (!isAuthenticated) {
      AppNotice.show(context, message: l10n.kizunarkLoginRequiredToPost);
      return;
    }
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
      linkedProjectId: int.tryParse(_selectedComposerFund?.projectId ?? ''),
      linkedProjectName: _selectedComposerFund?.projectName,
      imageFilePaths: imageFilePaths,
    );
    if (submitted && mounted) {
      setState(() {
        _selectedComposerFund = null;
      });
      AppNotice.show(context, message: l10n.kizunarkPostSuccessNotice);
    }
  }

  Future<void> _submitReplyWithImages(
    String threadId, {
    required bool isAuthenticated,
    required List<String> imageFilePaths,
  }) async {
    final l10n = context.l10n;
    final controller = ref.read(
      discussionBoardControllerProvider(null).notifier,
    );
    if (!isAuthenticated) {
      AppNotice.show(context, message: l10n.kizunarkLoginRequiredToPost);
      return;
    }
    final submitted = await controller.submitReply(
      threadId,
      nowLabel: l10n.kizunarkJustNow,
      fallbackName: l10n.kizunarkFallbackDisplayName,
      fallbackHandle: l10n.kizunarkFallbackHandle,
      fallbackBadgeLabel: l10n.kizunarkInvestorBadge,
      linkedProjectId: int.tryParse(_selectedComposerFund?.projectId ?? ''),
      imageFilePaths: imageFilePaths,
    );
    if (submitted && mounted) {
      final draftStore = ref.read(discussionBoardDraftLocalDataSourceProvider);
      final storedDrafts = await draftStore.readDrafts();
      for (final draft in storedDrafts.where(
        (DiscussionBoardDraft draft) =>
            draft.kind == DiscussionDraftKind.reply &&
            draft.replyThreadId == threadId,
      )) {
        await draftStore.deleteDraft(draft.id);
      }
      ref.invalidate(discussionBoardDraftsProvider);
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedComposerFund = null;
      });
      AppNotice.show(context, message: l10n.kizunarkReplySuccessNotice);
    }
  }

  Future<void> _savePostDraft(List<String> imageFilePaths) async {
    final content = _composerController.text.trim();
    if (content.isEmpty && imageFilePaths.isEmpty) {
      return;
    }
    final now = DateTime.now().toUtc();
    final draft = DiscussionBoardDraft(
      id: 'post_${now.microsecondsSinceEpoch}',
      kind: DiscussionDraftKind.post,
      content: content,
      imageFilePaths: imageFilePaths,
      updatedAtIso: now.toIso8601String(),
      projectId: _selectedComposerFund?.projectId,
      projectName: _selectedComposerFund?.projectName,
    );
    await ref
        .read(discussionBoardDraftLocalDataSourceProvider)
        .saveDraft(draft);
    ref.invalidate(discussionBoardDraftsProvider);
    _composerController.clear();
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .updateComposerText('');
    if (mounted) {
      setState(() {
        _selectedComposerFund = null;
      });
    }
  }

  Future<void> _saveReplyDraft({
    required DiscussionThread thread,
    required TextEditingController controller,
    required List<String> imageFilePaths,
  }) async {
    final content = controller.text.trim();
    if (content.isEmpty && imageFilePaths.isEmpty) {
      return;
    }
    final now = DateTime.now().toUtc();
    final draft = DiscussionBoardDraft(
      id: 'reply_${thread.id}_${now.microsecondsSinceEpoch}',
      kind: DiscussionDraftKind.reply,
      content: content,
      imageFilePaths: imageFilePaths,
      updatedAtIso: now.toIso8601String(),
      projectId: _selectedComposerFund?.projectId,
      projectName: _selectedComposerFund?.projectName,
      replyThreadId: thread.id,
      replyTargetName: thread.author.displayName,
      replyTargetBody: thread.body,
    );
    await ref
        .read(discussionBoardDraftLocalDataSourceProvider)
        .saveDraft(draft);
    ref.invalidate(discussionBoardDraftsProvider);
    controller.clear();
    ref
        .read(discussionBoardControllerProvider(null).notifier)
        .updateReplyDraft(thread.id, '');
    if (mounted) {
      setState(() {
        _selectedComposerFund = null;
      });
    }
  }

  Future<DiscussionBoardDraft?> _openPostDraftList() {
    return context.push<DiscussionBoardDraft>(
      '/discussion-board/drafts',
      extra: const KizunarkDraftListRouteArgs(kind: DiscussionDraftKind.post),
    );
  }

  Future<String?> _pickDiscussionImage() async {
    final result = await ref
        .read(profileDocumentImagePickerProvider)
        .pick(ProfileDocumentImageSource.gallery);
    if (!mounted) {
      return null;
    }
    switch (result.status) {
      case ProfileDocumentImagePickStatus.success:
        return result.path?.trim();
      case ProfileDocumentImagePickStatus.canceled:
        return null;
      case ProfileDocumentImagePickStatus.permissionDenied:
      case ProfileDocumentImagePickStatus.permissionSettingsRequired:
        AppNotice.show(
          context,
          message: context.l10n.permissionSettingsPhotosMessage,
        );
        return null;
      case ProfileDocumentImagePickStatus.sizeLimitExceeded:
        AppNotice.show(context, message: context.l10n.profileImageSizeTooLarge);
        return null;
      case ProfileDocumentImagePickStatus.failed:
        AppNotice.show(
          context,
          message: result.errorMessage?.trim().isNotEmpty == true
              ? result.errorMessage!.trim()
              : context.l10n.discussionAvatarPickFailed,
        );
        return null;
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

  Future<SelectedComposerFund?> _showComposerFundPicker() async {
    final selectedFund =
        await AppBottomSheet.showAdaptive<SelectedComposerFund>(
          context: context,
          useRootNavigator: true,
          builder: (BuildContext bottomSheetContext) {
            return KizunarkComposerFundPickerSheet(
              currentSelection: _selectedComposerFund,
            );
          },
        );
    if (!mounted || selectedFund == null) {
      return null;
    }
    final nextFund = selectedFund.isClearSelection ? null : selectedFund;
    setState(() {
      _selectedComposerFund = nextFund;
    });
    return nextFund;
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
          selectedFund: _selectedComposerFund,
          onPickImage: _pickDiscussionImage,
          onPickFund: _showComposerFundPicker,
          onOpenDrafts: _openPostDraftList,
          onSelectedFundChanged: (SelectedComposerFund? fund) {
            setState(() {
              _selectedComposerFund = fund;
            });
          },
          onTextChanged: ref
              .read(discussionBoardControllerProvider(null).notifier)
              .updateComposerText,
          onSaveDraft: _savePostDraft,
          onSubmit: (List<String> imageFilePaths) async {
            await _submitPostWithImages(
              isAuthenticated: isAuthenticated,
              imageFilePaths: imageFilePaths,
            );
            return mounted
                ? ref
                      .read(discussionBoardControllerProvider(null))
                      .composerText
                      .isEmpty
                : false;
          },
          fullPage: true,
        ),
      ),
    );
  }

  Future<void> _openReplyComposer({
    required DiscussionThread thread,
    required bool isAuthenticated,
  }) async {
    if (!isAuthenticated) {
      AppNotice.show(
        context,
        message: context.l10n.kizunarkLoginRequiredToPost,
      );
      return;
    }
    final replyController = _replyControllerFor(thread.id);
    final storedDrafts = await ref
        .read(discussionBoardDraftLocalDataSourceProvider)
        .readDrafts();
    if (!mounted) {
      return;
    }
    final storedReplyDrafts =
        storedDrafts
            .where(
              (DiscussionBoardDraft draft) =>
                  draft.kind == DiscussionDraftKind.reply &&
                  draft.replyThreadId == thread.id,
            )
            .toList()
          ..sort(
            (DiscussionBoardDraft left, DiscussionBoardDraft right) =>
                right.updatedAtIso.compareTo(left.updatedAtIso),
          );
    final storedReplyDraft = storedReplyDrafts.isEmpty
        ? null
        : storedReplyDrafts.first;
    final liveDraft =
        ref
            .read(discussionBoardControllerProvider(null))
            .replyDrafts[thread.id] ??
        '';
    final activeStoredDraft = liveDraft.trim().isEmpty
        ? storedReplyDraft
        : null;
    final currentDraft = liveDraft.trim().isNotEmpty
        ? liveDraft
        : activeStoredDraft?.content ?? '';
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
    final draftProjectId = activeStoredDraft?.projectId?.trim() ?? '';
    if (draftProjectId.isNotEmpty) {
      setState(() {
        _selectedComposerFund = SelectedComposerFund(
          projectId: draftProjectId,
          projectName: activeStoredDraft?.projectName ?? '',
          selectionKey: draftProjectId,
        );
      });
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
          linkedFundLabel: context.l10n.kizunarkAssociateFundAction,
          imageCounterBuilder: context.l10n.kizunarkImageCounter,
          controller: replyController,
          onChanged: (String value) => ref
              .read(discussionBoardControllerProvider(null).notifier)
              .updateReplyDraft(thread.id, value),
          onPickImage: _pickDiscussionImage,
          onPickFund: () async {
            await _showComposerFundPicker();
          },
          onSaveDraft: (List<String> imageFilePaths) => _saveReplyDraft(
            thread: thread,
            controller: replyController,
            imageFilePaths: imageFilePaths,
          ),
          initialImageFilePaths:
              activeStoredDraft?.imageFilePaths ?? const <String>[],
          onSubmit: (List<String> imageFilePaths) async {
            await _submitReplyWithImages(
              thread.id,
              isAuthenticated: isAuthenticated,
              imageFilePaths: imageFilePaths,
            );
            final shouldClose =
                mounted &&
                (ref
                            .read(discussionBoardControllerProvider(null))
                            .replyDrafts[thread.id] ??
                        '')
                    .isEmpty;
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
        KizunarkGradientHeader(
          title: l10n.mainTabKizunark,
          subtitle: l10n.kizunarkSubtitle,
          titleLightAssetPath: 'assets/images/kizunark.nav.light.png',
          titleDarkAssetPath: 'assets/images/kizunark.nav.dark.png',
        ),
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
