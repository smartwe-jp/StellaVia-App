import 'dart:io';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/discussion_board_draft.dart';
import '../providers/discussion_board_providers.dart';

class KizunarkDraftListRouteArgs {
  const KizunarkDraftListRouteArgs({this.kind});

  final DiscussionDraftKind? kind;
}

class KizunarkDraftListPage extends ConsumerWidget {
  const KizunarkDraftListPage({this.kind, super.key});

  final DiscussionDraftKind? kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.kizunarkDraftListTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: _DraftListBody(
        kind: kind,
        onSelected: (DiscussionBoardDraft draft) => context.pop(draft),
      ),
    );
  }
}

class KizunarkDraftListSheet extends StatelessWidget {
  const KizunarkDraftListSheet({this.kind, super.key});

  final DiscussionDraftKind? kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: ColoredBox(
        color: colors.surface,
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.commonCancel),
                      ),
                    ),
                    Text(
                      l10n.kizunarkDraftListTitle,
                      style: appText.sectionTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: colors.borderSoft),
              Expanded(
                child: _DraftListBody(
                  kind: kind,
                  onSelected: (DiscussionBoardDraft draft) =>
                      Navigator.of(context).pop(draft),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftListBody extends ConsumerWidget {
  const _DraftListBody({required this.kind, required this.onSelected});

  final DiscussionDraftKind? kind;
  final ValueChanged<DiscussionBoardDraft> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draftsAsync = ref.watch(discussionBoardDraftsProvider);
    return draftsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _DraftEmptyState(message: l10n.kizunarkDraftLoadError),
      data: (drafts) {
        final visibleDrafts = kind == null
            ? drafts
            : drafts
                  .where((draft) => draft.kind == kind)
                  .toList(growable: false);
        if (visibleDrafts.isEmpty) {
          return _DraftEmptyState(message: l10n.kizunarkDraftEmptyState);
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          itemBuilder: (BuildContext context, int index) {
            final draft = visibleDrafts[index];
            return _DraftDismissibleTile(
              draft: draft,
              onTap: () async {
                await ref
                    .read(discussionBoardDraftLocalDataSourceProvider)
                    .deleteDraft(draft.id);
                ref.invalidate(discussionBoardDraftsProvider);
                if (!context.mounted) {
                  return;
                }
                onSelected(draft);
              },
              onDelete: () async {
                await ref
                    .read(discussionBoardDraftLocalDataSourceProvider)
                    .deleteDraft(draft.id);
                ref.invalidate(discussionBoardDraftsProvider);
              },
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemCount: visibleDrafts.length,
        );
      },
    );
  }
}

class _DraftEmptyState extends StatelessWidget {
  const _DraftEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: appText.body.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}

class _DraftDismissibleTile extends StatelessWidget {
  const _DraftDismissibleTile({
    required this.draft,
    required this.onTap,
    required this.onDelete,
  });

  final DiscussionBoardDraft draft;
  final Future<void> Function() onTap;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;
    return Dismissible(
      key: ValueKey<String>(draft.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
          context: context,
          title: l10n.kizunarkDraftDeleteConfirmTitle,
          message: l10n.kizunarkDraftDeleteConfirmBody,
          actions: <AppDialogAction<bool>>[
            AppDialogAction<bool>(label: l10n.commonCancel, value: false),
            AppDialogAction<bool>(
              label: l10n.kizunarkDraftDeleteAction,
              value: true,
              isDestructive: true,
            ),
          ],
        );
        if (confirmed == true) {
          await onDelete();
        }
        return false;
      },
      background: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.danger,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              l10n.kizunarkDraftDeleteAction,
              style: Theme.of(
                context,
              ).appTextTheme.bodyStrong.copyWith(color: colors.onDark),
            ),
          ),
        ),
      ),
      child: _DraftTile(draft: draft, onTap: onTap),
    );
  }
}

class _DraftTile extends StatelessWidget {
  const _DraftTile({required this.draft, required this.onTap});

  final DiscussionBoardDraft draft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final text = draft.content.trim().isEmpty
        ? context.l10n.kizunarkDraftImageOnlyLabel
        : draft.content.trim();
    final replyTargetName = draft.replyTargetName?.trim() ?? '';
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 96),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (draft.kind == DiscussionDraftKind.reply &&
                        replyTargetName.isNotEmpty)
                      _DraftReplyTargetLabel(targetName: replyTargetName)
                    else
                      Icon(
                        Icons.edit_calendar,
                        size: 22,
                        color: colors.textTertiary,
                      ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: appText.sectionTitle.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (draft.imageFilePaths.isNotEmpty) ...<Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _DraftImagePreview(
                      imageFilePaths: draft.imageFilePaths,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftReplyTargetLabel extends StatelessWidget {
  const _DraftReplyTargetLabel({required this.targetName});

  final String targetName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Row(
      children: <Widget>[
        Icon(Icons.reply_rounded, size: 16, color: colors.textTertiary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            '@$targetName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: appText.bodyStrong.copyWith(color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _DraftImagePreview extends StatelessWidget {
  const _DraftImagePreview({required this.imageFilePaths});

  final List<String> imageFilePaths;

  @override
  Widget build(BuildContext context) {
    final normalized = imageFilePaths
        .where((path) => path.trim().isNotEmpty && File(path).existsSync())
        .take(4)
        .toList(growable: false);
    final colors = Theme.of(context).appColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.surfaceAlt),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: normalized.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.file(
              File(normalized[index]),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ColoredBox(color: colors.surfaceAlt),
            );
          },
        ),
      ),
    );
  }
}
