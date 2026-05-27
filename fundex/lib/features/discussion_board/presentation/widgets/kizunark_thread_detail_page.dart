import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../main_shell/presentation/widgets/main_shell_chrome_visibility.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../providers/discussion_board_providers.dart';
import '../support/discussion_board_time_label.dart';

class KizunarkThreadDetailRouteArgs {
  const KizunarkThreadDetailRouteArgs({
    required this.thread,
    required this.isAuthenticated,
    required this.currentUserId,
    required this.onOpenImageViewer,
    required this.onReply,
    required this.onMessageLongPress,
  });

  final DiscussionThread thread;
  final bool isAuthenticated;
  final String currentUserId;
  final Future<void> Function(List<String> imageUrls, int index)
  onOpenImageViewer;
  final VoidCallback onReply;
  final Future<void> Function({
    required String commentId,
    required String messageBody,
    required bool canDelete,
    required bool isDeleting,
  })
  onMessageLongPress;
}

class KizunarkThreadDetailPage extends ConsumerWidget {
  const KizunarkThreadDetailPage({
    required this.thread,
    required this.isAuthenticated,
    required this.currentUserId,
    required this.onOpenImageViewer,
    required this.onReply,
    required this.onMessageLongPress,
    super.key,
  });

  final DiscussionThread thread;
  final bool isAuthenticated;
  final String currentUserId;
  final Future<void> Function(List<String> imageUrls, int index)
  onOpenImageViewer;
  final VoidCallback onReply;
  final Future<void> Function({
    required String commentId,
    required String messageBody,
    required bool canDelete,
    required bool isDeleting,
  })
  onMessageLongPress;

  void _openLinkedFundDetail(BuildContext context, String? projectId) {
    final normalized = projectId?.trim() ?? '';
    if (normalized.isEmpty) {
      return;
    }
    context.push('/funds/$normalized');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(discussionBoardControllerProvider(null));
    final liveThread = state.threads.firstWhere(
      (item) => item.id == thread.id,
      orElse: () => thread,
    );
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: <Widget>[
          MainShellChromeVisibility(
            child: AppNavigationBar(
              title: l10n.kizunarkRepliesTitle(liveThread.replies.length),
              backgroundColor: colors.surface,
              foregroundColor: colors.textPrimary,
              leading: AppNavigationIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => context.pop(),
                backgroundColor: colors.surface.withValues(alpha: 0),
                foregroundColor: colors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 96),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: KizunarkPostCard(
                    key: ValueKey<String>('discussion-thread-${liveThread.id}'),
                    avatar: AppUserAvatar(
                      avatarUrl: liveThread.author.avatarUrl,
                      gradientColorValues:
                          liveThread.author.avatarGradientColorValues,
                      size: 32,
                      fontSize: 12,
                    ),
                    displayName: liveThread.author.displayName,
                    accountText: liveThread.author.accountHandle,
                    badgeLabel: liveThread.author.badge.label,
                    badgeBackgroundColor: Color(
                      liveThread.author.badge.backgroundColorValue,
                    ),
                    badgeForegroundColor: Color(
                      liveThread.author.badge.foregroundColorValue,
                    ),
                    timeLabel: buildDiscussionBoardTimeLabel(
                      context,
                      createdAtIso: liveThread.createdAtIso,
                      fallbackLabel: liveThread.timeLabel,
                    ),
                    body: liveThread.body,
                    imageUrls: liveThread.imageUrls,
                    onImageTap: (int index) =>
                        onOpenImageViewer(liveThread.imageUrls, index),
                    fundReferenceChip: liveThread.fundReferenceLabel == null
                        ? null
                        : KizunarkFundReferenceChip(
                            label: liveThread.fundReferenceLabel!,
                            onTap: () => _openLinkedFundDetail(
                              context,
                              liveThread.fundReferenceId,
                            ),
                          ),
                    commentCount: liveThread.commentCount,
                    onToggleRepliesTap: onReply,
                    showReplies: false,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.kizunarkRepliesSectionTitle,
                    style: appText.bodyStrong.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...liveThread.replies.map((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KizunarkReplyTile(
                      key: ValueKey<String>('discussion-reply-${reply.id}'),
                      avatar: AppUserAvatar(
                        avatarUrl: reply.author.avatarUrl,
                        gradientColorValues:
                            reply.author.avatarGradientColorValues,
                        size: 28,
                        fontSize: 11,
                      ),
                      displayName: reply.author.displayName,
                      timeLabel: buildDiscussionBoardTimeLabel(
                        context,
                        createdAtIso: reply.createdAtIso,
                        fallbackLabel: reply.timeLabel,
                      ),
                      body: reply.body,
                      imageUrls: reply.imageUrls,
                      onImageTap: (int index) =>
                          onOpenImageViewer(reply.imageUrls, index),
                      onLongPress: () => onMessageLongPress(
                        commentId: reply.id,
                        messageBody: reply.body,
                        canDelete:
                            reply.author.id == currentUserId &&
                            currentUserId.isNotEmpty,
                        isDeleting: state.deletingCommentIds.contains(reply.id),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: FilledButton(
            onPressed: isAuthenticated ? onReply : null,
            child: Text(l10n.kizunarkWriteReplyAction),
          ),
        ),
      ),
    );
  }
}
