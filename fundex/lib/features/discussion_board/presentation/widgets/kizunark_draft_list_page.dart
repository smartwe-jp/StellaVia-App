import 'dart:io';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/discussion_board_draft.dart';
import '../providers/discussion_board_providers.dart';

class KizunarkDraftListRouteArgs {
  const KizunarkDraftListRouteArgs({required this.kind});

  final DiscussionDraftKind kind;
}

class KizunarkDraftListPage extends ConsumerWidget {
  const KizunarkDraftListPage({required this.kind, super.key});

  final DiscussionDraftKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;
    final draftsAsync = ref.watch(discussionBoardDraftsProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.kizunarkDraftListTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: draftsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _DraftEmptyState(message: l10n.kizunarkDraftLoadError),
        data: (drafts) {
          final visibleDrafts = drafts
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
                onTap: () {
                  context.pop(draft);
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
      ),
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
  final VoidCallback onTap;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;
    return Dismissible(
      key: ValueKey<String>(draft.id),
      direction: DismissDirection.endToStart,
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
      onDismissed: (_) => onDelete(),
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
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
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
                child: Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: appText.sectionTitle.copyWith(
                    color: colors.textSecondary,
                  ),
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

class _DraftImagePreview extends StatelessWidget {
  const _DraftImagePreview({required this.imageFilePaths});

  final List<String> imageFilePaths;

  @override
  Widget build(BuildContext context) {
    final normalized = imageFilePaths
        .where((path) => path.trim().isNotEmpty)
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
