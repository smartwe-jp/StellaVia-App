import 'dart:async';
import 'dart:io';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/entities/discussion_board_draft.dart';

class SelectedComposerFund {
  const SelectedComposerFund({
    required this.projectId,
    required this.projectName,
    required this.selectionKey,
  });

  const SelectedComposerFund.clear()
    : projectId = '',
      projectName = '',
      selectionKey = '';

  final String projectId;
  final String projectName;
  final String selectionKey;

  bool get isClearSelection => projectId.isEmpty;
}

class KizunarkReplyComposeRouteArgs {
  const KizunarkReplyComposeRouteArgs({required this.child});

  final Widget child;
}

class KizunarkPostComposeRouteArgs {
  const KizunarkPostComposeRouteArgs({required this.child});

  final Widget child;
}

class KizunarkSendActionButton extends StatelessWidget {
  const KizunarkSendActionButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(74, 38),
        maximumSize: const Size(120, 42),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}

class KizunarkPostEntry extends StatelessWidget {
  const KizunarkPostEntry({
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.enabled,
    required this.onTap,
    super.key,
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
              KizunarkSendActionButton(
                label: actionLabel,
                onPressed: enabled ? onTap : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KizunarkComposeSheet extends StatefulWidget {
  const KizunarkComposeSheet({
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
    required this.onOpenDrafts,
    required this.onOpenReplyDraft,
    required this.onSelectedFundChanged,
    required this.onTextChanged,
    required this.onSaveDraft,
    required this.onSubmit,
    this.fullPage = false,
    super.key,
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
  final SelectedComposerFund? selectedFund;
  final Future<String?> Function() onPickImage;
  final Future<SelectedComposerFund?> Function() onPickFund;
  final Future<DiscussionBoardDraft?> Function() onOpenDrafts;
  final Future<void> Function(DiscussionBoardDraft draft) onOpenReplyDraft;
  final ValueChanged<SelectedComposerFund?> onSelectedFundChanged;
  final ValueChanged<String> onTextChanged;
  final Future<void> Function(List<String> imageFilePaths) onSaveDraft;
  final Future<bool> Function(List<String> imageFilePaths) onSubmit;
  final bool fullPage;

  @override
  State<KizunarkComposeSheet> createState() => _KizunarkComposeSheetState();
}

class _KizunarkComposeSheetState extends State<KizunarkComposeSheet> {
  static const int _maxImages = 4;
  final List<String> _imageFilePaths = <String>[];
  SelectedComposerFund? _selectedFund;
  bool _isSubmitting = false;
  bool _hasInputContent = false;
  bool _canSubmitContent = false;

  @override
  void initState() {
    super.initState();
    _selectedFund = widget.selectedFund;
    _hasInputContent = _hasDraftContent;
    _canSubmitContent = _hasSubmitContent;
    widget.controller.addListener(_syncInputContentState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncInputContentState);
    super.dispose();
  }

  bool get _hasDraftContent =>
      widget.controller.text.trim().isNotEmpty || _imageFilePaths.isNotEmpty;
  bool get _hasSubmitContent => widget.controller.text.trim().isNotEmpty;
  bool get _canSubmit => _hasSubmitContent;

  Iterable<String> get _validImageFilePaths => _imageFilePaths.where(
    (path) => path.trim().isNotEmpty && File(path).existsSync(),
  );

  void _syncInputContentState() {
    final nextHasContent = _hasDraftContent;
    final nextCanSubmit = _hasSubmitContent;
    if ((nextHasContent == _hasInputContent &&
            nextCanSubmit == _canSubmitContent) ||
        !mounted) {
      return;
    }
    setState(() {
      _hasInputContent = nextHasContent;
      _canSubmitContent = nextCanSubmit;
    });
  }

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
      _hasInputContent = true;
      _canSubmitContent = _hasSubmitContent;
    });
  }

  Future<void> _confirmClose() async {
    if (!_hasDraftContent) {
      Navigator.of(context).pop();
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return _ComposeCloseMenu(
          onDelete: () {
            Navigator.of(sheetContext).pop();
            widget.controller.clear();
            widget.onTextChanged('');
            _imageFilePaths.clear();
            Navigator.of(context).pop();
          },
          onSaveDraft: () async {
            Navigator.of(sheetContext).pop();
            await widget.onSaveDraft(List<String>.of(_validImageFilePaths));
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  Future<void> _openDrafts() async {
    final draft = await widget.onOpenDrafts();
    if (!mounted || draft == null) {
      return;
    }
    if (draft.kind == DiscussionDraftKind.reply) {
      Navigator.of(context).pop();
      await widget.onOpenReplyDraft(draft);
      return;
    }
    widget.controller.value = TextEditingValue(
      text: draft.content,
      selection: TextSelection.collapsed(offset: draft.content.length),
    );
    widget.onTextChanged(draft.content);
    setState(() {
      _imageFilePaths
        ..clear()
        ..addAll(
          draft.imageFilePaths
              .where(
                (path) => path.trim().isNotEmpty && File(path).existsSync(),
              )
              .take(_maxImages),
        );
      _hasInputContent = _hasDraftContent;
      _canSubmitContent = _hasSubmitContent;
    });
    final projectId = draft.projectId?.trim() ?? '';
    final projectName = draft.projectName?.trim() ?? '';
    final fund = projectId.isEmpty
        ? null
        : SelectedComposerFund(
            projectId: projectId,
            projectName: projectName,
            selectionKey: projectId,
          );
    setState(() {
      _selectedFund = fund;
    });
    widget.onSelectedFundChanged(fund);
  }

  Future<void> _pickFund() async {
    final fund = await widget.onPickFund();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedFund = fund;
    });
  }

  void _submit() {
    if (_isSubmitting || !_canSubmit) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    unawaited(widget.onSubmit(List<String>.of(_validImageFilePaths)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;
    final content = Material(
      color: colors.surface,
      borderRadius: widget.fullPage
          ? BorderRadius.zero
          : const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          _PostComposeHeader(
            closeLabel: widget.closeLabel,
            draftLabel: l10n.kizunarkComposeDraftAction,
            submitLabel: widget.submitLabel,
            isSubmitting: _isSubmitting,
            canSubmit: _canSubmit,
            showDraftAction: !_hasInputContent,
            onClose: _confirmClose,
            onDraftTap: _openDrafts,
            onSubmit: _submit,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              children: <Widget>[
                _PostInputComposer(
                  avatarUrl: widget.currentUser?.avatar,
                  avatarSeed: widget.avatarSeed,
                  authorLabel: widget.authorLabel,
                  placeholder: widget.placeholder,
                  controller: widget.controller,
                  onChanged: widget.onTextChanged,
                  imageFilePaths: List<String>.of(_validImageFilePaths),
                  onRemoveImage: (int index) {
                    setState(() {
                      _imageFilePaths.removeAt(index);
                      _hasInputContent = _hasDraftContent;
                      _canSubmitContent = _hasSubmitContent;
                    });
                  },
                ),
                if (_selectedFund != null) ...<Widget>[
                  const SizedBox(height: 10),
                  _LinkedFundPreview(fund: _selectedFund!),
                ],
              ],
            ),
          ),
          _ComposeDock(
            addImageLabel: widget.addImageLabel,
            linkedFundLabel: widget.linkedFundLabel,
            imageCounter: widget.imageCounterBuilder(_imageFilePaths.length),
            canAddImage: _imageFilePaths.length < _maxImages,
            onAddImage: _addImage,
            onPickFund: _pickFund,
          ),
        ],
      ),
    );
    final page = SafeArea(
      top: true,
      bottom: false,
      minimum: widget.fullPage
          ? EdgeInsets.zero
          : const EdgeInsets.only(top: 8),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: widget.fullPage
            ? content
            : Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.92,
                  alignment: Alignment.bottomCenter,
                  child: content,
                ),
              ),
      ),
    );
    return widget.fullPage
        ? ColoredBox(color: colors.surface, child: page)
        : page;
  }
}

class KizunarkReplyComposeSheet extends StatefulWidget {
  const KizunarkReplyComposeSheet({
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
    required this.targetAvatarUrl,
    required this.targetAvatarGradientColorValues,
    required this.targetImageUrls,
    required this.onTargetImageTap,
    required this.addImageLabel,
    required this.linkedFundLabel,
    required this.imageCounterBuilder,
    required this.controller,
    required this.onChanged,
    required this.onPickImage,
    required this.onPickFund,
    required this.onSaveDraft,
    required this.onSubmit,
    this.initialImageFilePaths = const <String>[],
    this.fullPage = false,
    super.key,
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
  final String? targetAvatarUrl;
  final List<int> targetAvatarGradientColorValues;
  final List<String> targetImageUrls;
  final ValueChanged<int> onTargetImageTap;
  final String addImageLabel;
  final String linkedFundLabel;
  final String Function(int count) imageCounterBuilder;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Future<String?> Function() onPickImage;
  final Future<void> Function() onPickFund;
  final Future<void> Function(List<String> imageFilePaths) onSaveDraft;
  final Future<bool> Function(List<String> imageFilePaths) onSubmit;
  final List<String> initialImageFilePaths;
  final bool fullPage;

  @override
  State<KizunarkReplyComposeSheet> createState() =>
      _KizunarkReplyComposeSheetState();
}

class _KizunarkReplyComposeSheetState extends State<KizunarkReplyComposeSheet> {
  static const int _maxImages = 4;
  final List<String> _imageFilePaths = <String>[];
  bool _isSubmitting = false;
  bool _hasInputContent = false;
  bool _canSubmitContent = false;

  @override
  void initState() {
    super.initState();
    _imageFilePaths.addAll(
      widget.initialImageFilePaths
          .where((path) => path.trim().isNotEmpty && File(path).existsSync())
          .take(_maxImages),
    );
    _hasInputContent = _hasDraftContent;
    _canSubmitContent = _hasSubmitContent;
    widget.controller.addListener(_syncInputContentState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncInputContentState);
    super.dispose();
  }

  bool get _hasDraftContent =>
      widget.controller.text.trim().isNotEmpty || _imageFilePaths.isNotEmpty;
  bool get _hasSubmitContent => widget.controller.text.trim().isNotEmpty;
  bool get _canSubmit => _hasSubmitContent;

  Iterable<String> get _validImageFilePaths => _imageFilePaths.where(
    (path) => path.trim().isNotEmpty && File(path).existsSync(),
  );

  void _syncInputContentState() {
    final nextHasContent = _hasDraftContent;
    final nextCanSubmit = _hasSubmitContent;
    if ((nextHasContent == _hasInputContent &&
            nextCanSubmit == _canSubmitContent) ||
        !mounted) {
      return;
    }
    setState(() {
      _hasInputContent = nextHasContent;
      _canSubmitContent = nextCanSubmit;
    });
  }

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
      _hasInputContent = true;
      _canSubmitContent = _hasSubmitContent;
    });
  }

  Future<void> _confirmClose() async {
    if (!_hasDraftContent) {
      Navigator.of(context).pop();
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return _ComposeCloseMenu(
          onDelete: () {
            Navigator.of(sheetContext).pop();
            widget.controller.clear();
            widget.onChanged('');
            _imageFilePaths.clear();
            Navigator.of(context).pop();
          },
          onSaveDraft: () async {
            Navigator.of(sheetContext).pop();
            await widget.onSaveDraft(List<String>.of(_validImageFilePaths));
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  void _submit() {
    if (_isSubmitting || !_canSubmit) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    unawaited(widget.onSubmit(List<String>.of(_validImageFilePaths)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final content = Material(
      color: colors.surface,
      borderRadius: widget.fullPage
          ? BorderRadius.zero
          : const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          _ReplyComposeHeader(
            closeLabel: widget.closeLabel,
            submitLabel: widget.submitLabel,
            isSubmitting: _isSubmitting,
            canSubmit: _canSubmit,
            onClose: _confirmClose,
            onSubmit: _submit,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              children: <Widget>[
                _ReplyTargetPostPreview(
                  avatarUrl: widget.targetAvatarUrl,
                  gradientColorValues: widget.targetAvatarGradientColorValues,
                  name: widget.targetName,
                  body: widget.targetBody,
                  imageUrls: widget.targetImageUrls,
                  onImageTap: widget.onTargetImageTap,
                ),
                _ReplyInputComposer(
                  avatarUrl: widget.currentUser?.avatar,
                  avatarSeed: widget.avatarSeed,
                  replyLabel: widget.targetLabel,
                  targetName: widget.targetName,
                  placeholder: widget.placeholder,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  imageFilePaths: List<String>.of(_validImageFilePaths),
                  onRemoveImage: (int index) {
                    setState(() {
                      _imageFilePaths.removeAt(index);
                      _hasInputContent = _hasDraftContent;
                      _canSubmitContent = _hasSubmitContent;
                    });
                  },
                ),
              ],
            ),
          ),
          _ComposeDock(
            addImageLabel: widget.addImageLabel,
            linkedFundLabel: widget.linkedFundLabel,
            imageCounter: widget.imageCounterBuilder(_imageFilePaths.length),
            canAddImage: _imageFilePaths.length < _maxImages,
            onAddImage: _addImage,
            onPickFund: widget.onPickFund,
          ),
        ],
      ),
    );
    final page = SafeArea(
      top: true,
      bottom: false,
      minimum: widget.fullPage
          ? EdgeInsets.zero
          : const EdgeInsets.only(top: 8),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: widget.fullPage
            ? content
            : Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.92,
                  alignment: Alignment.bottomCenter,
                  child: content,
                ),
              ),
      ),
    );
    return widget.fullPage
        ? ColoredBox(color: colors.surface, child: page)
        : page;
  }
}

class KizunarkGuestPrompt extends StatelessWidget {
  const KizunarkGuestPrompt({
    required this.message,
    required this.onLoginTap,
    required this.onRegisterTap,
    super.key,
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

class _PostComposeHeader extends StatelessWidget {
  const _PostComposeHeader({
    required this.closeLabel,
    required this.draftLabel,
    required this.submitLabel,
    required this.isSubmitting,
    required this.canSubmit,
    required this.showDraftAction,
    required this.onClose,
    required this.onDraftTap,
    required this.onSubmit,
  });

  final String closeLabel;
  final String draftLabel;
  final String submitLabel;
  final bool isSubmitting;
  final bool canSubmit;
  final bool showDraftAction;
  final VoidCallback onClose;
  final VoidCallback onDraftTap;
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
            TextButton(
              onPressed: onClose,
              child: Text(
                closeLabel,
                style: appText.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: showDraftAction
                  ? TextButton(
                      key: const ValueKey<String>('draft-action'),
                      onPressed: onDraftTap,
                      child: Text(
                        draftLabel,
                        style: appText.bodyStrong.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey<String>('draft-action-empty'),
                    ),
            ),
            const SizedBox(width: 8),
            KizunarkSendActionButton(
              label: submitLabel,
              onPressed: isSubmitting || !canSubmit ? null : onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplyComposeHeader extends StatelessWidget {
  const _ReplyComposeHeader({
    required this.closeLabel,
    required this.submitLabel,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onClose,
    required this.onSubmit,
  });

  final String closeLabel;
  final String submitLabel;
  final bool isSubmitting;
  final bool canSubmit;
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
            TextButton(
              onPressed: onClose,
              child: Text(
                closeLabel,
                style: appText.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            KizunarkSendActionButton(
              label: submitLabel,
              onPressed: isSubmitting || !canSubmit ? null : onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposeCloseMenu extends StatelessWidget {
  const _ComposeCloseMenu({required this.onDelete, required this.onSaveDraft});

  final VoidCallback onDelete;
  final VoidCallback onSaveDraft;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final l10n = context.l10n;
    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.delete_outline, color: colors.danger),
                title: Text(
                  l10n.kizunarkComposeDeleteDraftAction,
                  style: appText.bodyStrong.copyWith(color: colors.danger),
                ),
                onTap: onDelete,
              ),
              ListTile(
                leading: Icon(Icons.bookmark_border, color: colors.textPrimary),
                title: Text(
                  l10n.kizunarkComposeSaveDraftAction,
                  style: appText.bodyStrong.copyWith(color: colors.textPrimary),
                ),
                onTap: onSaveDraft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostInputComposer extends StatelessWidget {
  const _PostInputComposer({
    required this.avatarUrl,
    required this.avatarSeed,
    required this.authorLabel,
    required this.placeholder,
    required this.controller,
    required this.onChanged,
    required this.imageFilePaths,
    required this.onRemoveImage,
  });

  final String? avatarUrl;
  final int? avatarSeed;
  final String authorLabel;
  final String placeholder;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final List<String> imageFilePaths;
  final ValueChanged<int> onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 40,
          child: AppUserAvatar(
            avatarUrl: avatarUrl,
            avatarSeed: avatarSeed,
            size: 36,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                authorLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appText.bodyStrong.copyWith(color: colors.textPrimary),
              ),
              TextField(
                controller: controller,
                autofocus: true,
                minLines: 5,
                maxLines: 10,
                onChanged: onChanged,
                style: appText.inputText.copyWith(
                  color: colors.textPrimary,
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 12),
                ),
              ),
              _SelectedImageStrip(
                imageFilePaths: imageFilePaths,
                onRemove: onRemoveImage,
              ),
            ],
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
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageFilePaths.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(imageFilePaths[index]),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: colors.surfaceAlt,
                      child: const SizedBox(width: 82, height: 82),
                    ),
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
                    child: Icon(Icons.close, size: 26, color: colors.onDark),
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

  final SelectedComposerFund fund;

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

class _ReplyTargetPostPreview extends StatelessWidget {
  const _ReplyTargetPostPreview({
    required this.avatarUrl,
    required this.gradientColorValues,
    required this.name,
    required this.body,
    required this.imageUrls,
    required this.onImageTap,
  });

  final String? avatarUrl;
  final List<int> gradientColorValues;
  final String name;
  final String body;
  final List<String> imageUrls;
  final ValueChanged<int> onImageTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 40,
            child: Column(
              children: <Widget>[
                AppUserAvatar(
                  avatarUrl: avatarUrl,
                  gradientColorValues: gradientColorValues,
                  size: 36,
                  fontSize: 12,
                ),
                const SizedBox(height: 8),
                Expanded(child: Container(width: 2, color: colors.border)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appText.bodyStrong.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: appText.body.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      if (imageUrls.isNotEmpty)
                        Expanded(
                          flex: 1,
                          child: KizunarkImageGrid(
                            imageUrls: imageUrls,
                            //onImageTap: onImageTap,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyInputComposer extends StatelessWidget {
  const _ReplyInputComposer({
    required this.avatarUrl,
    required this.avatarSeed,
    required this.replyLabel,
    required this.targetName,
    required this.placeholder,
    required this.controller,
    required this.onChanged,
    required this.imageFilePaths,
    required this.onRemoveImage,
  });

  final String? avatarUrl;
  final int? avatarSeed;
  final String replyLabel;
  final String targetName;
  final String placeholder;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final List<String> imageFilePaths;
  final ValueChanged<int> onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 40,
          child: AppUserAvatar(
            avatarUrl: avatarUrl,
            avatarSeed: avatarSeed,
            size: 36,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  text: '$replyLabel ',
                  style: appText.meta.copyWith(color: colors.textTertiary),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '@$targetName',
                      style: appText.meta.copyWith(color: colors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                autofocus: true,
                minLines: 1,
                maxLines: 9,
                onChanged: onChanged,
                style: appText.inputText.copyWith(
                  color: colors.textPrimary,
                  height: 1.55,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              _SelectedImageStrip(
                imageFilePaths: imageFilePaths,
                onRemove: onRemoveImage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
