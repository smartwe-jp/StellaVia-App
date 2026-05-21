import 'dart:io';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/domain/entities/auth_user.dart';

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
    required this.onTextChanged,
    required this.onSubmit,
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
  final Future<void> Function() onPickFund;
  final ValueChanged<String> onTextChanged;
  final Future<bool> Function(List<String> imageFilePaths) onSubmit;

  @override
  State<KizunarkComposeSheet> createState() => _KizunarkComposeSheetState();
}

class _KizunarkComposeSheetState extends State<KizunarkComposeSheet> {
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
    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.92,
            alignment: Alignment.bottomCenter,
            child: Material(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
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
      ),
    );
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
    required this.addImageLabel,
    required this.imageCounterBuilder,
    required this.controller,
    required this.onChanged,
    required this.onPickImage,
    required this.onSubmit,
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
  final String addImageLabel;
  final String Function(int count) imageCounterBuilder;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Future<String?> Function() onPickImage;
  final Future<bool> Function(List<String> imageFilePaths) onSubmit;

  @override
  State<KizunarkReplyComposeSheet> createState() =>
      _KizunarkReplyComposeSheetState();
}

class _KizunarkReplyComposeSheetState extends State<KizunarkReplyComposeSheet> {
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
    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.92,
            alignment: Alignment.bottomCenter,
            child: Material(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
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
      ),
    );
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
