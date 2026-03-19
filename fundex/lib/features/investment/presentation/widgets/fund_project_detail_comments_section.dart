import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/domain/utils/auth_utils.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../discussion_board/presentation/controllers/discussion_board_controller.dart';
import '../../../discussion_board/presentation/providers/discussion_board_providers.dart';
import '../../../discussion_board/presentation/widgets/discussion_board_thread_list.dart';
import '../../../../l10n/app_localizations.dart';

class FundProjectDetailCommentsSection extends ConsumerStatefulWidget {
  const FundProjectDetailCommentsSection({
    super.key,
    required this.projectId,
    this.onViewMoreTap,
  });

  final int? projectId;
  final VoidCallback? onViewMoreTap;

  @override
  ConsumerState<FundProjectDetailCommentsSection> createState() =>
      _FundProjectDetailCommentsSectionState();
}

class _FundProjectDetailCommentsSectionState
    extends ConsumerState<FundProjectDetailCommentsSection> {
  late final TextEditingController _composerController;

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  Future<void> _submitPost(
    BuildContext context,
    AppLocalizations l10n,
    DiscussionBoardController controller,
    bool isAuthenticated,
  ) async {
    if (!isAuthenticated) {
      return;
    }

    final localContext = context;
    if (!mounted) return;

    final submitted = await controller.submitPost(
      nowLabel: l10n.kizunarkJustNow,
      fallbackName: l10n.kizunarkFallbackDisplayName,
      fallbackHandle: l10n.kizunarkFallbackHandle,
      fallbackBadgeLabel: l10n.kizunarkInvestorBadge,
    );

    if (submitted) {
      // ignore: use_build_context_synchronously
      AppNotice.show(localContext, message: l10n.kizunarkPostSuccessNotice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final state = ref.watch(
      discussionBoardControllerProvider(widget.projectId),
    );
    final controller = ref.read(
      discussionBoardControllerProvider(widget.projectId).notifier,
    );
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;

    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      final previousValue = previous?.asData?.value;
      final nextValue = next.asData?.value;
      if (previousValue == nextValue) {
        return;
      }
      controller.handleAuthChange(previousValue ?? false, nextValue ?? false);
    });

    ref.listen<AsyncValue<AuthUser?>>(currentAuthUserProvider, (
      previous,
      next,
    ) {
      final previousId = resolveCurrentUserId(previous?.asData?.value);
      final nextId = resolveCurrentUserId(next.asData?.value);
      if (previousId == nextId) {
        return;
      }
      controller.handleUserChange(previousId, nextId);
    });

    if (_composerController.text != state.composerText) {
      _composerController.text = state.composerText;
      _composerController.selection = TextSelection.collapsed(
        offset: state.composerText.length,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DiscussionBoardThreadList(
          l10n: l10n,
          state: state,
          controller: controller,
        ),
        const SizedBox(height: 16),
        if (isAuthenticated)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: KizunarkComposerCard(
              controller: _composerController,
              placeholder: l10n.kizunarkComposePlaceholder,
              postLabel: l10n.kizunarkPostAction,
              enabled: !state.isPosting,
              onChanged: controller.updateComposerText,
              onPostTap: () =>
                  _submitPost(context, l10n, controller, isAuthenticated),
            ),
          ),
        if (widget.onViewMoreTap != null) ...<Widget>[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: widget.onViewMoreTap,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              side: BorderSide(color: colors.communityPrimary),
              foregroundColor: colors.communityPrimary,
              textStyle: appText.chip.copyWith(color: colors.communityPrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius12),
              ),
            ),
            child: Text(l10n.fundDetailCommentsMoreAction),
          ),
        ],
      ],
    );
  }
}
