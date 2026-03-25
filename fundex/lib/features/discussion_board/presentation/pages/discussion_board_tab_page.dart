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
import '../controllers/discussion_board_controller.dart';
import '../providers/discussion_board_providers.dart';
import '../state/discussion_board_state.dart';
import '../support/discussion_board_time_label.dart';

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
  final Map<String, TextEditingController> _replyControllers =
      <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
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

  String _resolveAvatarText(AuthUser? user) {
    final candidates = <String>[
      user?.lastName ?? '',
      user?.username ?? '',
      user?.firstName ?? '',
      user?.id ?? '',
    ];
    for (final candidate in candidates) {
      final text = candidate.trim();
      if (text.isNotEmpty) {
        return String.fromCharCode(text.runes.first);
      }
    }
    return '田';
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

  Future<void> _submitPost({required bool isAuthenticated}) async {
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
    );
    if (submitted && mounted) {
      AppNotice.show(context, message: l10n.kizunarkPostSuccessNotice);
    }
  }

  Future<void> _submitReply(
    String threadId, {
    required bool isAuthenticated,
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
    );
    if (submitted && mounted) {
      AppNotice.show(context, message: l10n.kizunarkReplySuccessNotice);
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: KizunarkNoticeBanner(
                    label: l10n.kizunarkInvestorOnlyNotice,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: isAuthenticated
                      ? KizunarkComposerCard(
                          leading: KizunarkAvatarBadge(
                            text: _resolveAvatarText(currentUser),
                            gradientColors: const <Color>[
                              AppColorTokens.kizunarkPrimary,
                              AppColorTokens.kizunarkSecondary,
                            ],
                            size: 32,
                            fontSize: 13,
                          ),
                          controller: _composerController,
                          placeholder: l10n.kizunarkComposePlaceholder,
                          postLabel: l10n.kizunarkPostAction,
                          enabled: !state.isPosting && isAuthenticated,
                          onChanged: controller.updateComposerText,
                          onPostTap: () =>
                              _submitPost(isAuthenticated: isAuthenticated),
                        )
                      : _KizunarkGuestPrompt(
                          message: l10n.kizunarkGuestLoginPrompt,
                          onLoginTap: () => context.push('/login'),
                          onRegisterTap: () =>
                              context.push('/login?openRegister=1'),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: _buildFeedSection(
                    l10n: l10n,
                    state: state,
                    controller: controller,
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
    required DiscussionBoardController controller,
    required bool isAuthenticated,
    required String currentUserId,
  }) {
    if (state.isLoading && state.threads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (state.threads.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColorTokens.fundexBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
            l10n.kizunarkEmptyState,
            textAlign: TextAlign.center,
            style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
                .copyWith(
                  color: AppColorTokens.fundexTextSecondary,
                  height: 1.6,
                ),
          ),
        ),
      );
    }

    final threadCards = state.threads
        .map<Widget>((thread) {
          final expanded = state.expandedThreadIds.contains(thread.id);
          final replyController = _replyControllerFor(thread.id);
          final draft = state.replyDrafts[thread.id] ?? '';
          if (replyController.text != draft) {
            replyController.value = TextEditingValue(
              text: draft,
              selection: TextSelection.collapsed(offset: draft.length),
            );
          }

          final replies = thread.replies
              .map<Widget>(
                (reply) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: KizunarkReplyTile(
                    avatar: KizunarkAvatarBadge(
                      text: reply.author.avatarText,
                      gradientColors: reply.author.avatarGradientColorValues
                          .map(Color.new)
                          .toList(growable: false),
                      size: 24,
                      fontSize: 10,
                    ),
                    displayName: reply.author.displayName,
                    timeLabel: buildDiscussionBoardTimeLabel(
                      context,
                      createdAtIso: reply.createdAtIso,
                      fallbackLabel: reply.timeLabel,
                    ),
                    body: reply.body,
                    quoteTitle: reply.quote?.sourceText,
                    quoteBody: reply.quote?.body,
                    onLongPress: () => _showMessageActionSheet(
                      commentId: reply.id,
                      messageBody: reply.body,
                      canDelete:
                          reply.author.id == currentUserId &&
                          currentUserId.isNotEmpty,
                      isDeleting: state.deletingCommentIds.contains(reply.id),
                    ),
                  ),
                ),
              )
              .toList(growable: false);

          final replySection = Column(
            children: <Widget>[
              ...replies,
              if (isAuthenticated)
                KizunarkReplyComposer(
                  controller: replyController,
                  placeholder: l10n.kizunarkReplyPlaceholder,
                  sendLabel: l10n.kizunarkReplySendAction,
                  enabled:
                      !state.replySubmittingThreadIds.contains(thread.id) &&
                      isAuthenticated,
                  onChanged: (String value) =>
                      controller.updateReplyDraft(thread.id, value),
                  onSendTap: () =>
                      _submitReply(thread.id, isAuthenticated: isAuthenticated),
                ),
            ],
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: KizunarkPostCard(
              avatar: KizunarkAvatarBadge(
                text: thread.author.avatarText,
                gradientColors: thread.author.avatarGradientColorValues
                    .map(Color.new)
                    .toList(growable: false),
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
              fundReferenceChip: thread.fundReferenceLabel == null
                  ? null
                  : KizunarkFundReferenceChip(
                      label: thread.fundReferenceLabel!,
                      onTap: () => AppNotice.show(
                        context,
                        message: thread.fundReferenceLabel!,
                      ),
                    ),
              commentCount: thread.commentCount,
              onToggleRepliesTap: () => controller.toggleReplies(thread.id),
              showReplies: expanded,
              replySection: replySection,
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
                TextButton(
                  onPressed: onLoginTap,
                  child: Text(l10n.loginTitle),
                ),
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
