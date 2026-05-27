import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/discussion_board_controller.dart';
import '../state/discussion_board_state.dart';
import '../support/discussion_board_time_label.dart';

class DiscussionBoardThreadList extends StatelessWidget {
  const DiscussionBoardThreadList({
    super.key,
    required this.l10n,
    required this.state,
    required this.controller,
  });

  final AppLocalizations l10n;
  final DiscussionBoardState state;
  final DiscussionBoardController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    if (state.isLoading && state.threads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (state.threads.isEmpty) {
      return FundDetailContentCard(
        child: Text(
          l10n.kizunarkEmptyState,
          textAlign: TextAlign.center,
          style: appText.bodyMuted.copyWith(
            color: colors.textSecondary,
            height: 1.6,
          ),
        ),
      );
    }

    return Column(
      children: state.threads
          .map<Widget>((thread) {
            final expanded = state.expandedThreadIds.contains(thread.id);

            final replies = thread.replies
                .map<Widget>(
                  (reply) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: KizunarkReplyTile(
                      key: ValueKey<String>('discussion-reply-${reply.id}'),
                      avatar: AppUserAvatar(
                        avatarUrl: reply.author.avatarUrl,
                        gradientColorValues:
                            reply.author.avatarGradientColorValues,
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
                    ),
                  ),
                )
                .toList(growable: false);

            final replySection = replies.isEmpty
                ? null
                : Column(children: replies);

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
                commentCount: thread.commentCount,
                onToggleRepliesTap: () => controller.toggleReplies(thread.id),
                showReplies: expanded,
                replySection: replySection,
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
