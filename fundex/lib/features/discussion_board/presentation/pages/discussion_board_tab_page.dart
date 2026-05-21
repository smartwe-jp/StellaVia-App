import 'dart:io';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/support/profile_document_image_picker.dart';
import '../../../member_profile/presentation/support/mypage_section_support.dart';
import '../../../member_profile/presentation/widgets/my_page_active_fund_summary_card.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../providers/discussion_board_providers.dart';
import '../state/discussion_board_state.dart';
import '../support/discussion_board_time_label.dart';
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
  _SelectedComposerFund? _selectedComposerFund;

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
      imageFilePaths: imageFilePaths,
    );
    if (submitted && mounted) {
      AppNotice.show(context, message: l10n.kizunarkReplySuccessNotice);
    }
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

  Future<void> _showComposerFundPicker() async {
    final selectedFund =
        await AppBottomSheet.showAdaptive<_SelectedComposerFund>(
          context: context,
          useRootNavigator: true,
          builder: (BuildContext bottomSheetContext) {
            return _ComposerFundPickerSheet(
              currentSelection: _selectedComposerFund,
            );
          },
        );
    if (!mounted || selectedFund == null) {
      return;
    }
    setState(() {
      _selectedComposerFund = selectedFund.isClearSelection
          ? null
          : selectedFund;
    });
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
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return _KizunarkComposeSheet(
          title: context.l10n.kizunarkComposeSheetTitle,
          closeLabel: context.l10n.kizunarkComposeCloseAction,
          submitLabel: context.l10n.kizunarkPostAction,
          placeholder: context.l10n.kizunarkComposePlaceholder,
          currentUser: currentUser,
          avatarSeed: _resolveCurrentUserAvatarSeed(currentUser),
          authorLabel: context.l10n.kizunarkComposeAuthorLabel,
          addImageLabel: context.l10n.kizunarkAddImageAction,
          linkedFundLabel: context.l10n.kizunarkAssociateFundAction,
          imageCounterBuilder: context.l10n.kizunarkImageCounter,
          controller: _composerController,
          selectedFund: _selectedComposerFund,
          onPickImage: _pickDiscussionImage,
          onPickFund: _showComposerFundPicker,
          onTextChanged: ref
              .read(discussionBoardControllerProvider(null).notifier)
              .updateComposerText,
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
        );
      },
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
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return _KizunarkReplyComposeSheet(
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
          addImageLabel: context.l10n.kizunarkAddImageAction,
          imageCounterBuilder: context.l10n.kizunarkImageCounter,
          controller: replyController,
          onChanged: (String value) => ref
              .read(discussionBoardControllerProvider(null).notifier)
              .updateReplyDraft(thread.id, value),
          onPickImage: _pickDiscussionImage,
          onSubmit: (List<String> imageFilePaths) async {
            await _submitReplyWithImages(
              thread.id,
              isAuthenticated: isAuthenticated,
              imageFilePaths: imageFilePaths,
            );
            return mounted &&
                (ref
                            .read(discussionBoardControllerProvider(null))
                            .replyDrafts[thread.id] ??
                        '')
                    .isEmpty;
          },
        );
      },
    );
  }

  Future<void> _openThreadDetail({
    required DiscussionThread thread,
    required bool isAuthenticated,
    required String currentUserId,
  }) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => KizunarkThreadDetailPage(
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
                      ? _KizunarkPostEntry(
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
                      : _KizunarkGuestPrompt(
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

class _KizunarkPostEntry extends StatelessWidget {
  const _KizunarkPostEntry({
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.enabled,
    required this.onTap,
  });

  final Widget avatar;
  final String title;
  final String subtitle;
  final String actionLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSoft),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              avatar,
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appText.bodyStrong.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appText.meta.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: enabled ? onTap : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(64, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KizunarkComposeSheet extends StatefulWidget {
  const _KizunarkComposeSheet({
    required this.title,
    required this.closeLabel,
    required this.submitLabel,
    required this.placeholder,
    required this.currentUser,
    required this.avatarSeed,
    required this.authorLabel,
    required this.addImageLabel,
    required this.linkedFundLabel,
    required this.imageCounterBuilder,
    required this.controller,
    required this.selectedFund,
    required this.onPickImage,
    required this.onPickFund,
    required this.onTextChanged,
    required this.onSubmit,
  });

  final String title;
  final String closeLabel;
  final String submitLabel;
  final String placeholder;
  final AuthUser? currentUser;
  final int? avatarSeed;
  final String authorLabel;
  final String addImageLabel;
  final String linkedFundLabel;
  final String Function(int count) imageCounterBuilder;
  final TextEditingController controller;
  final _SelectedComposerFund? selectedFund;
  final Future<String?> Function() onPickImage;
  final Future<void> Function() onPickFund;
  final ValueChanged<String> onTextChanged;
  final Future<bool> Function(List<String> imageFilePaths) onSubmit;

  @override
  State<_KizunarkComposeSheet> createState() => _KizunarkComposeSheetState();
}

class _KizunarkComposeSheetState extends State<_KizunarkComposeSheet> {
  static const int _maxImages = 4;
  final List<String> _imageFilePaths = <String>[];
  bool _isSubmitting = false;

  Future<void> _addImage() async {
    if (_imageFilePaths.length >= _maxImages) {
      return;
    }
    final path = await widget.onPickImage();
    if (!mounted || path == null || path.isEmpty) {
      return;
    }
    setState(() {
      _imageFilePaths.add(path);
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    final shouldClose = await widget.onSubmit(List<String>.of(_imageFilePaths));
    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
    });
    if (shouldClose) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.92;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: height,
          child: Material(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                _ComposeSheetHeader(
                  title: widget.title,
                  closeLabel: widget.closeLabel,
                  submitLabel: widget.submitLabel,
                  isSubmitting: _isSubmitting,
                  onClose: () => Navigator.of(context).pop(),
                  onSubmit: _submit,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    children: <Widget>[
                      _ComposeAuthorRow(
                        avatarUrl: widget.currentUser?.avatar,
                        avatarSeed: widget.avatarSeed,
                        label: widget.authorLabel,
                      ),
                      TextField(
                        controller: widget.controller,
                        autofocus: true,
                        minLines: 6,
                        maxLines: 10,
                        onChanged: widget.onTextChanged,
                        style: appText.inputText.copyWith(
                          color: colors.textPrimary,
                          height: 1.55,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.placeholder,
                          border: InputBorder.none,
                        ),
                      ),
                      if (widget.selectedFund != null) ...<Widget>[
                        const SizedBox(height: 10),
                        _LinkedFundPreview(fund: widget.selectedFund!),
                      ],
                      _SelectedImageStrip(
                        imageFilePaths: _imageFilePaths,
                        onRemove: (int index) {
                          setState(() {
                            _imageFilePaths.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _ComposeDock(
                  addImageLabel: widget.addImageLabel,
                  linkedFundLabel: widget.linkedFundLabel,
                  imageCounter: widget.imageCounterBuilder(
                    _imageFilePaths.length,
                  ),
                  canAddImage: _imageFilePaths.length < _maxImages,
                  onAddImage: _addImage,
                  onPickFund: widget.onPickFund,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KizunarkReplyComposeSheet extends StatefulWidget {
  const _KizunarkReplyComposeSheet({
    required this.title,
    required this.closeLabel,
    required this.submitLabel,
    required this.placeholder,
    required this.currentUser,
    required this.avatarSeed,
    required this.authorLabel,
    required this.targetLabel,
    required this.targetName,
    required this.targetBody,
    required this.addImageLabel,
    required this.imageCounterBuilder,
    required this.controller,
    required this.onChanged,
    required this.onPickImage,
    required this.onSubmit,
  });

  final String title;
  final String closeLabel;
  final String submitLabel;
  final String placeholder;
  final AuthUser? currentUser;
  final int? avatarSeed;
  final String authorLabel;
  final String targetLabel;
  final String targetName;
  final String targetBody;
  final String addImageLabel;
  final String Function(int count) imageCounterBuilder;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Future<String?> Function() onPickImage;
  final Future<bool> Function(List<String> imageFilePaths) onSubmit;

  @override
  State<_KizunarkReplyComposeSheet> createState() =>
      _KizunarkReplyComposeSheetState();
}

class _KizunarkReplyComposeSheetState
    extends State<_KizunarkReplyComposeSheet> {
  static const int _maxImages = 4;
  final List<String> _imageFilePaths = <String>[];
  bool _isSubmitting = false;

  Future<void> _addImage() async {
    if (_imageFilePaths.length >= _maxImages) {
      return;
    }
    final path = await widget.onPickImage();
    if (!mounted || path == null || path.isEmpty) {
      return;
    }
    setState(() {
      _imageFilePaths.add(path);
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    final shouldClose = await widget.onSubmit(List<String>.of(_imageFilePaths));
    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
    });
    if (shouldClose) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.92;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: height,
          child: Material(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                _ComposeSheetHeader(
                  title: widget.title,
                  closeLabel: widget.closeLabel,
                  submitLabel: widget.submitLabel,
                  isSubmitting: _isSubmitting,
                  onClose: () => Navigator.of(context).pop(),
                  onSubmit: _submit,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    children: <Widget>[
                      _ComposeAuthorRow(
                        avatarUrl: widget.currentUser?.avatar,
                        avatarSeed: widget.avatarSeed,
                        label: widget.authorLabel,
                      ),
                      const SizedBox(height: 14),
                      _ReplyTargetPreview(
                        label: widget.targetLabel,
                        name: widget.targetName,
                        body: widget.targetBody,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: widget.controller,
                        autofocus: true,
                        minLines: 5,
                        maxLines: 9,
                        onChanged: widget.onChanged,
                        style: appText.inputText.copyWith(
                          color: colors.textPrimary,
                          height: 1.55,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.placeholder,
                          border: InputBorder.none,
                        ),
                      ),
                      _SelectedImageStrip(
                        imageFilePaths: _imageFilePaths,
                        onRemove: (int index) {
                          setState(() {
                            _imageFilePaths.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _ComposeDock(
                  addImageLabel: widget.addImageLabel,
                  imageCounter: widget.imageCounterBuilder(
                    _imageFilePaths.length,
                  ),
                  canAddImage: _imageFilePaths.length < _maxImages,
                  onAddImage: _addImage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposeSheetHeader extends StatelessWidget {
  const _ComposeSheetHeader({
    required this.title,
    required this.closeLabel,
    required this.submitLabel,
    required this.isSubmitting,
    required this.onClose,
    required this.onSubmit,
  });

  final String title;
  final String closeLabel;
  final String submitLabel;
  final bool isSubmitting;
  final VoidCallback onClose;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSoft)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
        child: Row(
          children: <Widget>[
            TextButton(onPressed: onClose, child: Text(closeLabel)),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: appText.bodyStrong.copyWith(color: colors.textPrimary),
              ),
            ),
            FilledButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: FilledButton.styleFrom(
                minimumSize: const Size(64, 36),
                maximumSize: const Size(120, 40),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: Text(submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposeAuthorRow extends StatelessWidget {
  const _ComposeAuthorRow({
    required this.avatarUrl,
    required this.avatarSeed,
    required this.label,
  });

  final String? avatarUrl;
  final int? avatarSeed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Row(
      children: <Widget>[
        AppUserAvatar(avatarUrl: avatarUrl, avatarSeed: avatarSeed, size: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: appText.bodyStrong.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _ComposeDock extends StatelessWidget {
  const _ComposeDock({
    required this.addImageLabel,
    required this.imageCounter,
    required this.canAddImage,
    required this.onAddImage,
    this.linkedFundLabel,
    this.onPickFund,
  });

  final String addImageLabel;
  final String? linkedFundLabel;
  final String imageCounter;
  final bool canAddImage;
  final VoidCallback onAddImage;
  final VoidCallback? onPickFund;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderSoft)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Row(
            children: <Widget>[
              if (linkedFundLabel != null && onPickFund != null) ...<Widget>[
                OutlinedButton.icon(
                  onPressed: onPickFund,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    maximumSize: const Size(180, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  label: Text(
                    linkedFundLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              OutlinedButton.icon(
                onPressed: canAddImage ? onAddImage : null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  maximumSize: const Size(140, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.image_outlined),
                label: Text(
                  addImageLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Text(
                imageCounter,
                style: appText.meta.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedImageStrip extends StatelessWidget {
  const _SelectedImageStrip({
    required this.imageFilePaths,
    required this.onRemove,
  });

  final List<String> imageFilePaths;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    if (imageFilePaths.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageFilePaths.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(imageFilePaths[index]),
                  width: 82,
                  height: 82,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: colors.surfaceAlt,
                    child: const SizedBox(width: 82, height: 82),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: colors.scrim.withValues(alpha: 0.72),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => onRemove(index),
                    child: Icon(Icons.close, size: 18, color: colors.onDark),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LinkedFundPreview extends StatelessWidget {
  const _LinkedFundPreview({required this.fund});

  final _SelectedComposerFund fund;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primarySoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          fund.projectName,
          style: appText.bodyStrong.copyWith(color: colors.primary),
        ),
      ),
    );
  }
}

class _ReplyTargetPreview extends StatelessWidget {
  const _ReplyTargetPreview({
    required this.label,
    required this.name,
    required this.body,
  });

  final String label;
  final String name;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.warningSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: appText.meta.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: appText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: appText.body.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _KizunarkGuestPrompt extends StatelessWidget {
  const _KizunarkGuestPrompt({
    required this.message,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  final String message;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message,
              style: appText.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: <Widget>[
                TextButton(onPressed: onLoginTap, child: Text(l10n.loginTitle)),
                TextButton(
                  onPressed: onRegisterTap,
                  child: Text(l10n.loginCreateAccount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerFundPickerSheet extends ConsumerStatefulWidget {
  const _ComposerFundPickerSheet({required this.currentSelection});

  final _SelectedComposerFund? currentSelection;

  @override
  ConsumerState<_ComposerFundPickerSheet> createState() =>
      _ComposerFundPickerSheetState();
}

class _ComposerFundPickerSheetState
    extends ConsumerState<_ComposerFundPickerSheet> {
  static const int _pageSize = 20;
  static const double _cardScrollExtent = 166;
  static const List<MyPageActiveFundFilter> _filters = <MyPageActiveFundFilter>[
    MyPageActiveFundFilter.all,
    MyPageActiveFundFilter.open,
    MyPageActiveFundFilter.operating,
    MyPageActiveFundFilter.ended,
  ];

  final ScrollController _scrollController = ScrollController();
  final List<MyPageInvestmentRecord> _records = <MyPageInvestmentRecord>[];
  MyPageActiveFundFilter _selectedFilter = MyPageActiveFundFilter.all;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _error;
  int _nextPage = 1;
  int _loadGeneration = 0;
  String? _lastAutoScrolledProjectId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients ||
        _isInitialLoading ||
        _isLoadingMore ||
        !_hasMore) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _loadNextPage();
    }
  }

  void _scheduleScrollToSelected(
    List<MyPageInvestmentRecord> records,
    _SelectedComposerFund? selection,
  ) {
    final projectId = selection?.projectId;
    if (projectId == null || projectId.isEmpty) {
      return;
    }
    final selectionKey = selection?.selectionKey ?? '';
    final scrollKey = selectionKey.isNotEmpty ? selectionKey : projectId;
    if (_lastAutoScrolledProjectId == scrollKey) {
      return;
    }
    final selectedIndex = records.indexWhere((record) {
      if (selectionKey.isEmpty) {
        return record.projectId == projectId;
      }
      return _selectionKeyForRecord(record) == selectionKey;
    });
    if (selectedIndex < 0) {
      return;
    }
    _lastAutoScrolledProjectId = scrollKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      final position = _scrollController.position;
      final targetOffset = (selectedIndex * _cardScrollExtent).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  List<MyPageInvestmentRecord> get _filteredRecords {
    return filterInvestmentRecordsByActiveFundFilter(_records, _selectedFilter);
  }

  String _selectionKeyForRecord(MyPageInvestmentRecord record) {
    final recordIndex = _records.indexOf(record);
    final safeIndex = recordIndex < 0 ? 0 : recordIndex;
    final parts = <String>[
      record.projectId,
      record.processId ?? '',
      record.investorCode ?? '',
      record.createTime ?? '',
      record.status?.toString() ?? '',
      record.projectStatus?.toString() ?? '',
      record.investNum?.toString() ?? '',
      record.investMoney?.toString() ?? '',
      safeIndex.toString(),
    ];
    return parts.join('::');
  }

  bool _isRecordSelected(
    List<MyPageInvestmentRecord> records,
    MyPageInvestmentRecord record,
    int visibleIndex,
  ) {
    final selection = widget.currentSelection;
    if (selection == null || selection.isClearSelection) {
      return false;
    }
    if (selection.selectionKey.isNotEmpty) {
      return _selectionKeyForRecord(record) == selection.selectionKey;
    }
    return record.projectId == selection.projectId &&
        records.indexWhere((item) => item.projectId == selection.projectId) ==
            visibleIndex;
  }

  Future<void> _loadInitial({bool preserveContent = false}) async {
    final requestGeneration = ++_loadGeneration;
    final shouldPreserveContent = preserveContent && _records.isNotEmpty;
    setState(() {
      _isInitialLoading = !shouldPreserveContent;
      _isLoadingMore = shouldPreserveContent;
      _hasMore = true;
      _error = null;
      _nextPage = 1;
      if (!shouldPreserveContent) {
        _records.clear();
        _lastAutoScrolledProjectId = null;
      }
    });

    try {
      final records = await ref
          .read(fetchMyPageInvestmentListUseCaseProvider)
          .call(startPage: 1, limit: _pageSize);
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _records
          ..clear()
          ..addAll(records);
        _nextPage = 2;
        _hasMore = records.length >= _pageSize;
        _error = null;
        _isInitialLoading = false;
        _isLoadingMore = false;
        _lastAutoScrolledProjectId = null;
      });
      await _loadNextPageIfFilterHasNoVisibleRecords();
    } catch (error) {
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }
    final requestGeneration = _loadGeneration;
    setState(() {
      _isLoadingMore = true;
      _error = null;
    });

    try {
      final records = await ref
          .read(fetchMyPageInvestmentListUseCaseProvider)
          .call(startPage: _nextPage, limit: _pageSize);
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _records.addAll(records);
        _nextPage += 1;
        _hasMore = records.length >= _pageSize;
        _error = null;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
      await _loadNextPageIfFilterHasNoVisibleRecords();
    } catch (error) {
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadNextPageIfFilterHasNoVisibleRecords() async {
    if (!mounted ||
        _filteredRecords.isNotEmpty ||
        !_hasMore ||
        _isLoadingMore) {
      return;
    }
    await _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = mediaQuery.size.height * 0.8;
    final fundProjects =
        ref.watch(fundProjectListProvider).valueOrNull ?? const <FundProject>[];
    final fundProjectsById = <String, FundProject>{
      for (final project in fundProjects) project.id: project,
    };

    return SizedBox(
      height: sheetHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.kizunarkAssociateFundSheetTitle,
            style: appText.sectionTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          AppFilterBar<MyPageActiveFundFilter>(
            value: _selectedFilter,
            onChanged: (MyPageActiveFundFilter value) {
              if (_selectedFilter == value) {
                return;
              }
              setState(() {
                _selectedFilter = value;
                _lastAutoScrolledProjectId = null;
              });
              _loadNextPageIfFilterHasNoVisibleRecords();
            },
            backgroundColor: colors.surface,
            borderRadius: BorderRadius.circular(999),
            padding: EdgeInsets.zero,
            selectedBackgroundColor: colors.primary,
            selectedForegroundColor: colors.onDark,
            unselectedBackgroundColor: colors.surfaceAlt,
            unselectedForegroundColor: colors.textSecondary,
            borderColor: colors.border,
            items: _filters
                .map(
                  (filter) => AppFilterBarItem<MyPageActiveFundFilter>(
                    value: filter,
                    label: resolveMyPageActiveFundFilterLabel(l10n, filter),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: _buildFundListContent(
              context,
              sheetHeight: sheetHeight,
              fundProjectsById: fundProjectsById,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundListContent(
    BuildContext context, {
    required double sheetHeight,
    required Map<String, FundProject> fundProjectsById,
  }) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final currencyFormatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final displayRecords = _filteredRecords;
    _scheduleScrollToSelected(displayRecords, widget.currentSelection);

    if (_isInitialLoading && displayRecords.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (_error != null && displayRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                l10n.myPageSectionLoadError,
                textAlign: TextAlign.center,
                style: appText.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => _loadInitial(preserveContent: true),
                child: Text(l10n.fundListRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (displayRecords.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadInitial(preserveContent: true),
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: sheetHeight * 0.48,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  child: Text(
                    resolveMyPageActiveFundEmptyState(l10n, _selectedFilter),
                    textAlign: TextAlign.center,
                    style: appText.body.copyWith(color: colors.textSecondary),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadInitial(preserveContent: true),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            displayRecords.length +
            ((_isLoadingMore || (_error != null && _records.isNotEmpty))
                ? 1
                : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (BuildContext context, int index) {
          if (index >= displayRecords.length) {
            if (_isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Center(
                child: OutlinedButton(
                  onPressed: _loadNextPage,
                  child: Text(l10n.fundListRetry),
                ),
              ),
            );
          }

          final record = displayRecords[index];
          final selectionKey = _selectionKeyForRecord(record);
          final group = investmentRecordToGroup(record);
          final project = fundProjectsById[record.projectId];
          final status = project?.projectStatus ?? record.projectStatus;
          final periodText = formatMyPageActiveFundPeriod(context, project);
          final investorTypeDisplay = resolveInvestorTypeDisplayText(
            l10n,
            record.investorType,
            fallbackInvestorCode: record.investorCode,
            fallbackEarningType: group.earningType,
            fallbackEarningRatio: group.earningRatio,
          );
          final isSelected = _isRecordSelected(displayRecords, record, index);
          return _ComposerFundPickerCard(
            data: MyPageActiveFundSummaryCardData(
              title: group.projectName,
              periodText: periodText != null
                  ? '${l10n.fundListPeriodLabel}：$periodText'
                  : l10n.myPageResultAnnouncementTbd,
              investorCode: investorTypeDisplay.investorCode,
              investorType: investorTypeDisplay.investorType,
              returnText: investorTypeDisplay.returnText,
              investmentAmountLabel: l10n.myPageInvestmentAmountLabel,
              investmentAmountValue: formatCurrency(
                group.investMoney,
                currencyFormatter,
              ),
              accumulatedEarningsLabel: l10n.myPageAccumulatedDistributionLabel,
              accumulatedEarningsValue: formatCurrency(
                group.earnings,
                currencyFormatter,
              ),
              statusLabel: resolveMyPageActiveFundStatusLabel(l10n, status),
              statusBackgroundColor:
                  resolveMyPageActiveFundStatusBackgroundColor(context, status),
              statusForegroundColor:
                  resolveMyPageActiveFundStatusForegroundColor(context, status),
              progress: resolveMyPageActiveFundProgress(project),
              imageUrls: project?.photos ?? const <String>[],
              onTap: () {
                Navigator.of(context).pop(
                  isSelected
                      ? const _SelectedComposerFund.clear()
                      : _SelectedComposerFund(
                          projectId: record.projectId,
                          projectName: record.projectName,
                          selectionKey: selectionKey,
                        ),
                );
              },
            ),
            isSelected: isSelected,
          );
        },
      ),
    );
  }
}

class _ComposerFundPickerCard extends StatelessWidget {
  const _ComposerFundPickerCard({required this.data, required this.isSelected});

  final MyPageActiveFundSummaryCardData data;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Stack(
      children: <Widget>[
        MyPageActiveFundSummaryCard(data: data, shadowPadding: EdgeInsets.zero),
        if (isSelected)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(UiTokens.radius12),
                  border: Border.all(color: colors.primary, width: 2),
                ),
              ),
            ),
          ),
        if (isSelected)
          Positioned(
            top: 10,
            right: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: colors.onDark,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SelectedComposerFund {
  const _SelectedComposerFund({
    required this.projectId,
    required this.projectName,
    required this.selectionKey,
  });

  const _SelectedComposerFund.clear()
    : projectId = '',
      projectName = '',
      selectionKey = '';

  final String projectId;
  final String projectName;
  final String selectionKey;

  bool get isClearSelection => projectId.isEmpty;
}
