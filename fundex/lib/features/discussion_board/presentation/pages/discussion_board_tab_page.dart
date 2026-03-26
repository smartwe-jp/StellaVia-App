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
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
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
  _SelectedComposerFund? _selectedComposerFund;

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
      user?.firstName ?? '',
      user?.username ?? '',
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
      linkedProjectId: int.tryParse(_selectedComposerFund?.projectId ?? ''),
      linkedProjectName: _selectedComposerFund?.projectName,
    );
    if (submitted && mounted) {
      setState(() {
        _selectedComposerFund = null;
      });
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

  void _openLinkedFundDetail(String? projectId) {
    final normalized = projectId?.trim() ?? '';
    if (normalized.isEmpty) {
      return;
    }
    context.go('/funds/$normalized');
  }

  Future<void> _showComposerFundPicker() async {
    final selectedFund =
        await AppBottomSheet.showAdaptive<_SelectedComposerFund>(
          context: context,
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
                          footerLeading: Align(
                            alignment: Alignment.centerLeft,
                            child: _ComposerFundPickerButton(
                              fundName: _selectedComposerFund?.projectName,
                              onTap: _showComposerFundPicker,
                            ),
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
                      onTap: () =>
                          _openLinkedFundDetail(thread.fundReferenceId),
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

class _ComposerFundPickerButton extends StatelessWidget {
  const _ComposerFundPickerButton({
    required this.fundName,
    required this.onTap,
  });

  final String? fundName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final label = (fundName?.trim().isNotEmpty ?? false)
        ? fundName!.trim()
        : context.l10n.kizunarkAssociateFundAction;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220, minHeight: 36),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.primarySubtle,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.primarySoft),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 16,
                  color: colors.primary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appText.chip.copyWith(color: colors.primary),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 16,
                  color: colors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposerFundPickerSheet extends ConsumerStatefulWidget {
  const _ComposerFundPickerSheet({required this.currentSelection});

  static const double _mainShellTabBarHeight = 61;

  final _SelectedComposerFund? currentSelection;

  @override
  ConsumerState<_ComposerFundPickerSheet> createState() =>
      _ComposerFundPickerSheetState();
}

class _ComposerFundPickerSheetState
    extends ConsumerState<_ComposerFundPickerSheet> {
  final Map<String, GlobalKey> _itemKeys = <String, GlobalKey>{};
  String? _lastAutoScrolledProjectId;

  GlobalKey _keyForProject(String projectId) {
    return _itemKeys.putIfAbsent(
      projectId,
      () => GlobalKey(debugLabel: 'composer-fund-$projectId'),
    );
  }

  void _scheduleScrollToSelected(
    List<_ComposerFundGroup> groups,
    String? projectId,
  ) {
    if (projectId == null || projectId.isEmpty) {
      return;
    }
    if (_lastAutoScrolledProjectId == projectId) {
      return;
    }
    if (!groups.any((group) => group.projectId == projectId)) {
      return;
    }
    _lastAutoScrolledProjectId = projectId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final targetContext = _itemKeys[projectId]?.currentContext;
      if (targetContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.18,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height -
        _ComposerFundPickerSheet._mainShellTabBarHeight -
        mediaQuery.padding.bottom;
    final sheetHeight = availableHeight * 0.5;

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
          Flexible(
            child: ref
                .watch(myPageInvestmentListProvider)
                .when(
                  data: (records) {
                    final groups = _groupComposerFundRecords(records);
                    _scheduleScrollToSelected(
                      groups,
                      widget.currentSelection?.projectId,
                    );
                    if (groups.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 24,
                          ),
                          child: Text(
                            l10n.kizunarkAssociateFundEmpty,
                            textAlign: TextAlign.center,
                            style: appText.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }

                    final currencyFormatter = NumberFormat.currency(
                      locale: Localizations.localeOf(context).toLanguageTag(),
                      symbol: '¥',
                      decimalDigits: 0,
                    );

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: groups.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final group = groups[index];
                        final isSelected =
                            widget.currentSelection?.projectId ==
                            group.projectId;
                        return _ComposerFundPickerCard(
                          key: _keyForProject(group.projectId),
                          data: FundActiveFundCardData(
                            title: group.projectName,
                            annualYield: _formatYieldPercent(
                              group.earningRatio,
                            ),
                            rows: <FundLabeledValue>[
                              FundLabeledValue(
                                label: l10n.myPageInvestmentAmountLabel,
                                value: currencyFormatter.format(
                                  group.investMoney,
                                ),
                              ),
                              FundLabeledValue(
                                label: l10n.myPageAccumulatedDistributionLabel,
                                value: currencyFormatter.format(group.earnings),
                                valueColor: colors.success,
                              ),
                            ],
                          ),
                          isSelected: isSelected,
                          onTap: () {
                            Navigator.of(context).pop(
                              isSelected
                                  ? const _SelectedComposerFund.clear()
                                  : _SelectedComposerFund(
                                      projectId: group.projectId,
                                      projectName: group.projectName,
                                    ),
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            l10n.myPageSectionLoadError,
                            textAlign: TextAlign.center,
                            style: appText.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () =>
                                ref.invalidate(myPageInvestmentListProvider),
                            child: Text(l10n.fundListRetry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _ComposerFundPickerCard extends StatelessWidget {
  const _ComposerFundPickerCard({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final FundActiveFundCardData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        children: <Widget>[
          FundActiveFundCard(
            data: FundActiveFundCardData(
              title: data.title,
              annualYield: data.annualYield,
              rows: data.rows,
              onTap: onTap,
            ),
            shadowPadding: EdgeInsets.zero,
          ),
          if (isSelected)
            Positioned(
              top: 12,
              right: 12,
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
      ),
    );
  }
}

List<_ComposerFundGroup> _groupComposerFundRecords(
  List<MyPageInvestmentRecord> records,
) {
  final operatingRecords = records
      .where((record) => record.projectStatus == 4)
      .toList(growable: false);
  final source = operatingRecords.isEmpty ? records : operatingRecords;
  final sorted = [...source]
    ..sort((a, b) => _compareComposerDateDesc(a.createTime, b.createTime));

  final groups = <String, _ComposerFundGroupAccumulator>{};
  for (final record in sorted) {
    groups.putIfAbsent(
      record.projectId,
      () => _ComposerFundGroupAccumulator(record),
    );
    groups[record.projectId]!.add(record);
  }

  final values = groups.values
      .map((accumulator) => accumulator.build())
      .toList(growable: false);
  values.sort(
    (a, b) =>
        _compareComposerDateTimeDesc(a.latestCreateTime, b.latestCreateTime),
  );
  return values;
}

String _formatYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

DateTime? _parseComposerApiDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }

  final value = raw.trim();
  for (final pattern in <String>['yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd']) {
    try {
      return DateFormat(pattern).parseStrict(value);
    } catch (_) {
      continue;
    }
  }
  return DateTime.tryParse(value);
}

int _compareComposerDateDesc(String? left, String? right) {
  return _compareComposerDateTimeDesc(
    _parseComposerApiDate(left),
    _parseComposerApiDate(right),
  );
}

int _compareComposerDateTimeDesc(DateTime? left, DateTime? right) {
  if (left == null && right == null) {
    return 0;
  }
  if (left == null) {
    return 1;
  }
  if (right == null) {
    return -1;
  }
  return right.compareTo(left);
}

class _SelectedComposerFund {
  const _SelectedComposerFund({
    required this.projectId,
    required this.projectName,
  });

  const _SelectedComposerFund.clear() : projectId = '', projectName = '';

  final String projectId;
  final String projectName;

  bool get isClearSelection => projectId.isEmpty;
}

class _ComposerFundGroup {
  const _ComposerFundGroup({
    required this.projectId,
    required this.projectName,
    required this.investMoney,
    required this.earnings,
    required this.earningRatio,
    required this.latestCreateTime,
  });

  final String projectId;
  final String projectName;
  final num investMoney;
  final num earnings;
  final double? earningRatio;
  final DateTime? latestCreateTime;
}

class _ComposerFundGroupAccumulator {
  _ComposerFundGroupAccumulator(MyPageInvestmentRecord seed)
    : projectId = seed.projectId,
      projectName = seed.projectName,
      investMoney = seed.investMoney ?? 0,
      earnings = seed.earnings ?? 0,
      latestCreateTime = _parseComposerApiDate(seed.createTime),
      earningRatio = seed.earningRadio ?? seed.investorType?.earningsRadio;

  final String projectId;
  final String projectName;
  num investMoney;
  num earnings;
  double? earningRatio;
  DateTime? latestCreateTime;

  void add(MyPageInvestmentRecord record) {
    investMoney += record.investMoney ?? 0;
    earnings += record.earnings ?? 0;
    earningRatio ??= record.earningRadio ?? record.investorType?.earningsRadio;
    final candidateDate = _parseComposerApiDate(record.createTime);
    if (_compareComposerDateTimeDesc(latestCreateTime, candidateDate) > 0) {
      latestCreateTime = candidateDate;
    }
  }

  _ComposerFundGroup build() {
    return _ComposerFundGroup(
      projectId: projectId,
      projectName: projectName,
      investMoney: investMoney,
      earnings: earnings,
      earningRatio: earningRatio,
      latestCreateTime: latestCreateTime,
    );
  }
}
